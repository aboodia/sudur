import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/mushaf/mushaf_repository.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/features/onboarding/onboarding_draft.dart';
import 'package:sudur/features/onboarding/onboarding_flow.dart';
import 'package:sudur/l10n/app_localizations.dart';

late QuranReferenceRepository _reference;
late MushafRepository _mushaf;

class _DraftWith extends OnboardingDraftController {
  _DraftWith(this.surahs);

  final Set<int> surahs;

  @override
  OnboardingDraft build() => OnboardingDraft(memorizedSurahs: surahs);
}

Future<AppDatabase> _pump(WidgetTester tester, Set<int> surahs) async {
  SharedPreferences.setMockInitialValues({});
  tester.view.physicalSize = const Size(900, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        quranReferenceProvider.overrideWith((ref) => _reference),
        mushafRepositoryProvider.overrideWith((ref) => _mushaf),
        onboardingDraftProvider.overrideWith(() => _DraftWith(surahs)),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: OnboardingFlow(),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 300));
  return db;
}

Future<void> _next(WidgetTester tester) async {
  await tester.tap(find.text('Suivant'));
  for (var i = 0; i < 10; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
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

  testWidgets('with sourates already known, the Wird goal is asked', (
    tester,
  ) async {
    await _pump(tester, {1, 2});

    // Bienvenue -> Sourates -> Profil dérivé -> Ton Wird
    await _next(tester);
    await _next(tester);
    await _next(tester);

    expect(tester.takeException(), isNull);
    expect(find.text('Ton Wird'), findsOneWidget);
    // About a month for the 49 pages of Al-Fatiha and Al-Baqara.
    expect(find.text('2 page(s) par jour'), findsOneWidget);

    await tester.tap(find.text('Juz'));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('1 Juz par jour'), findsOneWidget);
  });

  testWidgets('with nothing known yet, there is no Wird step', (tester) async {
    await _pump(tester, const {});

    await _next(tester);
    await _next(tester);
    await _next(tester);

    expect(find.text('Ton Wird'), findsNothing);
    expect(
      find.text('Quels jours pouvez-vous vous consacrer à Sudur ?'),
      findsOneWidget,
    );
  });

  testWidgets('the chosen goal is saved when the Onboarding ends', (
    tester,
  ) async {
    final db = await _pump(tester, {1, 2});
    await _next(tester);
    await _next(tester);
    await _next(tester);
    await tester.tap(find.text('Juz'));
    await tester.pump(const Duration(milliseconds: 200));
    await _next(tester); // Disponibilités
    await _next(tester); // Plan

    await tester.tap(find.text('Terminer'));
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 500)),
    );
    await tester.pump(const Duration(milliseconds: 200));

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('wird.unit'), 'juz');
    expect(prefs.getInt('wird.amount'), 1);
    final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
    expect(profile.hasCompletedOnboarding, isTrue);
  });
}
