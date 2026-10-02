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

  /// All of (surah, ayah)'s words in reading order, glyph ids included —
  /// used by the Mémorisation session to reuse the exact Mushaf rendering
  /// (word ids are assigned in Quran order, so they're contiguous for a
  /// given ayah once the first one is found).
  List<MushafWord> wordsForAyah(int surah, int ayah) {
    final firstId = _firstWordIdByAyah['$surah:$ayah'];
    if (firstId == null) return const [];
    final result = <MushafWord>[];
    var id = firstId;
    while (true) {
      final word = _words[id];
      if (word == null || word.surah != surah || word.ayah != ayah) break;
      result.add(word);
      id++;
    }
    return result;
  }

  /// The Mushaf page containing word [wordId] — a long ayah (e.g. 2:282,
  /// the Quran's longest) can straddle two pages, each needing its own QCF
  /// font, so this is looked up per word rather than once per ayah.
  int? pageForWordId(int wordId) {
    for (final entry in _linesByPage.entries) {
      for (final line in entry.value) {
        if (line.hasWords && line.firstWordId! <= wordId && wordId <= line.lastWordId!) {
          return entry.key;
        }
      }
    }
    return null;
  }

  /// The page on which (surah, ayah) first appears — used to jump from the
  /// continuous reading view into the Mushaf page view.
  int? pageForAyah(int surah, int ayah) {
    final wordId = _firstWordIdByAyah['$surah:$ayah'];
    if (wordId == null) return null;
    return pageForWordId(wordId);
  }

  Map<({int surah, int ayah}), int>? _firstPageByAyah;

  /// For every ayah, the page on which it begins — built in one pass over
  /// the layout (and cached), where calling [pageForAyah] for each of the
  /// 6,236 ayahs would scan the whole layout every time.
  Map<({int surah, int ayah}), int> firstPageByAyah() =>
      _firstPageByAyah ??= _buildFirstPageByAyah();

  Map<({int surah, int ayah}), int> _buildFirstPageByAyah() {
    final result = <({int surah, int ayah}), int>{};
    for (var page = 1; page <= pageCount; page++) {
      for (final line in _linesByPage[page] ?? const <MushafLine>[]) {
        if (!line.hasWords) continue;
        for (var id = line.firstWordId!; id <= line.lastWordId!; id++) {
          final word = _words[id];
          if (word == null) continue;
          result.putIfAbsent((surah: word.surah, ayah: word.ayah), () => page);
        }
      }
    }
    return result;
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
