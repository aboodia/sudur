// A Mushaf page whose font was never downloaded cannot be drawn offline: the
// screen says so and offers the text view, which needs no connection.

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/audio/audio_playback_controller.dart';
import 'package:sudur/core/audio/playback_state.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/mushaf/mushaf_font_cache.dart';
import 'package:sudur/core/mushaf/mushaf_repository.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/features/reading/mushaf/mushaf_page_view_screen.dart';
import 'package:sudur/l10n/app_localizations.dart';

late QuranReferenceRepository _reference;
late MushafRepository _mushaf;

class _SilentPlayback extends AudioPlaybackController {
  @override
  ReadingPlaybackState build() => const ReadingPlaybackState();

  @override
  Stream<Duration> get positionStream => const Stream.empty();

  @override
  Stream<Duration?> get durationStream => const Stream.empty();
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _reference = await QuranReferenceRepository.load();
    _mushaf = await MushafRepository.load();
  });

  testWidgets('offline, a page not downloaded offers the text view', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(900, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    String? opened;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const MushafPageViewScreen(initialPage: 582),
        ),
        GoRoute(
          path: '/lecture/sourate/:number',
          builder: (_, state) {
            opened = state.uri.toString();
            return const Scaffold(body: Text('texte'));
          },
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(
            AppDatabase.forTesting(NativeDatabase.memory()),
          ),
          quranReferenceProvider.overrideWith((ref) => _reference),
          mushafRepositoryProvider.overrideWith((ref) => _mushaf),
          // No connection and nothing cached: the font cannot be had.
          mushafPageFontProvider.overrideWith((ref, page) async => null),
          audioPlaybackProvider.overrideWith(_SilentPlayback.new),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(
      find.text('Cette page nécessite une connexion la première fois.'),
      findsOneWidget,
    );
    expect(find.text('Réessayer'), findsOneWidget);
    expect(find.text('Lire en vue texte'), findsOneWidget);

    await tester.tap(find.text('Lire en vue texte'));
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // Page 582 opens An-Naba, the first sourate of Juz 30.
    expect(opened, '/lecture/sourate/78?ayah=1');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 10));
  });
}
