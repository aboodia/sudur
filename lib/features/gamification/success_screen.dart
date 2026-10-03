import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/format/french_date.dart';
import '../../core/gamification/achievements.dart';
import '../../core/gamification/achievements_provider.dart';
import '../../core/gamification/streak.dart';
import '../../core/stats/progress_stats.dart';
import '../../core/stats/progress_stats_provider.dart';
import '../../l10n/app_localizations.dart';

/// Régularité et succès: the streak with its jokers, then every badge —
/// earned ones with their date, the others with how far along they are.
class SuccessScreen extends ConsumerStatefulWidget {
  const SuccessScreen({super.key});

  @override
  ConsumerState<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends ConsumerState<SuccessScreen> {
  // The badges that were new when the user arrived. They stay highlighted
  // while the screen is open even though they are marked as seen right
  // away, so that leaving never has to write anything.
  Set<String>? _newKeys;

  void _rememberNewBadges(AchievementsState state) {
    if (_newKeys != null) return;
    _newKeys = {
      for (final item in state.items)
        if (item.isNew) item.def.key,
    };
    if (_newKeys!.isNotEmpty) {
      final container = ProviderScope.containerOf(context, listen: false);
      Future.microtask(() => markAchievementsSeen(container));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final statsAsync = ref.watch(progressStatsProvider);
    final achievementsAsync = ref.watch(achievementsProvider);
    achievementsAsync.whenData(_rememberNewBadges);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.successTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            statsAsync.when(
              data: (stats) => _StreakCard(streak: stats.streak),
              loading: () => const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, _) => Text('Erreur : $err'),
            ),
            const SizedBox(height: 32),
            achievementsAsync.when(
              data: (state) => _Badges(state: state, newKeys: _newKeys ?? {}),
              loading: () => const SizedBox.shrink(),
              error: (err, _) => Text('Erreur : $err'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.streak});

  final StreakState streak;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final s = streak;

    final String status;
    if (s.current == 0) {
      status = l10n.streakNone;
    } else if (s.activeToday) {
      status = l10n.streakDoneToday;
    } else if (s.atRisk) {
      status = l10n.streakAtRisk;
    } else {
      status = '';
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.streakTitle, style: theme.textTheme.titleLarge),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.local_fire_department,
                size: 40,
                color: theme.colorScheme.tertiary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.streakCurrent(s.current),
                      style: theme.textTheme.titleMedium,
                    ),
                    if (s.longest > 0)
                      Text(
                        l10n.streakBest(s.longest),
                        style: theme.textTheme.bodyMedium,
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (status.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(status, style: theme.textTheme.bodyMedium),
          ],
          const Divider(height: 28),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.streakJokersTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              for (var i = 0; i < maxJokers; i++)
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 4),
                  child: Icon(
                    i < s.jokersLeft ? Icons.style : Icons.style_outlined,
                    color: i < s.jokersLeft
                        ? theme.colorScheme.tertiary
                        : theme.colorScheme.outline,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l10n.streakJokersLeft(s.jokersLeft),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            s.daysToNextJoker == null
                ? l10n.streakJokerFull
                : l10n.streakNextJoker(s.daysToNextJoker!),
            style: theme.textTheme.bodyMedium,
          ),
          if (s.lastCoveredDay != null) ...[
            const SizedBox(height: 8),
            Text(
              l10n.streakCovered(frenchDateLabel(s.lastCoveredDay!)),
              style: theme.textTheme.bodyMedium,
            ),
          ],
          const SizedBox(height: 12),
          Text(l10n.streakJokerExplain, style: theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(l10n.streakRestDays, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _Badges extends StatelessWidget {
  const _Badges({required this.state, required this.newKeys});

  final AchievementsState state;
  final Set<String> newKeys;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.badgesTitle, style: theme.textTheme.titleLarge),
            ),
            Text(
              l10n.badgesCount(state.earnedCount, state.items.length),
              style: theme.textTheme.titleSmall,
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final item in state.items) ...[
          _BadgeTile(item: item, isNew: newKeys.contains(item.def.key)),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

String achievementTitle(AppLocalizations l10n, AchievementDef def) {
  final n = def.target;
  return switch (def.kind) {
    AchievementKind.verses =>
      n == 1 ? l10n.achTitleFirstVerse : l10n.achTitleVerses(n),
    AchievementKind.juz =>
      def.isKhatm
          ? l10n.achTitleKhatm
          : (n == 1 ? l10n.achTitleFirstJuz : l10n.achTitleJuz(n)),
    AchievementKind.streak => l10n.achTitleStreak(n),
  };
}

String achievementDescription(AppLocalizations l10n, AchievementDef def) {
  final n = def.target;
  return switch (def.kind) {
    AchievementKind.verses =>
      n == 1 ? l10n.achDescFirstVerse : l10n.achDescVerses(n),
    AchievementKind.juz =>
      def.isKhatm
          ? l10n.achDescKhatm
          : (n == 1 ? l10n.achDescFirstJuz : l10n.achDescJuz(n)),
    AchievementKind.streak => l10n.achDescStreak(n),
  };
}

IconData achievementIcon(AchievementDef def) => switch (def.kind) {
  AchievementKind.verses => Icons.menu_book_outlined,
  AchievementKind.juz =>
    def.isKhatm ? Icons.workspace_premium : Icons.auto_stories,
  AchievementKind.streak => Icons.local_fire_department,
};

class _BadgeTile extends StatelessWidget {
  const _BadgeTile({required this.item, required this.isNew});

  final AchievementItem item;
  final bool isNew;

  String _figure(double v, AchievementKind kind) =>
      kind == AchievementKind.juz ? formatJuz(v) : '${v.floor()}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final def = item.def;
    final earned = item.earned;
    final color = earned
        ? theme.colorScheme.tertiary
        : theme.colorScheme.outline;

    return Semantics(
      container: true,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: earned
              ? theme.colorScheme.tertiaryContainer.withValues(alpha: 0.35)
              : null,
          border: Border.all(
            color: isNew
                ? theme.colorScheme.tertiary
                : theme.colorScheme.outlineVariant,
            width: isNew ? 1.5 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(
              earned ? achievementIcon(def) : Icons.lock_outline,
              size: 32,
              color: color,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          achievementTitle(l10n, def),
                          style: theme.textTheme.titleMedium,
                        ),
                      ),
                      if (isNew) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            l10n.badgeNew,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onTertiary,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    earned
                        ? l10n.badgeEarnedOn(frenchFullDate(item.unlockedAt!))
                        : achievementDescription(l10n, def),
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (!earned) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: item.status.progress,
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.badgeProgress(
                        _figure(item.status.value, def.kind),
                        '${def.target}',
                      ),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
