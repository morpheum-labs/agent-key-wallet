import 'dart:ui';

import 'package:flutter/material.dart';

import '../../design_system/blurs.dart';
import '../../design_system/colors.dart';
import '../../design_system/radius.dart';

/// Frosted panel with subtle border — Rainbow-style glass.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = RainbowRadius.xl,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: RainbowBlur.card, sigmaY: RainbowBlur.card),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surfacePrimary.withValues(alpha: 0.62),
                AppColors.surfaceSecondary.withValues(alpha: 0.42),
                AppColors.surfaceElevated.withValues(alpha: 0.28),
              ],
            ),
            border: Border.all(color: AppColors.borderGlass),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.1),
                blurRadius: 36,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
