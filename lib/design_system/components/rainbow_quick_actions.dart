import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/core/widgets/primary_button.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';

/// Receive / Send / optional third action — gradient CTAs + outlined tertiary.
class RainbowQuickActions extends StatelessWidget {
  const RainbowQuickActions({
    super.key,
    required this.onReceive,
    required this.onSend,
    this.onSwap,
    this.swapEnabled = true,
  });

  final VoidCallback onReceive;
  final VoidCallback onSend;
  final VoidCallback? onSwap;
  final bool swapEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                label: 'Receive',
                icon: Icons.south_west_rounded,
                onPressed: onReceive,
              ),
            ),
            SizedBox(width: RainbowSpacing.md.w),
            Expanded(
              child: PrimaryButton(
                label: 'Send',
                icon: Icons.north_east_rounded,
                onPressed: onSend,
              ),
            ),
          ],
        ),
        if (onSwap != null) ...[
          SizedBox(height: RainbowSpacing.md.h),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: swapEnabled ? onSwap : null,
              icon: Icon(Icons.swap_horiz_rounded, size: 22.sp, color: AppColors.label),
              label: Text(
                'Swap',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: RainbowSpacing.md.h),
                side: const BorderSide(color: AppColors.borderGlass),
                foregroundColor: AppColors.label,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(RainbowRadius.md),
                ),
                backgroundColor: AppColors.surfacePrimary.withValues(alpha: 0.35),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
