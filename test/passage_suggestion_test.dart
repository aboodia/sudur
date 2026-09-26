import 'package:flutter_test/flutter_test.dart';
import 'package:wird/core/database/app_database.dart';
import 'package:wird/core/memorization/passage_suggestion.dart';
import 'package:wird/core/quran_reference/quran_reference_repository.dart';

MemorizationUnit _unit(int surah, int start, int end) {
  final now = DateTime.now();
  return MemorizationUnit(
    id: 'u-$surah-$start-$end',
    profileId: 'local',
    surahNumber: surah,
    startAyah: start,
    endAyah: end,
    status: 'learning',
    masteryLevel: null,
    circle: null,
    lastReviewedAt: null,
    nextReviewDueAt: null,
    createdAt: now,
    updatedAt: now,
  );
}

void main() {
  late QuranReferenceRepository reference;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    reference = await QuranReferenceRepository.load();
  });

  test('suggests Al-Fatiha 1-3 when nothing is memorized yet', () {
    final suggestion = suggestNextPassage(reference, []);
    expect(suggestion, isNotNull);
    expect(suggestion!.surahNumber, 1);
    expect(suggestion.startAyah, 1);
    expect(suggestion.endAyah, 3);
  });

  test('continues into the next sourate once the current one is fully covered', () {
    final units = [_unit(1, 1, 7)];
    final suggestion = suggestNextPassage(reference, units);
    expect(suggestion, isNotNull);
    expect(suggestion!.surahNumber, 2);
    expect(suggestion.startAyah, 1);
    expect(suggestion.endAyah, 3);
  });

  test('continues correctly from a partial mid-sourate coverage', () {
    final units = [_unit(1, 1, 7), _unit(2, 1, 5)];
    final suggestion = suggestNextPassage(reference, units);
    expect(suggestion, isNotNull);
    expect(suggestion!.surahNumber, 2);
    expect(suggestion.startAyah, 6);
    expect(suggestion.endAyah, 8);
  });

  test('never crosses a sourate boundary even with fewer than 3 ayahs left', () {
    // Al-Fatiha has 7 ayahs: covering 1-6 leaves only ayah 7 uncovered.
    final units = [_unit(1, 1, 6)];
    final suggestion = suggestNextPassage(reference, units);
    expect(suggestion, isNotNull);
    expect(suggestion!.surahNumber, 1);
    expect(suggestion.startAyah, 7);
    expect(suggestion.endAyah, 7);
  });

  test('treats already-memorized and in-progress units the same as covered', () {
    final now = DateTime.now();
    final memorized = MemorizationUnit(
      id: 'm-1',
      profileId: 'local',
      surahNumber: 1,
      startAyah: 1,
      endAyah: 7,
      status: 'memorized',
      masteryLevel: 'solid',
      circle: 3,
      lastReviewedAt: now,
      nextReviewDueAt: null,
      createdAt: now,
      updatedAt: now,
    );
    final suggestion = suggestNextPassage(reference, [memorized]);
    expect(suggestion!.surahNumber, 2);
    expect(suggestion.startAyah, 1);
  });

  test('returns null once every ayah of the Quran is covered', () {
    final units = [for (final surah in reference.surahs) _unit(surah.number, 1, surah.numberOfAyahs)];
    expect(suggestNextPassage(reference, units), isNull);
  });
}
