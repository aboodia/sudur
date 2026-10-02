import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/core/stats/progress_stats.dart';

void main() {
  late QuranReferenceRepository reference;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    reference = await QuranReferenceRepository.load();
  });

  group('computeStreak', () {
    final now = DateTime(2026, 10, 2, 15);

    test('is zero with no activity', () {
      expect(computeStreak(const [], now), 0);
    });

    test('counts consecutive days ending today', () {
      final streak = computeStreak([
        DateTime(2026, 10, 2, 8),
        DateTime(2026, 10, 1, 22),
        DateTime(2026, 9, 30, 6),
      ], now);
      expect(streak, 3);
    });

    test('several events on one day count once', () {
      final streak = computeStreak([
        DateTime(2026, 10, 2, 8),
        DateTime(2026, 10, 2, 9),
        DateTime(2026, 10, 2, 20),
      ], now);
      expect(streak, 1);
    });

    test('a streak last extended yesterday is still alive today', () {
      final streak = computeStreak([
        DateTime(2026, 10, 1, 9),
        DateTime(2026, 9, 30, 9),
      ], now);
      expect(streak, 2);
    });

    test('a whole day without activity breaks it', () {
      final streak = computeStreak([
        DateTime(2026, 9, 30, 9),
        DateTime(2026, 9, 29, 9),
      ], now);
      expect(streak, 0);
    });

    test('a gap ends the count at the gap', () {
      final streak = computeStreak([
        DateTime(2026, 10, 2),
        DateTime(2026, 10, 1),
        DateTime(2026, 9, 28),
        DateTime(2026, 9, 27),
      ], now);
      expect(streak, 2);
    });

    test('runs across the autumn clock change without skipping a day', () {
      // France goes back to winter time on 25 October 2026.
      final streak = computeStreak([
        DateTime(2026, 10, 26, 7),
        DateTime(2026, 10, 25, 7),
        DateTime(2026, 10, 24, 7),
        DateTime(2026, 10, 23, 7),
      ], DateTime(2026, 10, 26, 20));
      expect(streak, 4);
    });
  });

  group('computeRetention', () {
    final now = DateTime(2026, 10, 2);

    test(
      'is null when there was no review, rather than an invented figure',
      () {
        expect(computeRetention(const [], now), isNull);
      },
    );

    test('is the share of reviews that were not "à reprendre"', () {
      final r = computeRetention([
        (at: DateTime(2026, 10, 1), outcome: 'clean'),
        (at: DateTime(2026, 10, 1), outcome: 'hesitant'),
        (at: DateTime(2026, 9, 30), outcome: 'clean'),
        (at: DateTime(2026, 9, 29), outcome: 'redo'),
      ], now);
      expect(r, 0.75);
    });

    test('ignores reviews older than the window', () {
      final r = computeRetention([
        (at: DateTime(2026, 8, 1), outcome: 'redo'),
        (at: DateTime(2026, 10, 1), outcome: 'clean'),
      ], now);
      expect(r, 1.0);
    });

    test('only old reviews means no recent figure', () {
      expect(
        computeRetention([(at: DateTime(2026, 1, 1), outcome: 'clean')], now),
        isNull,
      );
    });
  });

  group('study time', () {
    test('adds up the durations', () {
      expect(totalStudyTime([600, 900, 30]), const Duration(seconds: 1530));
      expect(totalStudyTime(const []), Duration.zero);
    });

    test('formats minutes then hours', () {
      expect(formatStudyTime(Duration.zero), '0 min');
      expect(formatStudyTime(const Duration(minutes: 35)), '35 min');
      expect(formatStudyTime(const Duration(minutes: 60)), '1 h 00');
      expect(formatStudyTime(const Duration(minutes: 125)), '2 h 05');
    });
  });

  test('formatJuz uses a French decimal comma', () {
    expect(formatJuz(0), '0');
    expect(formatJuz(0.047), '0,05');
    expect(formatJuz(0.1), '0,10');
    expect(formatJuz(1.26), '1,3');
    expect(formatJuz(12), '12,0');
    expect(formatJuz(29.96), '30,0');
  });

  group('juzEquivalent', () {
    test('is zero with nothing memorized', () {
      expect(juzEquivalent(reference, const []), 0);
    });

    test('the whole Quran adds up to exactly 30 Juz', () {
      final all = [
        for (final s in reference.surahs)
          for (var a = 1; a <= s.numberOfAyahs; a++) (surah: s.number, ayah: a),
      ];
      expect(juzEquivalent(reference, all), closeTo(30, 1e-9));
    });

    test('a short sourate is a small fraction of one Juz', () {
      // Al-Fatiha: 7 verses out of the first Juz's ~148.
      final fatiha = [for (var a = 1; a <= 7; a++) (surah: 1, ayah: a)];
      final juz = juzEquivalent(reference, fatiha);
      expect(juz, greaterThan(0.03));
      expect(juz, lessThan(0.06));
    });
  });
}
