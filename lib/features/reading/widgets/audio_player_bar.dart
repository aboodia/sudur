import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/audio/audio_playback_controller.dart';
import '../../../core/audio/playback_state.dart';
import '../../../core/audio/reciter.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';

const _kSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

/// Lecteur audio étendu (Brique 1) : transport, répétition à 4 états,
/// vitesse, choix du récitateur. Rendu globalement par le shell de
/// navigation (voir router.dart), pas par chaque écran de lecture, pour
/// qu'on sache toujours ce qui joue — même en revenant sur l'app depuis un
/// autre onglet — plutôt que de devoir renaviguer vers le bon écran pour
/// le retrouver.
class AudioPlayerBar extends ConsumerWidget {
  const AudioPlayerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playback = ref.watch(audioPlaybackProvider);
    final controller = ref.read(audioPlaybackProvider.notifier);
    final referenceAsync = ref.watch(quranReferenceProvider);
    final theme = Theme.of(context);

    if (!playback.hasCurrentAyah) return const SizedBox.shrink();

    final surahName = referenceAsync.value?.surahByNumber(playback.surahNumber!).englishName ??
        'Sourate ${playback.surahNumber}';

    return Material(
      elevation: 8,
      color: theme.colorScheme.surfaceContainerHigh,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              _RepeatModeButton(mode: playback.repeatMode, onTap: controller.cycleRepeatMode),
              IconButton(
                icon: const Icon(Icons.skip_previous),
                onPressed: controller.previous,
              ),
              IconButton(
                iconSize: 36,
                icon: playback.isLoading
                    ? const SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(playback.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
                onPressed: playback.isPlaying ? controller.pause : controller.resume,
              ),
              IconButton(
                icon: const Icon(Icons.skip_next),
                onPressed: controller.next,
              ),
              Expanded(
                child: InkWell(
                  onTap: () => context.push(
                    '/lecture/sourate/${playback.surahNumber}?ayah=${playback.ayahNumber}',
                  ),
                  child: Text(
                    '$surahName · verset ${playback.ayahNumber}'
                    '${playback.repeatMode == RepeatMode.repeatEachAyahNTimes ? ' (${playback.repeatProgress + 1}/${playback.repeatTarget})' : ''}',
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
              _SpeedButton(speed: playback.speed, onSelected: controller.setSpeed),
              _ReciterButton(reciterId: playback.reciterId, onSelected: controller.setReciter),
            ],
          ),
        ),
      ),
    );
  }
}

class _RepeatModeButton extends StatelessWidget {
  const _RepeatModeButton({required this.mode, required this.onTap});

  final RepeatMode mode;
  final VoidCallback onTap;

  IconData get _icon => switch (mode) {
        RepeatMode.off => Icons.repeat,
        RepeatMode.repeatAyah => Icons.repeat_one,
        RepeatMode.repeatRange => Icons.repeat_on,
        RepeatMode.repeatEachAyahNTimes => Icons.repeat_one_on,
      };

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: mode.label,
      child: IconButton(
        icon: Icon(_icon, color: mode == RepeatMode.off ? null : Theme.of(context).colorScheme.primary),
        onPressed: onTap,
      ),
    );
  }
}

class _SpeedButton extends StatelessWidget {
  const _SpeedButton({required this.speed, required this.onSelected});

  final double speed;
  final ValueChanged<double> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<double>(
      tooltip: 'Vitesse',
      initialValue: speed,
      onSelected: onSelected,
      itemBuilder: (context) => _kSpeeds
          .map((s) => PopupMenuItem(value: s, child: Text('${s}x')))
          .toList(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text('${speed}x', style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}

class _ReciterButton extends StatelessWidget {
  const _ReciterButton({required this.reciterId, required this.onSelected});

  final String reciterId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Récitateur',
      initialValue: reciterId,
      onSelected: onSelected,
      itemBuilder: (context) => kReciters
          .map((r) => PopupMenuItem(value: r.id, child: Text(r.name)))
          .toList(),
      icon: const Icon(Icons.record_voice_over),
    );
  }
}
