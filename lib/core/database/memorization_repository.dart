import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../review/spaced_repetition.dart';
import 'app_database.dart';
import 'profile_repository.dart';

/// Reads and seeds [MemorizationUnits] rows — whole-sourate ranges from the
/// Onboarding flow (Brique 2, `markSurahMemorized`), and 1-3 ayah passages
/// from guided sessions (Brique 3, `startUnit`/`completeUnit`).
class MemorizationRepository {
  MemorizationRepository(this._db);

  final AppDatabase _db;
  static const _uuid = Uuid();

  Future<void> markSurahMemorized(String profileId, int surahNumber, int numberOfAyahs) async {
    final now = DateTime.now();
    await _db.into(_db.memorizationUnits).insert(
          MemorizationUnitsCompanion.insert(
            id: _uuid.v4(),
            profileId: profileId,
            surahNumber: surahNumber,
            startAyah: 1,
            endAyah: numberOfAyahs,
            status: const Value('memorized'),
            masteryLevel: const Value('solid'),
            circle: const Value(3),
            lastReviewedAt: Value(now),
            nextReviewDueAt: Value(nextReviewDate(now, 3)),
            createdAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<List<MemorizationUnit>> allUnits(String profileId) {
    return (_db.select(_db.memorizationUnits)..where((u) => u.profileId.equals(profileId))).get();
  }

  /// Starts a guided-memorization session on a new 1-3 ayah passage —
  /// inserts it as `status: 'learning'` and returns its id.
  Future<String> startUnit(String profileId, int surahNumber, int startAyah, int endAyah) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await _db.into(_db.memorizationUnits).insert(
          MemorizationUnitsCompanion.insert(
            id: id,
            profileId: profileId,
            surahNumber: surahNumber,
            startAyah: startAyah,
            endAyah: endAyah,
            status: const Value('learning'),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return id;
  }

  /// A passage just finished its guided-memorization session — enters
  /// Cercle 1 ("Les Trois Cercles" : révision quotidienne), unlike the
  /// Onboarding's already-known sourates which start at Cercle 3.
  Future<void> completeUnit(String unitId) async {
    final now = DateTime.now();
    await (_db.update(_db.memorizationUnits)..where((u) => u.id.equals(unitId))).write(
      MemorizationUnitsCompanion(
        status: const Value('memorized'),
        circle: const Value(1),
        lastReviewedAt: Value(now),
        nextReviewDueAt: Value(nextReviewDate(now, 1)),
        updatedAt: Value(now),
      ),
    );
  }
}

final memorizationRepositoryProvider = Provider<MemorizationRepository>((ref) {
  return MemorizationRepository(ref.watch(appDatabaseProvider));
});

final memorizationUnitsProvider = FutureProvider<List<MemorizationUnit>>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  return ref.watch(memorizationRepositoryProvider).allUnits(profile.id);
});
