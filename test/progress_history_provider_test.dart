import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/memorization/review_scheduler.dart';
import 'package:sudur/core/stats/progress_history_provider.dart';

import 'helpers/revision_seed.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'guided verses are one event each, on the day they were learned',
    () async {
      final c = freshContainer();
      addTearDown(c.dispose);
      final due = DateTime.now().add(const Duration(days: 3));
      await seedAyah(c, surah: 67, ayah: 1, due: due);
      await seedAyah(c, surah: 67, ayah: 2, due: due);

      final events = await c.read(memorizationEventsProvider.future);

      expect(events, hasLength(2));
      expect(events.every((e) => e.weight == 1), isTrue);
      // seedAyah dates the memorization ten days back.
      expect(
        events.every((e) => DateTime.now().difference(e.at).inDays >= 9),
        isTrue,
      );
    },
  );

  test(
    'a declared sourate is a single event carrying all its verses',
    () async {
      final c = freshContainer();
      addTearDown(c.dispose);
      final profile = await c.read(currentProfileProvider.future);
      await c
          .read(memorizationRepositoryProvider)
          .markSurahMemorized(profile.id, 1, 7);

      final events = await c.read(memorizationEventsProvider.future);

      expect(events, hasLength(1));
      expect(events.single.weight, 7);
    },
  );

  test(
    'a sourate finished in the parcours is counted once, not twice',
    () async {
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

      final events = await c.read(memorizationEventsProvider.future);

      // The sourate is complete (it has a completion date) but has its own
      // verse rows: 3 events of 1, not those plus a 3-verse declaration.
      expect(events.fold<int>(0, (a, e) => a + e.weight), 3);
    },
  );

  test('the Mushaf map lights up the pages of what is memorized', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final profile = await c.read(currentProfileProvider.future);
    // Al-Fatiha alone fills page 1 of the Mushaf.
    await c
        .read(memorizationRepositoryProvider)
        .markSurahMemorized(profile.id, 1, 7);

    final coverage = await c.read(mushafCoverageProvider.future);

    expect(coverage, hasLength(604));
    expect(coverage[0], 1.0);
    expect(coverage[1], 0.0);
    expect(coverage.last, 0.0);
  });

  test('the history is the latest sessions, newest first, capped', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final profile = await c.read(currentProfileProvider.future);
    final repo = c.read(memorizationRepositoryProvider);
    final base = DateTime(2026, 9, 1, 8);
    for (var i = 0; i < studyHistoryLength + 5; i++) {
      await repo.logStudySession(
        profileId: profile.id,
        kind: i.isEven ? 'memorization' : 'revision',
        startedAt: base.add(Duration(days: i)),
        duration: Duration(minutes: i + 1),
        ayahCount: 5,
      );
    }

    final history = await c.read(studyHistoryProvider.future);

    expect(history, hasLength(studyHistoryLength));
    expect(
      history.first.startedAt,
      base.add(Duration(days: studyHistoryLength + 4)),
    );
    for (var i = 1; i < history.length; i++) {
      expect(history[i].startedAt.isBefore(history[i - 1].startedAt), isTrue);
    }
  });
}
