// The Wird opens the Mushaf through the app's real router: a page tapped in
// the Wird must open, not crash the navigator.

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/app/router.dart';
import 'package:sudur/app/theme.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/mushaf/mushaf_repository.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/core/quran_text/quran_text_repository.dart';
import 'package:sudur/core/settings/theme_settings.dart';
import 'package:sudur/l10n/app_localizations.dart';

void main() {
  late QuranReferenceRepository reference;
  late QuranTextRepository text;
  late MushafRepository mushaf;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    reference = await QuranReferenceRepository.load();
    text = await QuranTextRepository.load();
    mushaf = await MushafRepository.load();
  });

  testWidgets('a page tapped in the Wird opens the Mushaf, and comes back', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(900, 3000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
    await MemorizationRepository(db).markSurahMemorized(
      profile.id,
      1,
      reference.surahByNumber(1).numberOfAyahs,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          quranReferenceProvider.overrideWith((ref) => reference),
          quranTextProvider.overrideWith((ref) => text),
          mushafRepositoryProvider.overrideWith((ref) => mushaf),
        ],
        child: MaterialApp.router(
          routerConfig: appRouter,
          theme: SudurTheme.light(SudurThemeVariant.sudur),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    appRouter.push('/wird');
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    final fatiha = reference.surahByNumber(1).englishName;
    expect(find.text('Page 1 · $fatiha'), findsOneWidget);

    await tester.tap(find.text('Page 1 · $fatiha'));
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    expect(tester.takeException(), isNull);
    expect(find.text('Page 1 · $fatiha'), findsNothing);

    appRouter.pop();
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(tester.takeException(), isNull);
    expect(find.text('Mon Wird'), findsWidgets);
  });
}
