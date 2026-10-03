import '../memorization/review_calendar.dart';

// Weekly and monthly memorization goals — pure logic, no Flutter and no
// database. A goal is a number of new verses to memorize in the current
// calendar week (Monday to Sunday) or month.

/// The minutes a guided passage takes per verse, on average — the bridge
/// between the daily time the user gave in the onboarding and a verse count.
const minutesPerVerse = 3;

/// Bounds the goal editor allows.
const maxWeeklyGoal = 200;
const maxMonthlyGoal = 800;

typedef GoalPair = ({int weekly, int monthly});

/// A reasonable goal when the user has not set one: the verses that fit in
/// the daily time on each available day (bit 0 = Monday), at least one.
GoalPair defaultGoals({
  required int dailyTargetMinutes,
  required int availableDaysMask,
}) {
  var days = 0;
  for (var bit = 0; bit < 7; bit++) {
    if (availableDaysMask & (1 << bit) != 0) days++;
  }
  if (days == 0) days = 1;
  final perDay = (dailyTargetMinutes ~/ minutesPerVerse).clamp(1, 100);
  final weekly = (perDay * days).clamp(1, maxWeeklyGoal);
  final monthly = (weekly * 30 / 7).round().clamp(1, maxMonthlyGoal);
  return (weekly: weekly, monthly: monthly);
}

/// Monday of the week containing [day].
DateTime weekStart(DateTime day) =>
    DateTime(day.year, day.month, day.day - (day.weekday - DateTime.monday));

/// First day of the month containing [day].
DateTime monthStart(DateTime day) => DateTime(day.year, day.month);

/// Where the user stands against one goal.
class GoalProgress {
  const GoalProgress({
    required this.goal,
    required this.done,
    required this.daysLeft,
    required this.daysTotal,
    required this.daysElapsed,
  });

  final int goal;
  final int done;

  /// Days remaining in the period, today included (always at least 1).
  final int daysLeft;
  final int daysTotal;

  /// Days of the period already begun, today included.
  final int daysElapsed;

  bool get reached => done >= goal;
  int get remaining => reached ? 0 : goal - done;
  double get fraction => goal <= 0 ? 1 : (done / goal).clamp(0.0, 1.0);

  /// Verses to memorize each remaining day to still reach the goal.
  int get perDayNeeded => reached ? 0 : (remaining / daysLeft).ceil();

  /// Ahead of an even pace over the period — the share of the goal that
  /// "should" be done by now is not just rounded down: being on time counts.
  bool get aheadOfPace =>
      !reached && done * daysTotal > goal * daysElapsed && done > 0;
}

GoalProgress goalProgress({
  required int goal,
  required int done,
  required DateTime periodStart,
  required DateTime periodEnd,
  required DateTime today,
}) {
  final start = dateOnly(periodStart);
  final end = dateOnly(periodEnd);
  final total = daysBetween(start, end);
  final elapsed = (daysBetween(start, dateOnly(today)) + 1).clamp(1, total);
  return GoalProgress(
    goal: goal,
    done: done,
    daysLeft: (total - elapsed + 1).clamp(1, total),
    daysTotal: total,
    daysElapsed: elapsed,
  );
}

/// Whether [a] and [b] fall on the same calendar day.
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Verses memorized in `[from, to)`, counting each verse once.
int versesBetween(Iterable<DateTime> memorizedAt, DateTime from, DateTime to) {
  var n = 0;
  for (final at in memorizedAt) {
    if (!at.isBefore(from) && at.isBefore(to)) n++;
  }
  return n;
}
