/// How a "Réciter" self-assessment went — drives the next review date.
/// `clean`/`hesitant` both validate the verse (cycle advances); only
/// `redo` is a genuine failure (back to the Masquer step, cycle resets).
enum ReciteOutcome { clean, hesitant, redo }

/// Per-verse spaced repetition: J+1 → J+3 → J+7 → J+30, then monthly
/// forever. A "Quelques hésitations" outcome (or any remaining fragile
/// word) still advances the cycle but halves the interval, so a shaky
/// verse comes back sooner without being treated as a failure.
class ReviewScheduler {
  ReviewScheduler({required this.clock});

  /// Injected rather than calling `DateTime.now()` directly, so tests can
  /// pin "now" to a fixed instant.
  final DateTime Function() clock;

  static const _cycleDaysAfterFirst = [3, 7, 30];

  /// The very first review, right after a verse is memorized — always J+1,
  /// at `cycleStep` 0 (no successful review yet).
  DateTime scheduleFirstReview(DateTime memorizedAt) =>
      memorizedAt.add(const Duration(days: 1));

  /// Computes the next due date and cycle step after a review completes.
  /// [cycleStep] is how many successful reviews have happened so far (0
  /// right after [scheduleFirstReview]) — [from] is when this review took
  /// place (injected, never `DateTime.now()` directly).
  ({DateTime dueAt, int nextCycleStep}) scheduleNextReview({
    required DateTime from,
    required int cycleStep,
    required ReciteOutcome outcome,
    required bool hasFragileWords,
  }) {
    if (outcome == ReciteOutcome.redo) {
      return (dueAt: from.add(const Duration(days: 1)), nextCycleStep: 0);
    }

    final stepIndex = cycleStep.clamp(0, _cycleDaysAfterFirst.length - 1);
    final baseDays = _cycleDaysAfterFirst[stepIndex];
    final halved = outcome == ReciteOutcome.hesitant || hasFragileWords;
    final days = halved ? (baseDays / 2).round().clamp(1, baseDays) : baseDays;
    final nextCycleStep = (cycleStep + 1).clamp(
      0,
      _cycleDaysAfterFirst.length - 1,
    );

    return (
      dueAt: from.add(Duration(days: days)),
      nextCycleStep: nextCycleStep,
    );
  }

  /// Whether [dueAt] has arrived, per the injected clock.
  bool isDue(DateTime dueAt) => !dueAt.isAfter(clock());
}
