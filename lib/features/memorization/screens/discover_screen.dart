import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../core/audio/audio_playback_controller.dart';
import '../../../core/audio/playback_state.dart';
import '../../../core/audio/reciter.dart';
import '../../../core/database/app_database.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';
import '../../../core/quran_text/quran_text_repository.dart';
import '../../../l10n/app_localizations.dart';
import '../session_controller.dart';
import '../widgets/session_step_scaffold.dart';

/// Étape 1 : écoute passive du passage entier, texte suivi des yeux, verset
/// en cours surligné et centré automatiquement.
class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key, required this.passage});

  final Passage passage;

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _scrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    // Deferred: this screen's very first mount can happen synchronously
    // inside guidedSessionProvider's own state-notification cascade (e.g.
    // resuming a session on app start) — writing to audioPlaybackProvider
    // right there is rejected by Riverpod ("modify a provider while the
    // widget tree was building"). A microtask runs just after that
    // cascade unwinds, once it's safe.
    Future.microtask(_prepare);
  }

  /// Sets up the mini-player (range, first ayah) without starting
  /// playback — Découvrir waits for the user to press play themselves,
  /// same as every other step. `select` (not `prepare`) so the player
  /// really moves to this passage even if another ayah is still current.
  void _prepare() {
    if (!mounted) return;
    final audio = ref.read(audioPlaybackProvider.notifier);
    audio.setRepeatRange(widget.passage.ayahStart, widget.passage.ayahEnd);
    audio.select(widget.passage.surahNumber, widget.passage.ayahStart);
  }

  void _play() {
    if (!mounted) return;
    final audio = ref.read(audioPlaybackProvider.notifier);
    audio.setRepeatRange(widget.passage.ayahStart, widget.passage.ayahEnd);
    audio.playFrom(widget.passage.surahNumber, widget.passage.ayahStart);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textAsync = ref.watch(quranTextProvider);
    final referenceAsync = ref.watch(quranReferenceProvider);
    final playback = ref.watch(audioPlaybackProvider);
    final controller = ref.read(guidedSessionProvider.notifier);
    final surahName =
        referenceAsync.value
            ?.surahByNumber(widget.passage.surahNumber)
            .englishName ??
        '';

    ref.listen(audioPlaybackProvider, (previous, next) {
      final movedToNewAyah =
          next.ayahNumber != null && previous?.ayahNumber != next.ayahNumber;
      if (movedToNewAyah &&
          next.surahNumber == widget.passage.surahNumber &&
          _scrollController.isAttached) {
        final index = next.ayahNumber! - widget.passage.ayahStart;
        if (index >= 0) {
          _scrollController.scrollTo(
            index: index,
            duration: const Duration(milliseconds: 300),
            alignment: 0.3,
          );
        }
      }
    });

    return SessionStepScaffold(
      stepIndex: stepDiscover,
      stepLabel: 'Découvrir',
      headerLabel:
          '${surahName.toUpperCase()} · ${widget.passage.ayahStart}-${widget.passage.ayahEnd}',
      onQuit: () => _quitAndSave(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              l10n.discoverTitle,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
            child: Text(
              l10n.discoverSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _NowPlayingBar(
              playback: playback,
              reciterName: reciterById(playback.reciterId).name,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: textAsync.when(
              data: (repo) {
                final surah = repo.surah(widget.passage.surahNumber);
                final ayahs = surah.ayahs.sublist(
                  widget.passage.ayahStart - 1,
                  widget.passage.ayahEnd,
                );
                return ScrollablePositionedList.separated(
                  itemScrollController: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: ayahs.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final ayah = ayahs[index];
                    final isCurrent =
                        playback.surahNumber == widget.passage.surahNumber &&
                        playback.ayahNumber == ayah.numberInSurah;
                    return _DiscoverAyahCard(ayah: ayah, isCurrent: isCurrent);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Erreur : $err')),
            ),
          ),
        ],
      ),
      bottomBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton(
            onPressed: () async {
              await ref.read(audioPlaybackProvider.notifier).stop();
              await controller.finishDiscovering();
            },
            child: Text(l10n.finishedListening),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: _play, child: Text(l10n.listenAgain)),
        ],
      ),
    );
  }

  Future<void> _quitAndSave(BuildContext context) async {
    await ref.read(audioPlaybackProvider.notifier).stop();
    if (context.mounted) Navigator.of(context).maybePop();
  }
}

class _DiscoverAyahCard extends StatelessWidget {
  const _DiscoverAyahCard({required this.ayah, required this.isCurrent});

  final dynamic ayah; // AyahText
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCurrent
            ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35)
            : null,
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            ayah.arabic as String,
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'AmiriQuran',
              fontSize: 26,
              height: 1.9,
            ),
          ),
          if (isCurrent) ...[
            const SizedBox(height: 8),
            Text(
              ayah.french as String,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _NowPlayingBar extends ConsumerWidget {
  const _NowPlayingBar({required this.playback, required this.reciterName});

  final ReadingPlaybackState playback;
  final String reciterName;

  String _format(Duration d) {
    final minutes = d.inMinutes;
    final seconds = d.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = ref.read(audioPlaybackProvider.notifier);
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: playback.isPlaying
                    ? l10n.tooltipPause
                    : l10n.tooltipPlay,
                icon: Icon(
                  playback.isPlaying ? Icons.pause_circle : Icons.play_circle,
                  color: Colors.white,
                ),
                onPressed: () => playback.isPlaying
                    ? controller.pause()
                    : controller.resume(),
              ),
              Expanded(
                child: Text(
                  playback.ayahNumber != null
                      ? (playback.isPlaying
                          ? l10n.listeningToAyah(playback.ayahNumber!)
                          : l10n.readyAtAyah(playback.ayahNumber!))
                      : '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              StreamBuilder<Duration>(
                stream: controller.positionStream,
                builder: (context, posSnap) => StreamBuilder<Duration?>(
                  stream: controller.durationStream,
                  builder: (context, durSnap) => Text(
                    '${_format(posSnap.data ?? Duration.zero)} / ${_format(durSnap.data ?? Duration.zero)}',
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
          StreamBuilder<Duration>(
            stream: controller.positionStream,
            builder: (context, posSnap) => StreamBuilder<Duration?>(
              stream: controller.durationStream,
              builder: (context, durSnap) {
                final total = durSnap.data?.inMilliseconds ?? 0;
                final value = total == 0
                    ? 0.0
                    : (posSnap.data?.inMilliseconds ?? 0) / total;
                return ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: value.clamp(0, 1),
                    minHeight: 3,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Récitant : $reciterName',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
