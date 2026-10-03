import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/memorization_repository.dart';
import '../gamification/streak.dart';
import '../database/profile_repository.dart';
import '../quran_reference/quran_reference_repository.dart';
import 'memorized_set.dart';
import 'progress_stats.dart';

/// The figures on the dashboard's "Statistiques de progression".
class ProgressStats {
  const ProgressStats({
    required this.memorizedAyahs,
    required this.completedSurahs,
    required this.juz,
    required this.retention,
    required this.streak,
    required this.studyTime,
  });

  final int memorizedAyahs;
  final int completedSurahs;

  /// How much of the Quran is memorized, in Juz (0 to 30).
  final double juz;

  /// Share of the last 30 days' reviews that held (0 to 1), null without
  /// any review in that window.
  final double? retention;

  final StreakState streak;

  int get streakDays => streak.current;
  final Duration studyTime;
}

final progressStatsProvider = FutureProvider<ProgressStats>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  final repo = ref.watch(memorizationRepositoryProvider);
  final reference = await ref.watch(quranReferenceProvider.future);

  final surahRows = await ref.watch(surahProgressProvider.future);
  final ayahRows = await ref.watch(ayahProgressProvider.future);
  final log = await repo.reviewLog(profile.id);
  final sessions = await repo.studySessions(profile.id);
  final now = DateTime.now();

  final memorized = memorizedAyahSet(surahRows, ayahRows);

  return ProgressStats(
    memorizedAyahs: memorized.length,
    completedSurahs: surahRows.where((r) => r.completedAt != null).length,
    juz: juzEquivalent(reference, memorized),
    retention: computeRetention([
      for (final l in log.where((l) => l.kind == 'review'))
        (at: l.occurredAt, outcome: l.outcome),
    ], now),
    streak: computeStreakState(
      log.map((l) => l.occurredAt),
      now,
      availableDaysMask: profile.availableDaysMask,
    ),
    studyTime: totalStudyTime(sessions.map((s) => s.durationSeconds)),
  );
});
