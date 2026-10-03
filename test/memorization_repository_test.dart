import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/memorization/review_scheduler.dart';

// Same in-memory-DB pattern as the rest of the test suite — see
// widget_test.dart for why the real (on-disk) appDatabaseProvider isn't
// safe to share across test runs.
ProviderContainer _freshContainer() => ProviderContainer(
  overrides: [
    appDatabaseProvider.overrideWithValue(
      AppDatabase.forTesting(NativeDatabase.memory()),
    ),
  ],
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'a session saved mid-passage is read back identically (reprise)',
    () async {
      final container = _freshContainer();
      addTearDown(container.dispose);
      final profile = await container.read(currentProfileProvider.future);
      final repo = container.read(memorizationRepositoryProvider);

      final started = await repo.startPassage(profile.id, 67, 1, 5);
      expect(
        (await repo.activeSession(profile.id))!.progress.currentStepIndex,
        0,
      );

      await repo.saveProgress(
        passageId: started.passage.id,
        stepIndex: 2,
        currentAyah: 3,
        maskLevel: 'medium',
      );

      // Simulate "closing and reopening the app": a fresh repository instance
      // over the same underlying database.
      final reopened = MemorizationRepository(
        container.read(appDatabaseProvider),
      );
      final resumed = await reopened.activeSession(profile.id);

      expect(resumed, isNotNull);
      expect(resumed!.passage.surahNumber, 67);
      expect(resumed.progress.currentStepIndex, 2);
      expect(resumed.progress.currentAyah, 3);
      expect(resumed.progress.maskLevel, 'medium');
    },
  );

  test('finishing a passage clears it from the active session', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    final profile = await container.read(currentProfileProvider.future);
    final repo = container.read(memorizationRepositoryProvider);

    final started = await repo.startPassage(profile.id, 67, 1, 5);
    await repo.finishPassage(started.passage.id);

    expect(await repo.activeSession(profile.id), isNull);
  });

  test('recordAyahMemorized schedules the first review at J+1 and bumps surah progress once per ayah', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    final profile = await container.read(currentProfileProvider.future);
    final repo = container.read(memorizationRepositoryProvider);

    await repo.recordAyahMemorized(
      profileId: profile.id,
      surahNumber: 67,
      ayahNumber: 1,
      surahTotalAyahs: 30,
      outcome: ReciteOutcome.clean,
      fragileWordIndices: [],
    );
    // Recording the same ayah again (e.g. redoing a step) must not double-count it.
    await repo.recordAyahMemorized(
      profileId: profile.id,
      surahNumber: 67,
      ayahNumber: 1,
      surahTotalAyahs: 30,
      outcome: ReciteOutcome.hesitant,
      fragileWordIndices: [2],
    );
    await repo.recordAyahMemorized(
      profileId: profile.id,
      surahNumber: 67,
      ayahNumber: 2,
      surahTotalAyahs: 30,
      outcome: ReciteOutcome.clean,
      fragileWordIndices: [],
    );

    final keys = await repo.memorizedAyahKeys(profile.id);
    expect(keys, {'67:1', '67:2'});

    final progress = (await repo.allSurahProgress(profile.id)).single;
    expect(progress.surahNumber, 67);
    expect(progress.memorizedAyahCount, 2);
    expect(progress.totalAyahCount, 30);
    expect(progress.completedAt, isNull);
  });

  test('completing every ayah of a sourate marks it completed', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    final profile = await container.read(currentProfileProvider.future);
    final repo = container.read(memorizationRepositoryProvider);

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

    final progress = (await repo.allSurahProgress(profile.id)).single;
    expect(progress.memorizedAyahCount, 3);
    expect(progress.completedAt, isNotNull);
    expect(await repo.completedSurahCount(profile.id), 1);
  });

  test(
    'markSurahMemorized (onboarding) marks a whole sourate complete directly',
    () async {
      final container = _freshContainer();
      addTearDown(container.dispose);
      final profile = await container.read(currentProfileProvider.future);
      final repo = container.read(memorizationRepositoryProvider);

      await repo.markSurahMemorized(profile.id, 1, 7);

      final progress = (await repo.allSurahProgress(profile.id)).single;
      expect(progress.memorizedAyahCount, 7);
      expect(progress.totalAyahCount, 7);
      expect(progress.completedAt, isNotNull);
      expect(await repo.completedSurahCount(profile.id), 1);
    },
  );

  test('dueReviews only returns ayahs whose next review has arrived', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    final profile = await container.read(currentProfileProvider.future);
    final repo = container.read(memorizationRepositoryProvider);

    await repo.recordAyahMemorized(
      profileId: profile.id,
      surahNumber: 67,
      ayahNumber: 1,
      surahTotalAyahs: 30,
      outcome: ReciteOutcome.clean,
      fragileWordIndices: [],
    );

    final tomorrow = DateTime.now().add(const Duration(days: 2));
    expect(await repo.dueReviews(profile.id), isEmpty);
    expect(await repo.dueReviews(profile.id, asOf: tomorrow), hasLength(1));
  });

  test('recordAyahReview advances the cycle using ReviewScheduler', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    final profile = await container.read(currentProfileProvider.future);
    final repo = container.read(memorizationRepositoryProvider);

    await repo.recordAyahMemorized(
      profileId: profile.id,
      surahNumber: 67,
      ayahNumber: 1,
      surahTotalAyahs: 30,
      outcome: ReciteOutcome.clean,
      fragileWordIndices: [],
    );
    final entry = (await repo.dueReviews(
      profile.id,
      asOf: DateTime.now().add(const Duration(days: 2)),
    )).single;
    expect(entry.reviewCycleStep, 0);

    await repo.recordAyahReview(
      ayahProgressId: entry.id,
      outcome: ReciteOutcome.clean,
      hasFragileWords: false,
    );

    final updated = (await repo.dueReviews(
      profile.id,
      asOf: DateTime.now().add(const Duration(days: 40)),
    )).single;
    expect(updated.reviewCycleStep, 1);
    expect(updated.lastOutcome, 'clean');
  });

  test(
    'sourates declared when joining count as memorized, verse by verse',
    () async {
      final container = _freshContainer();
      addTearDown(container.dispose);
      final profile = await container.read(currentProfileProvider.future);
      final repo = container.read(memorizationRepositoryProvider);

      // Al-Fatiha (7 verses) declared, Al-Mulk's first verse learned.
      await repo.markSurahMemorized(profile.id, 1, 7);
      await repo.recordAyahMemorized(
        profileId: profile.id,
        surahNumber: 67,
        ayahNumber: 1,
        surahTotalAyahs: 30,
        outcome: ReciteOutcome.clean,
        fragileWordIndices: [],
      );

      final keys = await repo.memorizedAyahKeys(profile.id);

      expect(keys, {for (var a = 1; a <= 7; a++) '1:$a', '67:1'});
    },
  );

  test('a sourate only partly learned is not counted as declared', () async {
    final container = _freshContainer();
    addTearDown(container.dispose);
    final profile = await container.read(currentProfileProvider.future);
    final repo = container.read(memorizationRepositoryProvider);
    await repo.recordAyahMemorized(
      profileId: profile.id,
      surahNumber: 67,
      ayahNumber: 1,
      surahTotalAyahs: 30,
      outcome: ReciteOutcome.clean,
      fragileWordIndices: [],
    );

    expect(await repo.memorizedAyahKeys(profile.id), {'67:1'});
  });
}
