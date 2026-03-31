import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/components/rainbow_mini_sparkline.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';

/// Token / asset row: avatar, titles, fiat, optional % + sparkline (Rainbow-style).
class RainbowTokenAssetRow extends StatelessWidget {
  const RainbowTokenAssetRow({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailingPrimary,
    this.percentLabel,
    this.showSparkline = true,
    this.sparklineSeed = 0,
    this.sparklineValues,
    this.percentIsPositive,
    required this.onTap,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final String trailingPrimary;
  final String? percentLabel;
  final bool showSparkline;
  final int sparklineSeed;
  final List<double>? sparklineValues;
  final bool? percentIsPositive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final positive = percentIsPositive ?? true;

    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RainbowRadius.md),
          border: Border.all(color: AppColors.borderGlass),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surfacePrimary.withValues(alpha: 0.72),
              AppColors.surfaceSecondary.withValues(alpha: 0.45),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(RainbowRadius.md),
          splashColor: AppColors.accent.withValues(alpha: 0.12),
          highlightColor: AppColors.accent.withValues(alpha: 0.06),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: RainbowSpacing.lg.w,
              vertical: RainbowSpacing.md.h,
            ),
            child: Row(
              children: [
                leading,
                SizedBox(width: RainbowSpacing.lg.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: textTheme.titleMedium?.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      SizedBox(height: RainbowSpacing.xxs.h),
                      Text(
                        subtitle,
                        style: textTheme.bodySmall?.copyWith(
                          fontSize: 13.sp,
                          color: AppColors.labelSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (showSparkline) ...[
                  RainbowMiniSparkline(
                    seed: sparklineSeed,
                    isPositive: positive,
                    values: sparklineValues,
                  ),
                  SizedBox(width: RainbowSpacing.sm.w),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      trailingPrimary,
                      style: textTheme.titleMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    if (percentLabel != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        percentLabel!,
                        style: textTheme.labelSmall?.copyWith(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: _percentColor(percentLabel!, positive),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(width: RainbowSpacing.xs.w),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22.sp,
                  color: AppColors.labelSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color _percentColor(String label, bool positive) {
  if (label == '—' || label == '--') {
    return AppColors.labelSecondary;
  }
  return positive ? AppColors.accentGreen : AppColors.accentRed;
}

