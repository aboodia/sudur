import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/memorization_repository.dart';
import '../database/profile_repository.dart';
import 'goals.dart';

/// The weekly and monthly goals with where the user stands against each.
class GoalsState {
  const GoalsState({
    required this.week,
    required this.month,
    required this.defaults,
    required this.weeklyIsDefault,
    required this.monthlyIsDefault,
  });

  final GoalProgress week;
  final GoalProgress month;

  /// What the app proposes from the daily time and available days.
  final GoalPair defaults;

  /// Whether the goal shown is the proposed one (the user never set it).
  final bool weeklyIsDefault;
  final bool monthlyIsDefault;
}

/// Verses count toward a goal on the day the guided parcours validated them;
/// sourates declared in the onboarding are not progress made this week.
final goalsProvider = FutureProvider<GoalsState>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  final ayahRows = await ref
      .watch(memorizationRepositoryProvider)
      .allAyahProgress(profile.id);

  final defaults = defaultGoals(
    dailyTargetMinutes: profile.dailyTargetMinutes,
    availableDaysMask: profile.availableDaysMask,
  );
  final weeklyGoal = profile.weeklyVerseGoal ?? defaults.weekly;
  final monthlyGoal = profile.monthlyVerseGoal ?? defaults.monthly;

  final today = DateTime.now();
  final memorizedAt = [for (final r in ayahRows) r.memorizedAt];

  final wStart = weekStart(today);
  final wEnd = DateTime(wStart.year, wStart.month, wStart.day + 7);
  final mStart = monthStart(today);
  final mEnd = DateTime(mStart.year, mStart.month + 1);

  return GoalsState(
    week: goalProgress(
      goal: weeklyGoal,
      done: versesBetween(memorizedAt, wStart, wEnd),
      periodStart: wStart,
      periodEnd: wEnd,
      today: today,
    ),
    month: goalProgress(
      goal: monthlyGoal,
      done: versesBetween(memorizedAt, mStart, mEnd),
      periodStart: mStart,
      periodEnd: mEnd,
      today: today,
    ),
    defaults: defaults,
    weeklyIsDefault: profile.weeklyVerseGoal == null,
    monthlyIsDefault: profile.monthlyVerseGoal == null,
  );
});
