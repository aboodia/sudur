// Widget tests for the "Suivi" tab of Le Chemin. The Mushaf coverage is
// injected (the layout asset is covered by its own tests); the database is
// filled before the scope, as in the other screen tests.

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/memorization/review_scheduler.dart';
import 'package:sudur/core/path/surah_stories.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/core/stats/progress_history.dart';
import 'package:sudur/core/stats/progress_history_provider.dart';
import 'package:sudur/features/path/path_screen.dart';
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

/// Records which providers get rebuilt, to catch a change that reloads the
/// profile (and with it the whole app).
base class _ReloadSpy extends ProviderObserver {
  final reloaded = <Object>[];

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    reloaded.add(context.provider);
  }
}

Future<void> _openFollowUp(
  WidgetTester tester,
  AppDatabase db, {
  List<double>? coverage,
  ProviderObserver? spy,
}) async {
  tester.view.physicalSize = const Size(900, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: '/chemin',
    routes: [GoRoute(path: '/chemin', builder: (_, _) => const PathScreen())],
  );
  await tester.pumpWidget(
    ProviderScope(
      observers: [?spy],
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        quranReferenceProvider.overrideWith((ref) => _reference),
        surahStoriesProvider.overrideWith((ref) => const {}),
        mushafCoverageProvider.overrideWith(
          (ref) async => coverage ?? List.filled(604, 0.0),
        ),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await _settle(tester);
  await tester.tap(find.text('Suivi'));
  await _settle(tester);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _reference = await QuranReferenceRepository.load();
  });

  testWidgets('a new user sees encouraging empty states, not blank charts', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await _openFollowUp(tester, db);

    expect(tester.takeException(), isNull);
    expect(
      find.text('Ta courbe commencera avec ton premier passage mémorisé.'),
      findsOneWidget,
    );
    expect(
      find.text('Ton historique apparaîtra ici dès ta première session.'),
      findsOneWidget,
    );
    expect(find.text('0 page(s) complète(s) · 0 entamée(s) · 604 au total'), findsOne);
  });

  testWidgets('sessions are listed newest first with kind and duration', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
    final repo = MemorizationRepository(db);
    final now = DateTime.now();
    await repo.logStudySession(
      profileId: profile.id,
      kind: 'memorization',
      startedAt: now.subtract(const Duration(days: 1)),
      duration: const Duration(minutes: 12),
      ayahCount: 4,
    );
    await repo.logStudySession(
      profileId: profile.id,
      kind: 'revision',
      startedAt: now.subtract(const Duration(days: 2)),
      duration: const Duration(seconds: 20),
      ayahCount: 7,
    );

    await _openFollowUp(tester, db);
    await tester.scrollUntilVisible(
      find.text('Mémorisation · 4 verset(s)'),
      300,
      scrollable: find.byType(Scrollable).last,
    );

    expect(find.text('Mémorisation · 4 verset(s)'), findsOneWidget);
    expect(find.textContaining('Hier'), findsOneWidget);
    expect(find.textContaining('· 12 min'), findsOneWidget);
    // A real session of twenty seconds is never shown as "0 min".
    expect(find.text('Révision · 7 verset(s)'), findsOneWidget);
    expect(find.textContaining('· 1 min'), findsOneWidget);
  });

  testWidgets('the curve counts what was learned, not what was declared', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
    final repo = MemorizationRepository(db);
    // 7 verses known on joining, 3 learned since.
    await repo.markSurahMemorized(profile.id, 1, 7);
    for (var ayah = 1; ayah <= 3; ayah++) {
      await repo.recordAyahMemorized(
        profileId: profile.id,
        surahNumber: 67,
        ayahNumber: ayah,
        surahTotalAyahs: 30,
        outcome: ReciteOutcome.clean,
        fragileWordIndices: [],
      );
    }

    await _openFollowUp(tester, db);

    expect(find.text('+3 verset(s) sur la période'), findsOneWidget);
    expect(find.text('30 j'), findsOneWidget);

    await tester.tap(find.text('Tout'));
    await _settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Courbe de progression'), findsOneWidget);
    expect(find.text('+3 verset(s) sur la période'), findsOneWidget);
  });

  testWidgets('declaring sourates alone is no progress to show', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
    await MemorizationRepository(db).markSurahMemorized(profile.id, 1, 7);

    await _openFollowUp(tester, db);

    expect(
      find.text('Ta courbe commencera avec ton premier passage mémorisé.'),
      findsOneWidget,
    );
  });

  testWidgets('the map summary counts complete and started pages', (
    tester,
  ) async {
    final coverage = List.filled(604, 0.0);
    coverage[0] = 1.0;
    coverage[1] = 1.0;
    coverage[2] = 0.4;
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await _openFollowUp(tester, db, coverage: coverage);

    expect(find.text('2 page(s) complète(s) · 1 entamée(s) · 604 au total'), findsOne);
  });

  testWidgets('goals show progress and what is left, without reproach', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
    await UserProfileRepository(db)
        .setGoals(id: profile.id, weekly: 5, monthly: 20);

    await _openFollowUp(tester, db);

    expect(find.text('Objectifs'), findsOneWidget);
    expect(find.text('Cette semaine'), findsOneWidget);
    expect(find.text('0 / 5 versets'), findsOneWidget);
    expect(find.text('0 / 20 versets'), findsOneWidget);
    expect(find.textContaining('Encore 5 verset(s)'), findsOneWidget);
    // Chosen by the user: no "proposed" footnote.
    expect(find.text("Proposé d'après ton temps quotidien."), findsNothing);
  });

  testWidgets('a reached goal is celebrated', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
    await UserProfileRepository(db)
        .setGoals(id: profile.id, weekly: 2, monthly: 2);
    final repo = MemorizationRepository(db);
    for (var ayah = 1; ayah <= 2; ayah++) {
      await repo.recordAyahMemorized(
        profileId: profile.id,
        surahNumber: 67,
        ayahNumber: ayah,
        surahTotalAyahs: 30,
        outcome: ReciteOutcome.clean,
        fragileWordIndices: [],
      );
    }

    await _openFollowUp(tester, db);

    expect(find.text('Objectif atteint, mabrouk !'), findsNWidgets(2));
  });

  testWidgets('the goals can be edited and are kept', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
    await UserProfileRepository(db)
        .setGoals(id: profile.id, weekly: 5, monthly: 20);

    final spy = _ReloadSpy();
    await _openFollowUp(tester, db, spy: spy);
    spy.reloaded.clear();
    await tester.tap(find.text('Modifier'));
    await _settle(tester);
    expect(find.text('Tes objectifs'), findsOneWidget);

    await tester.tap(find.byTooltip('Augmenter').first);
    await tester.pump();
    await tester.tap(find.text('Enregistrer'));
    await _settle(tester);

    expect(find.text('0 / 6 versets'), findsOneWidget);
    // The profile feeds the app's onboarding gate: reloading it would rebuild
    // the whole app, and send the user back to the first tab.
    expect(spy.reloaded, isNot(contains(currentProfileProvider)));
    expect(find.text('Suivi'), findsOneWidget);
    expect(find.text('Objectifs'), findsOneWidget);
    final saved = await UserProfileRepository(db).getOrCreateLocalProfile();
    expect(saved.weeklyVerseGoal, 6);
    expect(saved.monthlyVerseGoal, 20);
  });

  testWidgets('a goal picked on purpose stays, even equal to the proposal', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await UserProfileRepository(db).getOrCreateLocalProfile();

    await _openFollowUp(tester, db);
    final proposed = (await UserProfileRepository(
      db,
    ).getOrCreateLocalProfile()).dailyTargetMinutes;
    expect(proposed, isNonZero);

    await tester.tap(find.text('Modifier'));
    await _settle(tester);
    // Up then down: back on the proposed value, but chosen by the user.
    await tester.tap(find.byTooltip('Augmenter').first);
    await tester.pump();
    await tester.tap(find.byTooltip('Diminuer').first);
    await tester.pump();
    await tester.tap(find.text('Enregistrer'));
    await _settle(tester);

    final saved = await UserProfileRepository(db).getOrCreateLocalProfile();
    expect(saved.weeklyVerseGoal, isNotNull);
    expect(saved.monthlyVerseGoal, isNull);
  });

  testWidgets('resetting goes back to the proposal', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
    await UserProfileRepository(db)
        .setGoals(id: profile.id, weekly: 5, monthly: 20);

    await _openFollowUp(tester, db);
    await tester.tap(find.text('Modifier'));
    await _settle(tester);
    await tester.tap(find.text('Revenir aux valeurs proposées'));
    await tester.pump();
    await tester.tap(find.text('Enregistrer'));
    await _settle(tester);

    final saved = await UserProfileRepository(db).getOrCreateLocalProfile();
    expect(saved.weeklyVerseGoal, isNull);
    expect(saved.monthlyVerseGoal, isNull);
    expect(find.text("Proposé d'après ton temps quotidien."), findsOneWidget);
  });

  testWidgets('the Suivi tab keeps its period when switching tabs', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await _openFollowUp(tester, db);

    await tester.tap(find.text('90 j'));
    await tester.pump();
    await tester.tap(find.text('Tracé'));
    await _settle(tester);
    await tester.tap(find.text('Suivi'));
    await _settle(tester);

    final selector = tester.widget<SegmentedButton<HistoryPeriod>>(
      find.byType(SegmentedButton<HistoryPeriod>),
    );
    expect(selector.selected, {HistoryPeriod.days90});
  });
}
