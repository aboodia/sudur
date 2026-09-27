import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/gamification/memorizer_profile.dart';
import 'package:sudur/core/memorization/profile_resolver.dart';

void main() {
  test('every badge but Hafiz has a next one', () {
    for (final badge in MemorizerBadge.values) {
      if (badge == MemorizerBadge.hafiz) {
        expect(badge.next, isNull);
      } else {
        expect(badge.next, isNotNull);
      }
    }
  });

  test('the badges are chained in ascending order', () {
    final values = MemorizerBadge.values;
    for (var i = 0; i < values.length - 1; i++) {
      expect(values[i].next, values[i + 1]);
    }
  });

  test('0 sourates: Muqbil, 1 sourate remaining to Mubtadi', () {
    expect(memorizerBadgeForCount(0), MemorizerBadge.muqbil);
    expect(surahsToNextBadge(0), 1);
  });

  test(
    'exactly on a threshold reports the count of that tier already reached',
    () {
      expect(memorizerBadgeForCount(6), MemorizerBadge.muthabir);
      expect(surahsToNextBadge(6), 21 - 6);
    },
  );

  test('114 sourates: Hafiz, nothing left to reach', () {
    expect(memorizerBadgeForCount(114), MemorizerBadge.hafiz);
    expect(surahsToNextBadge(114), 0);
  });

  test('just below Hafiz still counts down to it', () {
    expect(memorizerBadgeForCount(113), MemorizerBadge.khatm);
    expect(surahsToNextBadge(113), 1);
  });
}
