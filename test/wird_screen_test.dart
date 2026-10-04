// Widget tests for the Wird. Assets are loaded once outside testWidgets and
// injected (a cached asset load does not complete again in a later test's
// fake-async zone).

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/mushaf/mushaf_repository.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/features/wird/widgets/wird_card.dart';
import 'package:sudur/features/wird/wird_screen.dart';
import 'package:sudur/l10n/app_localizations.dart';

late QuranReferenceRepository _reference;
late MushafRepository _mushaf;

Future<void> _bounded(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<AppDatabase> _pump(
  WidgetTester tester,
  Widget screen, {
  List<int> declared = const [1, 2],
  Map<String, Object> prefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  tester.view.physicalSize = const Size(900, 3000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final db = AppDatabase.forTesting(NativeDatabase.memory());
  final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
  final repo = MemorizationRepository(db);
  for (final n in declared) {
    await repo.markSurahMemorized(
      profile.id,
      n,
      _reference.surahByNumber(n).numberOfAyahs,
    );
  }

  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, _) => Scaffold(body: screen),
      ),
      GoRoute(path: '/wird', builder: (_, _) => const Text('écran wird')),
      GoRoute(
        path: '/lecture/mushaf',
        builder: (_, state) =>
            Scaffold(body: Text('mushaf ${state.uri.queryParameters['page']}')),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        quranReferenceProvider.overrideWith((ref) => _reference),
        mushafRepositoryProvider.overrideWith((ref) => _mushaf),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await _bounded(tester);
  return db;
}

Future<void> _rateAndFinish(WidgetTester tester, String outcome) async {
  await tester.ensureVisible(find.text(outcome));
  await tester.tap(find.text(outcome));
  await tester.pump();
  await tester.ensureVisible(find.text('Terminer ma part'));
  await tester.tap(find.text('Terminer ma part'));
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 300)),
  );
  await _bounded(tester);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _reference = await QuranReferenceRepository.load();
    _mushaf = await MushafRepository.load();
    // Real letter widths, not the test font's squares.
    final loader = FontLoader('Roboto')
      ..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'));
    await loader.load();
  });

  testWidgets("today's pages are listed, each opening the Mushaf", (
    tester,
  ) async {
    await _pump(tester, const WirdScreen());

    expect(tester.takeException(), isNull);
    expect(find.text('Mon Wird'), findsOneWidget);
    expect(find.text('Tour 1'), findsOneWidget);
    // Al-Fatiha and Al-Baqara span 49 pages: about a month, two pages a day.
    expect(find.text('2 page(s) à lire aujourd\'hui'), findsOneWidget);
    final fatiha = _reference.surahByNumber(1).englishName;
    expect(find.text('Page 1 · $fatiha'), findsOneWidget);
    expect(find.text('0 page(s) sur 49 dans ce tour'), findsOneWidget);
    expect(find.text('Terminer ma part'), findsOneWidget);

    await tester.tap(find.text('Page 1 · $fatiha'));
    await _bounded(tester);
    expect(find.text('mushaf 1'), findsOneWidget);
  });

  testWidgets('finishing needs a self-assessment first', (tester) async {
    await _pump(tester, const WirdScreen());

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Terminer ma part'),
    );
    expect(button.onPressed, isNull);

    await tester.tap(find.text('Sans erreur'));
    await tester.pump();
    final enabled = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Terminer ma part'),
    );
    expect(enabled.onPressed, isNotNull);
  });

  testWidgets('a share read is recorded as activity and the loop moves on', (
    tester,
  ) async {
    final db = await _pump(tester, const WirdScreen());

    await _rateAndFinish(tester, 'Sans erreur');

    expect(
      find.text(
        "C'est fait pour aujourd'hui, bravo. Ta prochaine part t'attend demain.",
      ),
      findsOneWidget,
    );
    expect(find.text('Prochaine part : page 3'), findsOneWidget);
    expect(find.text('2 page(s) sur 49 dans ce tour'), findsOneWidget);

    final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
    final repo = MemorizationRepository(db);
    final log = await repo.reviewLog(profile.id);
    expect(log, hasLength(1));
    expect(log.single.kind, 'wird');
    expect(log.single.outcome, 'clean');
    final sessions = await repo.studySessions(profile.id);
    expect(sessions, hasLength(1));
    expect(sessions.single.kind, 'revision');
  });

  testWidgets('a share to redo stays to do, but still counts as activity', (
    tester,
  ) async {
    final db = await _pump(tester, const WirdScreen());

    await _rateAndFinish(tester, 'À reprendre');

    // Not done: the same pages are still offered.
    expect(find.text('Terminer ma part'), findsOneWidget);
    expect(find.text('0 page(s) sur 49 dans ce tour'), findsOneWidget);
    final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
    final log = await MemorizationRepository(db).reviewLog(profile.id);
    expect(log.single.outcome, 'redo');
  });

  testWidgets('the goal can be counted in Juz instead of pages', (
    tester,
  ) async {
    await _pump(tester, const WirdScreen());

    await tester.ensureVisible(find.text('Juz'));
    await tester.tap(find.text('Juz'));
    await _bounded(tester);

    expect(find.text('1 Juz par jour'), findsOneWidget);
    // A Juz is 20 pages.
    expect(find.text('20 page(s) à lire aujourd\'hui'), findsOneWidget);
  });

  testWidgets('the goal in pages can be raised and lowered', (tester) async {
    await _pump(tester, const WirdScreen());

    await tester.ensureVisible(find.byTooltip('Plus'));
    await tester.tap(find.byTooltip('Plus'));
    await _bounded(tester);
    expect(find.text('3 page(s) par jour'), findsOneWidget);
    expect(find.text('3 page(s) à lire aujourd\'hui'), findsOneWidget);

    await tester.tap(find.byTooltip('Moins'));
    await _bounded(tester);
    expect(find.text('2 page(s) par jour'), findsOneWidget);
  });

  testWidgets('a goal chosen earlier is kept', (tester) async {
    await _pump(
      tester,
      const WirdScreen(),
      prefs: {'wird.unit': 'pages', 'wird.amount': 5},
    );

    expect(find.text('5 page(s) par jour'), findsOneWidget);
    expect(find.text('5 page(s) à lire aujourd\'hui'), findsOneWidget);
  });

  testWidgets('the loop resumes where it was left', (tester) async {
    await _pump(
      tester,
      const WirdScreen(),
      prefs: {'wird.pointer': 10, 'wird.turns': 2},
    );

    expect(find.text('Tour 3'), findsOneWidget);
    expect(find.textContaining('Page 11 · '), findsOneWidget);
  });

  testWidgets('the card on the Accueil opens the Wird', (tester) async {
    await _pump(tester, const WirdCard());

    expect(find.text('Mon Wird'), findsOneWidget);
    expect(find.text('2 page(s) à lire aujourd\'hui'), findsOneWidget);
    await tester.tap(find.text('Mon Wird'));
    await _bounded(tester);
    expect(find.text('écran wird'), findsOneWidget);
  });

  testWidgets('with nothing known there is no Wird card', (tester) async {
    await _pump(tester, const WirdCard(), declared: const []);

    expect(find.text('Mon Wird'), findsNothing);
  });
}
