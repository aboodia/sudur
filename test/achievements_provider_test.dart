import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/database/achievement_repository.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/gamification/achievements_provider.dart';
import 'package:sudur/core/stats/progress_stats_provider.dart';

import 'helpers/revision_seed.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  AchievementItem item(AchievementsState s, String key) =>
      s.items.firstWhere((i) => i.def.key == key);

  test('a newcomer has earned nothing and nothing is new', () async {
    final c = freshContainer();
    addTearDown(c.dispose);

    final state = await c.read(achievementsProvider.future);

    expect(state.earnedCount, 0);
    expect(state.newCount, 0);
  });

  test('a first verse earns its badge, which starts out new', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    await seedAyah(
      c,
      surah: 67,
      ayah: 1,
      due: DateTime.now().add(const Duration(days: 3)),
    );

    final state = await c.read(achievementsProvider.future);

    final first = item(state, 'verses_1');
    expect(first.earned, isTrue);
    expect(first.isNew, isTrue);
    expect(state.newCount, 1);
    expect(item(state, 'verses_100').earned, isFalse);
  });

  test('declaring a sourate counts: Al-Fatiha is seven verses', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final profile = await c.read(currentProfileProvider.future);
    await c
        .read(memorizationRepositoryProvider)
        .markSurahMemorized(profile.id, 1, 7);

    final state = await c.read(achievementsProvider.future);

    expect(item(state, 'verses_1').earned, isTrue);
  });

  test('seeing the badges clears "new" but keeps them earned', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    await seedAyah(
      c,
      surah: 67,
      ayah: 1,
      due: DateTime.now().add(const Duration(days: 3)),
    );
    final before = await c.read(achievementsProvider.future);
    final earnedAt = item(before, 'verses_1').unlockedAt;

    await markAchievementsSeen(c);
    final after = await c.read(achievementsProvider.future);

    expect(after.newCount, 0);
    expect(item(after, 'verses_1').earned, isTrue);
    expect(item(after, 'verses_1').unlockedAt, earnedAt);
  });

  test('a badge once earned is not taken back', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final profile = await c.read(currentProfileProvider.future);
    // Recorded as earned although today's figures would not earn it.
    await c.read(achievementRepositoryProvider).unlock(profile.id, [
      'streak_30',
    ], DateTime(2026, 1, 1));
    c.invalidate(achievementsProvider);

    final state = await c.read(achievementsProvider.future);

    final streak = item(state, 'streak_30');
    expect(streak.earned, isTrue);
    expect(streak.unlockedAt, DateTime(2026, 1, 1));
    expect(streak.status.reached, isFalse);
  });

  test('recording the same badge twice keeps the first date', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final profile = await c.read(currentProfileProvider.future);
    final repo = c.read(achievementRepositoryProvider);

    await repo.unlock(profile.id, ['juz_1'], DateTime(2026, 1, 1));
    await repo.unlock(profile.id, ['juz_1'], DateTime(2026, 6, 1));

    final rows = await repo.unlocked(profile.id);
    expect(rows, hasLength(1));
    expect(rows.single.unlockedAt, DateTime(2026, 1, 1));
  });

  test(
    'the streak badges follow the best streak of the activity log',
    () async {
      final c = freshContainer();
      addTearDown(c.dispose);
      final profile = await c.read(currentProfileProvider.future);
      final db = c.read(appDatabaseProvider);
      // Four consecutive days of activity, ending a week ago: the current
      // streak is over, the best one (4) still earns the 3-day badge.
      for (var i = 0; i < 4; i++) {
        final at = DateTime.now().subtract(Duration(days: 8 + i));
        await db
            .into(db.reviewLogEntries)
            .insert(
              ReviewLogEntriesCompanion.insert(
                id: 'log-$i',
                profileId: profile.id,
                surahNumber: 67,
                ayahNumber: 1,
                kind: 'memorize',
                outcome: 'clean',
                occurredAt: at,
              ),
            );
      }
      c.invalidate(progressStatsProvider);

      final stats = await c.read(progressStatsProvider.future);
      final state = await c.read(achievementsProvider.future);

      expect(stats.streakDays, 0);
      expect(stats.streak.longest, 4);
      expect(item(state, 'streak_3').earned, isTrue);
      expect(item(state, 'streak_7').earned, isFalse);
    },
  );
}
