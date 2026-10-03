// The two ways of reading the same verse — Arabic only, or with its
// transliteration or French translation — for people who read Arabic and
// those who do not yet. The text comes from the app's own data, never typed
// here.

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/quran_text/quran_text_models.dart';
import 'package:sudur/core/quran_text/quran_text_repository.dart';
import 'package:sudur/core/settings/reading_settings.dart';
import 'package:sudur/features/reading/widgets/ayah_card.dart';
import 'package:sudur/l10n/app_localizations.dart';

late AyahText _ayah;

Future<void> _pump(WidgetTester tester, ReadingDisplayMode mode) async {
  SharedPreferences.setMockInitialValues({'reading.displayMode': mode.index});
  tester.view.physicalSize = const Size(900, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(
          AppDatabase.forTesting(NativeDatabase.memory()),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: AyahCard(
            surahNumber: 1,
            ayah: _ayah,
            isPlaying: false,
            onTap: () {},
          ),
        ),
      ),
    ),
  );
  // The saved mode is read from disk a moment after the first frame.
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 100)),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 100));
}

/// Takes the screen down and lets the database's stream timers fire, or the
/// test ends with a pending timer.
Future<void> _unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 10));
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final text = await QuranTextRepository.load();
    _ayah = text.surah(1).ayahs[1]; // the second verse: no basmalah quirks
  });

  testWidgets('Arabic only shows the verse and nothing else', (tester) async {
    await _pump(tester, ReadingDisplayMode.arabicOnly);

    expect(find.text(_ayah.arabic), findsOneWidget);
    expect(find.text(_ayah.transliteration), findsNothing);
    expect(find.text(_ayah.french), findsNothing);
    await _unmount(tester);
  });

  testWidgets('transliteration is shown under the verse for those who cannot '
      'read Arabic yet', (tester) async {
    await _pump(tester, ReadingDisplayMode.transliteration);

    expect(find.text(_ayah.arabic), findsOneWidget);
    expect(find.text(_ayah.transliteration), findsOneWidget);
    expect(find.text(_ayah.french), findsNothing);
    await _unmount(tester);
  });

  testWidgets('bilingual adds the French translation', (tester) async {
    await _pump(tester, ReadingDisplayMode.bilingual);

    expect(find.text(_ayah.arabic), findsOneWidget);
    expect(find.text(_ayah.french), findsOneWidget);
    expect(find.text(_ayah.transliteration), findsNothing);
    await _unmount(tester);
  });

  testWidgets('the Arabic is always the first thing shown', (tester) async {
    for (final mode in ReadingDisplayMode.values) {
      await _pump(tester, mode);
      expect(find.text(_ayah.arabic), findsOneWidget, reason: mode.name);
      await _unmount(tester);
    }
  });
}
