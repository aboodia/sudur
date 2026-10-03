// The three kinds of user the app is built for — someone starting out, someone
// partway through, a hafiz — each landing on a coherent Accueil, Chemin and
// Révision. Assets are loaded once outside testWidgets and injected.

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/mushaf/mushaf_repository.dart';
import 'package:sudur/core/path/surah_stories.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/core/stats/progress_history_provider.dart';
import 'package:sudur/features/home/home_screen.dart';
import 'package:sudur/features/path/path_screen.dart';
import 'package:sudur/features/revision/screens/revision_hub_screen.dart';
import 'package:sudur/l10n/app_localizations.dart';

late QuranReferenceRepository _reference;
late MushafRepository _mushaf;

Future<void> _bounded(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// A user who declared [declared] sourates when they joined.
Future<void> _pump(
  WidgetTester tester,
  Widget screen, {
  required List<int> declared,
}) async {
  SharedPreferences.setMockInitialValues({});
  tester.view.physicalSize = const Size(900, 4000);
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
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        quranReferenceProvider.overrideWith((ref) => _reference),
        mushafRepositoryProvider.overrideWith((ref) => _mushaf),
        surahStoriesProvider.overrideWith((ref) => const {}),
        mushafCoverageProvider.overrideWith(
          (ref) async => List.filled(604, 0.0),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: screen,
      ),
    ),
  );
  await _bounded(tester);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _reference = await QuranReferenceRepository.load();
    _mushaf = await MushafRepository.load();
    final loader = FontLoader('Roboto')
      ..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'));
    await loader.load();
  });

  group('someone starting out', () {
    testWidgets('is offered the first sourate and nothing to review', (
      tester,
    ) async {
      await _pump(tester, const HomeScreen(), declared: const []);

      expect(tester.takeException(), isNull);
      expect(find.text('Commencer la session'), findsOneWidget);
      expect(
        find.text(_reference.surahByNumber(1).englishName),
        findsOneWidget,
      );
      expect(find.text('Révision du Coran'), findsNothing);
      expect(find.text('Rien à réviser aujourd\'hui.'), findsOneWidget);
    });

    testWidgets('sees the Chemin start at the first milestone', (tester) async {
      await _pump(tester, const PathScreen(), declared: const []);

      expect(tester.takeException(), isNull);
      expect(find.text('0 sourate(s) sur 114'), findsOneWidget);
    });
  });

  group('someone partway through', () {
    const declared = [1, 2, 3, 4, 5];

    testWidgets('continues with the next sourate and reviews what they know', (
      tester,
    ) async {
      await _pump(tester, const HomeScreen(), declared: declared);

      expect(tester.takeException(), isNull);
      expect(
        find.text(_reference.surahByNumber(6).englishName),
        findsOneWidget,
        reason: 'the session picks up after the declared sourates',
      );
      expect(find.text('Révision du Coran'), findsOneWidget);
    });

    testWidgets('has the Révision hub offer the cycle', (tester) async {
      await _pump(tester, const RevisionHubScreen(), declared: declared);

      expect(tester.takeException(), isNull);
      expect(find.text('Révision du Coran'), findsOneWidget);
    });

    testWidgets('sees their sourates as done on the Chemin', (tester) async {
      await _pump(tester, const PathScreen(), declared: declared);

      expect(find.text('5 sourate(s) sur 114'), findsOneWidget);
    });
  });

  group('a hafiz', () {
    final all = [for (var n = 1; n <= 114; n++) n];

    testWidgets('is congratulated and still has revision to do', (
      tester,
    ) async {
      await _pump(tester, const HomeScreen(), declared: all);

      expect(tester.takeException(), isNull);
      expect(
        find.text('Mabrouk, tout le Coran est déjà mémorisé !'),
        findsOneWidget,
      );
      expect(find.text('Commencer la session'), findsNothing);
      // The whole Quran to keep up: a cycle across all its pages.
      expect(find.text('Révision du Coran'), findsOneWidget);
    });

    testWidgets('sees the whole Chemin walked', (tester) async {
      await _pump(tester, const PathScreen(), declared: all);

      expect(tester.takeException(), isNull);
      expect(find.text('114 sourate(s) sur 114'), findsOneWidget);
      expect(
        find.text('Tout le chemin est parcouru, mabrouk !'),
        findsOneWidget,
      );
    });

    testWidgets('has a share of pages to review each day', (tester) async {
      await _pump(tester, const RevisionHubScreen(), declared: all);

      expect(tester.takeException(), isNull);
      // 604 pages over the default 30 days is about 21 a day.
      expect(find.textContaining('page(s) aujourd\'hui'), findsOneWidget);
    });
  });
}
