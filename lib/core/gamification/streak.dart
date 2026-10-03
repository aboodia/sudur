import '../memorization/review_calendar.dart';

// The regularity streak with its jokers — pure logic, no Flutter and no
// database. The rules are meant to encourage, never to punish ("jamais
// d'échec silencieux"): a missed day is first covered by a joker, days the
// user said they are not available do not count against them, and the
// current day is never held against the streak before it is over.

/// Days of activity that earn one joker.
const streakDaysPerJoker = 7;

/// Most jokers that can be kept at once.
const maxJokers = 2;

/// Where the regularity streak stands.
class StreakState {
  const StreakState({
    required this.current,
    required this.longest,
    required this.jokersLeft,
    required this.jokersUsed,
    required this.lastCoveredDay,
    required this.activeToday,
    required this.atRisk,
  });

  /// Days of activity in the running streak (days off and days covered by a
  /// joker keep it alive without being counted).
  final int current;

  /// The best streak ever reached.
  final int longest;

  final int jokersLeft;

  /// Jokers spent over the whole history.
  final int jokersUsed;

  /// The latest day a joker kept the running streak alive, if any.
  final DateTime? lastCoveredDay;

  final bool activeToday;

  /// A streak is running, today is a day the user is available, nothing was
  /// done yet and no joker is left: missing today would end it.
  final bool atRisk;

  /// Active days still needed for the next joker; null while the stock is
  /// full.
  int? get daysToNextJoker => jokersLeft >= maxJokers
      ? null
      : streakDaysPerJoker - (current % streakDaysPerJoker);

  static const empty = StreakState(
    current: 0,
    longest: 0,
    jokersLeft: 0,
    jokersUsed: 0,
    lastCoveredDay: null,
    activeToday: false,
    atRisk: false,
  );
}

/// Computes the streak from the days of activity.
///
/// [availableDaysMask] has one bit per weekday (bit 0 = Monday, as in the
/// profile): a day whose bit is clear is a rest day, which neither extends
/// nor breaks the streak.
StreakState computeStreakState(
  Iterable<DateTime> activityTimes,
  DateTime now, {
  int availableDaysMask = 127,
}) {
  final days = {for (final t in activityTimes) dateOnly(t)};
  if (days.isEmpty) return StreakState.empty;

  final today = dateOnly(now);
  final active = days.where((d) => !d.isAfter(today)).toList()..sort();
  if (active.isEmpty) return StreakState.empty;

  bool isRestDay(DateTime d) =>
      availableDaysMask & (1 << (d.weekday - DateTime.monday)) == 0;

  var current = 0;
  var longest = 0;
  var jokers = 0;
  var jokersUsed = 0;
  DateTime? lastCovered;

  // Stepping with the constructor rather than adding 24 h: a clock change
  // would otherwise skip or repeat a date.
  for (
    var day = active.first;
    !day.isAfter(today);
    day = DateTime(day.year, day.month, day.day + 1)
  ) {
    if (days.contains(day)) {
      current++;
      if (current > longest) longest = current;
      if (current % streakDaysPerJoker == 0 && jokers < maxJokers) jokers++;
    } else if (isRestDay(day) || day == today) {
      // A day off, or a day not over yet: nothing happens.
    } else if (jokers > 0) {
      jokers--;
      jokersUsed++;
      lastCovered = day;
    } else {
      current = 0;
      lastCovered = null;
    }
  }

  final activeToday = days.contains(today);
  return StreakState(
    current: current,
    longest: longest,
    jokersLeft: jokers,
    jokersUsed: jokersUsed,
    lastCoveredDay: lastCovered,
    activeToday: activeToday,
    atRisk: current > 0 && !activeToday && !isRestDay(today) && jokers == 0,
  );
}
