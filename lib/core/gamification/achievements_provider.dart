import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../database/achievement_repository.dart';
import '../database/profile_repository.dart';
import '../stats/progress_stats_provider.dart';
import 'achievements.dart';

/// One badge with what is known about it: how far along, and — once earned
/// — when, and whether the user has seen it yet.
class AchievementItem {
  const AchievementItem({
    required this.status,
    required this.unlockedAt,
    required this.isNew,
  });

  final AchievementStatus status;
  final DateTime? unlockedAt;

  /// Earned but not yet seen on the badge screen.
  final bool isNew;

  AchievementDef get def => status.def;
  bool get earned => unlockedAt != null;
}

class AchievementsState {
  const AchievementsState(this.items);

  final List<AchievementItem> items;

  int get earnedCount => items.where((i) => i.earned).length;
  int get newCount => items.where((i) => i.isNew).length;
}

/// The badges against the user's real figures. Reading this is also what
/// records a newly reached badge: it is kept from then on, even if the
/// figure that earned it later drops (a streak that ends).
final achievementsProvider = FutureProvider<AchievementsState>((ref) async {
  final profile = await ref.watch(currentProfileProvider.future);
  final stats = await ref.watch(progressStatsProvider.future);
  final repo = ref.watch(achievementRepositoryProvider);

  final statuses = evaluateAchievements(
    verses: stats.memorizedAyahs,
    juz: stats.juz,
    bestStreak: stats.streak.longest,
  );

  final known = {
    for (final u in await repo.unlocked(profile.id)) u.achievementKey,
  };
  final fresh = [
    for (final s in statuses)
      if (s.reached && !known.contains(s.def.key)) s.def.key,
  ];
  if (fresh.isNotEmpty) await repo.unlock(profile.id, fresh, DateTime.now());

  final rows = {
    for (final u in await repo.unlocked(profile.id)) u.achievementKey: u,
  };
  return AchievementsState([
    for (final s in statuses)
      AchievementItem(
        status: s,
        unlockedAt: rows[s.def.key]?.unlockedAt,
        isNew: rows[s.def.key] != null && rows[s.def.key]!.seenAt == null,
      ),
  ]);
});

/// The user has now seen the badges earned so far.
Future<void> markAchievementsSeen(ProviderContainer container) async {
  final profile = await container.read(currentProfileProvider.future);
  await container
      .read(achievementRepositoryProvider)
      .markAllSeen(profile.id, DateTime.now());
  container.invalidate(achievementsProvider);
}
