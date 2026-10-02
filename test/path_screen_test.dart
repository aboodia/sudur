// Widget tests for Le Chemin. Assets are loaded once outside testWidgets (a
// cached asset load does not complete again in a later test's fake-async
// zone) and injected; the database is filled directly before the scope.

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/path/surah_stories.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/features/path/path_screen.dart';
import 'package:sudur/l10n/app_localizations.dart';

late QuranReferenceRepository _reference;

Future<AppDatabase> _dbWithDeclared(List<int> declaredSurahs) async {
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
  final repo = MemorizationRepository(db);
  for (final n in declaredSurahs) {
    await repo.markSurahMemorized(
      profile.id,
      n,
      _reference.surahByNumber(n).numberOfAyahs,
    );
  }
  return db;
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 100; i++) {
    await tester.pump(const Duration(milliseconds: 100));
    if (i >= 3 && find.byType(CircularProgressIndicator).evaluate().isEmpty) {
      break;
    }
  }
  await tester.pump(const Duration(milliseconds: 100));
}

Future<void> _pump(WidgetTester tester, AppDatabase db) async {
  tester.view.physicalSize = const Size(900, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    initialLocation: '/chemin',
    routes: [GoRoute(path: '/chemin', builder: (_, _) => const PathScreen())],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        quranReferenceProvider.overrideWith((ref) => _reference),
        surahStoriesProvider.overrideWith((ref) => const {}),
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

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _reference = await QuranReferenceRepository.load();
  });

  testWidgets('a new user starts on the first sourate', (tester) async {
    await _pump(tester, await _dbWithDeclared(const []));

    expect(tester.takeException(), isNull);
    expect(find.text('Le Chemin'), findsOneWidget);
    expect(find.text('0 sourate(s) sur 114'), findsOneWidget);
    final first = _reference.surahByNumber(1).englishName;
    expect(find.text('Prochaine étape : $first'), findsOneWidget);
    expect(find.text('Continuer'), findsOneWidget);
  });

  testWidgets('completed sourates are counted and the next one is current', (
    tester,
  ) async {
    await _pump(tester, await _dbWithDeclared(const [1, 2]));

    expect(find.text('2 sourate(s) sur 114'), findsOneWidget);
    final third = _reference.surahByNumber(3).englishName;
    expect(find.text('Prochaine étape : $third'), findsOneWidget);
    // The list opens on the milestone before the current one: a completed
    // sourate above, the current one, and sourates still ahead below.
    expect(find.textContaining('Achevée ·'), findsWidgets);
    expect(find.textContaining('En cours ·'), findsOneWidget);
    expect(find.textContaining('À venir ·'), findsWidgets);
  });

  testWidgets('a completed milestone opens its unlocked story', (tester) async {
    await _pump(tester, await _dbWithDeclared(const [1, 2]));

    final second = _reference.surahByNumber(2);
    // The name also appears in the tile; the first match is the tile.
    await tester.tap(find.text(second.englishName).first);
    await _settle(tester);

    expect(find.text('Histoire débloquée'.toUpperCase()), findsOneWidget);
    // No validated story is shipped yet: it says so, it invents nothing.
    expect(
      find.text(
        'Le récit de cette sourate sera ajouté une fois son contenu validé.',
      ),
      findsOneWidget,
    );
    // Declared in the onboarding: no per-verse history, no fake date.
    expect(
      find.text('Déjà mémorisée avant ton arrivée dans l\'application.'),
      findsOneWidget,
    );
    expect(find.text('Lire la sourate'), findsOneWidget);
  });

  testWidgets('the current milestone offers to continue memorizing', (
    tester,
  ) async {
    await _pump(tester, await _dbWithDeclared(const [1]));

    final second = _reference.surahByNumber(2);
    await tester.tap(find.text(second.englishName).first);
    await _settle(tester);

    expect(find.text('0 / ${second.numberOfAyahs} versets'), findsWidgets);
    expect(find.text('Continuer la mémorisation'), findsOneWidget);
  });

  testWidgets('a locked milestone says it is still ahead', (tester) async {
    await _pump(tester, await _dbWithDeclared(const [1]));

    final fourth = _reference.surahByNumber(4);
    await tester.tap(find.text(fourth.englishName).first);
    await _settle(tester);

    expect(
      find.text(
        'Elle s\'ouvrira sur ton chemin après les sourates qui la précèdent.',
      ),
      findsOneWidget,
    );
    expect(find.text('Continuer la mémorisation'), findsNothing);
  });

  testWidgets('with every sourate done there is nothing left to continue', (
    tester,
  ) async {
    await _pump(
      tester,
      await _dbWithDeclared([for (var n = 1; n <= 114; n++) n]),
    );

    expect(find.text('114 sourate(s) sur 114'), findsOneWidget);
    expect(find.text('Tout le chemin est parcouru, mabrouk !'), findsOneWidget);
    expect(find.text('Continuer'), findsNothing);
  });
}
