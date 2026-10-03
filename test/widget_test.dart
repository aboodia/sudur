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

void main() {
  testWidgets('a fresh profile boots straight into Onboarding', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
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
}
