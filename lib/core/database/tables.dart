import 'package:drift/drift.dart';

/// Mutable user data only (profile, memorization/review state). Kept
/// separate from the static Quran reference content (core/quran_reference)
/// so the two can evolve and sync independently, per §6.2 of the cahier des
/// charges. Primary keys are UUID text (not autoincrement ints) and every
/// row carries createdAt/updatedAt so that multi-device sync (Brique 9) can
/// be added without a data migration.

class UserProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get displayName => text().withDefault(const Constant(''))();

  /// 'debutant' | 'en_cours' | 'hafiz' — set by the Onboarding level test.
  TextColumn get memorizationLevel =>
      text().withDefault(const Constant('debutant'))();

  /// Bitmask over the 7 days of the week (bit 0 = Monday) for availability.
  IntColumn get availableDaysMask =>
      integer().withDefault(const Constant(127))();
  IntColumn get dailyTargetMinutes =>
      integer().withDefault(const Constant(10))();

  TextColumn get preferredQariId => text().nullable()();

  /// 'hafs' | 'warsh' — Mushaf script/riwaya.
  TextColumn get scriptMode => text().withDefault(const Constant('hafs'))();

  /// Whether the Onboarding (Brique 2) flow has been completed — gates
  /// whether the app shows it again on the next launch.
  BoolColumn get hasCompletedOnboarding =>
      boolean().withDefault(const Constant(false))();

  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// A memorization passage — a contiguous ayah range within one sourate, the
/// unit the 7-screen guided flow (Découvrir → ... → Enchaîner) works
/// through in one session (e.g. Al-Mulk 1-5).
class Passages extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().references(UserProfiles, #id, onDelete: KeyAction.cascade)();

  IntColumn get surahNumber => integer()();
  IntColumn get ayahStart => integer()();
  IntColumn get ayahEnd => integer()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Where a passage's guided session currently stands — read when the
/// screen opens to resume at the exact same step/verset/mask level, written
/// on every step change and whenever "Quitter" is pressed.
class SessionProgressEntries extends Table {
  TextColumn get id => text()();
  TextColumn get passageId =>
      text().references(Passages, #id, onDelete: KeyAction.cascade)();

  /// 0=Découvrir, 1=Répéter, 2=Masquer, 3=Réciter, 4=Enchaîner.
  IntColumn get currentStepIndex => integer().withDefault(const Constant(0))();
  IntColumn get currentAyah => integer()();

  /// 'light' | 'medium' | 'full' — only meaningful during Masquer.
  TextColumn get maskLevel => text().nullable()();

  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {passageId},
  ];
}

/// Per-ayah memorization/review state — the finer-grained replacement for
/// the old per-passage "circle"/"masteryLevel" (Brique 4). One row per ayah
/// ever memorized.
class AyahProgressEntries extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().references(UserProfiles, #id, onDelete: KeyAction.cascade)();

  IntColumn get surahNumber => integer()();
  IntColumn get ayahNumber => integer()();

  /// 'clean' | 'hesitant' | 'redo' — the last "Réciter" self-assessment.
  TextColumn get lastOutcome => text().nullable()();

  /// JSON-encoded list of word indices tapped during Masquer (revealed
  /// early) — feeds ReviewScheduler's `hasFragileWords`.
  TextColumn get fragileWordIndices =>
      text().withDefault(const Constant('[]'))();

  /// How many successful reviews so far — ReviewScheduler's `cycleStep`.
  IntColumn get reviewCycleStep => integer().withDefault(const Constant(0))();

  DateTimeColumn get memorizedAt => dateTime()();
  DateTimeColumn get nextReviewAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {profileId, surahNumber, ayahNumber},
  ];
}

/// How much of a sourate is memorized — a sourate only counts towards a
/// profil/badge once every one of its ayahs is memorized (design "Les 8
/// profils et badges" : "une sourate compte seulement quand tous ses
/// versets sont mémorisés").
class SurahProgressEntries extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().references(UserProfiles, #id, onDelete: KeyAction.cascade)();

  IntColumn get surahNumber => integer()();
  IntColumn get memorizedAyahCount =>
      integer().withDefault(const Constant(0))();
  IntColumn get totalAyahCount => integer()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {profileId, surahNumber},
  ];
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

/// One row each time a verse is validated — memorized for the first time
/// ('memorize') or reviewed later ('review') — with how it went. The raw
/// material for the dashboard's retention rate, streak and progress curve;
/// never read by the scheduling logic itself ([AyahProgressEntries] is the
/// source of truth for what's due).
class ReviewLogEntries extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().references(UserProfiles, #id, onDelete: KeyAction.cascade)();

  IntColumn get surahNumber => integer()();
  IntColumn get ayahNumber => integer()();

  /// 'memorize' | 'review'.
  TextColumn get kind => text()();

  /// 'clean' | 'hesitant' | 'redo' — same values as
  /// [AyahProgressEntries.lastOutcome].
  TextColumn get outcome => text()();

  DateTimeColumn get occurredAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// One row per finished study session (a guided memorization passage or a
/// revision session) — how long it took, for the dashboard's "temps
/// investi".
class StudySessionEntries extends Table {
  TextColumn get id => text()();
  TextColumn get profileId =>
      text().references(UserProfiles, #id, onDelete: KeyAction.cascade)();

  /// 'memorization' | 'revision'.
  TextColumn get kind => text()();

  DateTimeColumn get startedAt => dateTime()();
  IntColumn get durationSeconds => integer()();
  IntColumn get ayahCount => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
