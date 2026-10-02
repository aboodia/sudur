// Calendar helpers for the Révision screens — pure date/grouping logic,
// no Flutter and no database.

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// First instant of the day after [d] — the exclusive upper bound of "due
/// today": a verse is due the whole day its date falls on, not only from
/// the minute of the day it was scheduled at.
DateTime startOfNextDay(DateTime d) => DateTime(d.year, d.month, d.day + 1);

/// Whole calendar days from [from] to [to], ignoring the time of day.
/// Computed on UTC dates: subtracting local midnights is off by one day
/// across a daylight-saving change (23 or 25 hours apart).
int daysBetween(DateTime from, DateTime to) => DateTime.utc(
  to.year,
  to.month,
  to.day,
).difference(DateTime.utc(from.year, from.month, from.day)).inDays;

/// Groups [items] by the day they come due. Anything already overdue is
/// folded into [today] — a missed day is never lost, it's simply due now.
Map<DateTime, List<T>> groupByDueDay<T>(
  Iterable<T> items,
  DateTime Function(T item) dueAt, {
  required DateTime today,
}) {
  final todayOnly = dateOnly(today);
  final result = <DateTime, List<T>>{};
  for (final item in items) {
    var day = dateOnly(dueAt(item));
    if (day.isBefore(todayOnly)) day = todayOnly;
    result.putIfAbsent(day, () => []).add(item);
  }
  return result;
}

/// A run of consecutive ayahs of one sourate, e.g. "Al-Mulk 1-5".
class PassageRange {
  const PassageRange(this.surahNumber, this.ayahStart, this.ayahEnd);

  final int surahNumber;
  final int ayahStart;
  final int ayahEnd;

  int get length => ayahEnd - ayahStart + 1;

  @override
  bool operator ==(Object other) =>
      other is PassageRange &&
      other.surahNumber == surahNumber &&
      other.ayahStart == ayahStart &&
      other.ayahEnd == ayahEnd;

  @override
  int get hashCode => Object.hash(surahNumber, ayahStart, ayahEnd);

  @override
  String toString() => 'PassageRange($surahNumber:$ayahStart-$ayahEnd)';
}

/// Merges verses into runs of consecutive ayahs of the same sourate, in
/// Mushaf order, so "7 versets à réviser" reads as "Al-Mulk 1-5 · Al-Fatiha
/// 7" instead of 7 separate lines.
List<PassageRange> groupIntoPassages(Iterable<({int surah, int ayah})> verses) {
  final sorted = verses.toList()
    ..sort((a, b) {
      final bySurah = a.surah.compareTo(b.surah);
      return bySurah != 0 ? bySurah : a.ayah.compareTo(b.ayah);
    });

  final ranges = <PassageRange>[];
  for (final v in sorted) {
    final last = ranges.isEmpty ? null : ranges.last;
    if (last != null && last.surahNumber == v.surah) {
      if (v.ayah == last.ayahEnd) continue; // duplicate
      if (v.ayah == last.ayahEnd + 1) {
        ranges[ranges.length - 1] = PassageRange(
          last.surahNumber,
          last.ayahStart,
          v.ayah,
        );
        continue;
      }
    }
    ranges.add(PassageRange(v.surah, v.ayah, v.ayah));
  }
  return ranges;
}

/// The weeks of a month for a calendar grid, Monday first. Days outside
/// the month are `null` padding.
List<List<DateTime?>> monthGrid(int year, int month) {
  final first = DateTime(year, month, 1);
  final daysInMonth = DateTime(year, month + 1, 0).day;
  final leading = first.weekday - 1; // Monday = 1

  final cells = <DateTime?>[
    for (var i = 0; i < leading; i++) null,
    for (var d = 1; d <= daysInMonth; d++) DateTime(year, month, d),
  ];
  while (cells.length % 7 != 0) {
    cells.add(null);
  }
  return [for (var i = 0; i < cells.length; i += 7) cells.sublist(i, i + 7)];
}
