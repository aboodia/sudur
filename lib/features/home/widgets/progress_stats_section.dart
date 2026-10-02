import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/stats/progress_stats.dart';
import '../../../core/stats/progress_stats_provider.dart';
import '../../../l10n/app_localizations.dart';

/// "Statistiques de progression" — six figures computed from what the user
/// actually did (see [progressStatsProvider]); never invented placeholders.
class ProgressStatsSection extends ConsumerWidget {
  const ProgressStatsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final statsAsync = ref.watch(progressStatsProvider);

    return statsAsync.when(
      data: (s) {
        final retention = s.retention;
        final tiles = [
          _StatTile(
            label: l10n.statsTileVerses,
            value: '${s.memorizedAyahs}',
            caption: l10n.statsCaptionMemorized,
          ),
          _StatTile(
            label: l10n.statsTileSurahs,
            value: '${s.completedSurahs}',
            caption: l10n.statsCaptionCompleted,
          ),
          _StatTile(
            label: l10n.statsTileJuz,
            value: formatJuz(s.juz),
            caption: l10n.statsCaptionOutOf30,
          ),
          _StatTile(
            label: l10n.statsTileRetention,
            value: retention == null
                ? '—'
                : l10n.statsPercent((retention * 100).round()),
            caption: retention == null
                ? l10n.statsCaptionRetentionNone
                : l10n.statsCaptionRetention,
          ),
          _StatTile(
            label: l10n.statsTileStreak,
            value: l10n.statsDays(s.streakDays),
            caption: l10n.statsCaptionStreak,
          ),
          _StatTile(
            label: l10n.statsTileTime,
            value: formatStudyTime(s.studyTime),
            caption: l10n.statsCaptionTime,
          ),
        ];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.statsTitle, style: theme.textTheme.titleLarge),
            Text(l10n.statsSubtitle, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            for (var row = 0; row < tiles.length; row += 3) ...[
              if (row > 0) const SizedBox(height: 8),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var i = row; i < row + 3; i++) ...[
                      if (i > row) const SizedBox(width: 8),
                      Expanded(child: tiles[i]),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.caption,
  });

  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MergeSemantics(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLowest,
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.labelMedium),
            const SizedBox(height: 6),
            Text(
              value,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                // The title font's default old-style figures make "0 min"
                // read as "o min" and "1" as "I".
                fontFeatures: const [FontFeature.liningFigures()],
              ),
            ),
            const SizedBox(height: 2),
            Text(caption, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
