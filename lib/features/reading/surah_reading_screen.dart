import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../core/audio/audio_playback_controller.dart';
import '../../core/quran_reference/quran_reference_repository.dart';
import '../../core/quran_text/quran_text_repository.dart';
import '../../core/settings/reading_settings.dart';
import 'widgets/audio_player_bar.dart';
import 'widgets/ayah_card.dart';

/// Écran de lecture (Brique 1), mode Arabe seul en priorité — Translittération
/// et Bilingue réutilisent le même écran et le même réglage de zoom.
class SurahReadingScreen extends ConsumerWidget {
  const SurahReadingScreen({super.key, required this.surahNumber, this.initialAyah});

  final int surahNumber;
  final int? initialAyah;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textAsync = ref.watch(quranTextProvider);
    final referenceAsync = ref.watch(quranReferenceProvider);
    final playback = ref.watch(audioPlaybackProvider);
    final controller = ref.read(audioPlaybackProvider.notifier);

    final surahName = referenceAsync.value?.surahByNumber(surahNumber).englishName ??
        'Sourate $surahNumber';

    return Scaffold(
      appBar: AppBar(
        title: Text(surahName),
        actions: const [_DisplayModeMenu(), _TextSizeMenu()],
      ),
      body: textAsync.when(
        data: (repo) {
          final surah = repo.surah(surahNumber);
          return ScrollablePositionedList.separated(
            initialScrollIndex: ((initialAyah ?? 1) - 1).clamp(0, surah.ayahs.length - 1),
            itemCount: surah.ayahs.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final ayah = surah.ayahs[index];
              final isPlaying = playback.isPlaying &&
                  playback.surahNumber == surahNumber &&
                  playback.ayahNumber == ayah.numberInSurah;
              return AyahCard(
                surahNumber: surahNumber,
                ayah: ayah,
                isPlaying: isPlaying,
                onTap: () {
                  final isCurrent = playback.surahNumber == surahNumber &&
                      playback.ayahNumber == ayah.numberInSurah;
                  if (isCurrent && playback.isPlaying) {
                    controller.pause();
                  } else if (isCurrent) {
                    controller.resume();
                  } else {
                    controller.playFrom(surahNumber, ayah.numberInSurah);
                  }
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur : $err')),
      ),
      bottomNavigationBar: const AudioPlayerBar(),
    );
  }
}

class _DisplayModeMenu extends ConsumerWidget {
  const _DisplayModeMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(readingSettingsProvider);
    final controller = ref.read(readingSettingsProvider.notifier);
    return PopupMenuButton<ReadingDisplayMode>(
      tooltip: 'Mode d\'affichage',
      initialValue: settings.displayMode,
      onSelected: controller.setDisplayMode,
      itemBuilder: (context) => ReadingDisplayMode.values
          .map((mode) => PopupMenuItem(value: mode, child: Text(mode.label)))
          .toList(),
      icon: const Icon(Icons.translate),
    );
  }
}

class _TextSizeMenu extends ConsumerWidget {
  const _TextSizeMenu();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(readingSettingsProvider);
    final controller = ref.read(readingSettingsProvider.notifier);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.text_decrease),
          onPressed: () => controller.setTextScale(settings.textScale - 0.1),
        ),
        IconButton(
          icon: const Icon(Icons.text_increase),
          onPressed: () => controller.setTextScale(settings.textScale + 0.1),
        ),
      ],
    );
  }
}
