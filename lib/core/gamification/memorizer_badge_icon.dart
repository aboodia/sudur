import 'dart:math' as math;

import 'package:flutter/material.dart';

/// The 8-point rosette from the "Profils & badges" design
/// (`design/Les 8 profils et badges@1x.png`) — two overlapping squares (the
/// classic Rub el Hizb motif), stroked in the badge's color, with the
/// tier's Material icon centered inside.
class MemorizerBadgeIcon extends StatelessWidget {
  const MemorizerBadgeIcon({
    super.key,
    required this.color,
    required this.icon,
    this.size = 56,
    this.background,
  });

  final Color color;
  final IconData icon;
  final double size;
  final Color? background;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RosettePainter(color: color, background: background ?? Colors.white),
        child: Center(
          child: Icon(icon, color: color, size: size * 0.42),
        ),
      ),
    );
  }
}

class _RosettePainter extends CustomPainter {
  _RosettePainter({required this.color, required this.background});

  final Color color;
  final Color background;

  Path _square(Offset center, double radius, double rotationDegrees) {
    final path = Path();
    final angleRad = rotationDegrees * math.pi / 180;
    for (var i = 0; i < 4; i++) {
      final theta = angleRad + i * math.pi / 2 + math.pi / 4;
      final point = Offset(
        center.dx + radius * math.cos(theta),
        center.dy + radius * math.sin(theta),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * 0.92;

    final combined = Path.combine(
      PathOperation.union,
      _square(center, radius, 0),
      _square(center, radius, 45),
    );

    canvas.drawPath(combined, Paint()..color = background);
    canvas.drawPath(
      combined,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = size.width * 0.045
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _RosettePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.background != background;
}
