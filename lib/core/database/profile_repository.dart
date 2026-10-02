import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';

/// This is a single-profile local app for now (no multi-account switch),
/// so we always read/create the one row with this fixed id.
const localProfileId = 'local';

class UserProfileRepository {
  UserProfileRepository(this._db);

  final AppDatabase _db;

  Future<UserProfile> getOrCreateLocalProfile() async {
    final existing = await (_db.select(
      _db.userProfiles,
    )..where((p) => p.id.equals(localProfileId))).getSingleOrNull();
    if (existing != null) return existing;

    final now = DateTime.now();
    await _db
        .into(_db.userProfiles)
        .insert(
          UserProfilesCompanion.insert(
            id: localProfileId,
            createdAt: now,
            updatedAt: now,
          ),
        );
    return (_db.select(
      _db.userProfiles,
    )..where((p) => p.id.equals(localProfileId))).getSingle();
  }

  /// Partial update — used by the Onboarding flow (Brique 2) to persist the
  /// derived level, availability and completion flag once, at the end.
  Future<void> updateProfile({
    required String id,
    String? memorizationLevel,
    int? availableDaysMask,
    int? dailyTargetMinutes,
    bool? hasCompletedOnboarding,
  }) async {
    await (_db.update(_db.userProfiles)..where((p) => p.id.equals(id))).write(
      UserProfilesCompanion(
        memorizationLevel: memorizationLevel != null
            ? Value(memorizationLevel)
            : const Value.absent(),
        availableDaysMask: availableDaysMask != null
            ? Value(availableDaysMask)
            : const Value.absent(),
        dailyTargetMinutes: dailyTargetMinutes != null
            ? Value(dailyTargetMinutes)
            : const Value.absent(),
        hasCompletedOnboarding: hasCompletedOnboarding != null
            ? Value(hasCompletedOnboarding)
            : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Sets the weekly and monthly verse goals; null for either goes back to
  /// the proposed default.
  Future<void> setGoals({
    required String id,
    required int? weekly,
    required int? monthly,
  }) async {
    await (_db.update(_db.userProfiles)..where((p) => p.id.equals(id))).write(
      UserProfilesCompanion(
        weeklyVerseGoal: Value(weekly),
        monthlyVerseGoal: Value(monthly),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  return UserProfileRepository(ref.watch(appDatabaseProvider));
});

final currentProfileProvider = FutureProvider<UserProfile>((ref) {
  return ref.watch(userProfileRepositoryProvider).getOrCreateLocalProfile();
});

/// Whether the Onboarding flow (Brique 2) still needs to run before the
/// rest of the app is shown — see [SudurApp].
final needsOnboardingProvider = FutureProvider<bool>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  return !profile.hasCompletedOnboarding;
});
