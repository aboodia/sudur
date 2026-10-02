import 'package:flutter/material.dart';

import '../../../core/stats/progress_history.dart';
import '../../../l10n/app_localizations.dart';

/// The 604 pages of the Mushaf as a grid, each colored by how much of it is
/// memorized. Cells are far smaller than a touch target, so tapping one is
/// a shortcut to that page, not the way the map is read: the whole map is
/// announced as one summary.
class MushafMap extends StatelessWidget {
  const MushafMap({super.key, required this.coverage, this.onPageTap});

  /// Memorized share of each page (index 0 = page 1).
  final List<double> coverage;
  final void Function(int page)? onPageTap;

  static const columns = 20;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final full = completePages(coverage);
    final partial = partialPages(coverage);

    Color colorFor(double c) {
      if (c <= 0) return scheme.surfaceContainerHighest;
      if (c >= 1) return scheme.primary;
      return Color.lerp(
        scheme.primary.withValues(alpha: 0.3),
        scheme.primary.withValues(alpha: 0.75),
        c,
      )!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          label: l10n.mapSummary(full, partial, coverage.length),
          child: ExcludeSemantics(
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: coverage.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemBuilder: (context, index) => GestureDetector(
                onTap: onPageTap == null ? null : () => onPageTap!(index + 1),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorFor(coverage[index]),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.mapSummary(full, partial, coverage.length),
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 4,
          children: [
            _LegendDot(color: colorFor(0), label: l10n.mapLegendNone),
            _LegendDot(color: colorFor(0.5), label: l10n.mapLegendPartial),
            _LegendDot(color: colorFor(1), label: l10n.mapLegendFull),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
