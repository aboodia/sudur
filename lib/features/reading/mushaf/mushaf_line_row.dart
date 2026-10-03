import 'package:flutter/material.dart';

import '../../../core/mushaf/mushaf_models.dart';
import '../../../core/mushaf/surah_name_glyph.dart';

/// The single-glyph ligature (﷽) for the basmallah banner — QUL's
/// "quran-common" font maps U+FDFD directly (verified with fonttools),
/// unlike the per-page QCF font or the general Hafs text font, neither of
/// which contain this codepoint.
const _kBismillahLigature = '﷽';

/// Renders one line of a Mushaf page. Ayah lines use the page-specific QCF
/// glyph font (pixel-faithful to the print Mushaf); the sourate banner uses
/// the QUL "surah-name-v4" decorative font (ligature-substituted, see
/// [surahNameLigature]); the basmallah banner uses QUL's "quran-common"
/// font, the same shared utility font family as the sourate banner.
class MushafLineRow extends StatelessWidget {
  const MushafLineRow({
    super.key,
    required this.line,
    required this.words,
    required this.fontFamily,
    required this.textScale,
    required this.ink,
    required this.highlight,
    required this.onWordTap,
    this.playingSurah,
    this.playingAyah,
  });

  final MushafLine line;
  final List<MushafWord> words;
  final String? fontFamily;
  final double textScale;

  /// The color of the text, and the background of the word being played —
  /// chosen by the page (see [MushafPaper]) rather than taken from the theme.
  final Color ink;
  final Color highlight;
  final void Function(MushafWord word) onWordTap;

  /// The ayah the audio player is currently on, if any — words belonging
  /// to it are highlighted so the reader can always see where the audio
  /// is up to without hunting for it on the page.
  final int? playingSurah;
  final int? playingAyah;

  @override
  Widget build(BuildContext context) {
    if (line.type == 'surah_name') {
      if (line.surahNumber == null) return const SizedBox.shrink();
      return FittedBox(
        fit: BoxFit.contain,
        child: Text(
          surahNameLigature(line.surahNumber!),
          style: TextStyle(
            fontFamily: 'SurahNameV4',
            fontSize: 40 * textScale,
            color: ink,
          ),
        ),
      );
    }

    if (line.type == 'basmallah') {
      return FittedBox(
        fit: BoxFit.contain,
        child: Text(
          _kBismillahLigature,
          style: TextStyle(
            fontFamily: 'QuranCommon',
            fontSize: 34 * textScale,
            color: ink,
          ),
        ),
      );
    }

    if (fontFamily == null || words.isEmpty) {
      return const SizedBox.shrink();
    }

    // The parent Column sits in a SingleChildScrollView, so height here is
    // unbounded — BoxFit.contain then only ever binds on width, scaling
    // the line up or down to exactly match it. That's what makes a line
    // grow to fill a wider viewport (landscape, tablet) instead of staying
    // pixel-locked to whatever fit the last portrait layout, while still
    // shrinking a dense line's word count down when it doesn't fit.
    return FittedBox(
      fit: BoxFit.contain,
      alignment: Alignment.center,
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: line.isCentered ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
        children: [
          for (final word in words)
            GestureDetector(
              onTap: () => onWordTap(word),
              child: Container(
                color: word.surah == playingSurah && word.ayah == playingAyah
                    ? highlight
                    : null,
                padding: EdgeInsets.symmetric(horizontal: 4.0 * textScale),
                child: Text(
                  word.text,
                  style: TextStyle(fontFamily: fontFamily, fontSize: 22 * textScale, color: ink),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The colors of a Mushaf page. The page is always dark ink on light paper,
/// whatever the app's theme: the tajweed font draws its plain letters in
/// black, which disappear on a dark background, and a printed Mushaf is
/// light anyway.
class MushafPaper {
  const MushafPaper({
    required this.paper,
    required this.ink,
    required this.highlight,
  });

  final Color paper;
  final Color ink;
  final Color highlight;

  factory MushafPaper.of(ThemeData theme) {
    if (theme.brightness == Brightness.dark) {
      return const MushafPaper(
        paper: Color(0xFFF4EFE7),
        ink: Color(0xFF181D24),
        highlight: Color(0xFFCFDCF2),
      );
    }
    return MushafPaper(
      paper: theme.colorScheme.surface,
      ink: theme.colorScheme.onSurface,
      highlight: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
    );
  }
}
