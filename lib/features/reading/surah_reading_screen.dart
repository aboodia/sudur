import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../core/audio/audio_playback_controller.dart';
import '../../core/mushaf/mushaf_repository.dart';
import '../../core/quran_reference/quran_reference_repository.dart';
import '../../core/quran_text/quran_text_repository.dart';
import '../../core/settings/reading_settings.dart';
import 'widgets/audio_player_bar.dart';
import 'widgets/ayah_card.dart';

/// Écran de lecture (Brique 1), mode Arabe seul en priorité — Translittération
/// et Bilingue réutilisent le même écran et le même réglage de zoom.
class SurahReadingScreen extends ConsumerStatefulWidget {
  const SurahReadingScreen({super.key, required this.surahNumber, this.initialAyah});

  final int surahNumber;
  final int? initialAyah;

  @override
  ConsumerState<SurahReadingScreen> createState() => _SurahReadingScreenState();
}

class _SurahReadingScreenState extends ConsumerState<SurahReadingScreen> {
  final _itemScrollController = ItemScrollController();

  @override
  Widget build(BuildContext context) {
    final textAsync = ref.watch(quranTextProvider);
    final referenceAsync = ref.watch(quranReferenceProvider);
    final playback = ref.watch(audioPlaybackProvider);
    final controller = ref.read(audioPlaybackProvider.notifier);

    // Keep the playing ayah's highlight always in view: whenever playback
    // moves to a new ayah of this sourate, scroll it into a comfortable
    // position instead of leaving the reader to hunt for it manually.
    ref.listen(audioPlaybackProvider, (previous, next) {
      final movedToNewAyah =
          next.ayahNumber != null &&
          (previous?.ayahNumber != next.ayahNumber || previous?.surahNumber != next.surahNumber);
      if (next.surahNumber == widget.surahNumber && movedToNewAyah && _itemScrollController.isAttached) {
        _itemScrollController.scrollTo(
          index: next.ayahNumber! - 1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          alignment: 0.3,
        );
      }
    });

    final surahName = referenceAsync.value?.surahByNumber(widget.surahNumber).englishName ??
        'Sourate ${widget.surahNumber}';

    return Scaffold(
      appBar: AppBar(
        title: Text(surahName),
        actions: [
          _MushafButton(surahNumber: widget.surahNumber, ayah: widget.initialAyah ?? 1),
          const _DisplayModeMenu(),
          const _TextSizeMenu(),
        ],
      ),
      body: textAsync.when(
        data: (repo) {
          final surah = repo.surah(widget.surahNumber);
          return ScrollablePositionedList.separated(
            itemScrollController: _itemScrollController,
            initialScrollIndex: ((widget.initialAyah ?? 1) - 1).clamp(0, surah.ayahs.length - 1),
            itemCount: surah.ayahs.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final ayah = surah.ayahs[index];
              final isPlaying = playback.isPlaying &&
                  playback.surahNumber == widget.surahNumber &&
                  playback.ayahNumber == ayah.numberInSurah;
              return AyahCard(
                surahNumber: widget.surahNumber,
                ayah: ayah,
                isPlaying: isPlaying,
                onTap: () {
                  final isCurrent = playback.surahNumber == widget.surahNumber &&
                      playback.ayahNumber == ayah.numberInSurah;
                  if (isCurrent && playback.isPlaying) {
                    controller.pause();
                  } else if (isCurrent) {
                    controller.resume();
                  } else {
                    controller.playFrom(widget.surahNumber, ayah.numberInSurah);
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

class _MushafButton extends ConsumerWidget {
  const _MushafButton({required this.surahNumber, required this.ayah});

  final int surahNumber;
  final int ayah;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.menu_book),
      tooltip: 'Vue Mushaf',
      onPressed: () async {
        final mushaf = await ref.read(mushafRepositoryProvider.future);
        final page = mushaf.pageForAyah(surahNumber, ayah) ?? 1;
        if (context.mounted) context.push('/lecture/mushaf?page=$page');
      },
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
