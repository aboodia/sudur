import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/database/app_database.dart';
import 'package:sudur/core/database/memorization_repository.dart';
import 'package:sudur/core/database/profile_repository.dart';
import 'package:sudur/core/memorization/review_calendar.dart';
import 'package:sudur/core/memorization/review_scheduler.dart';
import 'package:sudur/features/revision/revision_session_controller.dart';

import 'helpers/revision_seed.dart';

DateTime _daysAgo(int n) => DateTime.now().subtract(Duration(days: n));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('with nothing due the session opens empty', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final sub = c.listen(revisionSessionProvider, (_, _) {});
    addTearDown(sub.close);

    await c.read(revisionSessionProvider.notifier).start();

    final state = c.read(revisionSessionProvider);
    expect(state.isLoaded, isTrue);
    expect(state.isEmpty, isTrue);
  });

  test(
    'takes the most overdue verses up to the cap, in Mushaf order',
    () async {
      final c = freshContainer();
      addTearDown(c.dispose);
      final sub = c.listen(revisionSessionProvider, (_, _) {});
      addTearDown(sub.close);

      // 12 due verses; ayah 1 is the most overdue ... ayah 12 the least.
      for (var ayah = 1; ayah <= revisionSessionSize + 2; ayah++) {
        await seedAyah(c, surah: 67, ayah: ayah, due: _daysAgo(30 - ayah));
      }
      // A verse from an earlier sourate, due the least long ago: dropped by
      // the cap, so it must not be in the session.
      await seedAyah(c, surah: 1, ayah: 1, due: _daysAgo(0));

      await c.read(revisionSessionProvider.notifier).start();
      final items = c.read(revisionSessionProvider).items;

      expect(items, hasLength(revisionSessionSize));
      expect(items.map((e) => e.surahNumber).toSet(), {67});
      expect(items.map((e) => e.ayahNumber), [
        for (var a = 1; a <= revisionSessionSize; a++) a,
      ]);
    },
  );

  test(
    'rating every verse advances the schedule and logs the session',
    () async {
      final c = freshContainer();
      addTearDown(c.dispose);
      final sub = c.listen(revisionSessionProvider, (_, _) {});
      addTearDown(sub.close);
      final profile = await c.read(currentProfileProvider.future);
      final repo = c.read(memorizationRepositoryProvider);
      final db = c.read(appDatabaseProvider);

      await seedAyah(c, surah: 108, ayah: 1, due: _daysAgo(1));
      await seedAyah(c, surah: 108, ayah: 2, due: _daysAgo(1), step: 1);
      await seedAyah(c, surah: 108, ayah: 3, due: _daysAgo(1), step: 1);

      final controller = c.read(revisionSessionProvider.notifier);
      await controller.start();
      await controller.submit(ReciteOutcome.clean);
      expect(c.read(revisionSessionProvider).isFinished, isFalse);
      await controller.submit(ReciteOutcome.hesitant);
      await controller.submit(ReciteOutcome.redo);

      final state = c.read(revisionSessionProvider);
      expect(state.isFinished, isTrue);
      expect(state.results, [
        ReciteOutcome.clean,
        ReciteOutcome.hesitant,
        ReciteOutcome.redo,
      ]);
      expect(state.count(ReciteOutcome.clean), 1);
      expect(state.remainingDue, 0);

      final rows = {
        for (final e in await repo.allAyahProgress(profile.id)) e.ayahNumber: e,
      };
      final today = dateOnly(DateTime.now());
      // clean at step 0: +3 days, now at step 1.
      expect(rows[1]!.reviewCycleStep, 1);
      expect(daysBetween(today, rows[1]!.nextReviewAt), 3);
      // hesitant at step 1: 7 days halved to 4, step advances.
      expect(rows[2]!.reviewCycleStep, 2);
      expect(daysBetween(today, rows[2]!.nextReviewAt), 4);
      // redo: back to the start, due tomorrow.
      expect(rows[3]!.reviewCycleStep, 0);
      expect(daysBetween(today, rows[3]!.nextReviewAt), 1);

      // Nothing is left due, and the next review is the redo, tomorrow.
      expect(await repo.dueReviews(profile.id), isEmpty);
      expect(
        state.nextReviewDay,
        DateTime(today.year, today.month, today.day + 1),
      );

      final session = (await db.select(db.studySessionEntries).get()).single;
      expect(session.kind, 'revision');
      expect(session.ayahCount, 3);
      expect(await db.select(db.reviewLogEntries).get(), hasLength(3));
    },
  );

  test('a verse that was shaky still gets the shorter interval', () async {
    final c = freshContainer();
    addTearDown(c.dispose);
    final sub = c.listen(revisionSessionProvider, (_, _) {});
    addTearDown(sub.close);
    final profile = await c.read(currentProfileProvider.future);
    final repo = c.read(memorizationRepositoryProvider);

    await seedAyah(c, surah: 2, ayah: 1, due: _daysAgo(1), fragile: '[4]');
    final controller = c.read(revisionSessionProvider.notifier);
    await controller.start();
    await controller.submit(ReciteOutcome.clean);

    final row = (await repo.allAyahProgress(profile.id)).single;
    // Step 0 would be +3 days; shaky words halve it to 2 (rounded).
    expect(daysBetween(dateOnly(DateTime.now()), row.nextReviewAt), 2);
    // ...and a clean recitation clears the flag for next time.
    expect(row.fragileWordIndices, '[]');
  });

  test(
    'quitting midway keeps what was rated and leaves the rest due',
    () async {
      final c = freshContainer();
      addTearDown(c.dispose);
      final sub = c.listen(revisionSessionProvider, (_, _) {});
      addTearDown(sub.close);
      final profile = await c.read(currentProfileProvider.future);
      final repo = c.read(memorizationRepositoryProvider);

      for (var ayah = 1; ayah <= 3; ayah++) {
        await seedAyah(c, surah: 105, ayah: ayah, due: _daysAgo(1));
      }
      final controller = c.read(revisionSessionProvider.notifier);
      await controller.start();
      await controller.submit(ReciteOutcome.clean);
      // ...the user leaves here.

      final stillDue = await repo.dueReviews(profile.id);
      expect(stillDue.map((e) => e.ayahNumber).toList()..sort(), [2, 3]);
    },
  );

  test(
    'more than one session is needed when more than the cap is due',
    () async {
      final c = freshContainer();
      addTearDown(c.dispose);
      final sub = c.listen(revisionSessionProvider, (_, _) {});
      addTearDown(sub.close);

      for (var ayah = 1; ayah <= revisionSessionSize + 3; ayah++) {
        await seedAyah(c, surah: 2, ayah: ayah, due: _daysAgo(1));
      }
      final controller = c.read(revisionSessionProvider.notifier);
      await controller.start();
      for (var i = 0; i < revisionSessionSize; i++) {
        await controller.submit(ReciteOutcome.clean);
      }

      final state = c.read(revisionSessionProvider);
      expect(state.isFinished, isTrue);
      expect(state.remainingDue, 3);
    },
  );
}
