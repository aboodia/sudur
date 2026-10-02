import '../memorization/review_calendar.dart';
import '../quran_reference/quran_reference_repository.dart';

// Pure computations behind the dashboard's progress tiles — no Flutter,
// no database. Every figure comes from what the user actually did.

/// Consecutive days of activity ending today. Today not being over yet,
/// a streak whose last day was yesterday is still alive: it only breaks
/// once a whole day has passed without activity.
int computeStreak(Iterable<DateTime> activityTimes, DateTime now) {
  final days = {for (final t in activityTimes) dateOnly(t)};
  var day = dateOnly(now);
  if (!days.contains(day)) {
    day = DateTime(day.year, day.month, day.day - 1);
  }
  var streak = 0;
  while (days.contains(day)) {
    streak++;
    // The constructor, not `subtract(Duration(days: 1))`: that lands an
    // hour off across a clock change and can skip or repeat a date.
    day = DateTime(day.year, day.month, day.day - 1);
  }
  return streak;
}

/// Share of recent reviews that held (anything but "à reprendre"), from 0
/// to 1 — null when there was no review in the window, so the dashboard
/// can say so instead of showing an invented 0 % or 100 %.
double? computeRetention(
  Iterable<({DateTime at, String outcome})> reviews,
  DateTime now, {
  int windowDays = 30,
}) {
  final since = DateTime(now.year, now.month, now.day - windowDays);
  var total = 0;
  var held = 0;
  for (final r in reviews) {
    if (r.at.isBefore(since)) continue;
    total++;
    if (r.outcome != 'redo') held++;
  }
  return total == 0 ? null : held / total;
}

/// Total time spent in study sessions.
Duration totalStudyTime(Iterable<int> durationsInSeconds) =>
    Duration(seconds: durationsInSeconds.fold(0, (a, b) => a + b));

/// "2 h 05", "35 min" — minutes only under an hour.
String formatStudyTime(Duration d) {
  final minutes = d.inMinutes;
  if (minutes < 60) return '$minutes min';
  final m = (minutes % 60).toString().padLeft(2, '0');
  return '${minutes ~/ 60} h $m';
}

/// A French decimal comma: 0 → "0", 0.047 → "0,05" (two decimals under one
/// Juz, so a first sourate doesn't read as nothing), 12 → "12,0".
String formatJuz(double juz) {
  if (juz <= 0) return '0';
  final digits = juz < 1 ? 2 : 1;
  return juz.toStringAsFixed(digits).replaceAll('.', ',');
}

/// How much of the Quran is memorized, in Juz: each verse counts for
/// 1 / (the number of verses in its Juz), so the whole Quran adds up to
/// exactly 30. [memorizedAyahs] are (surah, ayah) pairs.
double juzEquivalent(
  QuranReferenceRepository reference,
  Iterable<({int surah, int ayah})> memorizedAyahs,
) {
  final sizes = <int, int>{};
  for (final surah in reference.surahs) {
    for (var ayah = 1; ayah <= surah.numberOfAyahs; ayah++) {
      final juz = reference.juzForSurahAyah(surah.number, ayah);
      sizes[juz] = (sizes[juz] ?? 0) + 1;
    }
  }

  var total = 0.0;
  for (final v in memorizedAyahs) {
    final juz = reference.juzForSurahAyah(v.surah, v.ayah);
    total += 1 / sizes[juz]!;
  }
  return total;
}
