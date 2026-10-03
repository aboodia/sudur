import 'package:flutter_test/flutter_test.dart';
import 'package:sudur/core/gamification/achievements.dart';

void main() {
  Set<String> earned({int verses = 0, double juz = 0, int bestStreak = 0}) => {
    for (final s in evaluateAchievements(
      verses: verses,
      juz: juz,
      bestStreak: bestStreak,
    ))
      if (s.reached) s.def.key,
  };

  test('a newcomer has earned nothing', () {
    expect(earned(), isEmpty);
  });

  test('the first verse is the first badge', () {
    expect(earned(verses: 1), {'verses_1'});
  });

  test('verse badges stack as the count grows', () {
    expect(earned(verses: 100), {'verses_1', 'verses_100'});
    expect(earned(verses: 99), {'verses_1'});
    expect(earned(verses: 1000), containsAll(['verses_100', 'verses_1000']));
  });

  test('Juz badges follow the Juz memorized', () {
    expect(earned(juz: 0.99), isNot(contains('juz_1')));
    expect(earned(juz: 1), contains('juz_1'));
    expect(earned(juz: 5.2), containsAll(['juz_1', 'juz_5']));
    expect(earned(juz: 5.2), isNot(contains('juz_10')));
  });

  test('a whole Juz summed from fractions still counts', () {
    // 148 verses, each worth 1/148: the sum can land just under 1.
    var juz = 0.0;
    for (var i = 0; i < 148; i++) {
      juz += 1 / 148;
    }
    expect(earned(juz: juz), contains('juz_1'));
  });

  test('the full Quran is the last Juz badge', () {
    final defs = achievementDefs.where((d) => d.kind == AchievementKind.juz);
    expect(defs.last.target, 30);
    expect(defs.last.isKhatm, isTrue);
    expect(earned(juz: 30), contains('juz_30'));
  });

  test('regularity badges follow the best streak, not the current one', () {
    expect(earned(bestStreak: 7), {'streak_3', 'streak_7'});
    expect(earned(bestStreak: 2), isEmpty);
    expect(earned(bestStreak: 365), contains('streak_365'));
  });

  test('progress runs from 0 to 1 and never beyond', () {
    final status = evaluateAchievements(verses: 50, juz: 0, bestStreak: 0);
    final hundred = status.firstWhere((s) => s.def.key == 'verses_100');
    expect(hundred.progress, 0.5);
    final first = status.firstWhere((s) => s.def.key == 'verses_1');
    expect(first.progress, 1.0);
  });

  test('keys are unique', () {
    final keys = achievementDefs.map((d) => d.key).toList();
    expect(keys.toSet(), hasLength(keys.length));
  });
}
