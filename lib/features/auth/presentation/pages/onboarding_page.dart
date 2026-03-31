import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:rainbow_flutter/core/theme/app_colors.dart';
import 'package:rainbow_flutter/core/widgets/glass_card.dart';
import 'package:rainbow_flutter/core/widgets/primary_button.dart';
import 'package:rainbow_flutter/core/widgets/wallet_flow_background.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: WalletFlowBackground(
        orbAccent: AppColors.accent,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: RainbowSpacing.xxl.w,
              vertical: RainbowSpacing.lg.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: RainbowSpacing.xxl.h),
                Text(
                  'Your keys,\nyour crypto.',
                  style: textTheme.displayLarge?.copyWith(
                    fontSize: 36.sp,
                    height: 1.05,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                )
                    .animate()
                    .fadeIn(duration: 450.ms)
                    .slideX(begin: -0.04, end: 0, curve: Curves.easeOutCubic),
                SizedBox(height: RainbowSpacing.md.h),
                Text(
                  'Create a new wallet or import an existing one. Keys stay on-device.',
                  style: textTheme.bodyMedium?.copyWith(
                    fontSize: 15.sp,
                    color: AppColors.labelSecondary,
                    height: 1.45,
                  ),
                ).animate().fadeIn(delay: 120.ms, duration: 400.ms),
                const Spacer(),
                GlassCard(
                  padding: EdgeInsets.all(RainbowSpacing.lg.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryButton(
                        label: 'Create a new wallet',
                        icon: Icons.add_rounded,
                        onPressed: () => context.push('/create'),
                      ),
                      SizedBox(height: RainbowSpacing.md.h),
                      OutlinedButton(
                        onPressed: () => context.push('/import'),
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: RainbowSpacing.md.h),
                          side: const BorderSide(color: AppColors.borderGlass),
                          foregroundColor: AppColors.label,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(RainbowRadius.md),
                          ),
                        ),
                        child: Text(
                          'I already have a wallet',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms).moveY(begin: 12, end: 0),
                SizedBox(height: RainbowSpacing.xxl.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
