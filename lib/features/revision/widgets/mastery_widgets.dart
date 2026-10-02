import 'package:flutter/material.dart';

import '../../../core/memorization/mastery.dart';
import '../../../l10n/app_localizations.dart';

/// Faible = terre cuite, moyen = bleu atténué, solide = bleu Sudur. The
/// meaning is always spelled out next to the color ([MasteryLegend]) — it is
/// never carried by color alone.
Color masteryColor(ColorScheme scheme, MasteryLevel level) => switch (level) {
  MasteryLevel.weak => scheme.tertiary,
  MasteryLevel.medium => scheme.primary.withValues(alpha: 0.45),
  MasteryLevel.solid => scheme.primary,
};

String masteryLabel(AppLocalizations l10n, MasteryLevel level) =>
    switch (level) {
      MasteryLevel.weak => l10n.masteryWeak,
      MasteryLevel.medium => l10n.masteryMedium,
      MasteryLevel.solid => l10n.masterySolid,
    };

int _countOf(MasteryCounts counts, MasteryLevel level) => switch (level) {
  MasteryLevel.weak => counts.weak,
  MasteryLevel.medium => counts.medium,
  MasteryLevel.solid => counts.solid,
};

/// A thin stacked bar: how a set of verses splits across the three levels.
class MasteryBar extends StatelessWidget {
  const MasteryBar({super.key, required this.counts, this.height = 8});

  final MasteryCounts counts;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ExcludeSemantics(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(height / 2),
        child: SizedBox(
          height: height,
          child: counts.total == 0
              ? ColoredBox(color: scheme.surfaceContainerHighest)
              : Row(
                  // Stretch: otherwise the segments get a loose height and
                  // collapse to nothing.
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final level in MasteryLevel.values)
                      if (_countOf(counts, level) > 0)
                        Expanded(
                          flex: _countOf(counts, level),
                          child: ColoredBox(color: masteryColor(scheme, level)),
                        ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// "● Faible · 3   ● Moyen · 5   ● Solide · 12" — only the levels that
/// have at least one verse.
class MasteryLegend extends StatelessWidget {
  const MasteryLegend({super.key, required this.counts});

  final MasteryCounts counts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Wrap(
      spacing: 16,
      runSpacing: 4,
      children: [
        for (final level in MasteryLevel.values)
          if (_countOf(counts, level) > 0)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: masteryColor(theme.colorScheme, level),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.revisionResultLine(
                    masteryLabel(l10n, level),
                    _countOf(counts, level),
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
      ],
    );
  }
}
