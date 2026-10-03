import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/revision/review_cycle.dart';

void main() {
  final start = DateTime(2026, 10, 1);
  final pool = [for (var p = 1; p <= 60; p++) p];

  CyclePlan plan({
    int done = 0,
    int days = 30,
    DateTime? today,
    List<int>? pages,
  }) => planCycleDay(
    pool: pages ?? pool,
    donePages: done,
    cycleDays: days,
    start: start,
    today: today ?? start,
  );

  test('the first day takes an even share of the whole', () {
    final p = plan();
    expect(p.todayPages, [1, 2]); // 60 pages over 30 days
    expect(p.totalPages, 60);
    expect(p.daysLeft, 30);
    expect(p.finished, isFalse);
  });

  test('a share is always rounded up so the cycle ends on time', () {
    final p = plan(pages: [for (var i = 1; i <= 31; i++) i], days: 30);
    expect(p.todayPages, hasLength(2));
  });

  test('pages continue from where the cycle stands', () {
    final p = plan(done: 10, today: DateTime(2026, 10, 6));
    // 50 pages left, 25 days left: 2 pages, starting at the 11th.
    expect(p.todayPages, [11, 12]);
    expect(p.daysLeft, 25);
  });

  test('a missed day is spread over the remaining days, not paid at once', () {
    // Day 11 of 30, nothing done yet: 60 pages / 20 days = 3 a day.
    final p = plan(done: 0, today: DateTime(2026, 10, 11));
    expect(p.todayPages, [1, 2, 3]);
  });

  test('the last day takes whatever is left', () {
    final p = plan(done: 55, today: DateTime(2026, 10, 30));
    expect(p.daysLeft, 1);
    expect(p.todayPages, [56, 57, 58, 59, 60]);
  });

  test('past the end of the cycle, what is left is still due', () {
    final p = plan(done: 50, today: DateTime(2026, 12, 1));
    expect(p.daysLeft, 1);
    expect(p.todayPages, hasLength(10));
  });

  test('every page done means the cycle is finished', () {
    final p = plan(done: 60);
    expect(p.finished, isTrue);
    expect(p.todayPages, isEmpty);
    expect(p.fraction, 1.0);
  });

  test('an empty pool is not a finished cycle', () {
    final p = plan(pages: const []);
    expect(p.finished, isFalse);
    expect(p.todayPages, isEmpty);
    expect(p.fraction, 0);
  });

  test('more pages done than exist is clamped', () {
    final p = plan(done: 999);
    expect(p.donePages, 60);
    expect(p.finished, isTrue);
  });

  test('a clock change does not shift the day count', () {
    // Europe goes back to winter time on 2026-10-25.
    final p = planCycleDay(
      pool: pool,
      donePages: 0,
      cycleDays: 30,
      start: DateTime(2026, 10, 20),
      today: DateTime(2026, 10, 26, 0, 30),
    );
    expect(p.daysLeft, 24);
  });

  group('poolPages', () {
    test('lists each page once, in order', () {
      final pages = poolPages(
        declaredAyahs: [
          (surah: 1, ayah: 1),
          (surah: 1, ayah: 2),
          (surah: 2, ayah: 1),
          (surah: 2, ayah: 2),
        ],
        pageByAyah: {
          (surah: 1, ayah: 1): 1,
          (surah: 1, ayah: 2): 1,
          (surah: 2, ayah: 1): 2,
          (surah: 2, ayah: 2): 2,
        },
      );
      expect(pages, [1, 2]);
    });

    test('ignores a verse whose page is unknown', () {
      expect(
        poolPages(declaredAyahs: [(surah: 9, ayah: 9)], pageByAyah: const {}),
        isEmpty,
      );
    });
  });

  test('the choices include the default', () {
    expect(cycleLengthChoices, contains(defaultCycleDays));
  });
}
