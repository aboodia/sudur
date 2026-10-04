// Widget tests for Révision du Coran. Assets are loaded once outside
// testWidgets and injected (a cached asset load does not complete again in a
// later test's fake-async zone).

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
import 'package:sudur/features/revision/screens/cycle_screen.dart';
import 'package:sudur/features/revision/screens/revision_hub_screen.dart';
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
}) async {
  SharedPreferences.setMockInitialValues({});
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
      GoRoute(path: '/', builder: (_, _) => screen),
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

  testWidgets('today\'s pages are listed, each opening the Mushaf', (
    tester,
  ) async {
    await _pump(tester, const CycleScreen());

    expect(tester.takeException(), isNull);
    expect(find.text('Réviser mes sourates connues'), findsOneWidget);
    expect(
      find.textContaining('page(s) à réviser aujourd\'hui'),
      findsOneWidget,
    );
    final fatiha = _reference.surahByNumber(1).englishName;
    expect(find.text('Page 1 · $fatiha'), findsOneWidget);
    expect(find.text('Terminer la révision'), findsOneWidget);

    await tester.tap(find.text('Page 1 · $fatiha'));
    await _bounded(tester);
    expect(find.text('mushaf 1'), findsOneWidget);
  });

  testWidgets('finishing needs a self-assessment first', (tester) async {
    await _pump(tester, const CycleScreen());

    final button = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Terminer la révision'),
    );
    expect(button.onPressed, isNull);

    await tester.tap(find.text('Sans erreur'));
    await tester.pump();
    final enabled = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Terminer la révision'),
    );
    expect(enabled.onPressed, isNotNull);
  });

  testWidgets('a share reviewed is recorded and counts as activity', (
    tester,
  ) async {
    final db = await _pump(tester, const CycleScreen());

    await tester.ensureVisible(find.text('Sans erreur'));
    await tester.tap(find.text('Sans erreur'));
    await tester.pump();
    await tester.ensureVisible(find.text('Terminer la révision'));
    await tester.tap(find.text('Terminer la révision'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 300)),
    );
    await _bounded(tester);

    expect(
      find.text(
        "C'est fait pour aujourd'hui, bravo. Ta prochaine part t'attend demain.",
      ),
      findsOneWidget,
    );
    final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
    final log = await MemorizationRepository(db).reviewLog(profile.id);
    expect(log, hasLength(1));
    expect(log.single.kind, 'review');
    expect(log.single.outcome, 'clean');
    final sessions = await MemorizationRepository(db).studySessions(profile.id);
    expect(sessions, hasLength(1));
    expect(sessions.single.kind, 'revision');
  });

  testWidgets('a share to redo stays to do', (tester) async {
    await _pump(tester, const CycleScreen());

    await tester.ensureVisible(find.text('À reprendre'));
    await tester.tap(find.text('À reprendre'));
    await tester.pump();
    await tester.ensureVisible(find.text('Terminer la révision'));
    await tester.tap(find.text('Terminer la révision'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 300)),
    );
    await _bounded(tester);

    // Not done: the same pages are still offered.
    expect(find.text('Terminer la révision'), findsOneWidget);
    expect(find.textContaining('0 page(s) sur'), findsOneWidget);
  });

  testWidgets('the cycle length can be chosen', (tester) async {
    await _pump(tester, const CycleScreen());

    await tester.ensureVisible(find.text('60 jours'));
    await tester.tap(find.text('60 jours'));
    await _bounded(tester);

    final chip = tester.widget<ChoiceChip>(
      find.widgetWithText(ChoiceChip, '60 jours'),
    );
    expect(chip.selected, isTrue);
  });

  testWidgets('the Révision hub offers the cycle to a declared hafiz', (
    tester,
  ) async {
    await _pump(tester, const RevisionHubScreen());

    expect(find.text('Réviser mes sourates connues'), findsOneWidget);
    expect(find.textContaining('page(s) à relire aujourd\'hui'), findsOneWidget);
    // Not the "your reviews will appear here" message: there is something.
    expect(
      find.textContaining('apparaîtront ici dès que tu auras mémorisé'),
      findsNothing,
    );
  });

  testWidgets('with nothing declared the hub keeps its welcome message', (
    tester,
  ) async {
    await _pump(tester, const RevisionHubScreen(), declared: const []);

    expect(find.text('Réviser mes sourates connues'), findsNothing);
    expect(
      find.textContaining('apparaîtront ici dès que tu auras mémorisé'),
      findsOneWidget,
    );
  });
}
