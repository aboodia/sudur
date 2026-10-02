import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/memorization/review_scheduler.dart';

import 'helpers/revision_seed.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'a verse due later today is already due (whole-day semantics)',
    () async {
      final c = freshContainer();
      addTearDown(c.dispose);
      final profile = await c.read(currentProfileProvider.future);
      final repo = c.read(memorizationRepositoryProvider);

      final now = DateTime.now();
      final endOfToday = DateTime(now.year, now.month, now.day, 23, 59);
      final startOfTomorrow = DateTime(now.year, now.month, now.day + 1);
      await seedAyah(c, surah: 67, ayah: 1, due: endOfToday);
      await seedAyah(c, surah: 67, ayah: 2, due: startOfTomorrow);

      final due = await repo.dueReviews(profile.id);
      expect(due.map((e) => e.ayahNumber), [1]);
    },
  );

  test('memorizing and reviewing a verse both leave a log entry', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final profile = await c.read(currentProfileProvider.future);
    final repo = c.read(memorizationRepositoryProvider);
    final db = c.read(appDatabaseProvider);

    await repo.recordAyahMemorized(
      profileId: profile.id,
      surahNumber: 67,
      ayahNumber: 1,
      surahTotalAyahs: 30,
      outcome: ReciteOutcome.hesitant,
      fragileWordIndices: [2],
    );
    final entry = (await repo.allAyahProgress(profile.id)).single;
    await repo.recordAyahReview(
      ayahProgressId: entry.id,
      outcome: ReciteOutcome.redo,
      hasFragileWords: true,
    );

    final log = await (db.select(
      db.reviewLogEntries,
    )..orderBy([(t) => OrderingTerm.asc(t.occurredAt)])).get();
    expect(log.map((l) => (l.kind, l.outcome)), [
      ('memorize', 'hesitant'),
      ('review', 'redo'),
    ]);
    expect(log.every((l) => l.surahNumber == 67 && l.ayahNumber == 1), isTrue);
  });

  test(
    'a clean review forgets the fragile words, a hesitant one keeps them',
    () async {
      final c = freshContainer();
      addTearDown(c.dispose);
      final profile = await c.read(currentProfileProvider.future);
      final repo = c.read(memorizationRepositoryProvider);
      final past = DateTime.now().subtract(const Duration(days: 1));

      final a = await seedAyah(
        c,
        surah: 2,
        ayah: 1,
        due: past,
        fragile: '[1,3]',
      );
      final b = await seedAyah(
        c,
        surah: 2,
        ayah: 2,
        due: past,
        fragile: '[1,3]',
      );

      await repo.recordAyahReview(
        ayahProgressId: a.id,
        outcome: ReciteOutcome.clean,
        hasFragileWords: true,
      );
      await repo.recordAyahReview(
        ayahProgressId: b.id,
        outcome: ReciteOutcome.hesitant,
        hasFragileWords: true,
      );

      final rows = {
        for (final e in await repo.allAyahProgress(profile.id)) e.ayahNumber: e,
      };
      expect(rows[1]!.fragileWordIndices, '[]');
      expect(rows[2]!.fragileWordIndices, '[1,3]');
    },
  );

  test('logStudySession stores the duration and verse count', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final profile = await c.read(currentProfileProvider.future);
    final repo = c.read(memorizationRepositoryProvider);
    final db = c.read(appDatabaseProvider);

    await repo.logStudySession(
      profileId: profile.id,
      kind: 'revision',
      startedAt: DateTime(2026, 10, 2, 8),
      duration: const Duration(minutes: 7, seconds: 30),
      ayahCount: 6,
    );

    final session = (await db.select(db.studySessionEntries).get()).single;
    expect(session.kind, 'revision');
    expect(session.durationSeconds, 450);
    expect(session.ayahCount, 6);
  });
}
