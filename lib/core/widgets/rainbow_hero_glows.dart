import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/gradients.dart';

/// Decorative radial glows for wallet-style screens (ignore pointer; purely visual).
class RainbowHeroGlows extends StatelessWidget {
  const RainbowHeroGlows({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: -70.w,
          top: 90.h,
          child: IgnorePointer(
            child: Container(
              width: 260.w,
              height: 260.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RainbowGradients.radialGlow(
                  AppColors.accentSecondary,
                  opacity: 0.32,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: -50.w,
          top: 200.h,
          child: IgnorePointer(
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RainbowGradients.radialGlow(
                  AppColors.accentPurple,
                  opacity: 0.22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
