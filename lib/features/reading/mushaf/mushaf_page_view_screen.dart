import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/audio/audio_playback_controller.dart';
import '../../../core/mushaf/mushaf_font_cache.dart';
import '../../../core/mushaf/mushaf_models.dart';
import '../../../core/mushaf/mushaf_repository.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';
import '../../../core/settings/reading_settings.dart';
import 'mushaf_line_row.dart';

/// Vue Mushaf : pagination fidèle au Mushaf imprimé (604 pages, glyphes
/// mot-par-mot QCF v4 tajwid) — §6.6 du cahier des charges.
class MushafPageViewScreen extends ConsumerStatefulWidget {
  const MushafPageViewScreen({super.key, this.initialPage = 1});

  final int initialPage;

  @override
  ConsumerState<MushafPageViewScreen> createState() => _MushafPageViewScreenState();
}

class _MushafPageViewScreenState extends ConsumerState<MushafPageViewScreen> {
  late final PageController _controller;
  late int _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _controller = PageController(initialPage: widget.initialPage - 1);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mushafAsync = ref.watch(mushafRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Page $_currentPage'),
        actions: [
          IconButton(
            icon: const Icon(Icons.play_circle_outline),
            tooltip: 'Lire cette page',
            onPressed: () => _playPage(mushafAsync.value),
          ),
        ],
      ),
      body: mushafAsync.when(
        data: (mushaf) => PageView.builder(
          controller: _controller,
          itemCount: mushaf.pageCount,
          onPageChanged: (index) => setState(() => _currentPage = index + 1),
          itemBuilder: (context, index) => _MushafPageBody(pageNumber: index + 1),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Erreur : $err')),
      ),
    );
  }

  void _playPage(MushafRepository? mushaf) {
    if (mushaf == null) return;
    final lines = mushaf.linesForPage(_currentPage);
    for (final line in lines) {
      final words = mushaf.wordsForLine(line);
      if (words.isNotEmpty) {
        ref.read(audioPlaybackProvider.notifier).playFrom(words.first.surah, words.first.ayah);
        return;
      }
    }
  }
}

class _MushafPageBody extends ConsumerWidget {
  const _MushafPageBody({required this.pageNumber});

  final int pageNumber;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mushafAsync = ref.watch(mushafRepositoryProvider);
    final fontAsync = ref.watch(mushafPageFontProvider(pageNumber));
    final settings = ref.watch(readingSettingsProvider);
    final referenceAsync = ref.watch(quranReferenceProvider);
    final controller = ref.read(audioPlaybackProvider.notifier);

    final mushaf = mushafAsync.value;
    if (mushaf == null) return const SizedBox.shrink();

    final lines = mushaf.linesForPage(pageNumber);

    return fontAsync.when(
      data: (fontFamily) {
        if (fontFamily == null) {
          return _OfflineFallback(onRetry: () => ref.invalidate(mushafPageFontProvider(pageNumber)));
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Real Mushaf pages have up to 15 lines of constant height;
              // short pages (like page 1) use fewer and leave the rest of
              // the page blank, rather than stretching their lines apart.
              final rowHeight = constraints.maxHeight / kMushafLinesPerPage;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  for (final line in lines)
                    SizedBox(
                      height: rowHeight,
                      child: Center(
                        child: MushafLineRow(
                          line: line,
                          words: mushaf.wordsForLine(line),
                          fontFamily: fontFamily,
                          textScale: settings.textScale,
                          reference: referenceAsync.value,
                          onWordTap: (word) => controller.playFrom(word.surah, word.ayah),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => _OfflineFallback(onRetry: () => ref.invalidate(mushafPageFontProvider(pageNumber))),
    );
  }
}

class _OfflineFallback extends StatelessWidget {
  const _OfflineFallback({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 40),
          const SizedBox(height: 12),
          const Text('Cette page nécessite une connexion la première fois.'),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: onRetry, child: const Text('Réessayer')),
        ],
      ),
    );
  }
}
