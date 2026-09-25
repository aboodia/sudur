import 'package:flutter_test/flutter_test.dart';
import 'package:wird/core/mushaf/mushaf_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MushafRepository repo;

  setUpAll(() async {
    repo = await MushafRepository.load();
  });

  test('loads the standard 604-page Madina Mushaf layout', () {
    expect(repo.pageCount, 604);
  });

  test('page 1 starts with the Fatiha banner then its 7 ayahs (no separate '
      'basmallah line: it IS Al-Fatiha 1:1)', () {
    final lines = repo.linesForPage(1);
    expect(lines.first.type, 'surah_name');
    expect(lines.first.surahNumber, 1);
    final ayahLines = lines.where((l) => l.type == 'ayah').toList();
    expect(ayahLines, isNotEmpty);
    expect(repo.wordsForLine(ayahLines.first).first.ayah, 1);
  });

  test('Al-Baqara (surah 2) page has a separate basmallah banner line', () {
    final page2 = repo.pageForAyah(2, 1)!;
    final lines = repo.linesForPage(page2);
    expect(lines.any((l) => l.type == 'basmallah'), isTrue);
  });

  test('every word referenced by a line resolves to real glyph text', () {
    for (final line in repo.linesForPage(1)) {
      for (final word in repo.wordsForLine(line)) {
        expect(word.text, isNotEmpty);
      }
    }
  });

  test('Al-Fatiha 1:1 is on page 1, and the last ayah is on page 604', () {
    expect(repo.pageForAyah(1, 1), 1);
    expect(repo.pageForAyah(114, 6), 604);
  });
}
