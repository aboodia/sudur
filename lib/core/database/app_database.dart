import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    UserProfiles,
    Passages,
    SessionProgressEntries,
    AyahProgressEntries,
    SurahProgressEntries,
    Bookmarks,
    ReviewLogEntries,
    StudySessionEntries,
    AchievementUnlocks,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 6;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      if (from < 2) {
        await m.addColumn(userProfiles, userProfiles.hasCompletedOnboarding);
      }
      if (from < 3) {
        // Le parcours de mémorisation par verset (Passages/*ProgressEntries)
        // remplace l'ancien modèle par passage (MemorizationUnits.circle/
        // masteryLevel + ReviewHistoryEntries) — aucune donnée réelle en jeu
        // à ce stade, un DROP + CREATE propre plutôt qu'une migration de
        // données.
        await m.deleteTable('review_history_entries');
        await m.deleteTable('memorization_units');
        await m.createTable(passages);
        await m.createTable(sessionProgressEntries);
        await m.createTable(ayahProgressEntries);
        await m.createTable(surahProgressEntries);
      }
      if (from < 4) {
        // Journal d'activité (révisions, sessions) pour le Tableau de bord.
        await m.createTable(reviewLogEntries);
        await m.createTable(studySessionEntries);
      }
      if (from < 5) {
        await m.addColumn(userProfiles, userProfiles.weeklyVerseGoal);
        await m.addColumn(userProfiles, userProfiles.monthlyVerseGoal);
      }
      if (from < 6) {
        await m.createTable(achievementUnlocks);
      }
    },
  );
}

QueryExecutor _openConnection() {
  return driftDatabase(name: 'sudur');
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
