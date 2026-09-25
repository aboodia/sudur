import 'package:flutter/material.dart';

import '../../../core/mushaf/mushaf_models.dart';
import '../../../core/mushaf/surah_name_glyph.dart';

const _kBismillah = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';

/// Renders one line of a Mushaf page. Ayah lines use the page-specific QCF
/// glyph font (pixel-faithful to the print Mushaf); the sourate banner uses
/// the QUL "surah-name-v4" decorative font (ligature-substituted, see
/// [surahNameLigature]). The basmallah line isn't covered by any Mushaf
/// glyph dataset (it's not part of the 6236-ayah numbering), so it falls
/// back to the app's own Arabic font (AmiriQuran).
class MushafLineRow extends StatelessWidget {
  const MushafLineRow({
    super.key,
    required this.line,
    required this.words,
    required this.fontFamily,
    required this.textScale,
    required this.onWordTap,
  });

  final MushafLine line;
  final List<MushafWord> words;
  final String? fontFamily;
  final double textScale;
  final void Function(MushafWord word) onWordTap;

  @override
  Widget build(BuildContext context) {
    if (line.type == 'surah_name') {
      if (line.surahNumber == null) return const SizedBox.shrink();
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          surahNameLigature(line.surahNumber!),
          style: TextStyle(fontFamily: 'SurahNameV4', fontSize: 40 * textScale),
        ),
      );
    }

    if (line.type == 'basmallah') {
      return Center(
        child: Text(
          _kBismillah,
          style: TextStyle(fontFamily: 'AmiriQuran', fontSize: 20 * textScale),
        ),
      );
    }

    if (fontFamily == null || words.isEmpty) {
      return const SizedBox.shrink();
    }

    // A dense line (many short words) can be wider than the screen once
    // laid out edge-to-edge, especially at larger text scales — scale the
    // whole line down to fit instead of overflowing (FittedBox), rather
    // than wrapping mid-line, which would break the one-line-per-line
    // Mushaf layout.
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.center,
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: line.isCentered ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
        children: [
          for (final word in words)
            GestureDetector(
              onTap: () => onWordTap(word),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0 * textScale),
                child: Text(
                  word.text,
                  style: TextStyle(fontFamily: fontFamily, fontSize: 22 * textScale),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
