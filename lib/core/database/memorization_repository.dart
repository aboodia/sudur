import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'app_database.dart';

/// Seeds [MemorizationUnits] rows for sourates the Onboarding flow (Brique 2)
/// collected as already memorized. Whole-sourate ranges only for this v1
/// (no partial-Juz ranges — see the Onboarding plan).
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
            createdAt: now,
            updatedAt: now,
          ),
        );
  }
}

final memorizationRepositoryProvider = Provider<MemorizationRepository>((ref) {
  return MemorizationRepository(ref.watch(appDatabaseProvider));
});
