import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 'required' (wajib) | 'optional' (mustahab) — the classical distinction
/// between the two kinds of Quranic prostration verse. The Uthmani text
/// itself already carries the ۩ ornament inline (Tanzil source), so this
/// dataset's only added value is knowing *which* of the two a given sajda
/// is, for a badge/tooltip — not for rendering the mark itself.
class SajdaRepository {
  SajdaRepository(this._byLocation);

  static Future<SajdaRepository> load() async {
    final raw = await rootBundle.loadString('assets/data/quran_sajda.json');
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final byLocation = <String, String>{};
    for (final entry in json.values) {
      final map = entry as Map<String, dynamic>;
      final verseKey = map['verse_key'] as String; // "7:206"
      byLocation[verseKey] = map['sajdah_type'] as String;
    }
    return SajdaRepository(byLocation);
  }

  final Map<String, String> _byLocation;

  /// 'required', 'optional', or null if (surah, ayah) isn't a sajda verse.
  String? sajdaTypeFor(int surah, int ayah) => _byLocation['$surah:$ayah'];
}

final sajdaRepositoryProvider = FutureProvider<SajdaRepository>((ref) {
  return SajdaRepository.load();
});
