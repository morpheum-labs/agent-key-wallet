import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:rainbow_flutter/design_system/colors.dart';

/// Decorative mini trend line until real price history exists.
class RainbowMiniSparkline extends StatelessWidget {
  const RainbowMiniSparkline({
    super.key,
    required this.seed,
    this.isPositive = true,
  });

  /// Derive a stable path from symbol or id.
  final int seed;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppColors.accentGreen : AppColors.accentRed;

    return CustomPaint(
      size: const Size(48, 22),
      painter: _SparkPainter(seed: seed, color: color),
    );
  }
}

class _SparkPainter extends CustomPainter {
  _SparkPainter({required this.seed, required this.color});

  final int seed;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(seed);
    final path = Path();
    final n = 12;
    for (var i = 0; i <= n; i++) {
      final t = i / n;
      final x = t * size.width;
      final wobble = rnd.nextDouble() * 0.35 + 0.65;
      final y = size.height * (0.75 - t * 0.45 * wobble);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final paint = Paint()
      ..color = color.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparkPainter oldDelegate) =>
      oldDelegate.seed != seed || oldDelegate.color != color;
}
