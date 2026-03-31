import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';

/// Top row: screen title, address line, network pill.
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

    return Row(
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
                color: AppColors.accent.withValues(alpha: 0.08),
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
    );
  }
}
