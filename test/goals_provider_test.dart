import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/memorization/review_scheduler.dart';
import 'package:sudur/core/stats/goals.dart';
import 'package:sudur/core/stats/goals_provider.dart';

import 'helpers/revision_seed.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'without a chosen goal, the proposal from the onboarding is used',
    () async {
      final c = freshContainer();
      addTearDown(c.dispose);
      final profile = await c.read(currentProfileProvider.future);

      final goals = await c.read(goalsProvider.future);

      final expected = defaultGoals(
        dailyTargetMinutes: profile.dailyTargetMinutes,
        availableDaysMask: profile.availableDaysMask,
      );
      expect(goals.week.goal, expected.weekly);
      expect(goals.month.goal, expected.monthly);
      expect(goals.weeklyIsDefault, isTrue);
      expect(goals.week.done, 0);
    },
  );

  test('verses validated today count toward the week and the month', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final profile = await c.read(currentProfileProvider.future);
    final repo = c.read(memorizationRepositoryProvider);
    for (var ayah = 1; ayah <= 3; ayah++) {
      await repo.recordAyahMemorized(
        profileId: profile.id,
        surahNumber: 67,
        ayahNumber: ayah,
        surahTotalAyahs: 30,
        outcome: ReciteOutcome.clean,
        fragileWordIndices: [],
      );
    }

    final goals = await c.read(goalsProvider.future);

    expect(goals.week.done, 3);
    expect(goals.month.done, 3);
  });

  test(
    'a sourate declared in the onboarding is not this week\'s progress',
    () async {
      final c = freshContainer();
      addTearDown(c.dispose);
      final profile = await c.read(currentProfileProvider.future);
      await c
          .read(memorizationRepositoryProvider)
          .markSurahMemorized(profile.id, 1, 7);

      final goals = await c.read(goalsProvider.future);

      expect(goals.week.done, 0);
    },
  );

  test('verses learned long ago do not count', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    // seedAyah dates the memorization ten days back: never in this week
    // (at most 6 days old) — and, 10 days back, not in this month either on
    // the first days of it, so only the week is asserted.
    await seedAyah(
      c,
      surah: 67,
      ayah: 1,
      due: DateTime.now().add(const Duration(days: 3)),
    );

    final goals = await c.read(goalsProvider.future);

    expect(goals.week.done, 0);
  });

  test('a chosen goal is kept, and null goes back to the proposal', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final profile = await c.read(currentProfileProvider.future);
    final repo = c.read(userProfileRepositoryProvider);

    await repo.setGoals(id: profile.id, weekly: 12, monthly: 40);
    c.invalidate(goalsProvider);
    var goals = await c.read(goalsProvider.future);
    expect(goals.week.goal, 12);
    expect(goals.month.goal, 40);
    expect(goals.weeklyIsDefault, isFalse);

    await repo.setGoals(id: profile.id, weekly: null, monthly: null);
    c.invalidate(goalsProvider);
    goals = await c.read(goalsProvider.future);
    expect(goals.week.goal, goals.defaults.weekly);
    expect(goals.weeklyIsDefault, isTrue);
  });
}
