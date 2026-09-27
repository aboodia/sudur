import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/memorization/passage_suggestion.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';

void main() {
  late QuranReferenceRepository reference;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    reference = await QuranReferenceRepository.load();
  });

  Set<String> keysFor(int surah, int start, int end) => {
    for (var a = start; a <= end; a++) '$surah:$a',
  };

  test('suggests Al-Fatiha 1-5 when nothing is memorized yet', () {
    final suggestion = suggestNextPassage(reference, {});
    expect(suggestion, isNotNull);
    expect(suggestion!.surahNumber, 1);
    expect(suggestion.startAyah, 1);
    expect(suggestion.endAyah, 5);
  });

  test(
    'caps at the sourate boundary even with room left in maxAyahsPerPassage',
    () {
      // Al-Fatiha has 7 ayahs: covering 1-5 leaves 6-7, fewer than the default cap.
      final suggestion = suggestNextPassage(reference, keysFor(1, 1, 5));
      expect(suggestion!.surahNumber, 1);
      expect(suggestion.startAyah, 6);
      expect(suggestion.endAyah, 7);
    },
  );

  test(
    'continues into the next sourate once the current one is fully covered',
    () {
      final suggestion = suggestNextPassage(reference, keysFor(1, 1, 7));
      expect(suggestion!.surahNumber, 2);
      expect(suggestion.startAyah, 1);
      expect(suggestion.endAyah, 5);
    },
  );

  test('continues correctly from a partial mid-sourate coverage', () {
    final covered = {...keysFor(1, 1, 7), ...keysFor(2, 1, 5)};
    final suggestion = suggestNextPassage(reference, covered);
    expect(suggestion!.surahNumber, 2);
    expect(suggestion.startAyah, 6);
    expect(suggestion.endAyah, 10);
  });

  test('respects a smaller maxAyahsPerPassage', () {
    final suggestion = suggestNextPassage(reference, {}, maxAyahsPerPassage: 3);
    expect(suggestion!.endAyah, 3);
  });

  test('returns null once every ayah of the Quran is covered', () {
    final all = <String>{
      for (final surah in reference.surahs)
        for (var a = 1; a <= surah.numberOfAyahs; a++) '${surah.number}:$a',
    };
    expect(suggestNextPassage(reference, all), isNull);
  });
}
