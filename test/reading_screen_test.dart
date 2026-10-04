// The Lecture screen: finding a sourate, picking up where the user left off,
// seeing which sourates are already memorized.

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/audio/audio_playback_controller.dart';
import 'package:sudur/core/audio/playback_state.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/mushaf/mushaf_repository.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/features/reading/reading_screen.dart';
import 'package:sudur/l10n/app_localizations.dart';

late QuranReferenceRepository _reference;
late MushafRepository _mushaf;

class _SilentPlayback extends AudioPlaybackController {
  @override
  ReadingPlaybackState build() => const ReadingPlaybackState();
}

Future<void> _bounded(WidgetTester tester) async {
  for (var i = 0; i < 15; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _pump(
  WidgetTester tester, {
  Map<String, Object> prefs = const {},
  List<int> declared = const [],
  List<String>? openedPages,
}) async {
  SharedPreferences.setMockInitialValues(prefs);
  tester.view.physicalSize = const Size(900, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final db = AppDatabase.forTesting(NativeDatabase.memory());
  final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
  for (final n in declared) {
    await MemorizationRepository(db).markSurahMemorized(
      profile.id,
      n,
      _reference.surahByNumber(n).numberOfAyahs,
    );
  }
  final router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => const ReadingScreen()),
      GoRoute(
        path: '/lecture/mushaf',
        builder: (_, state) {
          openedPages?.add(state.uri.toString());
          return const Scaffold(body: Text('mushaf'));
        },
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        quranReferenceProvider.overrideWith((ref) => _reference),
        mushafRepositoryProvider.overrideWith((ref) => _mushaf),
        audioPlaybackProvider.overrideWith(_SilentPlayback.new),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await _bounded(tester);
}

Future<void> _unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 10));
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

  testWidgets('the screen has a title and its three tabs', (tester) async {
    await _pump(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Lecture'), findsOneWidget);
    expect(find.text('Sourates'), findsOneWidget);
    expect(find.text('Juz'), findsOneWidget);
    expect(find.text('Signets'), findsOneWidget);
    await _unmount(tester);
  });

  testWidgets('typing a name narrows the list to it', (tester) async {
    await _pump(tester);
    expect(find.text('Al-Faatiha'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'baqara');
    await tester.pump();

    expect(find.text('Al-Baqara'), findsOneWidget);
    expect(find.text('Al-Faatiha'), findsNothing);
    await _unmount(tester);
  });

  testWidgets('a search with no answer says so', (tester) async {
    await _pump(tester);

    await tester.enterText(find.byType(TextField), 'zzzzqq');
    await tester.pump();

    expect(find.text('Aucune sourate ne correspond.'), findsOneWidget);

    await tester.tap(find.byTooltip('Effacer'));
    await tester.pump();
    expect(find.text('Al-Faatiha'), findsOneWidget);
    await _unmount(tester);
  });

  testWidgets('memorized sourates are marked', (tester) async {
    await _pump(tester, declared: const [1]);

    // Al-Fatiha is memorized; the others on screen are not.
    expect(find.byTooltip('Mémorisée'), findsOneWidget);
    await _unmount(tester);
  });

  testWidgets('without a page read, there is nothing to resume', (
    tester,
  ) async {
    await _pump(tester);

    expect(find.text('Reprendre ta lecture'), findsNothing);
    await _unmount(tester);
  });

  testWidgets('the last page read can be picked up again', (tester) async {
    final opened = <String>[];
    await _pump(tester, prefs: {'reading.lastPage': 2}, openedPages: opened);

    expect(find.text('Reprendre ta lecture'), findsOneWidget);
    expect(find.text('Al-Baqara · page 2'), findsOneWidget);

    await tester.tap(find.text('Reprendre ta lecture'));
    await _bounded(tester);
    expect(opened, ['/lecture/mushaf?page=2']);
    await _unmount(tester);
  });

  testWidgets('the resume card steps aside while searching', (tester) async {
    await _pump(tester, prefs: {'reading.lastPage': 2});
    expect(find.text('Reprendre ta lecture'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'nas');
    await tester.pump();

    expect(find.text('Reprendre ta lecture'), findsNothing);
    await _unmount(tester);
  });

  testWidgets('empty bookmarks explain how to add one', (tester) async {
    await _pump(tester);

    await tester.tap(find.text('Signets'));
    await _bounded(tester);

    expect(find.text('Aucun signet pour le moment'), findsOneWidget);
    expect(find.textContaining('touche l\'icône de signet'), findsOneWidget);
    await _unmount(tester);
  });
}
