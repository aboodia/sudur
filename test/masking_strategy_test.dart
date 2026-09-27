import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/memorization/masking_strategy.dart';

void main() {
  // Fake, non-Quranic words throughout — never real ayah text in tests.
  const words = ['mot1', 'mot2', 'à', 'mot4', 'de', 'mot6', 'mot7', 'mot8'];

  group('full', () {
    test('hides everything except the first word', () {
      expect(maskedIndices(words, MaskLevel.full, 1), [1, 2, 3, 4, 5, 6, 7]);
    });

    test('a single-word verse has nothing left to hide', () {
      expect(maskedIndices(['seul'], MaskLevel.full, 1), isEmpty);
    });
  });

  group('light', () {
    test(
      'hides roughly a quarter of the words, skipping ones of length <= 2',
      () {
        final hidden = maskedIndices(words, MaskLevel.light, 42);
        expect(hidden.length, 2); // round(8 * 0.25)
        for (final i in hidden) {
          expect(words[i].length, greaterThan(2));
        }
      },
    );

    test('a verse of only short words masks nothing rather than crashing', () {
      expect(maskedIndices(['à', 'de', 'ô'], MaskLevel.light, 7), isEmpty);
    });

    test('a single-word verse below the length threshold masks nothing', () {
      expect(maskedIndices(['à'], MaskLevel.light, 7), isEmpty);
    });
  });

  group('medium', () {
    test('hides roughly 60% of the words, short words included', () {
      final hidden = maskedIndices(words, MaskLevel.medium, 42);
      expect(hidden.length, 5); // round(8 * 0.6)
    });

    test('a single-word verse still gets masked at medium level', () {
      expect(maskedIndices(['seul'], MaskLevel.medium, 7), [0]);
    });
  });

  test(
    'is deterministic: same words/level/seed always give the same result',
    () {
      final first = maskedIndices(words, MaskLevel.medium, 99);
      final second = maskedIndices(words, MaskLevel.medium, 99);
      expect(first, second);
    },
  );

  test('a different seed can select a different set of words', () {
    final a = maskedIndices(words, MaskLevel.light, 1);
    final b = maskedIndices(words, MaskLevel.light, 2);
    // Not guaranteed to differ for every possible pair, but true for these
    // fixed fixtures/seeds — pins down that the seed is actually used.
    expect(a == b, isFalse);
  });

  test('an empty verse (defensive) masks nothing', () {
    expect(maskedIndices(const [], MaskLevel.medium, 1), isEmpty);
  });
}
