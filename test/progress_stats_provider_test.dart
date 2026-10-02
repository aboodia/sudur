import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/memorization/review_scheduler.dart';
import 'package:sudur/core/stats/progress_stats_provider.dart';

import 'helpers/revision_seed.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('a new profile has nothing to show, and invents nothing', () async {
    final c = freshContainer();
    addTearDown(c.dispose);

    final s = await c.read(progressStatsProvider.future);

    expect(s.memorizedAyahs, 0);
    expect(s.completedSurahs, 0);
    expect(s.juz, 0);
    expect(s.retention, isNull);
    expect(s.streakDays, 0);
    expect(s.studyTime, Duration.zero);
  });

  test('memorizing a whole sourate through the parcours is counted', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final profile = await c.read(currentProfileProvider.future);
    final repo = c.read(memorizationRepositoryProvider);

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

    final s = await c.read(progressStatsProvider.future);
    expect(s.memorizedAyahs, 3);
    expect(s.completedSurahs, 1);
    expect(s.juz, greaterThan(0));
    // Memorizing is activity: the streak starts today.
    expect(s.streakDays, 1);
    // But no verse was *reviewed* yet, so there is no retention to report.
    expect(s.retention, isNull);
  });

  test(
    'a sourate declared in the onboarding counts without per-verse rows',
    () async {
      final c = freshContainer();
      addTearDown(c.dispose);
      final profile = await c.read(currentProfileProvider.future);
      final repo = c.read(memorizationRepositoryProvider);

      await repo.markSurahMemorized(profile.id, 1, 7);

      final s = await c.read(progressStatsProvider.future);
      expect(s.memorizedAyahs, 7);
      expect(s.completedSurahs, 1);
      expect(s.juz, greaterThan(0));
      // Declaring what you already knew is not study activity.
      expect(s.streakDays, 0);
    },
  );

  test(
    'a partly memorized sourate and a declared one do not double count',
    () async {
      final c = freshContainer();
      addTearDown(c.dispose);
      final profile = await c.read(currentProfileProvider.future);
      final repo = c.read(memorizationRepositoryProvider);

      await repo.markSurahMemorized(profile.id, 108, 3);
      // A verse of that same sourate also has its own row.
      await seedAyah(
        c,
        surah: 108,
        ayah: 2,
        due: DateTime.now().add(const Duration(days: 3)),
      );

      final s = await c.read(progressStatsProvider.future);
      expect(s.memorizedAyahs, 3);
    },
  );

  test('retention is the share of recent reviews that held', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final repo = c.read(memorizationRepositoryProvider);
    final profile = await c.read(currentProfileProvider.future);
    final past = DateTime.now().subtract(const Duration(days: 1));

    final rows = [
      await seedAyah(c, surah: 2, ayah: 1, due: past),
      await seedAyah(c, surah: 2, ayah: 2, due: past),
      await seedAyah(c, surah: 2, ayah: 3, due: past),
      await seedAyah(c, surah: 2, ayah: 4, due: past),
    ];
    final outcomes = [
      ReciteOutcome.clean,
      ReciteOutcome.hesitant,
      ReciteOutcome.clean,
      ReciteOutcome.redo,
    ];
    for (var i = 0; i < rows.length; i++) {
      await repo.recordAyahReview(
        ayahProgressId: rows[i].id,
        outcome: outcomes[i],
        hasFragileWords: false,
      );
    }

    final s = await c.read(progressStatsProvider.future);
    expect(s.retention, 0.75);
    expect(s.streakDays, 1);
    expect(profile.id, isNotEmpty);
  });

  test('time invested adds up the logged sessions', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final repo = c.read(memorizationRepositoryProvider);
    final profile = await c.read(currentProfileProvider.future);

    await repo.logStudySession(
      profileId: profile.id,
      kind: 'memorization',
      startedAt: DateTime.now(),
      duration: const Duration(minutes: 12),
      ayahCount: 5,
    );
    await repo.logStudySession(
      profileId: profile.id,
      kind: 'revision',
      startedAt: DateTime.now(),
      duration: const Duration(minutes: 8),
      ayahCount: 6,
    );

    final s = await c.read(progressStatsProvider.future);
    expect(s.studyTime, const Duration(minutes: 20));
  });
}
