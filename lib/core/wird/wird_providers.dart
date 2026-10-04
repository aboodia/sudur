import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/app_database.dart';
import '../database/memorization_repository.dart';
import '../database/profile_repository.dart';
import '../memorization/review_calendar.dart';
import '../mushaf/mushaf_repository.dart';
import 'wird_membership.dart';
import 'wird_plan.dart';
import 'wird_state.dart';

/// For each verse learned in the parcours, how many of its reviews held
/// since it was last learned or failed ("surah:ayah" → count).
final successfulReviewsProvider = FutureProvider<Map<String, int>>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  final log = await ref
      .watch(memorizationRepositoryProvider)
      .reviewLog(profile.id);
  final byVerse = <String, List<VerseLogEntry>>{};
  for (final entry in log) {
    byVerse
        .putIfAbsent('${entry.surahNumber}:${entry.ayahNumber}', () => [])
        .add((kind: entry.kind, outcome: entry.outcome));
  }
  return {for (final e in byVerse.entries) e.key: successfulReviews(e.value)};
});

/// The sourates in the Wird (known and fixed); everything else that is being
/// learned is in Révision.
final wirdSurahsProvider = FutureProvider<Set<int>>((ref) async {
  final surahRows = await ref.watch(surahProgressProvider.future);
  final ayahRows = await ref.watch(ayahProgressProvider.future);
  final reviews = await ref.watch(successfulReviewsProvider.future);
  return wirdSurahs(
    completedSurahs: [
      for (final r in surahRows)
        if (r.completedAt != null) r.surahNumber,
    ],
    verses: [
      for (final r in ayahRows)
        (
          surah: r.surahNumber,
          lastOutcome: r.lastOutcome,
          cycleStep: r.reviewCycleStep,
          successfulReviews: reviews['${r.surahNumber}:${r.ayahNumber}'] ?? 0,
        ),
    ],
  );
});

/// The verses of the parcours still being learned: those of sourates not
/// yet in the Wird.
final revisionEntriesProvider = FutureProvider<List<AyahProgressEntry>>((
  ref,
) async {
  final wird = await ref.watch(wirdSurahsProvider.future);
  final entries = await ref.watch(ayahProgressProvider.future);
  return [
    for (final e in entries)
      if (!wird.contains(e.surahNumber)) e,
  ];
});

/// The Révision's verses due today.
final dueRevisionProvider = FutureProvider<List<AyahProgressEntry>>((
  ref,
) async {
  final wird = await ref.watch(wirdSurahsProvider.future);
  final due = await ref.watch(dueReviewsProvider.future);
  return [
    for (final e in due)
      if (!wird.contains(e.surahNumber)) e,
  ];
});

/// The Mushaf pages of the sourates in the Wird, in order: the loop.
final wirdPoolProvider = FutureProvider<List<int>>((ref) async {
  final wird = await ref.watch(wirdSurahsProvider.future);
  if (wird.isEmpty) return const [];
  final surahRows = await ref.watch(surahProgressProvider.future);
  final mushaf = await ref.watch(mushafRepositoryProvider.future);
  return wirdPoolPages(
    ayahs: [
      for (final r in surahRows)
        if (wird.contains(r.surahNumber))
          for (var a = 1; a <= r.totalAyahCount; a++)
            (surah: r.surahNumber, ayah: a),
    ],
    pageByAyah: mushaf.firstPageByAyah(),
  );
});

/// Today's share of the Wird, with the goal behind it.
class WirdToday {
  const WirdToday({
    required this.plan,
    required this.doneToday,
    required this.unit,
    required this.amount,
    required this.goalPages,
    required this.isSuggested,
  });

  final WirdPlan plan;
  final bool doneToday;
  final WirdUnit unit;

  /// The goal in [unit] (the suggestion if the user has not chosen).
  final int amount;
  final int goalPages;

  /// The goal is the app's suggestion, not the user's choice.
  final bool isSuggested;
}

/// Null while no sourate is in the Wird.
final wirdTodayProvider = FutureProvider<WirdToday?>((ref) async {
  final pool = await ref.watch(wirdPoolProvider.future);
  if (pool.isEmpty) return null;
  final state = ref.watch(wirdControllerProvider);
  if (!state.loaded) return null;

  final chosen = state.amount;
  final amount = chosen ?? suggestedWirdPages(pool.length);
  final unit = chosen == null ? WirdUnit.pages : state.unit;
  final goalPages = wirdGoalPages(unit, amount);
  final today = dateOnly(DateTime.now());

  return WirdToday(
    plan: planWird(
      pool: pool,
      pointer: state.pointer,
      turnsDone: state.turnsDone,
      goalPages: goalPages,
    ),
    doneToday: state.lastDoneDay == today,
    unit: unit,
    amount: amount,
    goalPages: goalPages,
    isSuggested: chosen == null,
  );
});
