import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:rainbow_flutter/design_system/blurs.dart';
import 'package:rainbow_flutter/design_system/colors.dart';

/// Frosted glass panel (list row density) — shared by token rows, activity rows, etc.
class RainbowGlassSurface extends StatelessWidget {
  const RainbowGlassSurface({
    super.key,
    required this.borderRadius,
    required this.child,
    this.blurSigma = RainbowBlur.card,
  });

  final BorderRadius borderRadius;
  final Widget child;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: Border.all(color: AppColors.borderGlass),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surfacePrimary.withValues(alpha: 0.58),
                AppColors.surfaceSecondary.withValues(alpha: 0.38),
                AppColors.surfaceElevated.withValues(alpha: 0.22),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.22),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
