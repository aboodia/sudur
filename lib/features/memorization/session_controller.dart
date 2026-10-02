import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/memorization_repository.dart';
import '../../core/database/profile_repository.dart';
import '../../core/memorization/masking_strategy.dart';
import '../../core/memorization/passage_suggestion.dart';
import '../../core/memorization/review_scheduler.dart';
import '../../core/memorization/study_session.dart';
import '../../core/stats/progress_stats_provider.dart';
import '../../core/quran_reference/quran_reference_repository.dart';

/// The 5 guided steps, in order — matches [Passages]' `currentStepIndex`.
const stepDiscover = 0;
const stepRepeat = 1;
const stepMask = 2;
const stepRecite = 3;
const stepChain = 4;

/// Per-ayah status shown on the "Enchaîner" step.
enum ChainAyahStatus { upcoming, current, hesitant, validated }

class GuidedSessionState {
  const GuidedSessionState({
    this.passage,
    this.stepIndex = stepDiscover,
    this.currentAyah,
    this.maskLevel = MaskLevel.light,
    this.revealedIndices = const {},
    this.fragileIndices = const {},
    this.chainStatuses = const {},
    this.isLoaded = false,
    this.isFinished = false,
    this.isRedoFlow = false,
  });

  final Passage? passage;

  /// 0-4 while the guided steps are running.
  final int stepIndex;

  /// Which ayah is being worked on within the current step — null only
  /// during Découvrir, which operates on the whole passage at once.
  final int? currentAyah;

  final MaskLevel maskLevel;
  final Set<int> revealedIndices;

  /// Word indices revealed early during Masquer for [currentAyah] — feeds
  /// `hasFragileWords` once Réciter records the outcome.
  final Set<int> fragileIndices;

  final Map<int, ChainAyahStatus> chainStatuses;

  final bool isLoaded;
  final bool isFinished;

  /// True while Masquer is being revisited after a "à reprendre" verdict on
  /// Réciter — its "Je le connais" should return to Réciter instead of
  /// advancing to the next ayah.
  final bool isRedoFlow;

  GuidedSessionState copyWith({
    Passage? passage,
    int? stepIndex,
    int? currentAyah,
    MaskLevel? maskLevel,
    Set<int>? revealedIndices,
    Set<int>? fragileIndices,
    Map<int, ChainAyahStatus>? chainStatuses,
    bool? isLoaded,
    bool? isFinished,
    bool? returnToReciteAfterMaskRedo,
  }) => GuidedSessionState(
    passage: passage ?? this.passage,
    stepIndex: stepIndex ?? this.stepIndex,
    currentAyah: currentAyah ?? this.currentAyah,
    maskLevel: maskLevel ?? this.maskLevel,
    revealedIndices: revealedIndices ?? this.revealedIndices,
    fragileIndices: fragileIndices ?? this.fragileIndices,
    chainStatuses: chainStatuses ?? this.chainStatuses,
    isLoaded: isLoaded ?? this.isLoaded,
    isFinished: isFinished ?? this.isFinished,
    isRedoFlow: returnToReciteAfterMaskRedo ?? isRedoFlow,
  );
}

/// Drives the 5-step guided flow (Découvrir → Répéter → Masquer → Réciter
/// → Enchaîner) for one passage — Découvrir works on the whole passage at
/// once, the other 4 steps loop ayah by ayah. Découplé de l'audio comme les
/// contrôleurs précédents : l'écran pilote lui-même `audioPlaybackProvider`.
class GuidedSessionController extends Notifier<GuidedSessionState> {
  /// When this sitting began — only this sitting is timed, so a passage
  /// resumed the next day isn't counted as a day of study.
  DateTime _openedAt = DateTime.now();

  @override
  GuidedSessionState build() => const GuidedSessionState();

  /// Resumes an interrupted passage, or starts today's suggested one.
  Future<void> startOrResume() async {
    _openedAt = DateTime.now();
    final profile = await ref.read(currentProfileProvider.future);
    final repo = ref.read(memorizationRepositoryProvider);

    final active = await repo.activeSession(profile.id);
    if (active != null) {
      state = GuidedSessionState(
        passage: active.passage,
        stepIndex: active.progress.currentStepIndex,
        currentAyah: active.progress.currentAyah,
        maskLevel: _maskLevelFromName(active.progress.maskLevel),
        isLoaded: true,
      );
      return;
    }

    final reference = await ref.read(quranReferenceProvider.future);
    final memorized = await repo.memorizedAyahKeys(profile.id);
    final suggestion = suggestNextPassage(reference, memorized);
    if (suggestion == null) {
      // The whole Quran is memorized — nothing left to suggest today.
      state = const GuidedSessionState(isLoaded: true, isFinished: true);
      return;
    }

    final started = await repo.startPassage(
      profile.id,
      suggestion.surahNumber,
      suggestion.startAyah,
      suggestion.endAyah,
    );
    state = GuidedSessionState(
      passage: started.passage,
      stepIndex: stepDiscover,
      currentAyah: started.progress.currentAyah,
      isLoaded: true,
    );
  }

  Future<void> _persist() async {
    final passage = state.passage;
    if (passage == null) return;
    await ref
        .read(memorizationRepositoryProvider)
        .saveProgress(
          passageId: passage.id,
          stepIndex: state.stepIndex,
          currentAyah: state.currentAyah ?? passage.ayahStart,
          maskLevel: state.maskLevel.name,
        );
  }

  /// "J'ai écouté le passage" (Découvrir) → Répéter, verset de départ.
  Future<void> finishDiscovering() async {
    final passage = state.passage!;
    state = state.copyWith(
      stepIndex: stepRepeat,
      currentAyah: passage.ayahStart,
    );
    await _persist();
  }

  /// "Je le répète sans hésiter" (Répéter) → verset suivant, ou Masquer une
  /// fois le dernier verset du passage atteint.
  Future<void> finishRepeatingCurrentAyah() async {
    final passage = state.passage!;
    if (state.currentAyah! < passage.ayahEnd) {
      state = state.copyWith(currentAyah: state.currentAyah! + 1);
    } else {
      state = state.copyWith(
        stepIndex: stepMask,
        currentAyah: passage.ayahStart,
        maskLevel: MaskLevel.light,
        revealedIndices: const {},
      );
    }
    await _persist();
  }

  void setMaskLevel(MaskLevel level) {
    state = state.copyWith(maskLevel: level, revealedIndices: const {});
  }

  void revealWord(int index) {
    state = state.copyWith(
      revealedIndices: {...state.revealedIndices, index},
      fragileIndices: {...state.fragileIndices, index},
    );
  }

  /// "Je le connais" (Masquer) → verset suivant (Masquer), ou Réciter au
  /// verset de départ une fois le dernier verset masqué — sauf si on est
  /// revenu ici depuis un "à reprendre" sur Réciter, auquel cas on y
  /// retourne directement pour ce même verset.
  Future<void> finishMaskingCurrentAyah() async {
    final passage = state.passage!;

    if (state.isRedoFlow) {
      state = state.copyWith(
        stepIndex: stepRecite,
        revealedIndices: const {},
        returnToReciteAfterMaskRedo: false,
      );
      await _persist();
      return;
    }

    if (state.currentAyah! < passage.ayahEnd) {
      state = state.copyWith(
        currentAyah: state.currentAyah! + 1,
        maskLevel: MaskLevel.light,
        revealedIndices: const {},
      );
    } else {
      state = state.copyWith(
        stepIndex: stepRecite,
        currentAyah: passage.ayahStart,
        revealedIndices: const {},
        chainStatuses: {
          for (var a = passage.ayahStart; a <= passage.ayahEnd; a++)
            a: a == passage.ayahStart
                ? ChainAyahStatus.current
                : ChainAyahStatus.upcoming,
        },
      );
    }
    await _persist();
  }

  /// The 3-way self-assessment on "Réciter".
  Future<void> submitReciteOutcome(ReciteOutcome outcome) async {
    final passage = state.passage!;
    final ayah = state.currentAyah!;

    if (outcome == ReciteOutcome.redo) {
      state = state.copyWith(
        stepIndex: stepMask,
        maskLevel: MaskLevel.light,
        revealedIndices: const {},
        returnToReciteAfterMaskRedo: true,
        chainStatuses: {...state.chainStatuses, ayah: ChainAyahStatus.hesitant},
      );
      await _persist();
      return;
    }

    final profile = await ref.read(currentProfileProvider.future);
    final reference = await ref.read(quranReferenceProvider.future);
    await ref
        .read(memorizationRepositoryProvider)
        .recordAyahMemorized(
          profileId: profile.id,
          surahNumber: passage.surahNumber,
          ayahNumber: ayah,
          surahTotalAyahs: reference
              .surahByNumber(passage.surahNumber)
              .numberOfAyahs,
          outcome: outcome,
          fragileWordIndices: state.fragileIndices.toList(),
        );
    ref.invalidate(progressStatsProvider);

    final newStatuses = {
      ...state.chainStatuses,
      ayah: outcome == ReciteOutcome.hesitant
          ? ChainAyahStatus.hesitant
          : ChainAyahStatus.validated,
    };

    if (ayah < passage.ayahEnd) {
      final nextAyah = ayah + 1;
      state = state.copyWith(
        currentAyah: nextAyah,
        revealedIndices: const {},
        fragileIndices: const {},
        chainStatuses: {...newStatuses, nextAyah: ChainAyahStatus.current},
      );
    } else {
      state = state.copyWith(
        stepIndex: stepChain,
        revealedIndices: const {},
        fragileIndices: const {},
        chainStatuses: newStatuses,
      );
    }
    await _persist();
  }

  /// "Terminer le passage" (Enchaîner) → écran "Passage mémorisé". The
  /// screen stops any playback itself first, same convention as the other
  /// steps — this controller never touches audio directly.
  Future<void> finishPassage() async {
    final passage = state.passage!;
    final repo = ref.read(memorizationRepositoryProvider);
    await repo.finishPassage(passage.id);
    final profile = await ref.read(currentProfileProvider.future);
    await repo.logStudySession(
      profileId: profile.id,
      kind: 'memorization',
      startedAt: _openedAt,
      duration: cappedStudyDuration(DateTime.now().difference(_openedAt)),
      ayahCount: passage.ayahEnd - passage.ayahStart + 1,
    );
    ref.invalidate(ayahProgressProvider);
    ref.invalidate(progressStatsProvider);
    ref.invalidate(surahProgressProvider);
    ref.invalidate(activeSessionProvider);
    ref.invalidate(todaysPassagePreviewProvider);
    ref.invalidate(dueReviewsProvider);
    state = state.copyWith(isFinished: true);
  }

  /// The "←" control on steps 2-5 — a simple one-step-back, keeping the
  /// same ayah (Découvrir has none, so going back to it drops the concept).
  Future<void> goToPreviousStep() async {
    if (state.stepIndex == stepDiscover) return;
    state = state.copyWith(stepIndex: state.stepIndex - 1);
    await _persist();
  }

  MaskLevel _maskLevelFromName(String? name) => switch (name) {
    'medium' => MaskLevel.medium,
    'full' => MaskLevel.full,
    _ => MaskLevel.light,
  };
}

final guidedSessionProvider =
    NotifierProvider<GuidedSessionController, GuidedSessionState>(
      GuidedSessionController.new,
    );
