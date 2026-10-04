import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/memorization/review_scheduler.dart';
import 'package:sudur/core/stats/progress_history_provider.dart';
import 'package:sudur/core/wird/wird_providers.dart';
import 'package:sudur/core/wird/wird_state.dart';

import 'helpers/revision_seed.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('a declared sourate is in the Wird from the start', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final profile = await c.read(currentProfileProvider.future);
    // Al-Fatiha has 7 verses.
    await c
        .read(memorizationRepositoryProvider)
        .markSurahMemorized(profile.id, 1, 7);

    expect(await c.read(wirdSurahsProvider.future), {1});
    expect(await c.read(revisionEntriesProvider.future), isEmpty);
    final declared = await c.read(declaredAyahsProvider.future);
    expect(declared, hasLength(7));
  });

  test('a sourate being learned stays in Révision', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    await seedAyah(
      c,
      surah: 108,
      ayah: 1,
      due: DateTime.now().add(const Duration(days: 1)),
    );

    expect(await c.read(wirdSurahsProvider.future), isEmpty);
    expect(await c.read(revisionEntriesProvider.future), hasLength(1));
  });

  test('a completed sourate leaves Révision once its reviews held', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final profile = await c.read(currentProfileProvider.future);
    final repo = c.read(memorizationRepositoryProvider);
    // Al-Kawthar has 3 verses: each is learned, then reviewed four times
    // (J+1, J+3, J+7, J+30) without a slip.
    for (var a = 1; a <= 3; a++) {
      await repo.recordAyahMemorized(
        profileId: profile.id,
        surahNumber: 108,
        ayahNumber: a,
        surahTotalAyahs: 3,
        outcome: ReciteOutcome.clean,
        fragileWordIndices: const [],
      );
    }
    refreshProgressData(c.invalidate);
    expect(await c.read(wirdSurahsProvider.future), isEmpty);

    for (var round = 0; round < 4; round++) {
      for (final e in await repo.allAyahProgress(profile.id)) {
        await repo.recordAyahReview(
          ayahProgressId: e.id,
          outcome: ReciteOutcome.clean,
          hasFragileWords: false,
        );
      }
      refreshProgressData(c.invalidate);
      // Not fixed until the last of them.
      if (round < 3) expect(await c.read(wirdSurahsProvider.future), isEmpty);
    }

    expect(await c.read(wirdSurahsProvider.future), {108});
    expect(await c.read(revisionEntriesProvider.future), isEmpty);
    expect(await c.read(dueRevisionProvider.future), isEmpty);
  });

  test('a slip in a review keeps the sourate in Révision', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final profile = await c.read(currentProfileProvider.future);
    final repo = c.read(memorizationRepositoryProvider);
    await repo.recordAyahMemorized(
      profileId: profile.id,
      surahNumber: 112,
      ayahNumber: 1,
      surahTotalAyahs: 1,
      outcome: ReciteOutcome.clean,
      fragileWordIndices: const [],
    );
    final entry = (await repo.allAyahProgress(profile.id)).single;
    for (final outcome in [
      ReciteOutcome.clean,
      ReciteOutcome.clean,
      ReciteOutcome.clean,
      ReciteOutcome.hesitant,
    ]) {
      await repo.recordAyahReview(
        ayahProgressId: entry.id,
        outcome: outcome,
        hasFragileWords: false,
      );
    }
    refreshProgressData(c.invalidate);

    expect(await c.read(wirdSurahsProvider.future), isEmpty);
  });

  test('without sourate in the Wird there is no share to read', () async {
    final c = freshContainer();
    addTearDown(c.dispose);

    expect(await c.read(wirdPoolProvider.future), isEmpty);
    expect(await c.read(wirdTodayProvider.future), isNull);
  });

  test('a goal set right away is not lost to the saved settings', () async {
    final c = freshContainer();
    addTearDown(c.dispose);

    await c
        .read(wirdControllerProvider.notifier)
        .setGoal(c.read(wirdControllerProvider).unit, 7);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(c.read(wirdControllerProvider).amount, 7);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getInt('wird.amount'), 7);
  });
}
