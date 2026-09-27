import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/audio/audio_playback_controller.dart';
import '../../core/database/app_database.dart';
import '../../core/database/review_repository.dart';
import '../../core/mushaf/ayah_glyphs.dart';
import '../../core/mushaf/mushaf_repository.dart';
import '../../core/quran_reference/quran_reference_repository.dart';
import '../../core/review/spaced_repetition.dart';
import 'review_session_controller.dart';

/// Session de révision (murâja'a, Brique 4) : rappel de mémoire → dévoilement
/// → auto-évaluation (Faible/Moyen/Solide), un passage entier à la fois
/// (contrairement à la Mémorisation qui avance verset par verset).
class ReviewSessionScreen extends ConsumerStatefulWidget {
  const ReviewSessionScreen({super.key});

  @override
  ConsumerState<ReviewSessionScreen> createState() => _ReviewSessionScreenState();
}

class _ReviewSessionScreenState extends ConsumerState<ReviewSessionScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final units = await ref.read(dueUnitsProvider.future);
      ref.read(reviewSessionProvider.notifier).startSession(units);
    });
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(reviewSessionProvider);

    if (!session.isLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (session.units!.isEmpty) {
      return const _NoReviewsDueView();
    }
    if (session.stage == ReviewStage.complete) {
      return _ReviewCompletionView(count: session.units!.length);
    }

    final unit = session.currentUnit!;
    final referenceAsync = ref.watch(quranReferenceProvider);
    final mushafAsync = ref.watch(mushafRepositoryProvider);
    final controller = ref.read(reviewSessionProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(referenceAsync.value?.surahByNumber(unit.surahNumber).englishName ?? 'Révision'),
      ),
      body: mushafAsync.when(
        data: (mushaf) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Passage ${session.currentIndex + 1}/${session.units!.length} — '
                '${unit.startAyah == unit.endAyah ? 'verset ${unit.startAyah}' : 'versets ${unit.startAyah}-${unit.endAyah}'}',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Expanded(
                child: session.stage == ReviewStage.revealed
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            for (var ayah = unit.startAyah; ayah <= unit.endAyah; ayah++)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                child: AyahGlyphs(mushaf: mushaf, words: mushaf.wordsForAyah(unit.surahNumber, ayah)),
                              ),
                          ],
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.visibility_off_outlined,
                          size: 64,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              _ReviewStageControls(unit: unit, stage: session.stage, controller: controller),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur : $err')),
      ),
    );
  }
}

class _ReviewStageControls extends ConsumerWidget {
  const _ReviewStageControls({required this.unit, required this.stage, required this.controller});

  final MemorizationUnit unit;
  final ReviewStage stage;
  final ReviewSessionController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (stage == ReviewStage.recalling) {
      final playback = ref.watch(audioPlaybackProvider);
      final isPlayingThisUnit = playback.isPlaying &&
          playback.surahNumber == unit.surahNumber &&
          (playback.ayahNumber ?? -1) >= unit.startAyah &&
          (playback.ayahNumber ?? -1) <= unit.endAyah;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Récitez ce passage de mémoire, puis vérifiez.', textAlign: TextAlign.center),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () {
              final audio = ref.read(audioPlaybackProvider.notifier);
              if (isPlayingThisUnit) {
                audio.stop();
              } else {
                // Boucle confinée à ce seul passage : setRepeatRange ne
                // dépasse jamais [start, end] (voir _onAyahCompleted).
                audio.setRepeatRange(unit.startAyah, unit.endAyah);
                audio.playFrom(unit.surahNumber, unit.startAyah);
              }
            },
            icon: Icon(isPlayingThisUnit ? Icons.stop_circle : Icons.play_circle_outline),
            label: Text(isPlayingThisUnit ? 'Arrêter' : 'Écouter'),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () {
              ref.read(audioPlaybackProvider.notifier).stop();
              controller.reveal();
            },
            child: const Text('Afficher le verset'),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Comment était votre récitation ?', textAlign: TextAlign.center),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _rate(ref, ReviewRating.weak),
                child: const Text('Faible'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton(
                onPressed: () => _rate(ref, ReviewRating.medium),
                child: const Text('Moyen'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FilledButton(
                onPressed: () => _rate(ref, ReviewRating.solid),
                child: const Text('Solide'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _rate(WidgetRef ref, ReviewRating rating) {
    ref.read(audioPlaybackProvider.notifier).stop();
    controller.rate(rating);
  }
}

class _NoReviewsDueView extends StatelessWidget {
  const _NoReviewsDueView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Révision')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, size: 64, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              const Text(
                "Rien à réviser pour l'instant — revenez quand une échéance approchera.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: () => context.go('/accueil'), child: const Text('Retour à l\'accueil')),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReviewCompletionView extends StatelessWidget {
  const _ReviewCompletionView({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Révision terminée')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 64, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                count == 1 ? '1 passage révisé !' : '$count passages révisés !',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: () => context.go('/accueil'), child: const Text('Terminer')),
            ],
          ),
        ),
      ),
    );
  }
}
