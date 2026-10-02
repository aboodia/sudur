import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../memorization/passage_suggestion.dart';
import '../memorization/review_calendar.dart';
import '../memorization/review_scheduler.dart';
import '../quran_reference/quran_reference_repository.dart';
import 'app_database.dart';
import 'profile_repository.dart';

/// Reads and writes the guided memorization parcours' state: passages in
/// progress (with their step/verset/mask-level, for "quitter puis reprendre
/// au même endroit"), per-ayah memorization + review scheduling, and
/// per-sourate completion (feeding the profils/badges).
class MemorizationRepository {
  MemorizationRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  // ---------------------------------------------------------------------
  // Passages & session progress
  // ---------------------------------------------------------------------

  /// The passage this profile last left mid-session, if any — a passage
  /// keeps its [SessionProgressEntry] row until "Enchaîner" completes it
  /// (see [finishPassage]), so its mere presence means "resume here".
  Future<({Passage passage, SessionProgressEntry progress})?> activeSession(
    String profileId,
  ) async {
    final passages = await (_db.select(
      _db.passages,
    )..where((t) => t.profileId.equals(profileId))).get();
    for (final passage in passages) {
      final progress = await (_db.select(
        _db.sessionProgressEntries,
      )..where((t) => t.passageId.equals(passage.id))).getSingleOrNull();
      if (progress != null) return (passage: passage, progress: progress);
    }
    return null;
  }

  Future<({Passage passage, SessionProgressEntry progress})> startPassage(
    String profileId,
    int surahNumber,
    int ayahStart,
    int ayahEnd,
  ) async {
    final now = DateTime.now();
    final passageId = _uuid.v4();
    await _db
        .into(_db.passages)
        .insert(
          PassagesCompanion.insert(
            id: passageId,
            profileId: profileId,
            surahNumber: surahNumber,
            ayahStart: ayahStart,
            ayahEnd: ayahEnd,
            createdAt: now,
          ),
        );
    await _db
        .into(_db.sessionProgressEntries)
        .insert(
          SessionProgressEntriesCompanion.insert(
            id: _uuid.v4(),
            passageId: passageId,
            currentAyah: ayahStart,
            startedAt: now,
            updatedAt: now,
          ),
        );
    final passage = await (_db.select(
      _db.passages,
    )..where((t) => t.id.equals(passageId))).getSingle();
    final progress = await (_db.select(
      _db.sessionProgressEntries,
    )..where((t) => t.passageId.equals(passageId))).getSingle();
    return (passage: passage, progress: progress);
  }

  /// Persists the current step/verset/mask-level — called on every step
  /// change and whenever "Quitter" is pressed.
  Future<void> saveProgress({
    required String passageId,
    required int stepIndex,
    required int currentAyah,
    String? maskLevel,
  }) async {
    await (_db.update(
      _db.sessionProgressEntries,
    )..where((t) => t.passageId.equals(passageId))).write(
      SessionProgressEntriesCompanion(
        currentStepIndex: Value(stepIndex),
        currentAyah: Value(currentAyah),
        maskLevel: Value(maskLevel),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// "Enchaîner" just finished the passage — nothing left to resume.
  Future<void> finishPassage(String passageId) async {
    await (_db.delete(
      _db.sessionProgressEntries,
    )..where((t) => t.passageId.equals(passageId))).go();
  }

  // ---------------------------------------------------------------------
  // Per-ayah memorization & review scheduling
  // ---------------------------------------------------------------------

  Future<Set<String>> memorizedAyahKeys(String profileId) async {
    final rows = await (_db.select(
      _db.ayahProgressEntries,
    )..where((t) => t.profileId.equals(profileId))).get();
    return {for (final r in rows) '${r.surahNumber}:${r.ayahNumber}'};
  }

  /// Verses whose review falls on [asOf]'s day or earlier — due the whole
  /// day, not only from the minute they were scheduled at, so what the
  /// calendar files under "today" is what a session actually offers.
  Future<List<AyahProgressEntry>> dueReviews(
    String profileId, {
    DateTime? asOf,
  }) async {
    final cutoff = startOfNextDay(asOf ?? DateTime.now());
    return (_db.select(_db.ayahProgressEntries)
          ..where(
            (t) =>
                t.profileId.equals(profileId) &
                t.nextReviewAt.isSmallerThanValue(cutoff),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.nextReviewAt)]))
        .get();
  }

  /// Every verse ever memorized through the guided parcours, with its
  /// review state — what the calendar and the mastery view are built from.
  Future<List<AyahProgressEntry>> allAyahProgress(String profileId) =>
      (_db.select(_db.ayahProgressEntries)
            ..where((t) => t.profileId.equals(profileId))
            ..orderBy([
              (t) => OrderingTerm.asc(t.surahNumber),
              (t) => OrderingTerm.asc(t.ayahNumber),
            ]))
          .get();

  /// A verse just passed "Réciter" for the first time within its passage's
  /// guided session — creates its [AyahProgressEntries] row (first review
  /// due J+1) and bumps the sourate's progress. Calling this again for an
  /// ayah that's already memorized (e.g. redoing a step) only refreshes its
  /// outcome/fragile words, without double-counting it in
  /// [SurahProgressEntries].
  Future<void> recordAyahMemorized({
    required String profileId,
    required int surahNumber,
    required int ayahNumber,
    required int surahTotalAyahs,
    required ReciteOutcome outcome,
    required List<int> fragileWordIndices,
  }) async {
    final now = DateTime.now();
    final existing =
        await (_db.select(_db.ayahProgressEntries)..where(
              (t) =>
                  t.profileId.equals(profileId) &
                  t.surahNumber.equals(surahNumber) &
                  t.ayahNumber.equals(ayahNumber),
            ))
            .getSingleOrNull();

    if (existing != null) {
      await (_db.update(
        _db.ayahProgressEntries,
      )..where((t) => t.id.equals(existing.id))).write(
        AyahProgressEntriesCompanion(
          lastOutcome: Value(outcome.name),
          fragileWordIndices: Value(jsonEncode(fragileWordIndices)),
          updatedAt: Value(now),
        ),
      );
      await _log(profileId, surahNumber, ayahNumber, 'memorize', outcome, now);
      return;
    }

    final nextReview = ReviewScheduler(clock: () => now)
        .scheduleFirstReview(now);
    await _db
        .into(_db.ayahProgressEntries)
        .insert(
          AyahProgressEntriesCompanion.insert(
            id: _uuid.v4(),
            profileId: profileId,
            surahNumber: surahNumber,
            ayahNumber: ayahNumber,
            lastOutcome: Value(outcome.name),
            fragileWordIndices: Value(jsonEncode(fragileWordIndices)),
            memorizedAt: now,
            nextReviewAt: nextReview,
            updatedAt: now,
          ),
        );

    await _log(profileId, surahNumber, ayahNumber, 'memorize', outcome, now);
    await _bumpSurahProgress(profileId, surahNumber, surahTotalAyahs, now);
  }

  /// Records a later spaced-repetition review (outside the initial guided
  /// session) — advances or resets the verse's cycle per [ReviewScheduler].
  Future<void> recordAyahReview({
    required String ayahProgressId,
    required ReciteOutcome outcome,
    required bool hasFragileWords,
  }) async {
    final now = DateTime.now();
    final row = await (_db.select(
      _db.ayahProgressEntries,
    )..where((t) => t.id.equals(ayahProgressId))).getSingle();
    final result = ReviewScheduler(clock: () => now).scheduleNextReview(
      from: now,
      cycleStep: row.reviewCycleStep,
      outcome: outcome,
      hasFragileWords: hasFragileWords,
    );
    await (_db.update(
      _db.ayahProgressEntries,
    )..where((t) => t.id.equals(ayahProgressId))).write(
      AyahProgressEntriesCompanion(
        lastOutcome: Value(outcome.name),
        reviewCycleStep: Value(result.nextCycleStep),
        nextReviewAt: Value(result.dueAt),
        // A clean recitation means the shaky words held: stop halving this
        // verse's intervals forever over a word revealed once while
        // memorizing it.
        fragileWordIndices: outcome == ReciteOutcome.clean
            ? const Value('[]')
            : const Value.absent(),
        updatedAt: Value(now),
      ),
    );
    await _log(
      row.profileId,
      row.surahNumber,
      row.ayahNumber,
      'review',
      outcome,
      now,
    );
  }

  Future<void> _log(
    String profileId,
    int surahNumber,
    int ayahNumber,
    String kind,
    ReciteOutcome outcome,
    DateTime at,
  ) => _db
      .into(_db.reviewLogEntries)
      .insert(
        ReviewLogEntriesCompanion.insert(
          id: _uuid.v4(),
          profileId: profileId,
          surahNumber: surahNumber,
          ayahNumber: ayahNumber,
          kind: kind,
          outcome: outcome.name,
          occurredAt: at,
        ),
      );

  /// A finished guided passage ('memorization') or revision session
  /// ('revision') — feeds the dashboard's time invested.
  Future<void> logStudySession({
    required String profileId,
    required String kind,
    required DateTime startedAt,
    required Duration duration,
    required int ayahCount,
  }) => _db
      .into(_db.studySessionEntries)
      .insert(
        StudySessionEntriesCompanion.insert(
          id: _uuid.v4(),
          profileId: profileId,
          kind: kind,
          startedAt: startedAt,
          durationSeconds: duration.inSeconds,
          ayahCount: ayahCount,
        ),
      );

  Future<void> _bumpSurahProgress(
    String profileId,
    int surahNumber,
    int totalAyahs,
    DateTime now,
  ) async {
    final existing =
        await (_db.select(_db.surahProgressEntries)..where(
              (t) =>
                  t.profileId.equals(profileId) &
                  t.surahNumber.equals(surahNumber),
            ))
            .getSingleOrNull();

    if (existing == null) {
      final completed = totalAyahs <= 1;
      await _db
          .into(_db.surahProgressEntries)
          .insert(
            SurahProgressEntriesCompanion.insert(
              id: _uuid.v4(),
              profileId: profileId,
              surahNumber: surahNumber,
              memorizedAyahCount: const Value(1),
              totalAyahCount: totalAyahs,
              completedAt: Value(completed ? now : null),
              updatedAt: now,
            ),
          );
      return;
    }

    final newCount = existing.memorizedAyahCount + 1;
    final completed = newCount >= existing.totalAyahCount;
    await (_db.update(
      _db.surahProgressEntries,
    )..where((t) => t.id.equals(existing.id))).write(
      SurahProgressEntriesCompanion(
        memorizedAyahCount: Value(newCount),
        completedAt: Value(completed ? now : existing.completedAt),
        updatedAt: Value(now),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // Surah progress & onboarding
  // ---------------------------------------------------------------------

  Future<List<SurahProgressEntry>> allSurahProgress(String profileId) =>
      (_db.select(
        _db.surahProgressEntries,
      )..where((t) => t.profileId.equals(profileId))).get();

  Future<int> completedSurahCount(String profileId) async {
    final rows = await allSurahProgress(profileId);
    return rows.where((r) => r.completedAt != null).length;
  }

  /// Onboarding (Brique 2): the user already knows this whole sourate — no
  /// per-ayah review scheduling for it (that would be thousands of rows for
  /// a hafiz declaring the whole Quran at once), just marked complete.
  Future<void> markSurahMemorized(
    String profileId,
    int surahNumber,
    int numberOfAyahs,
  ) async {
    final now = DateTime.now();
    await _db
        .into(_db.surahProgressEntries)
        .insert(
          SurahProgressEntriesCompanion.insert(
            id: _uuid.v4(),
            profileId: profileId,
            surahNumber: surahNumber,
            memorizedAyahCount: Value(numberOfAyahs),
            totalAyahCount: numberOfAyahs,
            completedAt: Value(now),
            updatedAt: now,
          ),
        );
  }
}

final memorizationRepositoryProvider = Provider<MemorizationRepository>((ref) {
  return MemorizationRepository(ref.watch(appDatabaseProvider));
});

final activeSessionProvider = FutureProvider((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  return ref.watch(memorizationRepositoryProvider).activeSession(profile.id);
});

final surahProgressProvider = FutureProvider<List<SurahProgressEntry>>((
  ref,
) async {
  final profile = await ref.watch(currentProfileProvider.future);
  return ref.watch(memorizationRepositoryProvider).allSurahProgress(profile.id);
});

/// What the Accueil "session du jour" card should show: the passage left
/// mid-session if there is one, otherwise today's fresh suggestion — null
/// only once every ayah of the Quran is already memorized.
final todaysPassagePreviewProvider =
    FutureProvider<({int surahNumber, int ayahStart, int ayahEnd})?>((
      ref,
    ) async {
      final profile = await ref.watch(currentProfileProvider.future);
      final repo = ref.watch(memorizationRepositoryProvider);

      final active = await repo.activeSession(profile.id);
      if (active != null) {
        return (
          surahNumber: active.passage.surahNumber,
          ayahStart: active.passage.ayahStart,
          ayahEnd: active.passage.ayahEnd,
        );
      }

      final reference = await ref.watch(quranReferenceProvider.future);
      final memorized = await repo.memorizedAyahKeys(profile.id);
      final suggestion = suggestNextPassage(reference, memorized);
      if (suggestion == null) return null;
      return (
        surahNumber: suggestion.surahNumber,
        ayahStart: suggestion.startAyah,
        ayahEnd: suggestion.endAyah,
      );
    });

final dueReviewsProvider = FutureProvider<List<AyahProgressEntry>>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  return ref.watch(memorizationRepositoryProvider).dueReviews(profile.id);
});

/// Every memorized verse with its review state (calendar, mastery).
final ayahProgressProvider = FutureProvider<List<AyahProgressEntry>>((
  ref,
) async {
  final profile = await ref.watch(currentProfileProvider.future);
  return ref.watch(memorizationRepositoryProvider).allAyahProgress(profile.id);
});
