import 'package:flutter/material.dart';

import 'colors.dart';

/// Extra Rainbow tokens reachable via `Theme.of(context).extension<RainbowThemeExtension>()`.
@immutable
class RainbowThemeExtension extends ThemeExtension<RainbowThemeExtension> {
  const RainbowThemeExtension({
    required this.accentBlue,
    required this.accentGreen,
    required this.accentRed,
    required this.accentPurple,
  });

  final Color accentBlue;
  final Color accentGreen;
  final Color accentRed;
  final Color accentPurple;

  static const RainbowThemeExtension dark = RainbowThemeExtension(
    accentBlue: AppColors.accentBlue,
    accentGreen: AppColors.accentGreen,
    accentRed: AppColors.accentRed,
    accentPurple: AppColors.accentPurple,
  );

  @override
  RainbowThemeExtension copyWith({
    Color? accentBlue,
    Color? accentGreen,
    Color? accentRed,
    Color? accentPurple,
  }) {
    return RainbowThemeExtension(
      accentBlue: accentBlue ?? this.accentBlue,
      accentGreen: accentGreen ?? this.accentGreen,
      accentRed: accentRed ?? this.accentRed,
      accentPurple: accentPurple ?? this.accentPurple,
    );
  }

  @override
  RainbowThemeExtension lerp(ThemeExtension<RainbowThemeExtension>? other, double t) {
    if (other is! RainbowThemeExtension) return this;
    return RainbowThemeExtension(
      accentBlue: Color.lerp(accentBlue, other.accentBlue, t)!,
      accentGreen: Color.lerp(accentGreen, other.accentGreen, t)!,
      accentRed: Color.lerp(accentRed, other.accentRed, t)!,
      accentPurple: Color.lerp(accentPurple, other.accentPurple, t)!,
    );
  }
}
