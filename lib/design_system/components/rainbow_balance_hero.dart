import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';

/// Large centered balance with springy swap when [balanceText] changes.
class RainbowBalanceHero extends StatelessWidget {
  const RainbowBalanceHero({
    super.key,
    required this.caption,
    required this.balanceText,
    required this.footer,
  });

  final String caption;
  final String balanceText;
  final String footer;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          caption,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            fontSize: 14.sp,
            color: AppColors.labelSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: RainbowSpacing.md.h),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 420),
          switchInCurve: Curves.elasticOut,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.94, end: 1.0).animate(
                  CurvedAnimation(parent: animation, curve: Curves.elasticOut),
                ),
                child: child,
              ),
            );
          },
          child: Text(
            balanceText,
            key: ValueKey<String>(balanceText),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.displayLarge?.copyWith(
              fontSize: 44.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
              height: 1.02,
            ),
          ),
        ),
        SizedBox(height: RainbowSpacing.sm.h),
        Text(
          footer,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(
            fontSize: 12.5.sp,
            color: AppColors.labelSecondary,
          ),
        ),
      ],
    );
  }
}
