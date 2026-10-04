// Accessibility guards: every icon-only button is announced by screen
// readers, and the main screens still lay out with the text enlarged to the
// maximum the phone's settings allow.

import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/audio/audio_playback_controller.dart';
import 'package:sudur/core/audio/playback_state.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/path/surah_stories.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/core/stats/progress_history_provider.dart';
import 'package:sudur/features/gamification/success_screen.dart';
import 'package:sudur/features/home/home_screen.dart';
import 'package:sudur/features/memorization/memorization_flow_screen.dart';
import 'package:sudur/features/onboarding/onboarding_flow.dart';
import 'package:sudur/core/quran_text/quran_text_repository.dart';
import 'package:sudur/features/revision/screens/revision_hub_screen.dart';
import 'package:sudur/features/path/path_screen.dart';
import 'package:sudur/features/profile/profile_screen.dart';
import 'package:sudur/l10n/app_localizations.dart';

late QuranReferenceRepository _reference;
late QuranTextRepository _text;

/// A player that plays nothing (no audio plugin in tests).
class _SilentPlayback extends AudioPlaybackController {
  @override
  ReadingPlaybackState build() => const ReadingPlaybackState();

  @override
  Stream<Duration> get positionStream => const Stream.empty();

  @override
  Stream<Duration?> get durationStream => const Stream.empty();

  @override
  Future<void> select(int surahNumber, int ayahNumber) async {}

  @override
  Future<void> resume() async {}

  @override
  Future<void> pause() async {}

  @override
  Future<void> stop() async {}

  @override
  Future<void> playFrom(int surahNumber, int ayahNumber) async {}
}

/// The source of every `IconButton(...)` call in lib/ that has neither a
/// tooltip nor a Semantics wrapper.
List<String> _unlabelledIconButtons() {
  final found = <String>[];
  final call = RegExp(r'IconButton(?:\.\w+)?\(');
  for (final entity in Directory('lib').listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;
    if (entity.path.contains('l10n')) continue;
    final source = entity.readAsStringSync();
    for (final match in call.allMatches(source)) {
      var depth = 1;
      var i = match.end;
      while (depth > 0 && i < source.length) {
        if (source[i] == '(') depth++;
        if (source[i] == ')') depth--;
        i++;
      }
      final body = source.substring(match.start, i);
      if (!body.contains('tooltip') && !body.contains('Semantics')) {
        final line =
            '\n'.allMatches(source.substring(0, match.start)).length + 1;
        found.add('${entity.path}:$line');
      }
    }
  }
  return found;
}

Future<void> _bounded(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _pump(
  WidgetTester tester,
  Widget screen, {
  required AppDatabase db,
  double textScale = 2.0,
}) async {
  SharedPreferences.setMockInitialValues({});
  // A small phone: 360 x 640 dp.
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        quranReferenceProvider.overrideWith((ref) => _reference),
        surahStoriesProvider.overrideWith((ref) => const {}),
        quranTextProvider.overrideWith((ref) => _text),
        audioPlaybackProvider.overrideWith(_SilentPlayback.new),
        mushafCoverageProvider.overrideWith(
          (ref) async => List.filled(604, 0.0),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        home: screen,
      ),
    ),
  );
  await _bounded(tester);
}

Future<AppDatabase> _db({List<int> declared = const [1, 2]}) async {
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
  return db;
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // The test environment draws text in "Ahem", where every letter is a
    // full square: far wider than a real font, so layouts would overflow
    // that never do on a phone. Inter (bundled with the app) stands in for
    // the default font, with realistic letter widths.
    final loader = FontLoader('Roboto')
      ..addFont(rootBundle.load('assets/fonts/Inter-Variable.ttf'));
    await loader.load();
    _reference = await QuranReferenceRepository.load();
    _text = await QuranTextRepository.load();
  });

  test('every icon-only button has a tooltip for screen readers', () {
    expect(_unlabelledIconButtons(), isEmpty);
  });

  group('with the text enlarged to 200 %', () {
    testWidgets('Profil et réglages', (tester) async {
      await _pump(tester, const ProfileScreen(), db: await _db());
      expect(tester.takeException(), isNull);
      expect(find.text('Profil et réglages'), findsOneWidget);
    });

    testWidgets('Régularité et succès', (tester) async {
      await _pump(tester, const SuccessScreen(), db: await _db());
      expect(tester.takeException(), isNull);
      expect(find.text('Régularité et succès'), findsOneWidget);
    });

    testWidgets('Le Chemin', (tester) async {
      await _pump(tester, const PathScreen(), db: await _db());
      expect(tester.takeException(), isNull);
      expect(find.text('Le Chemin'), findsOneWidget);
    });

    testWidgets('Le Chemin, onglet Suivi', (tester) async {
      await _pump(tester, const PathScreen(), db: await _db());
      await tester.tap(find.text('Suivi'));
      await _bounded(tester);
      expect(tester.takeException(), isNull);
      expect(find.text('Objectifs'), findsOneWidget);
    });

    testWidgets('Accueil', (tester) async {
      await _pump(tester, const HomeScreen(), db: await _db());
      expect(tester.takeException(), isNull);
    });

    testWidgets('Révision', (tester) async {
      await _pump(tester, const RevisionHubScreen(), db: await _db());
      expect(tester.takeException(), isNull);
    });

    testWidgets('every step of the Onboarding', (tester) async {
      await _pump(tester, const OnboardingFlow(), db: await _db(declared: []));
      expect(tester.takeException(), isNull);
      for (var i = 0; i < 4; i++) {
        await tester.ensureVisible(find.text('Suivant'));
        await tester.tap(find.text('Suivant'));
        await _bounded(tester);
        expect(tester.takeException(), isNull, reason: 'step ${i + 2}');
      }
    });

    testWidgets('every step of a memorization session', (tester) async {
      // Al-Fatiha known: the session starts on Al-Baqara 2:1-5, whose first
      // verse is a single word.
      await _pump(
        tester,
        const MemorizationFlowScreen(),
        db: await _db(declared: const [1]),
      );
      expect(tester.takeException(), isNull);

      // Go through the five steps by pressing the main button of each.
      final seen = <String>{};
      var sawShortVerse = false;
      for (var i = 0; i < 14; i++) {
        final steps = find.textContaining(RegExp(r'Étape \d sur 5'));
        if (steps.evaluate().isNotEmpty) {
          seen.add((tester.widget<Text>(steps.first)).data ?? '');
        }
        // Al-Baqara 2:1 is a single word: nothing to hide in Masquer.
        if (find
            .textContaining('trop court pour être masqué')
            .evaluate()
            .isNotEmpty) {
          sawShortVerse = true;
        }
        final buttons = find.byType(FilledButton);
        if (buttons.evaluate().isEmpty) break;
        await tester.ensureVisible(buttons.first);
        await tester.tap(buttons.first, warnIfMissed: false);
        await _bounded(tester);
        expect(tester.takeException(), isNull, reason: 'after press ${i + 1}');
      }
      expect(seen.length, greaterThanOrEqualTo(4), reason: 'steps reached');
      expect(sawShortVerse, isTrue, reason: 'a one-word verse is not masked');
    });
  });
}
