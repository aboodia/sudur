import '../memorization/review_calendar.dart';

// The revision cycle of what the user declared as already memorized — pure
// logic, no Flutter and no database. Those sourates have no per-verse
// history to schedule from, so they are reviewed the way a hafiz does: a
// share of the Mushaf's pages each day, round the whole, over a length of
// time the user chooses.

/// The cycle lengths offered, in days.
const cycleLengthChoices = [15, 30, 60, 90];

const defaultCycleDays = 30;

/// What to review today.
class CyclePlan {
  const CyclePlan({
    required this.totalPages,
    required this.donePages,
    required this.daysLeft,
    required this.todayPages,
    required this.finished,
  });

  /// Pages in the cycle.
  final int totalPages;

  /// Pages already reviewed in this cycle.
  final int donePages;

  /// Days left in the cycle, today included (at least 1).
  final int daysLeft;

  /// The Mushaf pages to review today, in order. Empty when the cycle is
  /// complete.
  final List<int> todayPages;

  /// Every page of the cycle has been reviewed.
  final bool finished;

  double get fraction => totalPages == 0 ? 0 : donePages / totalPages;
}

/// Today's share of the cycle.
///
/// [pool] is the pages to review, in Mushaf order; [donePages] how many of
/// them (from the start) are already done; the cycle began on [start] and
/// lasts [cycleDays]. The share is what is left divided by the days left,
/// rounded up: a missed day is not a debt to pay at once, it is spread over
/// the days that remain.
CyclePlan planCycleDay({
  required List<int> pool,
  required int donePages,
  required int cycleDays,
  required DateTime start,
  required DateTime today,
}) {
  final total = pool.length;
  final done = donePages.clamp(0, total);
  final elapsed = daysBetween(dateOnly(start), dateOnly(today));
  final daysLeft = (cycleDays - elapsed).clamp(
    1,
    cycleDays < 1 ? 1 : cycleDays,
  );
  final remaining = total - done;
  if (remaining <= 0) {
    return CyclePlan(
      totalPages: total,
      donePages: done,
      daysLeft: daysLeft,
      todayPages: const [],
      finished: total > 0,
    );
  }
  final share = (remaining / daysLeft).ceil();
  return CyclePlan(
    totalPages: total,
    donePages: done,
    daysLeft: daysLeft,
    todayPages: pool.sublist(done, done + share),
    finished: false,
  );
}

/// The pages a set of declared verses fall on, in order and without
/// repetition. [pageByAyah] gives the page each verse begins on.
List<int> poolPages({
  required Iterable<({int surah, int ayah})> declaredAyahs,
  required Map<({int surah, int ayah}), int> pageByAyah,
}) {
  final pages = <int>{};
  for (final ayah in declaredAyahs) {
    final page = pageByAyah[ayah];
    if (page != null) pages.add(page);
  }
  return pages.toList()..sort();
}
