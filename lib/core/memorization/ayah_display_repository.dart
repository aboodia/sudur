import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A richer per-ayah text source than [QuranTextRepository] (used since
/// Brique 1) — `assets/data/quran_metadata_ayah.json` carries the QPC
/// "uthmani" script (nicer Quranic diacritics/pause marks) with the
/// trailing ayah-number glyph already embedded in `text`, e.g.
/// "بِسۡمِ ٱللَّهِ ٱلرَّحۡمَٰنِ ٱلرَّحِيمِ ١". Used by the Mémorisation
/// session (Brique 3) for a nicer verse-by-verse display.
class AyahDisplayRepository {
  AyahDisplayRepository(this._textBySurahAyah);

  static Future<AyahDisplayRepository> load() async {
    final raw = await rootBundle.loadString('assets/data/quran_metadata_ayah.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final map = <String, String>{};
    for (final entry in json.values) {
      final e = entry as Map<String, dynamic>;
      map['${e['surah_number']}:${e['ayah_number']}'] = e['text'] as String;
    }
    return AyahDisplayRepository(map);
  }

  final Map<String, String> _textBySurahAyah;

  /// Raw text including the trailing Eastern-Arabic ayah-number glyph —
  /// see [parseAyahDisplayText] to split it into maskable words.
  String? rawText(int surahNumber, int ayahNumber) => _textBySurahAyah['$surahNumber:$ayahNumber'];
}

final ayahDisplayRepositoryProvider = FutureProvider<AyahDisplayRepository>((ref) {
  return AyahDisplayRepository.load();
});

final _kTrailingNumber = RegExp(r'^[٠-٩]+$');

/// Splits an ayah's raw display text into maskable words and its trailing
/// ayah-number marker (if any) — the marker isn't a real word (it's not
/// counted in the source's `words_count`), so it's never masked and always
/// shown at the end of the verse, like the small ayah-end circle in a
/// printed Mushaf.
({List<String> words, String? marker}) parseAyahDisplayText(String raw) {
  final tokens = raw.trim().split(RegExp(r'\s+'));
  if (tokens.isNotEmpty && _kTrailingNumber.hasMatch(tokens.last)) {
    return (words: tokens.sublist(0, tokens.length - 1), marker: tokens.last);
  }
  return (words: tokens, marker: null);
}
