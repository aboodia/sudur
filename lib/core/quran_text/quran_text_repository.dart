import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'quran_text_models.dart';

/// Full Quran text (Arabic Uthmani, French translation, transliteration)
/// loaded once from assets/data/quran_text.json — Tanzil-sourced via
/// alquran.cloud (quran-uthmani / fr.hamidullah / en.transliteration).
///
/// This is a practical MVP source: it gives authentic, widely-used text
/// but not the pixel-perfect QCF glyph-per-word Mushaf pagination described
/// in §6.6 of the cahier des charges, which requires QUL/Quran Foundation
/// resources behind an account signup. Swappable later without touching
/// the reading UI, since callers only see [SurahText]/[AyahText].
class QuranTextRepository {
  QuranTextRepository(this._surahs);

  static Future<QuranTextRepository> load() async {
    final raw = await rootBundle.loadString('assets/data/quran_text.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final surahs = (json['surahs'] as List)
        .cast<Map<String, dynamic>>()
        .map(SurahText.fromJson)
        .toList(growable: false);
    return QuranTextRepository(surahs);
  }

  final List<SurahText> _surahs;

  SurahText surah(int number) => _surahs[number - 1];

  /// 1-based position of (surah, ayah) among all 6236 ayahs of the Quran —
  /// used to build reciter audio URLs (cdn.islamic.network numbers ayahs
  /// this way across the whole Mushaf, not per-sourate).
  int globalAyahNumber(int surahNumber, int ayahNumber) {
    var count = 0;
    for (var i = 0; i < surahNumber - 1; i++) {
      count += _surahs[i].ayahs.length;
    }
    return count + ayahNumber;
  }
}

final quranTextProvider = FutureProvider<QuranTextRepository>((ref) {
  return QuranTextRepository.load();
});
