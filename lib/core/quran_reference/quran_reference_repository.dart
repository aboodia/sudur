import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'quran_reference_models.dart';

/// Static Quran structure (114 sourates, 30 Juz, 60 Hizb) loaded once from
/// assets/data/quran_meta.json. Kept separate from the user database
/// (core/database) so the reference content can be updated independently of
/// user data, per §6.2 of the cahier des charges.
class QuranReferenceRepository {
  QuranReferenceRepository({
    required this.surahs,
    required this.juzStarts,
    required this.hizbStarts,
  });

  static Future<QuranReferenceRepository> load() async {
    final raw = await rootBundle.loadString('assets/data/quran_meta.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;

    final surahs = (json['surahs'] as List)
        .cast<Map<String, dynamic>>()
        .map(Surah.fromJson)
        .toList(growable: false);
    final juzStarts = (json['juzStarts'] as List)
        .cast<Map<String, dynamic>>()
        .map(JuzBoundary.fromJson)
        .toList(growable: false);
    final hizbStarts = (json['hizbStarts'] as List)
        .cast<Map<String, dynamic>>()
        .map(HizbBoundary.fromJson)
        .toList(growable: false);

    return QuranReferenceRepository(
      surahs: surahs,
      juzStarts: juzStarts,
      hizbStarts: hizbStarts,
    );
  }

  final List<Surah> surahs;
  final List<JuzBoundary> juzStarts;
  final List<HizbBoundary> hizbStarts;

  Surah surahByNumber(int number) =>
      surahs.firstWhere((s) => s.number == number);

  /// Returns true if (surah, ayah) comes at or after a boundary's start.
  bool _reached(int boundarySurah, int boundaryAyah, int surah, int ayah) =>
      surah > boundarySurah || (surah == boundarySurah && ayah >= boundaryAyah);

  /// Which of the 30 Juz a given ayah belongs to.
  int juzForSurahAyah(int surah, int ayah) {
    var result = 1;
    for (final boundary in juzStarts) {
      if (_reached(boundary.surah, boundary.ayah, surah, ayah)) {
        result = boundary.juz;
      } else {
        break;
      }
    }
    return result;
  }

  /// Which of the 60 Hizb a given ayah belongs to.
  int hizbForSurahAyah(int surah, int ayah) {
    var result = 1;
    for (final boundary in hizbStarts) {
      if (_reached(boundary.surah, boundary.ayah, surah, ayah)) {
        result = boundary.hizb;
      } else {
        break;
      }
    }
    return result;
  }

  /// All sourates that have at least one ayah within the given Juz.
  List<Surah> surahsInJuz(int juz) {
    return surahs.where((s) {
      final firstAyahJuz = juzForSurahAyah(s.number, 1);
      final lastAyahJuz = juzForSurahAyah(s.number, s.numberOfAyahs);
      return juz >= firstAyahJuz && juz <= lastAyahJuz;
    }).toList(growable: false);
  }
}

final quranReferenceProvider = FutureProvider<QuranReferenceRepository>((ref) {
  return QuranReferenceRepository.load();
});
