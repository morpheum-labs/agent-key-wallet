import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:rainbow_flutter/design_system/colors.dart';

/// Mini trend line — uses [values] when provided (0..1), else a seeded decorative path.
class RainbowMiniSparkline extends StatelessWidget {
  const RainbowMiniSparkline({
    super.key,
    this.seed = 0,
    this.isPositive = true,
    this.values,
  });

  final int seed;
  final bool isPositive;
  final List<double>? values;

  @override
  Widget build(BuildContext context) {
    final color = isPositive ? AppColors.accentGreen : AppColors.accentRed;

    return CustomPaint(
      size: const Size(48, 22),
      painter: values != null && values!.length >= 2
          ? _ValueSparkPainter(values: values!, color: color)
          : _SeedSparkPainter(seed: seed, color: color),
    );
  }
}

class _SeedSparkPainter extends CustomPainter {
  _SeedSparkPainter({required this.seed, required this.color});

  final int seed;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = math.Random(seed);
    final path = Path();
    const n = 12;
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
  bool shouldRepaint(covariant _SeedSparkPainter oldDelegate) =>
      oldDelegate.seed != seed || oldDelegate.color != color;
}

class _ValueSparkPainter extends CustomPainter {
  _ValueSparkPainter({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    var minV = values.first;
    var maxV = values.first;
    for (final v in values) {
      if (v < minV) minV = v;
      if (v > maxV) maxV = v;
    }
    final span = (maxV - minV).abs() < 1e-9 ? 1.0 : (maxV - minV);

    final path = Path();
    final n = values.length;
    for (var i = 0; i < n; i++) {
      final t = n == 1 ? 0.0 : i / (n - 1);
      final x = t * size.width;
      final norm = (values[i] - minV) / span;
      final y = size.height * (0.88 - norm * 0.76);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final paint = Paint()
      ..color = color.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ValueSparkPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.values != values;
}
