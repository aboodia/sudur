import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/memorization/review_calendar.dart';

void main() {
  group('groupByDueDay', () {
    final today = DateTime(2026, 10, 2, 9, 30);

    test('groups by calendar day, ignoring the time of day', () {
      final items = [
        DateTime(2026, 10, 3, 0, 5),
        DateTime(2026, 10, 3, 23, 59),
        DateTime(2026, 10, 5, 12),
      ];
      final grouped = groupByDueDay<DateTime>(items, (d) => d, today: today);
      expect(grouped[DateTime(2026, 10, 3)], hasLength(2));
      expect(grouped[DateTime(2026, 10, 5)], hasLength(1));
      expect(grouped.keys, hasLength(2));
    });

    test('folds anything overdue into today instead of losing it', () {
      final items = [
        DateTime(2026, 9, 20, 8),
        DateTime(2026, 10, 1, 22),
        DateTime(2026, 10, 2, 7),
      ];
      final grouped = groupByDueDay<DateTime>(items, (d) => d, today: today);
      expect(grouped.keys.single, DateTime(2026, 10, 2));
      expect(grouped[DateTime(2026, 10, 2)], hasLength(3));
    });

    test('an empty list gives an empty map', () {
      expect(
        groupByDueDay<DateTime>(const [], (d) => d, today: today),
        isEmpty,
      );
    });
  });

  group('groupIntoPassages', () {
    test('merges consecutive ayahs of one sourate', () {
      final ranges = groupIntoPassages([
        (surah: 67, ayah: 2),
        (surah: 67, ayah: 1),
        (surah: 67, ayah: 3),
      ]);
      expect(ranges, [const PassageRange(67, 1, 3)]);
    });

    test('splits on a gap and on a different sourate, in Mushaf order', () {
      final ranges = groupIntoPassages([
        (surah: 67, ayah: 5),
        (surah: 1, ayah: 7),
        (surah: 67, ayah: 1),
        (surah: 67, ayah: 2),
      ]);
      expect(ranges, [
        const PassageRange(1, 7, 7),
        const PassageRange(67, 1, 2),
        const PassageRange(67, 5, 5),
      ]);
    });

    test('a single verse is a range of length 1', () {
      final ranges = groupIntoPassages([(surah: 108, ayah: 2)]);
      expect(ranges.single.length, 1);
    });

    test('ignores a duplicated verse and handles no verses', () {
      expect(groupIntoPassages([(surah: 2, ayah: 1), (surah: 2, ayah: 1)]), [
        const PassageRange(2, 1, 1),
      ]);
      expect(groupIntoPassages(const []), isEmpty);
    });
  });

  group('monthGrid', () {
    test('starts weeks on Monday and pads with nulls', () {
      // 1 October 2026 is a Thursday.
      final grid = monthGrid(2026, 10);
      expect(grid.first.take(3), [null, null, null]);
      expect(grid.first[3], DateTime(2026, 10, 1));
      expect(grid.every((week) => week.length == 7), isTrue);
    });

    test('contains every day of the month exactly once', () {
      final days = monthGrid(2026, 2).expand((w) => w).whereType<DateTime>();
      expect(days, hasLength(28));
      expect(days.first, DateTime(2026, 2, 1));
      expect(days.last, DateTime(2026, 2, 28));
    });

    test('knows a leap February', () {
      final days = monthGrid(2028, 2).expand((w) => w).whereType<DateTime>();
      expect(days, hasLength(29));
    });
  });

  test('startOfNextDay rolls over month and year ends', () {
    expect(
      startOfNextDay(DateTime(2026, 12, 31, 23, 59)),
      DateTime(2027, 1, 1),
    );
    expect(startOfNextDay(DateTime(2026, 10, 2, 0, 0)), DateTime(2026, 10, 3));
  });
}
