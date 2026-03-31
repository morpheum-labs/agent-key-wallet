import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/gradients.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: -30.w,
            top: 100.h,
            child: IgnorePointer(
              child: Container(
                width: 160.w,
                height: 160.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RainbowGradients.radialGlow(
                    AppColors.accentGreen,
                    opacity: 0.18,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: RainbowSpacing.xxl.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Activity',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.8,
                        ),
                  ),
                  SizedBox(height: RainbowSpacing.md.h),
                  Text(
                    'Transaction history will appear here.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 15.sp,
                          color: AppColors.labelSecondary,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
