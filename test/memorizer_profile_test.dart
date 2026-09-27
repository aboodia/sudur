import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/gamification/memorizer_profile.dart';

void main() {
  test('memorizerBadgeForCount matches each tier boundary from the design', () {
    expect(memorizerBadgeForCount(0), MemorizerBadge.muqbil);
    expect(memorizerBadgeForCount(1), MemorizerBadge.mubtadi);
    expect(memorizerBadgeForCount(5), MemorizerBadge.mubtadi);
    expect(memorizerBadgeForCount(6), MemorizerBadge.muthabir);
    expect(memorizerBadgeForCount(20), MemorizerBadge.muthabir);
    expect(memorizerBadgeForCount(21), MemorizerBadge.salik);
    expect(memorizerBadgeForCount(40), MemorizerBadge.salik);
    expect(memorizerBadgeForCount(41), MemorizerBadge.mujtahid);
    expect(memorizerBadgeForCount(70), MemorizerBadge.mujtahid);
    expect(memorizerBadgeForCount(71), MemorizerBadge.mutqin);
    expect(memorizerBadgeForCount(100), MemorizerBadge.mutqin);
    expect(memorizerBadgeForCount(101), MemorizerBadge.khatm);
    expect(memorizerBadgeForCount(113), MemorizerBadge.khatm);
    expect(memorizerBadgeForCount(114), MemorizerBadge.hafiz);
  });

  test('every badge has a non-empty range label', () {
    for (final badge in MemorizerBadge.values) {
      expect(badge.info.rangeLabel, isNotEmpty);
    }
  });

  test('only hafiz uses the dark card treatment', () {
    for (final badge in MemorizerBadge.values) {
      expect(badge.info.isDark, badge == MemorizerBadge.hafiz);
    }
  });
}
