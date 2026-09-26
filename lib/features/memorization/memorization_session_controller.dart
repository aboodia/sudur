import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/memorization_repository.dart';
import '../../core/database/profile_repository.dart';

/// Répétition guidée (Brique 3) : écoute → répétition orale → masquage
/// progressif du texte → auto-évaluation — un ayah à la fois dans la
/// plage [startAyah, endAyah] du passage.
enum MemorizationStage { listening, repeating, masking, selfAssessing, complete }

/// State is decoupled from audio playback on purpose: this controller only
/// tracks passage/stage/DB bookkeeping (fully unit-testable without a real
/// player) — the session screen itself calls audioPlaybackProvider when the
/// stage becomes [MemorizationStage.listening].
class MemorizationSessionState {
  const MemorizationSessionState({
    this.surahNumber,
    this.startAyah,
    this.endAyah,
    this.currentAyah,
    this.unitId,
    this.stage = MemorizationStage.listening,
    this.maskLevel = 0,
    this.revealedWordIndices = const {},
  });

  final int? surahNumber;
  final int? startAyah;
  final int? endAyah;
  final int? currentAyah;
  final String? unitId;
  final MemorizationStage stage;

  /// Only meaningful during [MemorizationStage.masking]: 0 = texte entier,
  /// 1 = ~moitié masquée, 2 = tout masqué.
  final int maskLevel;

  /// Mots re-dévoilés manuellement par un tap, indépendamment de [maskLevel].
  final Set<int> revealedWordIndices;

  bool get isActive => surahNumber != null;

  MemorizationSessionState copyWith({
    int? surahNumber,
    int? startAyah,
    int? endAyah,
    int? currentAyah,
    String? unitId,
    MemorizationStage? stage,
    int? maskLevel,
    Set<int>? revealedWordIndices,
  }) =>
      MemorizationSessionState(
        surahNumber: surahNumber ?? this.surahNumber,
        startAyah: startAyah ?? this.startAyah,
        endAyah: endAyah ?? this.endAyah,
        currentAyah: currentAyah ?? this.currentAyah,
        unitId: unitId ?? this.unitId,
        stage: stage ?? this.stage,
        maskLevel: maskLevel ?? this.maskLevel,
        revealedWordIndices: revealedWordIndices ?? this.revealedWordIndices,
      );
}

class MemorizationSessionController extends Notifier<MemorizationSessionState> {
  @override
  MemorizationSessionState build() => const MemorizationSessionState();

  Future<void> startSession(int surahNumber, int startAyah, int endAyah) async {
    final profile = await ref.read(currentProfileProvider.future);
    final unitId = await ref
        .read(memorizationRepositoryProvider)
        .startUnit(profile.id, surahNumber, startAyah, endAyah);
    state = MemorizationSessionState(
      surahNumber: surahNumber,
      startAyah: startAyah,
      endAyah: endAyah,
      currentAyah: startAyah,
      unitId: unitId,
    );
  }

  /// listening → repeating → masking(0) → masking(1) → masking(2) →
  /// selfAssessing.
  void advanceStage() {
    switch (state.stage) {
      case MemorizationStage.listening:
        state = state.copyWith(stage: MemorizationStage.repeating);
      case MemorizationStage.repeating:
        state = state.copyWith(
          stage: MemorizationStage.masking,
          maskLevel: 0,
          revealedWordIndices: {},
        );
      case MemorizationStage.masking:
        if (state.maskLevel < 2) {
          state = state.copyWith(maskLevel: state.maskLevel + 1);
        } else {
          state = state.copyWith(stage: MemorizationStage.selfAssessing);
        }
      case MemorizationStage.selfAssessing:
      case MemorizationStage.complete:
        break;
    }
  }

  void revealWord(int index) {
    state = state.copyWith(revealedWordIndices: {...state.revealedWordIndices, index});
  }

  /// "Pas encore" — recommence le cycle sur le même verset depuis l'écoute.
  void markNeedsMoreWork() {
    state = state.copyWith(
      stage: MemorizationStage.listening,
      maskLevel: 0,
      revealedWordIndices: {},
    );
  }

  /// "Je l'ai !" — passe au verset suivant du passage, ou termine la
  /// session (passage marqué `memorized`) si c'était le dernier.
  Future<void> markGotIt() async {
    if (state.currentAyah! < state.endAyah!) {
      state = state.copyWith(
        currentAyah: state.currentAyah! + 1,
        stage: MemorizationStage.listening,
        maskLevel: 0,
        revealedWordIndices: {},
      );
    } else {
      await ref.read(memorizationRepositoryProvider).completeUnit(state.unitId!);
      state = state.copyWith(stage: MemorizationStage.complete);
    }
  }
}

final memorizationSessionProvider =
    NotifierProvider<MemorizationSessionController, MemorizationSessionState>(
  MemorizationSessionController.new,
);
