import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/gamification/streak.dart';

void main() {
  // Saturday 3 October 2026, early afternoon.
  final now = DateTime(2026, 10, 3, 14);
  DateTime ago(int days, [int hour = 9]) =>
      DateTime(now.year, now.month, now.day - days, hour);

  /// Activity on each of [count] consecutive days ending [lastAgo] days ago.
  List<DateTime> run(int count, {int lastAgo = 0}) => [
    for (var i = 0; i < count; i++) ago(lastAgo + i),
  ];

  test('no activity, no streak', () {
    final s = computeStreakState(const [], now);
    expect(s.current, 0);
    expect(s.longest, 0);
    expect(s.jokersLeft, 0);
    expect(s.atRisk, isFalse);
  });

  test('consecutive days count, several sessions in a day count once', () {
    final s = computeStreakState([ago(0, 8), ago(0, 20), ago(1), ago(2)], now);
    expect(s.current, 3);
    expect(s.activeToday, isTrue);
  });

  test('today not being over, a streak ending yesterday is still alive', () {
    final s = computeStreakState(run(3, lastAgo: 1), now);
    expect(s.current, 3);
    expect(s.activeToday, isFalse);
  });

  test('a missed day without a joker ends the streak', () {
    final s = computeStreakState([ago(2), ago(3), ago(4)], now);
    expect(s.current, 0);
    expect(s.longest, 3);
  });

  test('after a break, activity starts a new streak of one', () {
    final s = computeStreakState([ago(0), ago(3), ago(4)], now);
    expect(s.current, 1);
    expect(s.longest, 2);
  });

  group('jokers', () {
    test('seven days of activity earn one joker', () {
      final s = computeStreakState(run(7, lastAgo: 1), now);
      expect(s.current, 7);
      expect(s.jokersLeft, 1);
    });

    test('six days are not enough', () {
      expect(computeStreakState(run(6, lastAgo: 1), now).jokersLeft, 0);
    });

    test('a joker covers a missed day and the streak goes on', () {
      // Seven days (10..4 days ago), a miss 3 days ago, then 2 and 1.
      final s = computeStreakState([
        ...run(7, lastAgo: 4),
        ago(2),
        ago(1),
      ], now);
      expect(s.current, 9);
      expect(s.jokersLeft, 0);
      expect(s.jokersUsed, 1);
      expect(s.lastCoveredDay, DateTime(2026, 9, 30));
    });

    test('without a joker left, the same miss ends the streak', () {
      final s = computeStreakState([
        ...run(6, lastAgo: 4),
        ago(2),
        ago(1),
      ], now);
      expect(s.current, 2);
      expect(s.jokersUsed, 0);
    });

    test('the stock is capped', () {
      final s = computeStreakState(run(30, lastAgo: 1), now);
      expect(s.jokersLeft, maxJokers);
      expect(s.daysToNextJoker, isNull);
    });

    test('days to the next joker', () {
      final s = computeStreakState(run(9, lastAgo: 1), now);
      expect(s.jokersLeft, 1);
      expect(s.daysToNextJoker, 5);
    });

    test('two misses in a row use two jokers', () {
      // 14 days of activity (two jokers), then 2 missed days, then today.
      final s = computeStreakState([...run(14, lastAgo: 3), ago(0)], now);
      expect(s.jokersUsed, 2);
      expect(s.jokersLeft, 0);
      expect(s.current, 15);
    });
  });

  group('days off', () {
    // Weekdays Monday to Friday only: bit 0 = Monday ... bit 4 = Friday.
    const weekdays = 31;

    test('a weekend off does not end the streak, nor is it counted', () {
      // Fri 25 Sep, Mon 28, Tue 29, Wed 30, Thu 1 Oct, Fri 2 Oct.
      final s = computeStreakState(
        [
          DateTime(2026, 9, 25, 9),
          DateTime(2026, 9, 28, 9),
          DateTime(2026, 9, 29, 9),
          DateTime(2026, 9, 30, 9),
          DateTime(2026, 10, 1, 9),
          DateTime(2026, 10, 2, 9),
        ],
        now,
        availableDaysMask: weekdays,
      );
      expect(s.current, 6);
    });

    test('the same history breaks without the days off', () {
      final s = computeStreakState([
        DateTime(2026, 9, 25, 9),
        DateTime(2026, 9, 28, 9),
        DateTime(2026, 9, 29, 9),
        DateTime(2026, 9, 30, 9),
        DateTime(2026, 10, 1, 9),
        DateTime(2026, 10, 2, 9),
      ], now);
      expect(s.current, 5);
    });

    test('activity on a day off still counts', () {
      final s = computeStreakState(
        [ago(0), ago(1)], // Saturday and Friday
        now,
        availableDaysMask: weekdays,
      );
      expect(s.current, 2);
    });

    test('a day off today is never "at risk"', () {
      final s = computeStreakState(
        [ago(1), ago(2)],
        now, // Saturday
        availableDaysMask: weekdays,
      );
      expect(s.atRisk, isFalse);
    });
  });

  group('at risk', () {
    test('a running streak, nothing yet today, no joker: at risk', () {
      final s = computeStreakState(run(3, lastAgo: 1), now);
      expect(s.atRisk, isTrue);
    });

    test('a joker in reserve means the streak is not at risk', () {
      final s = computeStreakState(run(7, lastAgo: 1), now);
      expect(s.atRisk, isFalse);
    });

    test('done today: not at risk', () {
      expect(computeStreakState(run(3), now).atRisk, isFalse);
    });

    test('no streak, nothing to lose', () {
      expect(computeStreakState([ago(5)], now).atRisk, isFalse);
    });
  });

  test('a clock change does not skip or repeat a day', () {
    // Europe changes clocks on 2026-10-25: a streak across it stays whole.
    final after = DateTime(2026, 10, 27, 12);
    final s = computeStreakState([
      for (var d = 22; d <= 27; d++) DateTime(2026, 10, d, 7),
    ], after);
    expect(s.current, 6);
  });

  test('activity dated in the future is ignored', () {
    final s = computeStreakState([ago(-2), ago(0)], now);
    expect(s.current, 1);
  });
}
