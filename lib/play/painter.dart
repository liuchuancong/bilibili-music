import 'dart:math' as math show sqrt;
import 'package:flutter/material.dart';

/// A custom painter that renders a ring of [n] circles at time [t].
class RingOfCirclesPainter extends CustomPainter {
  final Color color;
  final double animation;

  RingOfCirclesPainter(this.color, this.animation);
  void circle(Canvas canvas, Rect rect, double value) {
    final double opacity = (1.0 - (value / 4.0)).clamp(0.0, 1.0);
    final Color rawColor = color.withValues(alpha: opacity);

    final double size = rect.width / 2;
    final double area = size * size;
    final double radius = math.sqrt(area * value / 4);

    final Paint paint = Paint()..color = rawColor;
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    for (int wave = 3; wave >= 0; wave--) {
      circle(canvas, rect, wave + animation);
    }
  }

  @override
  bool shouldRepaint(RingOfCirclesPainter oldDelegate) => oldDelegate != this;
}
