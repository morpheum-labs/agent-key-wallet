import 'package:flutter/material.dart';

import 'colors.dart';

abstract final class RainbowGradients {
  static RadialGradient heroOrb(Color center, {AlignmentGeometry alignment = Alignment.topLeft}) {
    return RadialGradient(
      center: alignment,
      radius: 0.95,
      colors: [
        center.withValues(alpha: 0.45),
        Colors.transparent,
      ],
    );
  }

  static RadialGradient radialGlow(Color color, {double opacity = 0.28}) {
    return RadialGradient(
      colors: [
        color.withValues(alpha: opacity),
        Colors.transparent,
      ],
    );
  }

  static LinearGradient cardSheen() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: AppColors.cardGradient,
    );
  }

  static LinearGradient ctaShimmer() {
    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        AppColors.accent,
        AppColors.accentSecondary,
        AppColors.accentPurple,
      ],
      stops: [0.0, 0.55, 1.0],
    );
  }
}
