import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../database/memorization_repository.dart';
import '../database/profile_repository.dart';
import '../mushaf/mushaf_repository.dart';
import 'memorized_set.dart';
import 'progress_history.dart';
import '../gamification/achievements_provider.dart';
import 'goals_provider.dart';
import 'progress_stats_provider.dart';

/// When verses were memorized, for the progress curve: one event per verse
/// learned in the guided parcours (on the day it was learned), and one
/// event per sourate declared in the onboarding (carrying all its verses,
/// on the day of the declaration).
final memorizationEventsProvider = FutureProvider<List<MemorizationEvent>>((
  ref,
) async {
  final surahRows = await ref.watch(surahProgressProvider.future);
  final ayahRows = await ref.watch(ayahProgressProvider.future);

  final withVerseRows = {for (final r in ayahRows) r.surahNumber};
  return [
    for (final r in ayahRows) (at: r.memorizedAt, weight: 1),
    for (final r in surahRows)
      if (r.completedAt != null && !withVerseRows.contains(r.surahNumber))
        (at: r.completedAt!, weight: r.totalAyahCount),
  ];
});

/// Memorized share of each of the 604 Mushaf pages (index 0 = page 1).
final mushafCoverageProvider = FutureProvider<List<double>>((ref) async {
  final mushaf = await ref.watch(mushafRepositoryProvider.future);

  final memorized = memorizedAyahSet(
    await ref.watch(surahProgressProvider.future),
    await ref.watch(ayahProgressProvider.future),
  );
  return pageCoverage(
    memorized: memorized,
    pageByAyah: mushaf.firstPageByAyah(),
    pageCount: mushaf.pageCount,
  );
});

/// How many sessions the history lists.
const studyHistoryLength = 20;

/// The latest study sessions, newest first.
final studyHistoryProvider = FutureProvider<List<StudySessionEntry>>((
  ref,
) async {
  final profile = await ref.watch(currentProfileProvider.future);
  final sessions = await ref
      .watch(memorizationRepositoryProvider)
      .studySessions(profile.id);
  sessions.sort((a, b) => b.startedAt.compareTo(a.startedAt));
  return sessions.take(studyHistoryLength).toList();
});

/// Everything computed from the user's activity goes stale when a verse is
/// validated or a session ends: refresh it all from one place.
void refreshProgressData(Ref ref) {
  ref.invalidate(ayahProgressProvider);
  ref.invalidate(surahProgressProvider);
  ref.invalidate(progressStatsProvider);
  ref.invalidate(memorizationEventsProvider);
  ref.invalidate(mushafCoverageProvider);
  ref.invalidate(studyHistoryProvider);
  ref.invalidate(goalsProvider);
  ref.invalidate(achievementsProvider);
}
