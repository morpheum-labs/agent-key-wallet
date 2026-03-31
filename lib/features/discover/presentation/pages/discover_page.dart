import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/gradients.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            right: -40.w,
            top: 60.h,
            child: IgnorePointer(
              child: Container(
                width: 180.w,
                height: 180.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RainbowGradients.radialGlow(
                    AppColors.accentBlue,
                    opacity: 0.2,
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
                    'Discover',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.8,
                        ),
                  ),
                  SizedBox(height: RainbowSpacing.md.h),
                  Text(
                    'Dapps and featured content — connect flows next.',
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
