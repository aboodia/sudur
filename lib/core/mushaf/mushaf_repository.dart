import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'mushaf_models.dart';

/// True Mushaf-exact pagination (§6.6 of the cahier des charges): 604 pages,
/// 15 lines each, word-for-word identical to the printed Madina Mushaf.
/// Built from QUL's "QPC v4 tajweed, 15 lines" layout + word/glyph export —
/// this repository only holds structure and glyph codes; the actual QCF v4
/// tajweed font is fetched per page by [MushafFontCache], since bundling
/// all 604 page fonts (~160MB as TTF) in the app is impractical.
class MushafRepository {
  MushafRepository(this._linesByPage, this._words, this._firstWordIdByAyah, this.pageCount);

  static Future<MushafRepository> load() async {
    final linesRaw = await rootBundle.loadString('assets/data/mushaf_pages.json');
    final wordsRaw = await rootBundle.loadString('assets/data/mushaf_words.json');

    final lineList = (jsonDecode(linesRaw) as List)
        .cast<Map<String, dynamic>>()
        .map(MushafLine.fromJson)
        .toList(growable: false);

    final linesByPage = <int, List<MushafLine>>{};
    var pageCount = 0;
    for (final line in lineList) {
      (linesByPage[line.page] ??= []).add(line);
      if (line.page > pageCount) pageCount = line.page;
    }

    final wordsJson = jsonDecode(wordsRaw) as Map<String, dynamic>;
    final words = <int, MushafWord>{};
    final firstWordIdByAyah = <String, int>{};
    wordsJson.forEach((idStr, value) {
      final id = int.parse(idStr);
      final word = MushafWord.fromJson(id, value as Map<String, dynamic>);
      words[id] = word;
      final key = '${word.surah}:${word.ayah}';
      final existing = firstWordIdByAyah[key];
      if (existing == null || id < existing) firstWordIdByAyah[key] = id;
    });

    return MushafRepository(linesByPage, words, firstWordIdByAyah, pageCount);
  }

  final Map<int, List<MushafLine>> _linesByPage;
  final Map<int, MushafWord> _words;
  final Map<String, int> _firstWordIdByAyah;
  final int pageCount;

  List<MushafLine> linesForPage(int page) => _linesByPage[page] ?? const [];

  List<MushafWord> wordsForLine(MushafLine line) {
    if (!line.hasWords) return const [];
    return [
      for (var id = line.firstWordId!; id <= line.lastWordId!; id++) ?_words[id],
    ];
  }

  /// The page on which (surah, ayah) first appears — used to jump from the
  /// continuous reading view into the Mushaf page view.
  int? pageForAyah(int surah, int ayah) {
    final wordId = _firstWordIdByAyah['$surah:$ayah'];
    if (wordId == null) return null;
    int? page;
    for (final entry in _linesByPage.entries) {
      for (final line in entry.value) {
        if (line.hasWords && line.firstWordId! <= wordId && wordId <= line.lastWordId!) {
          page = entry.key;
        }
      }
    }
    return page;
  }

  /// The (surah, ayah) of the first ayah on [page] — a page can start
  /// mid-sourate, so this is what labels the page header (surah name, Juz)
  /// rather than assuming the page's own banner line.
  ({int surah, int ayah})? firstAyahOnPage(int page) {
    final lines = List.of(_linesByPage[page] ?? const [])..sort((a, b) => a.line.compareTo(b.line));
    for (final line in lines) {
      if (!line.hasWords) continue;
      final word = _words[line.firstWordId];
      if (word != null) return (surah: word.surah, ayah: word.ayah);
    }
    return null;
  }
}

final mushafRepositoryProvider = FutureProvider<MushafRepository>((ref) {
  return MushafRepository.load();
});
