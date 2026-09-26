import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/audio/audio_playback_controller.dart';
import '../../../core/mushaf/mushaf_font_cache.dart';
import '../../../core/mushaf/mushaf_repository.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';
import '../../../core/settings/reading_settings.dart';
import '../widgets/audio_player_bar.dart';
import 'mushaf_line_row.dart';

/// Vue Mushaf : pagination fidèle au Mushaf imprimé (604 pages, glyphes
/// mot-par-mot QCF v4 tajwid) — §6.6 du cahier des charges. C'est la vue de
/// lecture par défaut à l'ouverture d'une sourate ; la lecture continue
/// (avec traduction) reste accessible via le bouton en haut à droite.
class MushafPageViewScreen extends ConsumerStatefulWidget {
  const MushafPageViewScreen({super.key, this.initialPage = 1});

  final int initialPage;

  @override
  ConsumerState<MushafPageViewScreen> createState() => _MushafPageViewScreenState();
}

class _MushafPageViewScreenState extends ConsumerState<MushafPageViewScreen> {
  late final PageController _controller;
  late int _currentPage;

  /// Masque/affiche ensemble le mini-lecteur ET la barre du haut (nom de
  /// sourate, Juz) sur un tap dans la zone de lecture — un seul geste pour
  /// une lecture immersive, plutôt que deux réglages indépendants qui se
  /// désynchroniseraient.
  bool _showChrome = true;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _controller = PageController(initialPage: widget.initialPage - 1);
    _prepareInitialAyah();
  }

  // Le mini-lecteur doit être visible dès l'entrée sur la page, prêt à
  // jouer sans attendre un premier tap sur un mot — sauf si une lecture
  // est déjà en cours ailleurs, que [prepare] ne doit pas écraser. Le
  // (surah, ayah) de la page d'entrée n'est connu qu'une fois le
  // MushafRepository chargé, d'où l'attente async.
  Future<void> _prepareInitialAyah() async {
    final mushaf = await ref.read(mushafRepositoryProvider.future);
    if (!mounted) return;
    final firstAyah = mushaf.firstAyahOnPage(widget.initialPage);
    if (firstAyah == null) return;
    ref.read(audioPlaybackProvider.notifier).prepare(firstAyah.surah, firstAyah.ayah);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mushafAsync = ref.watch(mushafRepositoryProvider);
    final referenceAsync = ref.watch(quranReferenceProvider);
    final playback = ref.watch(audioPlaybackProvider);

    // Keep the playing ayah's highlight always in view: whenever playback
    // moves to a new ayah, jump to whichever page it's on if we're not
    // already there.
    ref.listen(audioPlaybackProvider, (previous, next) {
      final movedToNewAyah =
          next.ayahNumber != null &&
          (previous?.ayahNumber != next.ayahNumber || previous?.surahNumber != next.surahNumber);
      if (!movedToNewAyah) return;
      final mushaf = mushafAsync.value;
      if (mushaf == null) return;
      final targetPage = mushaf.pageForAyah(next.surahNumber!, next.ayahNumber!);
      if (targetPage != null && targetPage != _currentPage && _controller.hasClients) {
        _controller.animateToPage(
          targetPage - 1,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });

    // A Mushaf page can start mid-sourate, so the header always reflects
    // the page's first ayah rather than assuming its own banner line.
    final firstAyah = mushafAsync.value?.firstAyahOnPage(_currentPage);
    final surahName = firstAyah != null
        ? referenceAsync.value?.surahByNumber(firstAyah.surah).englishName
        : null;
    final juz = firstAyah != null
        ? referenceAsync.value?.juzForSurahAyah(firstAyah.surah, firstAyah.ayah)
        : null;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _showChrome
                  ? _MushafTopBar(
                      surahName: surahName,
                      juz: juz,
                      onSwitchToTextView: firstAyah == null
                          ? null
                          : () => context.push(
                                '/lecture/sourate/${firstAyah.surah}?ayah=${firstAyah.ayah}',
                              ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
            Expanded(
              child: GestureDetector(
                // Tapoter une zone vide de la page (hors des mots, qui
                // lancent leur lecture) bascule l'affichage du mini-lecteur
                // et de la barre du haut, pour une lecture plus immersive —
                // ce détecteur ne couvre que la zone de lecture, pas la
                // barre du haut, pour qu'un tap dans un espace vide de
                // celle-ci ne masque pas tout par erreur.
                onTap: () => setState(() => _showChrome = !_showChrome),
                behavior: HitTestBehavior.translucent,
                child: mushafAsync.when(
                  data: (mushaf) => PageView.builder(
                    controller: _controller,
                    // Un Mushaf se feuillette de droite à gauche : glisser
                    // vers la droite doit avancer (page suivante), pas
                    // reculer.
                    reverse: true,
                    itemCount: mushaf.pageCount,
                    onPageChanged: (index) => setState(() => _currentPage = index + 1),
                    itemBuilder: (context, index) => _MushafPageBody(pageNumber: index + 1),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, _) => Center(child: Text('Erreur : $err')),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: _showChrome
            ? const AudioPlayerBar()
            : (playback.hasCurrentAyah
                ? CollapsedPlayerHandle(onTap: () => setState(() => _showChrome = true))
                : const SizedBox(width: double.infinity)),
      ),
    );
  }
}

class _MushafTopBar extends StatelessWidget {
  const _MushafTopBar({required this.surahName, required this.juz, required this.onSwitchToTextView});

  final String? surahName;
  final int? juz;
  final VoidCallback? onSwitchToTextView;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Retour',
              onPressed: () => context.pop(),
            ),
            Expanded(
              child: Text(
                surahName ?? '',
                style: theme.textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (juz != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('Juz $juz', style: theme.textTheme.titleMedium),
              ),
            IconButton(
              icon: const Icon(Icons.article_outlined),
              tooltip: 'Vue texte / traduction',
              onPressed: onSwitchToTextView,
            ),
          ],
        ),
      ),
    );
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
    final playback = ref.watch(audioPlaybackProvider);
    final controller = ref.read(audioPlaybackProvider.notifier);

    final mushaf = mushafAsync.value;
    if (mushaf == null) return const SizedBox.shrink();

    final lines = mushaf.linesForPage(pageNumber);

    return fontAsync.when(
      data: (fontFamily) {
        if (fontFamily == null) {
          return _OfflineFallback(onRetry: () => ref.invalidate(mushafPageFontProvider(pageNumber)));
        }
        // Each line is sized to fill the available width (FittedBox in
        // MushafLineRow), so it grows or shrinks with the actual screen —
        // portrait, landscape or tablet — instead of staying pixel-locked
        // to whatever fit a fixed row-height grid on first layout. Lines
        // are no longer squeezed into a fixed 15-row height division, so
        // the page scrolls vertically when a wider (and therefore taller,
        // width-fit) line no longer fits the viewport, e.g. in landscape.
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            children: [
              for (final line in lines)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 6 * settings.textScale),
                  child: MushafLineRow(
                    line: line,
                    words: mushaf.wordsForLine(line),
                    fontFamily: fontFamily,
                    textScale: settings.textScale,
                    playingSurah: playback.surahNumber,
                    playingAyah: playback.ayahNumber,
                    onWordTap: (word) => controller.playFrom(word.surah, word.ayah),
                  ),
                ),
            ],
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
