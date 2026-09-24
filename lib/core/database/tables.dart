import 'package:drift/drift.dart';

/// Mutable user data only (profile, memorization state, review history).
/// Kept separate from the static Quran reference content
/// (core/quran_reference) so the two can evolve and sync independently,
/// per §6.2 of the cahier des charges. Primary keys are UUID text (not
/// autoincrement ints) and every row carries createdAt/updatedAt so that
/// multi-device sync (Brique 9) can be added without a data migration.

class UserProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text().withDefault(const Constant(''))();

  /// 'debutant' | 'en_cours' | 'hafiz' — set by the Onboarding level test.
  TextColumn get memorizationLevel =>
      text().withDefault(const Constant('debutant'))();

  /// Bitmask over the 7 days of the week (bit 0 = Monday) for availability.
  IntColumn get availableDaysMask => integer().withDefault(const Constant(127))();
  IntColumn get dailyTargetMinutes => integer().withDefault(const Constant(10))();

  TextColumn get preferredQariId => text().nullable()();

  /// 'hafs' | 'warsh' — Mushaf script/riwaya.
  TextColumn get scriptMode => text().withDefault(const Constant('hafs'))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A memorized (or being-memorized) passage: a contiguous ayah range within
/// one sourate. Granularity is deliberately small (down to 1 ayah) so the
/// Mémorisation brique can découper a passage into 1-3 verset units.
class MemorizationUnits extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().references(UserProfiles, #id, onDelete: KeyAction.cascade)();

  IntColumn get surahNumber => integer()();
  IntColumn get startAyah => integer()();
  IntColumn get endAyah => integer()();

  /// 'not_started' | 'learning' | 'memorized'
  TextColumn get status => text().withDefault(const Constant('not_started'))();

  /// 'weak' | 'medium' | 'solid' — null until first review.
  TextColumn get masteryLevel => text().nullable()();

  /// Spaced-repetition circle ("Les Trois Cercles"): 1 = quotidien,
  /// 2 = hebdomadaire, 3 = mensuel. Null until the unit is memorized.
  IntColumn get circle => integer().nullable()();

  DateTimeColumn get lastReviewedAt => dateTime().nullable()();
  DateTimeColumn get nextReviewDueAt => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One completed review (murâja'a) event for a MemorizationUnit — the
/// audit trail behind the spaced-repetition circle transitions.
class ReviewHistoryEntries extends Table {
  TextColumn get id => text()();
  TextColumn get unitId =>
      text().references(MemorizationUnits, #id, onDelete: KeyAction.cascade)();

  DateTimeColumn get reviewedAt => dateTime()();

  /// 'success' | 'fail'
  TextColumn get result => text()();

  IntColumn get circleBefore => integer().nullable()();
  IntColumn get circleAfter => integer().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A signet (bookmark) on one ayah, shown in the Accueil lecture "Signets"
/// tab (Brique 1).
class Bookmarks extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().references(UserProfiles, #id, onDelete: KeyAction.cascade)();

  IntColumn get surahNumber => integer()();
  IntColumn get ayahNumber => integer()();
  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
