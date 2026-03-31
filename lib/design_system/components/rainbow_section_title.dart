import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/design_system/gradients.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';

/// Accent ribbon + bold section heading.
class RainbowSectionTitle extends StatelessWidget {
  const RainbowSectionTitle({
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
          height: 18.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RainbowRadius.full),
            gradient: RainbowGradients.accentRibbon(),
          ),
        ),
        SizedBox(width: RainbowSpacing.sm.w),
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.35,
              ),
        ),
      ],
    );
  }
}
