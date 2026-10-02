import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/stats/goals.dart';

void main() {
  group('defaultGoals', () {
    test('fits the daily time on each available day', () {
      // 15 min = 5 verses a day, 5 days a week (Mon-Fri = 0b0011111).
      final g = defaultGoals(dailyTargetMinutes: 15, availableDaysMask: 31);
      expect(g.weekly, 25);
      expect(g.monthly, (25 * 30 / 7).round());
    });

    test('never proposes zero, whatever the answers', () {
      final g = defaultGoals(dailyTargetMinutes: 0, availableDaysMask: 0);
      expect(g.weekly, 1);
      expect(g.monthly, greaterThanOrEqualTo(1));
    });

    test('stays within the editor bounds', () {
      final g = defaultGoals(dailyTargetMinutes: 10000, availableDaysMask: 127);
      expect(g.weekly, lessThanOrEqualTo(maxWeeklyGoal));
      expect(g.monthly, lessThanOrEqualTo(maxMonthlyGoal));
    });
  });

  group('periods', () {
    test('a week starts on Monday, whatever the day asked', () {
      // 2026-10-04 is a Sunday: its week began Monday 28 September.
      expect(weekStart(DateTime(2026, 10, 4, 23)), DateTime(2026, 9, 28));
      expect(weekStart(DateTime(2026, 9, 28)), DateTime(2026, 9, 28));
      expect(weekStart(DateTime(2026, 10, 1)), DateTime(2026, 9, 28));
    });

    test('a month starts on the 1st', () {
      expect(monthStart(DateTime(2026, 10, 17, 9)), DateTime(2026, 10));
    });
  });

  group('goalProgress', () {
    GoalProgress weekly({required int goal, required int done, DateTime? t}) =>
        goalProgress(
          goal: goal,
          done: done,
          periodStart: DateTime(2026, 9, 28),
          periodEnd: DateTime(2026, 10, 5),
          today: t ?? DateTime(2026, 9, 30, 14),
        );

    test('counts the days left, today included', () {
      final p = weekly(goal: 21, done: 5);
      expect(p.daysTotal, 7);
      expect(p.daysElapsed, 3);
      expect(p.daysLeft, 5);
      expect(p.remaining, 16);
      expect(p.perDayNeeded, 4); // 16 / 5, rounded up
    });

    test('on the last day everything left is due that day', () {
      final p = weekly(goal: 21, done: 18, t: DateTime(2026, 10, 4));
      expect(p.daysLeft, 1);
      expect(p.perDayNeeded, 3);
    });

    test('reaching the goal leaves nothing to do, even when exceeded', () {
      final p = weekly(goal: 10, done: 14);
      expect(p.reached, isTrue);
      expect(p.remaining, 0);
      expect(p.perDayNeeded, 0);
      expect(p.fraction, 1.0);
      expect(p.aheadOfPace, isFalse);
    });

    test('ahead of pace means more than an even share so far', () {
      // Day 3 of 7, goal 21: an even pace is 9.
      expect(weekly(goal: 21, done: 10).aheadOfPace, isTrue);
      expect(weekly(goal: 21, done: 9).aheadOfPace, isFalse);
      expect(weekly(goal: 21, done: 0).aheadOfPace, isFalse);
    });

    test('a month has its own length', () {
      final p = goalProgress(
        goal: 60,
        done: 10,
        periodStart: DateTime(2026, 10),
        periodEnd: DateTime(2026, 11),
        today: DateTime(2026, 10, 2),
      );
      expect(p.daysTotal, 31);
      expect(p.daysLeft, 30);
      expect(p.perDayNeeded, 2);
    });

    test('a daylight-saving week is still seven days', () {
      // Europe changes clocks on 2026-10-25.
      final p = goalProgress(
        goal: 7,
        done: 0,
        periodStart: DateTime(2026, 10, 19),
        periodEnd: DateTime(2026, 10, 26),
        today: DateTime(2026, 10, 26, 0, 30).subtract(const Duration(days: 1)),
      );
      expect(p.daysTotal, 7);
      expect(p.daysLeft, 1);
    });
  });

  test('versesBetween counts the half-open interval', () {
    final from = DateTime(2026, 9, 28);
    final to = DateTime(2026, 10, 5);
    final n = versesBetween(
      [
        DateTime(2026, 9, 27, 23, 59), // before
        from, // in
        DateTime(2026, 10, 4, 23, 59), // in
        to, // out: next week
      ],
      from,
      to,
    );
    expect(n, 2);
  });
}
