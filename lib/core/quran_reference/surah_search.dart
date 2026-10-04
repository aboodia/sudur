import 'quran_reference_models.dart';

// Finding a sourate by what the user types — pure logic, no Flutter.

const _accents = {
  'à': 'a',
  'â': 'a',
  'ä': 'a',
  'á': 'a',
  'é': 'e',
  'è': 'e',
  'ê': 'e',
  'ë': 'e',
  'î': 'i',
  'ï': 'i',
  'í': 'i',
  'ô': 'o',
  'ö': 'o',
  'ó': 'o',
  'ù': 'u',
  'û': 'u',
  'ü': 'u',
  'ú': 'u',
  'ç': 'c',
  'œ': 'oe',
  'æ': 'ae',
};

/// Lowercase letters and digits only, accents removed: "Al-Baqara",
/// "al baqara" and "ÂL BAQARA" all become "albaqara".
String normalizeSearch(String text) {
  final out = StringBuffer();
  for (final rune in text.toLowerCase().runes) {
    final ch = String.fromCharCode(rune);
    final plain = _accents[ch] ?? ch;
    for (final c in plain.runes) {
      final isDigit = c >= 0x30 && c <= 0x39;
      final isLetter = c >= 0x61 && c <= 0x7a;
      if (isDigit || isLetter) out.writeCharCode(c);
    }
  }
  return out.toString();
}

/// Whether [surah] answers [query]: its number, or part of its name in
/// transliteration or in French. An empty query matches every sourate.
bool surahMatches(Surah surah, String query) {
  final q = normalizeSearch(query);
  if (q.isEmpty) return true;
  if ('${surah.number}' == q) return true;
  return normalizeSearch(surah.englishName).contains(q) ||
      normalizeSearch(surah.frenchNameTranslation).contains(q) ||
      normalizeSearch(surah.englishNameTranslation).contains(q);
}
