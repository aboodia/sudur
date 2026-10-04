import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderOrFamily;

import '../database/app_database.dart';
import '../database/memorization_repository.dart';
import '../database/profile_repository.dart';
import '../mushaf/mushaf_repository.dart';
import 'memorized_set.dart';
import 'progress_history.dart';
import '../gamification/achievements_provider.dart';
import '../revision/review_cycle_provider.dart';
import 'goals_provider.dart';
import 'progress_stats_provider.dart';

/// When verses were memorized, for the progress curve: one event per verse
/// learned in the guided parcours, on the day it was learned. Sourates
/// declared when joining are not events — they were known before the first
/// day — and make up the curve's starting level instead
/// ([declaredBaselineProvider]).
final memorizationEventsProvider = FutureProvider<List<MemorizationEvent>>((
  ref,
) async {
  final ayahRows = await ref.watch(ayahProgressProvider.future);
  return [for (final r in ayahRows) (at: r.memorizedAt, weight: 1)];
});

/// Verses known before joining (the declared sourates): where the progress
/// curve starts from, so that declaring a sourate is not counted as progress.
final declaredBaselineProvider = FutureProvider<int>((ref) async {
  return (await ref.watch(declaredAyahsProvider.future)).length;
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
/// validated or a session ends: refresh it all from one place. Pass the
/// `invalidate` of the `Ref` or `WidgetRef` at hand.
void refreshProgressData(void Function(ProviderOrFamily provider) invalidate) {
  invalidate(ayahProgressProvider);
  invalidate(surahProgressProvider);
  invalidate(progressStatsProvider);
  invalidate(memorizationEventsProvider);
  invalidate(mushafCoverageProvider);
  invalidate(studyHistoryProvider);
  invalidate(goalsProvider);
  invalidate(achievementsProvider);
}
