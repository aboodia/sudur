import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/memorization/mastery.dart';

void main() {
  group('masteryFor', () {
    test('a failed verse is weak whatever its history', () {
      for (final step in [0, 1, 2, 5]) {
        expect(
          masteryFor(lastOutcome: 'redo', cycleStep: step),
          MasteryLevel.weak,
        );
      }
    });

    test('a hesitant verse is weak until it reaches the monthly cycle', () {
      expect(
        masteryFor(lastOutcome: 'hesitant', cycleStep: 0),
        MasteryLevel.weak,
      );
      expect(
        masteryFor(lastOutcome: 'hesitant', cycleStep: 1),
        MasteryLevel.weak,
      );
      expect(
        masteryFor(lastOutcome: 'hesitant', cycleStep: solidCycleStep),
        MasteryLevel.medium,
      );
    });

    test('a clean verse is solid only once on the monthly cycle', () {
      expect(
        masteryFor(lastOutcome: 'clean', cycleStep: 0),
        MasteryLevel.medium,
      );
      expect(
        masteryFor(lastOutcome: 'clean', cycleStep: 1),
        MasteryLevel.medium,
      );
      expect(
        masteryFor(lastOutcome: 'clean', cycleStep: solidCycleStep),
        MasteryLevel.solid,
      );
    });

    test('an unknown or missing outcome never crashes and reads as medium', () {
      expect(masteryFor(lastOutcome: null, cycleStep: 0), MasteryLevel.medium);
      expect(
        masteryFor(lastOutcome: 'garbage', cycleStep: 3),
        MasteryLevel.medium,
      );
    });
  });

  group('MasteryCounts', () {
    test('counts each level and totals them', () {
      final counts = MasteryCounts.of([
        MasteryLevel.weak,
        MasteryLevel.solid,
        MasteryLevel.solid,
        MasteryLevel.medium,
      ]);
      expect(counts.weak, 1);
      expect(counts.medium, 1);
      expect(counts.solid, 2);
      expect(counts.total, 4);
    });

    test('is all zeros for no verses', () {
      final counts = MasteryCounts.of(const []);
      expect(counts.total, 0);
    });
  });
}
