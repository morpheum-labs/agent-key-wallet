import 'package:flutter/material.dart';

/// Rainbow-style semantic palette (dark-first). Refine against live Rainbow + design docs.
abstract final class AppColors {
  // Surfaces
  static const Color background = Color(0xFF0B0E23);
  static const Color surfacePrimary = Color(0xFF14182E);
  static const Color surfaceSecondary = Color(0xFF1A1F35);
  static const Color surfaceElevated = Color(0xFF252A45);

  /// Legacy alias — use [surfacePrimary].
  static const Color surface = surfacePrimary;

  // Text
  static const Color label = Color(0xFFF8F9FF);
  static const Color labelSecondary = Color(0xFF8B95B2);

  /// Legacy aliases.
  static const Color textPrimary = label;
  static const Color textSecondary = labelSecondary;

  // Brand & accents
  static const Color accent = Color(0xFF7B61FF);
  static const Color accentSecondary = Color(0xFF00D4E8);
  static const Color accentBlue = Color(0xFF0DB8FF);
  static const Color accentGreen = Color(0xFF00D395);
  static const Color accentRed = Color(0xFFFF6B8A);
  static const Color accentPurple = Color(0xFFB084FF);

  // Glass / strokes
  static const Color borderGlass = Color(0x1FFFFFFF);
  static const Color borderStrong = Color(0x33FFFFFF);

  /// Modal / sheet scrim.
  static const Color scrim = Color(0xB3000000);

  /// Dim overlay on hero imagery.
  static const Color overlay = Color(0x66000000);

  // Semantic feedback (Rainbow-style accents)
  static const Color success = accentGreen;
  static const Color warning = Color(0xFFFFB020);
  static const Color error = accentRed;

  /// Hero / marketing gradients (multi-stop).
  static const List<Color> heroGradient = [
    Color(0xFF7B61FF),
    Color(0xFF00D4E8),
    Color(0xFFB084FF),
  ];

  /// Subtle card sheen (top-left → bottom-right).
  static const List<Color> cardGradient = [
    Color(0x66252545),
    Color(0x331A1F35),
  ];
}
