import 'package:flutter/material.dart';

import '../../../core/format/french_date.dart';
import '../../../l10n/app_localizations.dart';

/// The cumulative number of memorized verses over a period, one point per
/// day. The vertical scale runs from the figure at the start of the period
/// to the figure now, so a small gain is still visible on a long history.
class ProgressCurve extends StatelessWidget {
  const ProgressCurve({
    super.key,
    required this.series,
    required this.start,
    required this.end,
    this.height = 160,
  });

  /// Total memorized at the end of each day, oldest first.
  final List<int> series;
  final DateTime start;
  final DateTime end;
  final double height;

  String _shortDate(DateTime d) => '${d.day} ${frenchMonth(d.month)}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    if (series.isEmpty) return SizedBox(height: height);

    final first = series.first;
    final last = series.last;

    return Semantics(
      label: l10n.curveSemantics(first, last),
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: height,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _CurvePainter(
                        series: series,
                        lineColor: theme.colorScheme.primary,
                        gridColor: theme.colorScheme.outlineVariant,
                      ),
                    ),
                  ),
                  // Set back from the edge: the line ends there, and would run
                  // through the figure.
                  Positioned(
                    top: 0,
                    right: 14,
                    child: Text('$last', style: theme.textTheme.labelMedium),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: Text('$first', style: theme.textTheme.labelMedium),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_shortDate(start), style: theme.textTheme.bodySmall),
                Text(_shortDate(end), style: theme.textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CurvePainter extends CustomPainter {
  _CurvePainter({
    required this.series,
    required this.lineColor,
    required this.gridColor,
  });

  final List<int> series;
  final Color lineColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    const pad = 6.0;
    final w = size.width;
    final h = size.height;

    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    canvas.drawLine(Offset(0, h - pad), Offset(w, h - pad), grid);
    canvas.drawLine(const Offset(0, pad), Offset(w, pad), grid);

    final min = series.first;
    final max = series.last;
    final range = (max - min).toDouble();

    Offset point(int i) {
      final x = series.length == 1 ? w : i / (series.length - 1) * w;
      // No change over the period: a flat line along the bottom.
      final t = range == 0 ? 0.0 : (series[i] - min) / range;
      return Offset(x, h - pad - t * (h - 2 * pad));
    }

    final line = Path()..moveTo(point(0).dx, point(0).dy);
    for (var i = 1; i < series.length; i++) {
      final p = point(i);
      line.lineTo(p.dx, p.dy);
    }

    final area = Path.from(line)
      ..lineTo(w, h - pad)
      ..lineTo(0, h - pad)
      ..close();
    canvas.drawPath(area, Paint()..color = lineColor.withValues(alpha: 0.15));
    canvas.drawPath(
      line,
      Paint()
        ..color = lineColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );
    canvas.drawCircle(point(series.length - 1), 4, Paint()..color = lineColor);
  }

  @override
  bool shouldRepaint(_CurvePainter old) =>
      old.series != series ||
      old.lineColor != lineColor ||
      old.gridColor != gridColor;
}
