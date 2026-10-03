import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/audio/audio_playback_controller.dart';
import '../../../core/audio/playback_state.dart';
import '../../../core/audio/reciter.dart';
import '../../../core/settings/audio_settings.dart';
import '../../../core/mushaf/mushaf_repository.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';
import '../../../l10n/app_localizations.dart';

/// Lecteur audio étendu (Brique 1) : transport, répétition à 4 états,
/// vitesse, choix du récitateur. Rendu globalement par le shell de
/// navigation (voir router.dart), pas par chaque écran de lecture, pour
/// qu'on sache toujours ce qui joue — même en revenant sur l'app depuis un
/// autre onglet — plutôt que de devoir renaviguer vers le bon écran pour
/// le retrouver.
class AudioPlayerBar extends ConsumerWidget {
  const AudioPlayerBar({super.key, this.onShowPage});

  /// Called with the Mushaf page of the playing ayah when its name is
  /// tapped, by a screen that already shows the Mushaf (it just turns to
  /// that page). Null elsewhere: the Mushaf is then opened on that page.
  final void Function(int page)? onShowPage;

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
              _RepeatModeButton(playback: playback, controller: controller),
              IconButton(
                tooltip: AppLocalizations.of(context).tooltipPreviousAyah,
                icon: const Icon(Icons.skip_previous),
                onPressed: controller.previous,
              ),
              IconButton(
                tooltip: playback.isPlaying
                    ? AppLocalizations.of(context).tooltipPause
                    : AppLocalizations.of(context).tooltipPlay,
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
                tooltip: AppLocalizations.of(context).tooltipNextAyah,
                icon: const Icon(Icons.skip_next),
                onPressed: controller.next,
              ),
              Expanded(
                child: InkWell(
                  onTap: () async {
                    final mushaf = await ref.read(mushafRepositoryProvider.future);
                    final page =
                        mushaf.pageForAyah(playback.surahNumber!, playback.ayahNumber!) ?? 1;
                    if (!context.mounted) return;
                    if (onShowPage != null) {
                      onShowPage!(page);
                    } else {
                      context.push('/lecture/mushaf?page=$page');
                    }
                  },
                  child: Text(
                    '$surahName · verset ${playback.ayahNumber}'
                    '${playback.repeatMode == RepeatMode.repeatEachAyahNTimes ? ' (${playback.repeatProgress + 1}/${playback.repeatTarget + 1})' : ''}',
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

/// Combien de fois répéter l'ayah courant avant de passer au suivant :
/// aucune répétition, 1 à 3 fois, ou en boucle infinie. Plutôt qu'un menu
/// à choix, un tap fait défiler ces états dans l'ordre — le symbole du
/// bouton affiche directement l'état courant (1, 2, 3, ∞ ou l'icône de
/// répétition pour "aucune").
class _RepeatModeButton extends StatelessWidget {
  const _RepeatModeButton({required this.playback, required this.controller});

  final ReadingPlaybackState playback;
  final AudioPlaybackController controller;

  bool get _isActive => playback.repeatMode != RepeatMode.off;

  void _cycle() {
    switch (playback.repeatMode) {
      case RepeatMode.off:
      case RepeatMode.repeatRange:
      case RepeatMode.repeatThenStop:
        controller.setRepeatCount(1);
      case RepeatMode.repeatEachAyahNTimes:
        if (playback.repeatTarget < 3) {
          controller.setRepeatCount(playback.repeatTarget + 1);
        } else {
          controller.setInfiniteRepeat();
        }
      case RepeatMode.repeatAyah:
        controller.setNoRepeat();
    }
  }

  Widget _symbol(Color color) {
    switch (playback.repeatMode) {
      case RepeatMode.off:
      case RepeatMode.repeatRange:
      case RepeatMode.repeatThenStop:
        return Icon(Icons.repeat, color: color);
      case RepeatMode.repeatAyah:
        return Text('∞', style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold));
      case RepeatMode.repeatEachAyahNTimes:
        // Le chiffre se superpose au centre de l'icône de répétition (les
        // deux flèches tournantes), plutôt que de la remplacer.
        return Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.repeat, color: color),
            Text(
              '${playback.repeatTarget}',
              style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold, height: 1),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = _isActive ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant;
    return IconButton(
      tooltip: 'Répétition',
      onPressed: _cycle,
      icon: _symbol(color),
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
      itemBuilder: (context) => kPlaybackSpeeds
          .map((s) => PopupMenuItem(value: s, child: Text('${s}x')))
          .toList(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Text('${speed}x', style: Theme.of(context).textTheme.bodyMedium),
      ),
    );
  }
}

/// Poignée affichée à la place du mini-lecteur quand la lecture immersive
/// l'a masqué (tap sur le texte) — sans elle, rien ne montre que la barre
/// est juste cachée plutôt que disparue, ni comment la faire réapparaître.
class CollapsedPlayerHandle extends StatelessWidget {
  const CollapsedPlayerHandle({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      child: SafeArea(
        top: false,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: double.infinity,
            height: 32,
            child: Icon(
              Icons.keyboard_arrow_up,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
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
