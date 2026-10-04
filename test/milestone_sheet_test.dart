// The sheet of a completed sourate tells when it was finished only if it was
// learned here — not if it was declared when joining.

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/memorization/review_scheduler.dart';
import 'package:sudur/core/path/milestones.dart';
import 'package:sudur/core/path/surah_stories.dart';
import 'package:sudur/core/quran_reference/quran_reference_repository.dart';
import 'package:sudur/features/path/widgets/milestone_sheet.dart';
import 'package:sudur/l10n/app_localizations.dart';

late QuranReferenceRepository _reference;

Future<void> _openSheet(
  WidgetTester tester, {
  required AppDatabase db,
  required Milestone milestone,
}) async {
  tester.view.physicalSize = const Size(900, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, _) => Scaffold(
          body: Center(
            child: ElevatedButton(
              onPressed: () => showMilestoneSheet(context, milestone),
              child: const Text('ouvrir'),
            ),
          ),
        ),
      ),
    ],
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        quranReferenceProvider.overrideWith((ref) => _reference),
        surahStoriesProvider.overrideWith((ref) => const {}),
      ],
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.tap(find.text('ouvrir'));
  for (var i = 0; i < 15; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _unmount(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pump(const Duration(milliseconds: 10));
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    _reference = await QuranReferenceRepository.load();
  });

  Milestone completed(int surah, DateTime at) => Milestone(
    surahNumber: surah,
    state: MilestoneState.completed,
    memorizedAyahs: _reference.surahByNumber(surah).numberOfAyahs,
    totalAyahs: _reference.surahByNumber(surah).numberOfAyahs,
    completedAt: at,
  );

  testWidgets('a sourate learned here shows the day it was finished', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
    final repo = MemorizationRepository(db);
    // Al-Kawthar, 3 verses, each learned in the parcours.
    for (var ayah = 1; ayah <= 3; ayah++) {
      await repo.recordAyahMemorized(
        profileId: profile.id,
        surahNumber: 108,
        ayahNumber: ayah,
        surahTotalAyahs: 3,
        outcome: ReciteOutcome.clean,
        fragileWordIndices: [],
      );
    }

    await _openSheet(
      tester,
      db: db,
      milestone: completed(108, DateTime(2026, 9, 29)),
    );

    expect(find.text('Achevée le 29 septembre 2026'), findsOneWidget);
    await _unmount(tester);
  });

  testWidgets('a declared sourate never claims a completion day', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final profile = await UserProfileRepository(db).getOrCreateLocalProfile();
    final repo = MemorizationRepository(db);
    // Al-Fatiha declared when joining, then five of its verses learned
    // again by mistake: it was still not learned here.
    await repo.markSurahMemorized(profile.id, 1, 7);
    for (var ayah = 1; ayah <= 5; ayah++) {
      await repo.recordAyahMemorized(
        profileId: profile.id,
        surahNumber: 1,
        ayahNumber: ayah,
        surahTotalAyahs: 7,
        outcome: ReciteOutcome.clean,
        fragileWordIndices: [],
      );
    }

    await _openSheet(
      tester,
      db: db,
      milestone: completed(1, DateTime(2026, 10, 3)),
    );

    expect(
      find.text("Déjà mémorisée avant ton arrivée dans l'application."),
      findsOneWidget,
    );
    expect(find.textContaining('Achevée le'), findsNothing);
    await _unmount(tester);
  });
}
