import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/core/widgets/glass_card.dart';
import 'package:rainbow_flutter/core/widgets/wallet_flow_background.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/gradients.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: WalletFlowBackground(
        orbAccent: AppColors.accentBlue,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: RainbowSpacing.xxl.w),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 3.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(RainbowRadius.full),
                        gradient: RainbowGradients.accentRibbon(),
                      ),
                    ),
                    SizedBox(width: RainbowSpacing.sm.w),
                    Text(
                      'Discover',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 32.sp,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: RainbowSpacing.md.h),
                Text(
                  'Browse dapps and featured drops — wallet connect flows ship next.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15.sp,
                        color: AppColors.labelSecondary,
                        height: 1.45,
                      ),
                ),
                SizedBox(height: RainbowSpacing.xxl.h),
                GlassCard(
                  padding: EdgeInsets.all(RainbowSpacing.xl.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.hub_outlined,
                        size: 28.sp,
                        color: AppColors.accentSecondary,
                      ),
                      SizedBox(width: RainbowSpacing.lg.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Coming soon',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            SizedBox(height: RainbowSpacing.xs.h),
                            Text(
                              'Curated Web3 apps, NFT mints, and per-chain shortcuts will land here.',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.labelSecondary,
                                    height: 1.4,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: RainbowSpacing.xxl.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
