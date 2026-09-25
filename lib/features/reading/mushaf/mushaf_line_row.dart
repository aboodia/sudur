import 'package:flutter/material.dart';

import '../../../core/mushaf/mushaf_models.dart';
import '../../../core/quran_reference/quran_reference_repository.dart';

const _kBismillah = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';

/// Renders one line of a Mushaf page. Ayah lines use the page-specific QCF
/// glyph font (pixel-faithful to the print Mushaf); the sourate banner and
/// basmallah lines aren't covered by the word/glyph dataset (they're not
/// part of the 6236-ayah numbering), so they fall back to the app's own
/// Arabic font (AmiriQuran) with a simple decorative treatment.
class MushafLineRow extends StatelessWidget {
  const MushafLineRow({
    super.key,
    required this.line,
    required this.words,
    required this.fontFamily,
    required this.textScale,
    required this.reference,
    required this.onWordTap,
  });

  final MushafLine line;
  final List<MushafWord> words;
  final String? fontFamily;
  final double textScale;
  final QuranReferenceRepository? reference;
  final void Function(MushafWord word) onWordTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (line.type == 'surah_name') {
      final name = line.surahNumber != null
          ? reference?.surahByNumber(line.surahNumber!).nameArabic ?? ''
          : '';
      return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          name,
          style: TextStyle(fontFamily: 'AmiriQuran', fontSize: 20 * textScale),
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

    return Row(
      textDirection: TextDirection.rtl,
      mainAxisAlignment: line.isCentered ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
      children: [
        for (final word in words)
          GestureDetector(
            onTap: () => onWordTap(word),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: line.isCentered ? 4.0 * textScale : 0),
              child: Text(
                word.text,
                style: TextStyle(fontFamily: fontFamily, fontSize: 22 * textScale),
              ),
            ),
          ),
      ],
    );
  }
}
