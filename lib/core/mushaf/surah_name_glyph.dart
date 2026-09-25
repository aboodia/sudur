/// The QUL "surah-name-v4" font (§6.6 of the cahier des charges: decorative
/// Mushaf banners, not covered by the ayah word/glyph dataset) renders its
/// glyphs via OpenType ligature substitution, not direct Unicode codepoints:
/// typing the literal ASCII string "surah001".."surah114" (and the standalone
/// "surah-icon") triggers the 'liga' feature to substitute in the matching
/// decorative glyph. Flutter/Skia applies standard ligatures by default, so
/// no special TextStyle configuration is needed — just render this string
/// with the SurahNameV4 font family.
String surahNameLigature(int surahNumber) =>
    'surah${surahNumber.toString().padLeft(3, '0')}';

const kSurahIconLigature = 'surah-icon';
