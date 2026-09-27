import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../memorization/review_scheduler.dart';
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

  Future<List<AyahProgressEntry>> dueReviews(
    String profileId, {
    DateTime? asOf,
  }) async {
    final cutoff = asOf ?? DateTime.now();
    return (_db.select(_db.ayahProgressEntries)
          ..where(
            (t) =>
                t.profileId.equals(profileId) &
                t.nextReviewAt.isSmallerOrEqualValue(cutoff),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.nextReviewAt)]))
        .get();
  }

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
        updatedAt: Value(now),
      ),
    );
  }

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

final dueReviewsProvider = FutureProvider<List<AyahProgressEntry>>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  return ref.watch(memorizationRepositoryProvider).dueReviews(profile.id);
});
