// Smoke test for Brique 0/2: the app boots straight into Onboarding on a
// fresh profile, and completing it reveals the bottom navigation skeleton
// (5 grands onglets).
//
// Each test gets its own in-memory AppDatabase override — the real
// appDatabaseProvider persists to an on-disk file (driftDatabase(name:
// 'sudur')) that survives across separate `flutter test` runs, which would
// make "fresh profile" assertions depend on whatever a previous run last
// wrote (e.g. hasCompletedOnboarding already true).

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sudur/app/app.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';

void main() {
  // Loaded once, outside the widget tests: an asset load cached by an
  // earlier test never completes again in a later test's fake-async zone.
  late QuranReferenceRepository reference;
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    reference = await QuranReferenceRepository.load();
  });

  testWidgets('a fresh profile boots straight into Onboarding', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quranReferenceProvider.overrideWith((ref) => reference),
          appDatabaseProvider.overrideWithValue(
            AppDatabase.forTesting(NativeDatabase.memory()),
          ),
        ],
        child: const SudurApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bienvenue sur Sudur'), findsOneWidget);
    expect(find.text('Accueil'), findsNothing);
  });

  testWidgets('completing Onboarding reveals the 4 navigation tabs', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quranReferenceProvider.overrideWith((ref) => reference),
          appDatabaseProvider.overrideWithValue(
            AppDatabase.forTesting(NativeDatabase.memory()),
          ),
        ],
        child: const SudurApp(),
      ),
    );
    await tester.pumpAndSettle();

    // Bienvenue -> Sourates -> Profil dérivé -> Disponibilités -> Plan : 4
    // "Suivant", puis "Terminer" sans rien cocher (profil débutant).
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Terminer'));
    await tester.pumpAndSettle();

    expect(find.text('Accueil'), findsWidgets);
    expect(find.text('Lecture'), findsWidgets);
    expect(find.text('Chemin'), findsWidgets);
    // La Communauté (Brique 8) est volontairement retirée pour l'instant.
    expect(find.text('Communauté'), findsNothing);
    expect(find.text('Profil'), findsWidgets);
  });

  testWidgets('reloading the profile does not tear the app down', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quranReferenceProvider.overrideWith((ref) => reference),
          appDatabaseProvider.overrideWithValue(
            AppDatabase.forTesting(NativeDatabase.memory()),
          ),
        ],
        child: const SudurApp(),
      ),
    );
    await tester.pumpAndSettle();
    for (var i = 0; i < 4; i++) {
      await tester.tap(find.text('Suivant'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.text('Terminer'));
    // Bounded pumps: from the second widget test on, the Accueil's
    // loading indicators never settle (cached asset loads).
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(find.text('Accueil'), findsWidgets);

    // Changing a setting stored on the profile reloads it. That must not
    // send the app through its loading screen and rebuild everything.
    final container = ProviderScope.containerOf(
      tester.element(find.byType(SudurApp)),
    );
    container.invalidate(currentProfileProvider);
    await tester.pump();

    expect(find.text('Accueil'), findsWidgets);
    expect(find.text('Profil'), findsWidgets);
  });
}
