import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/design_system/gradients.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';

/// Large screen title with accent ribbon (Activity, Discover, Profile, etc.).
class RainbowPageTitle extends StatelessWidget {
  const RainbowPageTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 3.w,
          height: 22.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RainbowRadius.full),
            gradient: RainbowGradients.accentRibbon(),
          ),
        ),
        SizedBox(width: RainbowSpacing.sm.w),
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                ),
          ),
        ),
      ],
    );
  }
}
