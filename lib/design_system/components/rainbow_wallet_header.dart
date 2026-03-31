import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/design_system/blurs.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/gradients.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';

/// Top row: screen title, address line, network pill — frosted glass + accent wash.
class RainbowWalletHeader extends StatelessWidget {
  const RainbowWalletHeader({
    super.key,
    required this.title,
    required this.addressLine,
    required this.networkLabel,
  });

  final String title;
  final String addressLine;
  final String networkLabel;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(RainbowRadius.lg),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: RainbowBlur.subtle,
          sigmaY: RainbowBlur.subtle,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RainbowRadius.lg),
            border: Border.all(color: AppColors.borderGlass),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surfacePrimary.withValues(alpha: 0.55),
                AppColors.surfaceSecondary.withValues(alpha: 0.38),
                AppColors.accent.withValues(alpha: 0.06),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RainbowGradients.heroOrb(
                      AppColors.accentSecondary,
                      alignment: Alignment.topRight,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: RainbowSpacing.lg.w,
                  vertical: RainbowSpacing.md.h,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: textTheme.headlineMedium?.copyWith(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.6,
                            ),
                          ),
                          SizedBox(height: RainbowSpacing.xs.h),
                          Text(
                            addressLine,
                            style: textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                              color: AppColors.labelSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: RainbowSpacing.md.w,
                        vertical: RainbowSpacing.sm.h,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(RainbowRadius.full),
                        border: Border.all(color: AppColors.borderGlass),
                        gradient: LinearGradient(
                          colors: [
                            AppColors.surfacePrimary.withValues(alpha: 0.85),
                            AppColors.surfaceSecondary.withValues(alpha: 0.65),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Text(
                        networkLabel,
                        style: textTheme.labelMedium?.copyWith(
                          fontSize: 12.sp,
                          color: AppColors.label,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
