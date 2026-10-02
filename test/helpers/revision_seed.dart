import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/profile_repository.dart';

/// A container over a fresh in-memory database — same pattern as the rest
/// of the suite (the real appDatabaseProvider persists to disk).
ProviderContainer freshContainer() => ProviderContainer(
  overrides: [
    appDatabaseProvider.overrideWithValue(
      AppDatabase.forTesting(NativeDatabase.memory()),
    ),
  ],
);

/// Inserts a memorized verse directly into [db], with full control over its
/// review state (the repository's own entry points always schedule J+1 from
/// now). Works on the database itself so widget tests can seed before
/// building a `ProviderScope`.
Future<AyahProgressEntry> seedAyahInDb(
  AppDatabase db, {
  required int surah,
  required int ayah,
  required DateTime due,
  String outcome = 'clean',
  int step = 0,
  String fragile = '[]',
}) async {
  final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
  final now = DateTime.now();
  await db
      .into(db.ayahProgressEntries)
      .insert(
        AyahProgressEntriesCompanion.insert(
          id: 'e-$surah-$ayah',
          profileId: profile.id,
          surahNumber: surah,
          ayahNumber: ayah,
          lastOutcome: Value(outcome),
          reviewCycleStep: Value(step),
          fragileWordIndices: Value(fragile),
          memorizedAt: now.subtract(const Duration(days: 10)),
          nextReviewAt: due,
          updatedAt: now,
        ),
      );
  return (db.select(
    db.ayahProgressEntries,
  )..where((t) => t.id.equals('e-$surah-$ayah'))).getSingle();
}

/// [seedAyahInDb] on a container's database.
Future<AyahProgressEntry> seedAyah(
  ProviderContainer c, {
  required int surah,
  required int ayah,
  required DateTime due,
  String outcome = 'clean',
  int step = 0,
  String fragile = '[]',
}) => seedAyahInDb(
  c.read(appDatabaseProvider),
  surah: surah,
  ayah: ayah,
  due: due,
  outcome: outcome,
  step: step,
  fragile: fragile,
);
