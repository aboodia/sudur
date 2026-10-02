import '../memorization/review_calendar.dart';

// Pure computations behind the "Suivi" view — the progress curve and the
// Mushaf coverage map. No Flutter, no database.

/// The time span the progress curve covers.
enum HistoryPeriod { days30, days90, all }

/// A memorization event: [weight] verses became memorized at [at] (1 for a
/// verse learned in the guided parcours, a whole sourate's verse count for
/// one declared in the onboarding).
typedef MemorizationEvent = ({DateTime at, int weight});

/// First day shown on the curve. "All" starts at the first event (at least a
/// week back, so the first days don't fill the whole width).
DateTime historyStart(
  HistoryPeriod period,
  Iterable<MemorizationEvent> events,
  DateTime today,
) {
  final end = dateOnly(today);
  DateTime back(int days) => DateTime(end.year, end.month, end.day - days);

  switch (period) {
    case HistoryPeriod.days30:
      return back(29);
    case HistoryPeriod.days90:
      return back(89);
    case HistoryPeriod.all:
      DateTime? first;
      for (final e in events) {
        final day = dateOnly(e.at);
        if (first == null || day.isBefore(first)) first = day;
      }
      if (first == null) return back(29);
      final weekBack = back(6);
      return first.isBefore(weekBack) ? first : weekBack;
  }
}

/// Total memorized at the end of each day from [from] to [to] (inclusive),
/// oldest first: whatever was memorized before [from] is the baseline, so
/// the curve starts where the user actually was, not at zero.
List<int> cumulativeSeries(
  Iterable<MemorizationEvent> events, {
  required DateTime from,
  required DateTime to,
}) {
  final sorted = events.toList()..sort((a, b) => a.at.compareTo(b.at));
  final start = dateOnly(from);
  final end = dateOnly(to);

  final series = <int>[];
  var total = 0;
  var next = 0;
  // Stepping with the constructor rather than adding 24 h: a clock change
  // would otherwise skip or repeat a date.
  for (
    var day = start;
    !day.isAfter(end);
    day = DateTime(day.year, day.month, day.day + 1)
  ) {
    final endOfDay = startOfNextDay(day);
    while (next < sorted.length && sorted[next].at.isBefore(endOfDay)) {
      total += sorted[next].weight;
      next++;
    }
    series.add(total);
  }
  return series;
}

/// How much of each Mushaf page is memorized, from 0 to 1 (index 0 = page
/// 1). A verse counts on the page where it begins — a verse running over
/// two pages isn't counted twice.
List<double> pageCoverage({
  required Set<({int surah, int ayah})> memorized,
  required Map<({int surah, int ayah}), int> pageByAyah,
  required int pageCount,
}) {
  final total = List<int>.filled(pageCount, 0);
  final done = List<int>.filled(pageCount, 0);

  pageByAyah.forEach((ayah, page) {
    if (page < 1 || page > pageCount) return;
    total[page - 1]++;
    if (memorized.contains(ayah)) done[page - 1]++;
  });

  return [
    for (var i = 0; i < pageCount; i++)
      total[i] == 0 ? 0.0 : done[i] / total[i],
  ];
}

/// Pages with every verse memorized.
int completePages(List<double> coverage) =>
    coverage.where((c) => c >= 1).length;

/// Pages begun but not complete.
int partialPages(List<double> coverage) =>
    coverage.where((c) => c > 0 && c < 1).length;
