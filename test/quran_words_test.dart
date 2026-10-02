import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/quran_text/quran_text_repository.dart';
import 'package:sudur/core/quran_text/quran_words.dart';

void main() {
  late QuranTextRepository repo;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    repo = await QuranTextRepository.load();
  });

  test('no ayah carries an invisible byte-order mark', () {
    for (var s = 1; s <= 114; s++) {
      for (final ayah in repo.surah(s).ayahs) {
        expect(
          ayah.arabic.contains('﻿'),
          isFalse,
          reason: '$s:${ayah.numberInSurah}',
        );
      }
    }
  });

  test('every ayah of the Quran starts with a real word', () {
    // Al-Fatiha 1:1 used to start with a U+FEFF, which made its "first
    // word" an empty string and hid it on the recitation screens.
    for (var s = 1; s <= 114; s++) {
      for (final ayah in repo.surah(s).ayahs) {
        final words = quranWords(ayah.arabic);
        expect(words, isNotEmpty, reason: '$s:${ayah.numberInSurah}');
        expect(words.first, isNotEmpty, reason: '$s:${ayah.numberInSurah}');
        expect(words.every((w) => w.isNotEmpty), isTrue);
      }
    }
  });

  group('quranWords', () {
    test('splits on any whitespace and drops empty pieces', () {
      expect(quranWords('  mot1   mot2\tmot3 '), ['mot1', 'mot2', 'mot3']);
    });

    test('a single word, and nothing at all', () {
      expect(quranWords('mot1'), ['mot1']);
      expect(quranWords('   '), isEmpty);
    });
  });
}
