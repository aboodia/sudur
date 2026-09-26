import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/audio/audio_playback_controller.dart';
import '../../core/quran_reference/quran_reference_repository.dart';
import '../../core/quran_text/quran_text_repository.dart';
import 'memorization_session_controller.dart';

/// Répétition guidée (Brique 3), un ayah à la fois : écoute → répétition
/// orale → masquage progressif → auto-évaluation → verset suivant.
class MemorizationSessionScreen extends ConsumerStatefulWidget {
  const MemorizationSessionScreen({
    super.key,
    required this.surahNumber,
    required this.startAyah,
    required this.endAyah,
  });

  final int surahNumber;
  final int startAyah;
  final int endAyah;

  @override
  ConsumerState<MemorizationSessionScreen> createState() => _MemorizationSessionScreenState();
}

class _MemorizationSessionScreenState extends ConsumerState<MemorizationSessionScreen> {
  @override
  void initState() {
    super.initState();
    // Toujours relancer une session fraîche pour CES paramètres — le
    // provider peut encore porter l'état d'une session précédente (Brique 3
    // n'a pas d'autoDispose ici puisque la fin de session doit rester
    // visible le temps de l'écran de complétion).
    Future.microtask(
      () => ref
          .read(memorizationSessionProvider.notifier)
          .startSession(widget.surahNumber, widget.startAyah, widget.endAyah),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(memorizationSessionProvider);
    final matchesThisPassage =
        session.surahNumber == widget.surahNumber && session.startAyah == widget.startAyah;

    if (!matchesThisPassage) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (session.stage == MemorizationStage.complete) {
      return _CompletionView(
        surahNumber: widget.surahNumber,
        startAyah: widget.startAyah,
        endAyah: widget.endAyah,
      );
    }

    final referenceAsync = ref.watch(quranReferenceProvider);
    final textAsync = ref.watch(quranTextProvider);
    final controller = ref.read(memorizationSessionProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(referenceAsync.value?.surahByNumber(widget.surahNumber).englishName ?? 'Mémorisation'),
      ),
      body: textAsync.when(
        data: (repo) {
          final ayah = repo
              .surah(widget.surahNumber)
              .ayahs
              .firstWhere((a) => a.numberInSurah == session.currentAyah);

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  session.startAyah == session.endAyah
                      ? 'Verset ${session.currentAyah}'
                      : 'Verset ${session.currentAyah} — passage ${session.startAyah}-${session.endAyah}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Center(
                    child: session.stage == MemorizationStage.masking
                        ? _MaskedAyahText(
                            arabic: ayah.arabic,
                            maskLevel: session.maskLevel,
                            revealedIndices: session.revealedWordIndices,
                            onWordTap: controller.revealWord,
                          )
                        : Text(
                            ayah.arabic,
                            textDirection: TextDirection.rtl,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontFamily: 'AmiriQuran', fontSize: 28, height: 1.9),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                _StageControls(session: session, controller: controller),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur : $err')),
      ),
    );
  }
}

class _MaskedAyahText extends StatelessWidget {
  const _MaskedAyahText({
    required this.arabic,
    required this.maskLevel,
    required this.revealedIndices,
    required this.onWordTap,
  });

  final String arabic;
  final int maskLevel;
  final Set<int> revealedIndices;
  final ValueChanged<int> onWordTap;

  Set<int> _hiddenIndices(int wordCount) {
    switch (maskLevel) {
      case 0:
        return const {};
      case 1:
        return {for (var i = 1; i < wordCount; i += 2) i};
      default:
        return {for (var i = 0; i < wordCount; i++) i};
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final words = arabic.split(RegExp(r'\s+'));
    final hidden = _hiddenIndices(words.length);

    return Wrap(
      alignment: WrapAlignment.center,
      textDirection: TextDirection.rtl,
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < words.length; i++)
          if (hidden.contains(i) && !revealedIndices.contains(i))
            GestureDetector(
              onTap: () => onWordTap(i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text('•••', style: TextStyle(fontFamily: 'AmiriQuran', fontSize: 26)),
              ),
            )
          else
            Text(
              words[i],
              textDirection: TextDirection.rtl,
              style: const TextStyle(fontFamily: 'AmiriQuran', fontSize: 26, height: 1.9),
            ),
      ],
    );
  }
}

class _StageControls extends ConsumerWidget {
  const _StageControls({required this.session, required this.controller});

  final MemorizationSessionState session;
  final MemorizationSessionController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (session.stage) {
      case MemorizationStage.listening:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: () => ref
                  .read(audioPlaybackProvider.notifier)
                  .playFrom(session.surahNumber!, session.currentAyah!),
              icon: const Icon(Icons.play_circle_outline),
              label: const Text('Écouter'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: controller.advanceStage,
              child: const Text('Suivant : répéter à voix haute'),
            ),
          ],
        );
      case MemorizationStage.repeating:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Répétez ce verset à voix haute, autant de fois que nécessaire.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: controller.advanceStage, child: const Text("Masquer et m'évaluer")),
          ],
        );
      case MemorizationStage.masking:
        return FilledButton(
          onPressed: controller.advanceStage,
          child: Text(session.maskLevel < 2 ? 'Masquer davantage' : "Je m'évalue"),
        );
      case MemorizationStage.selfAssessing:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: controller.markNeedsMoreWork,
                child: const Text('Pas encore, revoir'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(onPressed: controller.markGotIt, child: const Text("Je l'ai !")),
            ),
          ],
        );
      case MemorizationStage.complete:
        return const SizedBox.shrink();
    }
  }
}

class _CompletionView extends ConsumerWidget {
  const _CompletionView({required this.surahNumber, required this.startAyah, required this.endAyah});

  final int surahNumber;
  final int startAyah;
  final int endAyah;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final referenceAsync = ref.watch(quranReferenceProvider);
    final theme = Theme.of(context);
    final surahName = referenceAsync.value?.surahByNumber(surahNumber).englishName ?? 'Sourate $surahNumber';
    final label = startAyah == endAyah ? 'le verset $startAyah' : 'les versets $startAyah à $endAyah';

    return Scaffold(
      appBar: AppBar(title: const Text('Passage mémorisé')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 64, color: theme.colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                '$surahName — $label mémorisé(s) !',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () {
                  final controller = ref.read(audioPlaybackProvider.notifier);
                  controller.setRepeatRange(startAyah, endAyah);
                  controller.playFrom(surahNumber, startAyah);
                },
                icon: const Icon(Icons.repeat),
                label: const Text('Réécouter tout le passage'),
              ),
              const SizedBox(height: 12),
              FilledButton(onPressed: () => context.go('/accueil'), child: const Text('Terminer')),
            ],
          ),
        ),
      ),
    );
  }
}
