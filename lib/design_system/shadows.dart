import 'package:flutter/material.dart';

import 'colors.dart';

/// Preset shadows for depth + glow (Rainbow-style soft elevation).
abstract final class RainbowShadows {
  static List<BoxShadow> softCard({Color? accentTint}) {
    return [
      BoxShadow(
        color: (accentTint ?? AppColors.accent).withValues(alpha: 0.12),
        blurRadius: 32,
        offset: const Offset(0, 16),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.35),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ];
  }

  static List<BoxShadow> subtleLift() => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];

  static List<BoxShadow> tabBarGlow(Color accent) => [
        BoxShadow(
          color: accent.withValues(alpha: 0.18),
          blurRadius: 20,
          spreadRadius: -4,
          offset: const Offset(0, 4),
        ),
      ];
}
