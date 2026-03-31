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

  /// Wallet / home backdrop — top-heavy blue → purple wash.
  static LinearGradient walletBackdrop() {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF1A1B4A),
        Color(0xFF0B0E23),
        Color(0xFF0B0E23),
      ],
      stops: [0.0, 0.42, 1.0],
    );
  }

  /// Accent stripe behind balance or CTA row.
  static LinearGradient accentRibbon() {
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        AppColors.accentBlue,
        AppColors.accent,
        AppColors.accentPurple,
      ],
      stops: [0.0, 0.5, 1.0],
    );
  }

  /// Subtle vertical fade for lists over gradient bg.
  static LinearGradient listFadeToBackground() {
    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0x000B0E23),
        Color(0xFF0B0E23),
      ],
    );
  }
}
