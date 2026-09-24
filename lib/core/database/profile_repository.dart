import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// This is a single-profile local app for now (no multi-account switch),
/// so we always read/create the one row with this fixed id.
const localProfileId = 'local';

class UserProfileRepository {
  UserProfileRepository(this._db);

  final AppDatabase _db;

  Future<UserProfile> getOrCreateLocalProfile() async {
    final existing = await (_db.select(_db.userProfiles)
          ..where((p) => p.id.equals(localProfileId)))
        .getSingleOrNull();
    if (existing != null) return existing;

    final now = DateTime.now();
    await _db.into(_db.userProfiles).insert(
          UserProfilesCompanion.insert(
            id: localProfileId,
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (_db.select(_db.userProfiles)
          ..where((p) => p.id.equals(localProfileId)))
        .getSingle();
  }
}

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository(ref.watch(appDatabaseProvider));
});

final currentProfileProvider = FutureProvider<UserProfile>((ref) {
  return ref.watch(userProfileRepositoryProvider).getOrCreateLocalProfile();
});
