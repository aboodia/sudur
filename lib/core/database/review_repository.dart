import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../review/spaced_repetition.dart';
import 'app_database.dart';
import 'profile_repository.dart';

/// Lit les unités dues et enregistre les auto-évaluations de révision
/// (murâja'a, Brique 4) — le pendant de [ReviewHistoryEntries] pour
/// [MemorizationRepository], qui ne pose que le côté mémorisation.
class ReviewRepository {
  ReviewRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  /// Unités mémorisées dont l'échéance est passée, les plus en retard en
  /// premier — "les passages les plus anciens... reviennent plus souvent"
  /// (§4.4).
  Future<List<MemorizationUnit>> dueUnits(String profileId, {DateTime? asOf}) {
    final cutoff = asOf ?? DateTime.now();
    return (_db.select(_db.memorizationUnits)
          ..where((u) => u.profileId.equals(profileId) & u.status.equals('memorized') & u.nextReviewDueAt.isSmallerOrEqualValue(cutoff))
          ..orderBy([(u) => OrderingTerm.asc(u.nextReviewDueAt)]))
        .get();
  }

  /// Enregistre une auto-évaluation : met à jour le cercle/niveau de
  /// maîtrise/prochaine échéance de l'unité et journalise l'événement dans
  /// [ReviewHistoryEntries].
  Future<void> recordReview(String unitId, ReviewRating rating) async {
    await _db.transaction(() async {
      final unit = await (_db.select(_db.memorizationUnits)..where((u) => u.id.equals(unitId))).getSingle();
      final outcome = applyReviewOutcome(circleBefore: unit.circle, rating: rating);
      final now = DateTime.now();

      await (_db.update(_db.memorizationUnits)..where((u) => u.id.equals(unitId))).write(
        MemorizationUnitsCompanion(
          circle: Value(outcome.circle),
          masteryLevel: Value(outcome.masteryLevel),
          lastReviewedAt: Value(now),
          nextReviewDueAt: Value(nextReviewDate(now, outcome.circle)),
          updatedAt: Value(now),
        ),
      );

      await _db.into(_db.reviewHistoryEntries).insert(
            ReviewHistoryEntriesCompanion.insert(
              id: _uuid.v4(),
              unitId: unitId,
              reviewedAt: now,
              result: outcome.success ? 'success' : 'fail',
              circleBefore: Value(unit.circle),
              circleAfter: Value(outcome.circle),
              createdAt: now,
            ),
          );
    });
  }
}

final reviewRepositoryProvider = Provider<ReviewRepository>((ref) {
  return ReviewRepository(ref.watch(appDatabaseProvider));
});

final dueUnitsProvider = FutureProvider<List<MemorizationUnit>>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  return ref.watch(reviewRepositoryProvider).dueUnits(profile.id);
});
