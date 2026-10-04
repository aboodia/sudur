import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/wird/wird_membership.dart';

void main() {
  group('successfulReviews', () {
    VerseLogEntry memorize() => (kind: 'memorize', outcome: 'clean');
    VerseLogEntry review([String outcome = 'clean']) =>
        (kind: 'review', outcome: outcome);

    test('counts the reviews that held', () {
      expect(successfulReviews([memorize(), review(), review('hesitant')]), 2);
    });

    test('a verse never reviewed has none', () {
      expect(successfulReviews([memorize()]), 0);
      expect(successfulReviews(const []), 0);
    });

    test('a failed review starts the count over', () {
      expect(
        successfulReviews([
          memorize(),
          review(),
          review(),
          review('redo'),
          review(),
        ]),
        1,
      );
    });

    test('learning the verse again starts the count over', () {
      expect(
        successfulReviews([
          memorize(),
          review(),
          review(),
          memorize(),
          review(),
        ]),
        1,
      );
    });
  });

  group('isVerseFixed', () {
    test('four clean reviews in the monthly cycle fix a verse', () {
      expect(
        isVerseFixed(lastOutcome: 'clean', cycleStep: 2, successfulReviews: 4),
        isTrue,
      );
    });

    test('before the last step it is not fixed yet', () {
      expect(
        isVerseFixed(lastOutcome: 'clean', cycleStep: 2, successfulReviews: 3),
        isFalse,
      );
    });

    test('a hesitation on the last review keeps it from being solid', () {
      expect(
        isVerseFixed(
          lastOutcome: 'hesitant',
          cycleStep: 2,
          successfulReviews: 5,
        ),
        isFalse,
      );
    });

    test('a verse that was just redone is not fixed', () {
      expect(
        isVerseFixed(lastOutcome: 'redo', cycleStep: 0, successfulReviews: 0),
        isFalse,
      );
    });
  });

  group('wirdSurahs', () {
    VerseState verse(int surah, {bool fixed = true}) => (
      surah: surah,
      lastOutcome: 'clean',
      cycleStep: fixed ? 2 : 1,
      successfulReviews: fixed ? 4 : 1,
    );

    test('a declared sourate is in the Wird from the start', () {
      expect(wirdSurahs(completedSurahs: [1, 2], verses: const []), {1, 2});
    });

    test('a sourate learned here enters once all its verses are fixed', () {
      expect(
        wirdSurahs(
          completedSurahs: [108],
          verses: [verse(108), verse(108), verse(108)],
        ),
        {108},
      );
    });

    test(
      'one verse still in its cycle keeps the whole sourate in Révision',
      () {
        expect(
          wirdSurahs(
            completedSurahs: [108],
            verses: [verse(108), verse(108, fixed: false), verse(108)],
          ),
          isEmpty,
        );
      },
    );

    test('a sourate not yet complete is never in the Wird', () {
      expect(
        wirdSurahs(completedSurahs: const [], verses: [verse(67), verse(67)]),
        isEmpty,
      );
    });

    test('each sourate is judged on its own verses', () {
      expect(
        wirdSurahs(
          completedSurahs: [1, 108],
          verses: [verse(108, fixed: false), verse(1)],
        ),
        {1},
      );
    });
  });
}
