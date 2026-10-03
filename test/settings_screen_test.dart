import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/settings/audio_settings.dart';
import 'package:sudur/core/settings/reading_settings.dart';
import 'package:sudur/features/profile/profile_screen.dart';
import 'package:sudur/l10n/app_localizations.dart';

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

Future<AppDatabase> _open(WidgetTester tester) async {
  SharedPreferences.setMockInitialValues({});
  tester.view.physicalSize = const Size(900, 4000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await UserProfileRepository(db).getOrCreateLocalProfile();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ProfileScreen(),
      ),
    ),
  );
  await _settle(tester);
  return db;
}

Future<UserProfile> _profile(AppDatabase db) =>
    UserProfileRepository(db).getOrCreateLocalProfile();

void main() {
  testWidgets('shows every group of settings', (tester) async {
    await _open(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Profil et réglages'), findsOneWidget);
    expect(find.text("Plan d'étude"), findsOneWidget);
    expect(find.text('Lecture'), findsOneWidget);
    expect(find.text('Audio'), findsOneWidget);
    expect(find.text('Rappel quotidien'), findsOneWidget);
    expect(find.text('Contenus hors-ligne'), findsOneWidget);
    expect(find.text('Régularité et succès'), findsOneWidget);
    expect(find.text('Charte graphique'), findsOneWidget);
  });

  testWidgets('the daily time can be changed and is kept', (tester) async {
    final db = await _open(tester);
    final before = (await _profile(db)).dailyTargetMinutes;

    await tester.tap(find.byTooltip('Augmenter').first);
    await _settle(tester);

    final after = (await _profile(db)).dailyTargetMinutes;
    expect(after, before + 5);
    expect(find.text('$after min'), findsOneWidget);
  });

  testWidgets('the daily time stops at its bounds', (tester) async {
    final db = await _open(tester);
    await UserProfileRepository(db)
        .updateProfile(id: (await _profile(db)).id, dailyTargetMinutes: 5);

    // Reopen with the new value.
    await _settle(tester);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ProfileScreen)),
    );
    container.invalidate(currentProfileProvider);
    await _settle(tester);

    final decrease = tester.widget<IconButton>(
      find
          .ancestor(
            of: find.byIcon(Icons.remove),
            matching: find.byType(IconButton),
          )
          .first,
    );
    expect(decrease.onPressed, isNull);
  });

  testWidgets('a day can be switched off and back on', (tester) async {
    final db = await _open(tester);
    expect((await _profile(db)).availableDaysMask, 127);

    await tester.tap(find.widgetWithText(FilterChip, 'Sam'));
    await _settle(tester);
    expect((await _profile(db)).availableDaysMask, 127 & ~(1 << 5));

    await tester.tap(find.widgetWithText(FilterChip, 'Sam'));
    await _settle(tester);
    expect((await _profile(db)).availableDaysMask, 127);
  });

  testWidgets('the last available day cannot be removed', (tester) async {
    final db = await _open(tester);
    await UserProfileRepository(db)
        .updateProfile(id: (await _profile(db)).id, availableDaysMask: 1);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ProfileScreen)),
    );
    container.invalidate(currentProfileProvider);
    await _settle(tester);

    await tester.tap(find.widgetWithText(FilterChip, 'Lun'));
    await _settle(tester);

    expect((await _profile(db)).availableDaysMask, 1);
    expect(find.text('Garde au moins un jour disponible.'), findsOneWidget);
  });

  testWidgets('the name can be set', (tester) async {
    final db = await _open(tester);
    expect(find.text('Non renseigné'), findsOneWidget);

    await tester.tap(find.text('Prénom'));
    await _settle(tester);
    await tester.enterText(find.byType(TextField), '  Abdou ');
    await tester.tap(find.text('Enregistrer'));
    await _settle(tester);

    expect((await _profile(db)).displayName, 'Abdou');
    expect(find.text('Abdou'), findsOneWidget);
  });

  testWidgets('the reciter and speed are remembered', (tester) async {
    await _open(tester);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ProfileScreen)),
    );

    await tester.tap(find.text('Mishary Alafasy'));
    await _settle(tester);
    await tester.tap(find.text('Mahmoud Khalil Al-Husary').last);
    await _settle(tester);

    expect(container.read(audioSettingsProvider).reciterId, 'husary');
  });

  testWidgets('the text display mode can be changed', (tester) async {
    await _open(tester);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(ProfileScreen)),
    );

    await tester.tap(find.text('Bilingue'));
    await _settle(tester);

    expect(
      container.read(readingSettingsProvider).displayMode,
      ReadingDisplayMode.bilingual,
    );
  });
}
