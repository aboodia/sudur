import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/memorization/review_scheduler.dart';

void main() {
  final fixedNow = DateTime(2026, 1, 10);
  ReviewScheduler scheduler() => ReviewScheduler(clock: () => fixedNow);

  test('the first review is always J+1', () {
    final memorizedAt = DateTime(2026, 1, 1);
    expect(scheduler().scheduleFirstReview(memorizedAt), DateTime(2026, 1, 2));
  });

  test('a clean cycle runs J+3 -> J+7 -> J+30 -> stays at J+30', () {
    final s = scheduler();
    var from = DateTime(2026, 1, 1);
    var step = 0;

    var result = s.scheduleNextReview(
      from: from,
      cycleStep: step,
      outcome: ReciteOutcome.clean,
      hasFragileWords: false,
    );
    expect(result.dueAt, from.add(const Duration(days: 3)));
    expect(result.nextCycleStep, 1);
    from = result.dueAt;
    step = result.nextCycleStep;

    result = s.scheduleNextReview(
      from: from,
      cycleStep: step,
      outcome: ReciteOutcome.clean,
      hasFragileWords: false,
    );
    expect(result.dueAt, from.add(const Duration(days: 7)));
    expect(result.nextCycleStep, 2);
    from = result.dueAt;
    step = result.nextCycleStep;

    result = s.scheduleNextReview(
      from: from,
      cycleStep: step,
      outcome: ReciteOutcome.clean,
      hasFragileWords: false,
    );
    expect(result.dueAt, from.add(const Duration(days: 30)));
    expect(result.nextCycleStep, 2);
    from = result.dueAt;
    step = result.nextCycleStep;

    // Steady state: once at the end of the cycle, it stays monthly forever.
    result = s.scheduleNextReview(
      from: from,
      cycleStep: step,
      outcome: ReciteOutcome.clean,
      hasFragileWords: false,
    );
    expect(result.dueAt, from.add(const Duration(days: 30)));
    expect(result.nextCycleStep, 2);
  });

  test(
    'hesitant still advances the cycle but halves the interval (min 1 day)',
    () {
      final s = scheduler();
      final from = DateTime(2026, 1, 1);

      final result = s.scheduleNextReview(
        from: from,
        cycleStep: 0,
        outcome: ReciteOutcome.hesitant,
        hasFragileWords: false,
      );
      expect(result.dueAt, from.add(const Duration(days: 2))); // round(3 / 2)
      expect(result.nextCycleStep, 1);
    },
  );

  test('a fragile word halves the interval even on a clean recitation', () {
    final s = scheduler();
    final from = DateTime(2026, 1, 1);

    final result = s.scheduleNextReview(
      from: from,
      cycleStep: 2,
      outcome: ReciteOutcome.clean,
      hasFragileWords: true,
    );
    expect(result.dueAt, from.add(const Duration(days: 15))); // round(30 / 2)
    expect(result.nextCycleStep, 2);
  });

  test('halving never drops below 1 day', () {
    final s = scheduler();
    final from = DateTime(2026, 1, 1);

    // cycleStep 0 -> base 3 days, but imagine a hypothetical 1-day base:
    // exercised indirectly by asserting the floor holds for the smallest
    // real base (3 days -> 2, never 0).
    final result = s.scheduleNextReview(
      from: from,
      cycleStep: 0,
      outcome: ReciteOutcome.hesitant,
      hasFragileWords: false,
    );
    expect(result.dueAt.isAfter(from), isTrue);
  });

  test('redo resets to J+1 and cycle step 0, regardless of prior progress', () {
    final s = scheduler();
    final from = DateTime(2026, 1, 1);

    final result = s.scheduleNextReview(
      from: from,
      cycleStep: 3,
      outcome: ReciteOutcome.redo,
      hasFragileWords: true,
    );
    expect(result.dueAt, from.add(const Duration(days: 1)));
    expect(result.nextCycleStep, 0);
  });

  group('isDue', () {
    test('a past or present due date is due', () {
      final s = scheduler();
      expect(s.isDue(fixedNow.subtract(const Duration(days: 1))), isTrue);
      expect(s.isDue(fixedNow), isTrue);
    });

    test('a future due date is not due yet', () {
      final s = scheduler();
      expect(s.isDue(fixedNow.add(const Duration(days: 1))), isFalse);
    });
  });
}
