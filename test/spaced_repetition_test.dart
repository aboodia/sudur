import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/review/spaced_repetition.dart';

void main() {
  group('reviewIntervalDays / nextReviewDate', () {
    test('maps circles to quotidien/hebdomadaire/mensuel', () {
      expect(reviewIntervalDays(1), 1);
      expect(reviewIntervalDays(2), 7);
      expect(reviewIntervalDays(3), 30);
    });

    test('an unexpected circle value falls back to the monthly interval', () {
      expect(reviewIntervalDays(4), 30);
    });

    test('nextReviewDate adds the circle interval', () {
      final from = DateTime(2026, 1, 1);
      expect(nextReviewDate(from, 1), DateTime(2026, 1, 2));
      expect(nextReviewDate(from, 2), DateTime(2026, 1, 8));
      expect(nextReviewDate(from, 3), DateTime(2026, 1, 31));
    });
  });

  group('applyReviewOutcome', () {
    test('weak always reintegrates Cercle 1 and reports failure', () {
      for (final before in [null, 1, 2, 3]) {
        final outcome = applyReviewOutcome(circleBefore: before, rating: ReviewRating.weak);
        expect(outcome.circle, 1, reason: 'circleBefore=$before');
        expect(outcome.masteryLevel, 'weak');
        expect(outcome.success, isFalse);
      }
    });

    test('medium keeps the same circle (defaulting to 1 if null) and reports success', () {
      expect(applyReviewOutcome(circleBefore: null, rating: ReviewRating.medium).circle, 1);
      expect(applyReviewOutcome(circleBefore: 2, rating: ReviewRating.medium).circle, 2);
      final outcome = applyReviewOutcome(circleBefore: 2, rating: ReviewRating.medium);
      expect(outcome.masteryLevel, 'medium');
      expect(outcome.success, isTrue);
    });

    test('solid advances the circle by one step, capped at 3', () {
      expect(applyReviewOutcome(circleBefore: null, rating: ReviewRating.solid).circle, 1);
      expect(applyReviewOutcome(circleBefore: 1, rating: ReviewRating.solid).circle, 2);
      expect(applyReviewOutcome(circleBefore: 2, rating: ReviewRating.solid).circle, 3);
      expect(applyReviewOutcome(circleBefore: 3, rating: ReviewRating.solid).circle, 3);
      final outcome = applyReviewOutcome(circleBefore: 1, rating: ReviewRating.solid);
      expect(outcome.masteryLevel, 'solid');
      expect(outcome.success, isTrue);
    });
  });
}
