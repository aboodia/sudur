import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/stats/progress_history.dart';

void main() {
  final today = DateTime(2026, 10, 2, 15);

  group('historyStart', () {
    test('30 and 90 day windows end today and include it', () {
      expect(
        historyStart(HistoryPeriod.days30, const [], today),
        DateTime(2026, 9, 3),
      );
      expect(
        historyStart(HistoryPeriod.days90, const [], today),
        DateTime(2026, 7, 5),
      );
    });

    test('"all" starts at the first event', () {
      final events = [
        (at: DateTime(2026, 8, 10, 9), weight: 1),
        (at: DateTime(2026, 9, 20, 9), weight: 1),
      ];
      expect(
        historyStart(HistoryPeriod.all, events, today),
        DateTime(2026, 8, 10),
      );
    });

    test('"all" never covers less than a week', () {
      final events = [(at: DateTime(2026, 10, 2, 9), weight: 1)];
      expect(
        historyStart(HistoryPeriod.all, events, today),
        DateTime(2026, 9, 26),
      );
    });

    test('"all" with no event falls back to a month', () {
      expect(
        historyStart(HistoryPeriod.all, const [], today),
        DateTime(2026, 9, 3),
      );
    });
  });

  group('cumulativeSeries', () {
    test('has one point per day, both ends included', () {
      final s = cumulativeSeries(
        const [],
        from: DateTime(2026, 10, 1),
        to: DateTime(2026, 10, 5),
      );
      expect(s, [0, 0, 0, 0, 0]);
    });

    test('accumulates events on the day they happen', () {
      final s = cumulativeSeries(
        [
          (at: DateTime(2026, 10, 2, 8), weight: 1),
          (at: DateTime(2026, 10, 2, 22), weight: 1),
          (at: DateTime(2026, 10, 4, 7), weight: 3),
        ],
        from: DateTime(2026, 10, 1),
        to: DateTime(2026, 10, 5),
      );
      expect(s, [0, 2, 2, 5, 5]);
    });

    test('what was memorized before the window is the baseline', () {
      final s = cumulativeSeries(
        [
          (at: DateTime(2026, 9, 1), weight: 114),
          (at: DateTime(2026, 10, 2), weight: 1),
        ],
        from: DateTime(2026, 10, 1),
        to: DateTime(2026, 10, 3),
      );
      expect(s, [114, 115, 115]);
    });

    test('events after the window do not leak in', () {
      final s = cumulativeSeries(
        [(at: DateTime(2026, 10, 9), weight: 5)],
        from: DateTime(2026, 10, 1),
        to: DateTime(2026, 10, 3),
      );
      expect(s, [0, 0, 0]);
    });

    test('is order independent', () {
      final events = [
        (at: DateTime(2026, 10, 3), weight: 2),
        (at: DateTime(2026, 10, 1), weight: 1),
      ];
      final s = cumulativeSeries(
        events,
        from: DateTime(2026, 10, 1),
        to: DateTime(2026, 10, 3),
      );
      expect(s, [1, 1, 3]);
    });

    test('keeps one point per day across the autumn clock change', () {
      final s = cumulativeSeries(
        [(at: DateTime(2026, 10, 25, 12), weight: 1)],
        from: DateTime(2026, 10, 23),
        to: DateTime(2026, 10, 27),
      );
      expect(s, [0, 0, 1, 1, 1]);
    });
  });

  group('pageCoverage', () {
    // Page 1 holds three verses, page 2 two, page 3 none.
    final pageByAyah = {
      (surah: 1, ayah: 1): 1,
      (surah: 1, ayah: 2): 1,
      (surah: 1, ayah: 3): 1,
      (surah: 1, ayah: 4): 2,
      (surah: 1, ayah: 5): 2,
    };

    test('is the share of each page\'s verses that are memorized', () {
      final c = pageCoverage(
        memorized: {
          (surah: 1, ayah: 1),
          (surah: 1, ayah: 2),
          (surah: 1, ayah: 4),
          (surah: 1, ayah: 5),
        },
        pageByAyah: pageByAyah,
        pageCount: 3,
      );
      expect(c[0], closeTo(2 / 3, 1e-9));
      expect(c[1], 1.0);
      expect(c[2], 0.0);
      expect(completePages(c), 1);
      expect(partialPages(c), 1);
    });

    test('nothing memorized is all zeros', () {
      final c = pageCoverage(
        memorized: const {},
        pageByAyah: pageByAyah,
        pageCount: 3,
      );
      expect(c, [0.0, 0.0, 0.0]);
      expect(completePages(c), 0);
      expect(partialPages(c), 0);
    });

    test('a memorized verse unknown to the page index is ignored', () {
      final c = pageCoverage(
        memorized: {(surah: 99, ayah: 1)},
        pageByAyah: pageByAyah,
        pageCount: 3,
      );
      expect(c, [0.0, 0.0, 0.0]);
    });
  });
}
