// Widget tests for Régularité et succès. The Quran reference is loaded once
// outside testWidgets and injected (a cached asset load does not complete
// again in a later test's fake-async zone).

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/database/achievement_repository.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/features/gamification/success_screen.dart';
import 'package:sudur/l10n/app_localizations.dart';

late QuranReferenceRepository _reference;

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 100; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (i >= 3 && find.byType(CircularProgressIndicator).evaluate().isEmpty) {
      break;
    }
  }
  await tester.pump(const Duration(milliseconds: 100));
}

/// One activity-log entry per given day offset (0 = today, 1 = yesterday).
Future<AppDatabase> _dbWithActivity(List<int> daysAgo) async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
  final now = DateTime.now();
  for (final d in daysAgo) {
    await db
        .into(db.reviewLogEntries)
        .insert(
          ReviewLogEntriesCompanion.insert(
            id: 'log-$d',
            profileId: profile.id,
            surahNumber: 67,
            ayahNumber: 1,
            kind: 'memorize',
            outcome: 'clean',
            occurredAt: DateTime(now.year, now.month, now.day - d, 9),
          ),
        );
  }
  return db;
}

Future<void> _pump(WidgetTester tester, AppDatabase db) async {
  tester.view.physicalSize = const Size(900, 3200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        quranReferenceProvider.overrideWith((ref) => _reference),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: SuccessScreen(),
      ),
    ),
  );
  await _settle(tester);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _reference = await QuranReferenceRepository.load();
  });

  testWidgets('a newcomer sees an inviting start, not a zero', (tester) async {
    await _pump(tester, await _dbWithActivity(const []));

    expect(tester.takeException(), isNull);
    expect(find.text('Ta série commence avec ta prochaine session.'), findsOne);
    expect(find.text('0 jour(s) de suite'), findsOneWidget);
    expect(find.text('0 joker(s) en réserve'), findsOneWidget);
    expect(find.text('0 sur 13'), findsOneWidget);
    expect(find.textContaining('Nouveau'), findsNothing);
  });

  testWidgets('a running streak is shown with the days to the next joker', (
    tester,
  ) async {
    await _pump(tester, await _dbWithActivity(const [0, 1, 2]));

    expect(find.text('3 jour(s) de suite'), findsOneWidget);
    expect(find.text("C'est fait pour aujourd'hui, bravo."), findsOneWidget);
    expect(find.text("Prochain joker dans 4 jour(s) d'étude."), findsOneWidget);
    // Three days of regularity earn the first regularity badge.
    expect(find.text('3 jours de régularité'), findsOneWidget);
    expect(find.textContaining('Obtenu le'), findsWidgets);
  });

  testWidgets('a streak at risk says so gently', (tester) async {
    await _pump(tester, await _dbWithActivity(const [1, 2]));

    expect(find.text('2 jour(s) de suite'), findsOneWidget);
    expect(
      find.text("Ta série est en jeu aujourd'hui : même 5 minutes suffisent."),
      findsOneWidget,
    );
  });

  testWidgets('a seven-day streak earns a joker', (tester) async {
    await _pump(tester, await _dbWithActivity(const [0, 1, 2, 3, 4, 5, 6]));

    expect(find.text('1 joker(s) en réserve'), findsOneWidget);
    expect(find.text('7 jours de régularité'), findsOneWidget);
  });

  testWidgets('badges still to earn show their goal and progress', (
    tester,
  ) async {
    await _pump(tester, await _dbWithActivity(const [0]));

    expect(find.text('Mémoriser 100 versets.'), findsOneWidget);
    expect(find.text('Étudier 7 jours de suite.'), findsOneWidget);
    expect(find.text('1 / 7'), findsOneWidget);
  });

  testWidgets('new badges are highlighted, then marked as seen', (
    tester,
  ) async {
    final db = await _dbWithActivity(const [0, 1, 2]);
    await _pump(tester, db);

    // Highlighted while the user is on the screen...
    expect(find.text('Nouveau'), findsOneWidget);

    // ...and already recorded as seen, so the Accueil banner goes away.
    final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
    final rows = await AchievementRepository(db).unlocked(profile.id);
    expect(rows, isNotEmpty);
    expect(rows.every((r) => r.seenAt != null), isTrue);
  });
}
