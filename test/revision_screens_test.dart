// Widget tests for the Révision screens: the hub (today card, calendar,
// mastery) and a full session driven by taps. Bounded pumps instead of
// pumpAndSettle — a CircularProgressIndicator never settles, and the
// session screen shows one while it loads.

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/core/quran_text/quran_text_repository.dart';
import 'package:sudur/features/revision/screens/revision_hub_screen.dart';
import 'package:sudur/features/revision/screens/revision_session_screen.dart';
import 'package:sudur/l10n/app_localizations.dart';

import 'helpers/revision_seed.dart';

// Assets are loaded once, outside any testWidgets: a cached asset load does
// not complete again inside a later test's fake-async zone, which left the
// screens stuck on their loading spinner from the second test on.
late QuranReferenceRepository _reference;
late QuranTextRepository _text;

/// Pumps until every loading indicator is gone (assets and database reads
/// finish at their own pace), instead of guessing a duration.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 100; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (i >= 3 && find.byType(CircularProgressIndicator).evaluate().isEmpty) {
      break;
    }
  }
  await tester.pump(const Duration(milliseconds: 100));
}

Future<void> _pumpApp(WidgetTester tester, AppDatabase db) async {
  tester.view.physicalSize = const Size(900, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: '/revision',
    routes: [
      GoRoute(
        path: '/revision',
        builder: (_, _) => const RevisionHubScreen(),
        routes: [
          GoRoute(
            path: 'session',
            builder: (_, _) => const RevisionSessionScreen(),
          ),
        ],
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        quranReferenceProvider.overrideWith((ref) => _reference),
        quranTextProvider.overrideWith((ref) => _text),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await _settle(tester);
}

AppDatabase _freshDb() => AppDatabase.forTesting(NativeDatabase.memory());

DateTime _tomorrowAtNoon() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + 1, 12);
}

DateTime _hoursFromNow(int h) => DateTime.now().add(Duration(hours: h));

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _reference = await QuranReferenceRepository.load();
    _text = await QuranTextRepository.load();
  });

  testWidgets('a brand-new user sees an explanation, not an empty screen', (
    tester,
  ) async {
    final db = _freshDb();
    await _pumpApp(tester, db);

    expect(tester.takeException(), isNull);
    expect(find.textContaining('premier passage'), findsOneWidget);
    expect(find.text('Commencer la révision'), findsNothing);
  });

  testWidgets('the hub offers today\'s session, the calendar and mastery', (
    tester,
  ) async {
    final db = _freshDb();
    await seedAyahInDb(db, surah: 105, ayah: 1, due: _hoursFromNow(-30));
    await seedAyahInDb(db, surah: 105, ayah: 2, due: _hoursFromNow(-30));
    await seedAyahInDb(db, surah: 105, ayah: 4, due: _hoursFromNow(72));
    await _pumpApp(tester, db);

    expect(tester.takeException(), isNull);
    expect(find.text('Commencer la révision'), findsOneWidget);
    // Two of the three verses are due today.
    expect(find.text('2 verset(s)'), findsWidgets);
    expect(find.text('Calendrier'), findsOneWidget);
    expect(find.text('Ta maîtrise'), findsOneWidget);
  });

  testWidgets('when nothing is due the hub says so and when to come back', (
    tester,
  ) async {
    final db = _freshDb();
    await seedAyahInDb(
      db,
      surah: 105,
      ayah: 1,
      // Noon tomorrow: "now + 26 h" lands on the day after tomorrow late
      // in the evening, which made this test depend on the time it runs.
      due: _tomorrowAtNoon(),
    );
    await _pumpApp(tester, db);

    expect(find.text('Tu es à jour'), findsOneWidget);
    expect(find.text('Prochaine révision : demain'), findsOneWidget);
    expect(find.text('Commencer la révision'), findsNothing);
  });

  testWidgets('a full session: rate each verse, see the recap, go back', (
    tester,
  ) async {
    final db = _freshDb();
    await seedAyahInDb(db, surah: 105, ayah: 1, due: _hoursFromNow(-30));
    await seedAyahInDb(db, surah: 105, ayah: 2, due: _hoursFromNow(-30));
    await _pumpApp(tester, db);

    await tester.tap(find.text('Commencer la révision'));
    await _settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('Verset 1 sur 2'), findsOneWidget);

    // "Continuer" stays disabled until a self-assessment is chosen.
    FilledButton continueButton() => tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Continuer'),
    );
    expect(continueButton().onPressed, isNull);

    await tester.tap(find.text('Sans erreur'));
    await tester.pump();
    expect(continueButton().onPressed, isNotNull);
    await tester.tap(find.text('Continuer'));
    await _settle(tester);
    expect(find.text('Verset 2 sur 2'), findsOneWidget);

    await tester.tap(find.text('À reprendre'));
    await tester.pump();
    await tester.tap(find.text('Continuer'));
    await _settle(tester);

    expect(find.text('Révision terminée'), findsOneWidget);
    expect(find.text('Sans erreur · 1'), findsOneWidget);
    expect(find.text('À reprendre · 1'), findsOneWidget);
    expect(find.text('Quelques hésitations · 0'), findsOneWidget);
    // The redo comes back tomorrow.
    expect(find.text('Prochaine révision : demain'), findsOneWidget);

    final log = await (db.select(
      db.reviewLogEntries,
    )..orderBy([(t) => OrderingTerm.asc(t.ayahNumber)])).get();
    expect(log.map((l) => l.outcome), ['clean', 'redo']);
    expect(await MemorizationRepository(db).dueReviews('local'), isEmpty);

    await tester.tap(find.text('Retour'));
    await _settle(tester);
    expect(find.text('Tu es à jour'), findsOneWidget);
  });

  testWidgets(
    'opening the session with nothing due shows the up-to-date view',
    (tester) async {
      final db = _freshDb();
      await seedAyahInDb(
        db,
        surah: 105,
        ayah: 1,
        due: DateTime.now().add(const Duration(days: 3)),
      );
      await _pumpApp(tester, db);
      // No "Commencer" button here, so open the session route directly.
      final context = tester.element(find.byType(RevisionHubScreen));
      GoRouter.of(context).push('/revision/session');
      await _settle(tester);

      expect(tester.takeException(), isNull);
      expect(find.text('Tu es à jour'), findsOneWidget);
    },
  );
}
