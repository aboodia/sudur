import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/audio/audio_playback_controller.dart';
import '../../../core/database/app_database.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';
import '../../../core/quran_text/quran_text_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../session_controller.dart';
import '../widgets/record_control.dart';
import '../widgets/session_step_scaffold.dart';

const _defaultRepeatTimes = 3;

/// Étape 2 : un verset à la fois, écouté puis répété à voix haute — pas de
/// masquage ici, juste de l'imprégnation par répétition.
class RepeatScreen extends ConsumerStatefulWidget {
  const RepeatScreen({
    super.key,
    required this.passage,
    required this.ayahNumber,
  });

  final Passage passage;
  final int ayahNumber;

  @override
  ConsumerState<RepeatScreen> createState() => _RepeatScreenState();
}

class _RepeatScreenState extends ConsumerState<RepeatScreen> {
  @override
  void initState() {
    super.initState();
    // Deferred for the same reason as DiscoverScreen: the very first mount
    // of a step can happen synchronously inside guidedSessionProvider's own
    // state-notification cascade (e.g. resuming straight into Répéter on
    // app start), where writing to audioPlaybackProvider right away is
    // rejected by Riverpod.
    Future.microtask(_play);
  }

  @override
  void didUpdateWidget(covariant RepeatScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ayahNumber != widget.ayahNumber) _play();
  }

  void _play() {
    if (!mounted) return;
    final audio = ref.read(audioPlaybackProvider.notifier);
    audio.setRepeatCount(_defaultRepeatTimes - 1);
    audio.playFrom(widget.passage.surahNumber, widget.ayahNumber);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textAsync = ref.watch(quranTextProvider);
    final referenceAsync = ref.watch(quranReferenceProvider);
    final playback = ref.watch(audioPlaybackProvider);
    final audio = ref.read(audioPlaybackProvider.notifier);
    final controller = ref.read(guidedSessionProvider.notifier);
    final theme = Theme.of(context);
    final surahName =
        referenceAsync.value
            ?.surahByNumber(widget.passage.surahNumber)
            .englishName ??
        '';

    return SessionStepScaffold(
      stepIndex: stepRepeat,
      stepLabel: 'Répéter',
      headerLabel:
          '${surahName.toUpperCase()} · ${widget.passage.ayahStart}-${widget.passage.ayahEnd}',
      onQuit: () => _quit(),
      onBack: () async {
        await ref.read(audioPlaybackProvider.notifier).stop();
        await controller.goToPreviousStep();
      },
      body: textAsync.when(
        data: (repo) {
          final ayah = repo
              .surah(widget.passage.surahNumber)
              .ayahs[widget.ayahNumber - 1];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text(
                      l10n.verseOfTotal(
                        widget.ayahNumber - widget.passage.ayahStart + 1,
                        widget.passage.ayahEnd - widget.passage.ayahStart + 1,
                      ),
                      style: theme.textTheme.titleMedium,
                    ),
                    const Spacer(),
                    Chip(label: Text(l10n.repeatAloudBadge)),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Text(
                              ayah.arabic,
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                fontFamily: 'AmiriQuran',
                                fontSize: 30,
                                height: 1.9,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              ayah.transliteration,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              ayah.french,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.listenXOfY(
                    (playback.repeatProgress + 1).clamp(1, _defaultRepeatTimes),
                    _defaultRepeatTimes,
                  ),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur : $err')),
      ),
      bottomBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () =>
                    audio.setSpeed(playback.speed == 1.0 ? 0.8 : 1.0),
                child: Text(playback.speed == 1.0 ? '1×' : '0,8×'),
              ),
              const SizedBox(width: 24),
              IconButton.filled(
                iconSize: 40,
                icon: Icon(playback.isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () =>
                    playback.isPlaying ? audio.pause() : audio.resume(),
              ),
              const SizedBox(width: 24),
              const RecordControl(),
            ],
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () async {
              await audio.stop();
              await controller.finishRepeatingCurrentAyah();
            },
            child: Text(l10n.noHesitation),
          ),
        ],
      ),
    );
  }

  Future<void> _quit() async {
    await ref.read(audioPlaybackProvider.notifier).stop();
    if (mounted) Navigator.of(context).maybePop();
  }
}
