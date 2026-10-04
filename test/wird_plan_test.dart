import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/wird/wird_plan.dart';

void main() {
  group('the daily goal', () {
    test('pages count as themselves, a Juz as twenty pages', () {
      expect(wirdGoalPages(WirdUnit.pages, 7), 7);
      expect(wirdGoalPages(WirdUnit.juz, 1), pagesPerJuz);
      expect(wirdGoalPages(WirdUnit.juz, 3), 3 * pagesPerJuz);
    });

    test('a suggestion loops in about a month, within the limits', () {
      expect(suggestedWirdPages(604), 21);
      expect(suggestedWirdPages(30), 1);
      expect(suggestedWirdPages(0), 1);
      expect(suggestedWirdPages(100000), maxWirdPages);
    });

    test('days to loop round up and need a goal', () {
      expect(daysToLoop(604, 20), 31);
      expect(daysToLoop(60, 20), 3);
      expect(daysToLoop(0, 20), 0);
      expect(daysToLoop(10, 0), 10);
    });

    test('the maximum depends on the unit', () {
      expect(maxWirdAmount(WirdUnit.pages), maxWirdPages);
      expect(maxWirdAmount(WirdUnit.juz), maxWirdJuz);
    });
  });

  group('planWird', () {
    final pool = [for (var p = 1; p <= 10; p++) p];

    WirdPlan plan({
      int pointer = 0,
      int turns = 0,
      int goal = 3,
      List<int>? p,
    }) => planWird(
      pool: p ?? pool,
      pointer: pointer,
      turnsDone: turns,
      goalPages: goal,
    );

    test('a new round starts at the first page', () {
      final p = plan();
      expect(p.todayPages, [1, 2, 3]);
      expect(p.turn, 1);
      expect(p.donePagesInTurn, 0);
      expect(p.totalPages, 10);
    });

    test('the share continues after the last page read', () {
      final p = plan(pointer: 3);
      expect(p.todayPages, [4, 5, 6]);
      expect(p.donePagesInTurn, 3);
    });

    test('the share runs on from the end of the loop to its start', () {
      final p = plan(pointer: 9, turns: 2);
      expect(p.todayPages, [10, 1, 2]);
      expect(p.turn, 3);
    });

    test('a goal bigger than the loop reads it once, not twice', () {
      final p = plan(goal: 50);
      expect(p.todayPages, hasLength(10));
      expect(p.todayPages.toSet(), hasLength(10));
    });

    test('pages that are not consecutive are followed in order', () {
      final p = plan(p: [3, 8, 9, 40, 41], pointer: 8, goal: 2);
      expect(p.todayPages, [9, 40]);
    });

    test('an empty loop has nothing to read', () {
      final p = plan(p: const []);
      expect(p.todayPages, isEmpty);
      expect(p.totalPages, 0);
      expect(p.fraction, 0);
    });

    test('it says how long a round takes', () {
      expect(plan(goal: 3).daysToLoop, 4);
    });

    test('a pointer left on a page no longer in the loop still works', () {
      final p = plan(p: [3, 8, 9], pointer: 5, goal: 1);
      expect(p.todayPages, [8]);
    });
  });

  group('advanceWird', () {
    final pool = [for (var p = 1; p <= 10; p++) p];

    ({int pointer, int turnsDone}) advance(
      int pointer,
      int turns,
      List<int> r,
    ) =>
        advanceWird(pool: pool, pointer: pointer, turnsDone: turns, portion: r);

    test('reading moves the pointer to the last page read', () {
      expect(advance(0, 0, [1, 2, 3]), (pointer: 3, turnsDone: 0));
      expect(advance(3, 0, [4, 5, 6]), (pointer: 6, turnsDone: 0));
    });

    test('reaching the last page ends the round and starts a new one', () {
      expect(advance(7, 0, [8, 9, 10]), (pointer: 0, turnsDone: 1));
    });

    test('a share that goes round the loop counts the round', () {
      expect(advance(9, 0, [10, 1, 2]), (pointer: 2, turnsDone: 1));
    });

    test('reading the whole loop in a day is one round', () {
      expect(advance(0, 4, pool), (pointer: 0, turnsDone: 5));
    });

    test('nothing read, nothing moves', () {
      expect(advance(4, 2, const []), (pointer: 4, turnsDone: 2));
    });

    test('days follow one another without skipping or repeating a page', () {
      var pointer = 0, turns = 0;
      final seen = <int>[];
      for (var day = 0; day < 8; day++) {
        final p = planWird(
          pool: pool,
          pointer: pointer,
          turnsDone: turns,
          goalPages: 3,
        );
        seen.addAll(p.todayPages);
        final next = advanceWird(
          pool: pool,
          pointer: pointer,
          turnsDone: turns,
          portion: p.todayPages,
        );
        pointer = next.pointer;
        turns = next.turnsDone;
      }
      // 24 pages read over a 10-page loop: 2 full rounds and 4 more.
      expect(seen, [for (var i = 0; i < 24; i++) pool[i % 10]]);
      expect(turns, 2);
    });
  });

  test('pool pages are listed once each, in order', () {
    final pages = wirdPoolPages(
      ayahs: [
        (surah: 2, ayah: 1),
        (surah: 1, ayah: 1),
        (surah: 1, ayah: 2),
        (surah: 9, ayah: 9),
      ],
      pageByAyah: {
        (surah: 1, ayah: 1): 1,
        (surah: 1, ayah: 2): 1,
        (surah: 2, ayah: 1): 2,
      },
    );
    expect(pages, [1, 2]);
  });

  group('firstWirdAyahByPage', () {
    test('names a page by the sourate of the Wird that begins on it', () {
      // Page 5 opens with the end of sourate 1 (not in the Wird) and sourate
      // 2 begins there.
      final byPage = firstWirdAyahByPage(
        ayahs: [(surah: 2, ayah: 1), (surah: 2, ayah: 2)],
        pageByAyah: {
          (surah: 1, ayah: 9): 5,
          (surah: 2, ayah: 1): 5,
          (surah: 2, ayah: 2): 5,
        },
      );

      expect(byPage, {5: (surah: 2, ayah: 1)});
    });

    test('keeps the earliest verse of the page', () {
      final byPage = firstWirdAyahByPage(
        ayahs: [(surah: 3, ayah: 4), (surah: 3, ayah: 2)],
        pageByAyah: {(surah: 3, ayah: 4): 9, (surah: 3, ayah: 2): 9},
      );

      expect(byPage[9], (surah: 3, ayah: 2));
    });
  });
}
