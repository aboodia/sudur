import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'app_database.dart';

const _uuid = Uuid();

class AchievementRepository {
  AchievementRepository(this._db);

  final AppDatabase _db;

  Future<List<AchievementUnlock>> unlocked(String profileId) => (_db.select(
    _db.achievementUnlocks,
  )..where((t) => t.profileId.equals(profileId))).get();

  /// Records the badges just earned. A badge already recorded is left as it
  /// is, so its date and "new" state are never reset.
  Future<void> unlock(
    String profileId,
    Iterable<String> keys,
    DateTime at,
  ) async {
    for (final key in keys) {
      await _db
          .into(_db.achievementUnlocks)
          .insert(
            AchievementUnlocksCompanion.insert(
              id: _uuid.v4(),
              profileId: profileId,
              achievementKey: key,
              unlockedAt: at,
            ),
            mode: InsertMode.insertOrIgnore,
          );
    }
  }

  /// The user has seen the badges earned so far.
  Future<void> markAllSeen(String profileId, DateTime at) =>
      (_db.update(_db.achievementUnlocks)
            ..where((t) => t.profileId.equals(profileId) & t.seenAt.isNull()))
          .write(AchievementUnlocksCompanion(seenAt: Value(at)));
}

final achievementRepositoryProvider = Provider<AchievementRepository>((ref) {
  return AchievementRepository(ref.watch(appDatabaseProvider));
});
