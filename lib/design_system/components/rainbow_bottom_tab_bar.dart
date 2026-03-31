import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/design_system/blurs.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/radius.dart';

/// Default tabs for the main wallet shell (Wallet · Discover · Activity · Profile).
const List<({IconData icon, String label})> kRainbowMainTabItems = [
  (icon: Icons.account_balance_wallet_rounded, label: 'Wallet'),
  (icon: Icons.explore_outlined, label: 'Discover'),
  (icon: Icons.swap_horiz_rounded, label: 'Activity'),
  (icon: Icons.person_outline_rounded, label: 'Profile'),
];

/// Frosted bar with pill selection, elastic scale, and accent glow.
class RainbowBottomTabBar extends StatelessWidget {
  const RainbowBottomTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.items = kRainbowMainTabItems,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<({IconData icon, String label})> items;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: RainbowBlur.subtle,
          sigmaY: RainbowBlur.subtle,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: AppColors.borderGlass),
            ),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.surfacePrimary.withValues(alpha: 0.92),
                AppColors.background.withValues(alpha: 0.98),
              ],
            ),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: 60.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (var i = 0; i < items.length; i++)
                    Expanded(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => onTap(i),
                          splashColor: AppColors.accent.withValues(alpha: 0.12),
                          child: Center(
                            child: AnimatedScale(
                              scale: i == currentIndex ? 1.06 : 1.0,
                              duration: const Duration(milliseconds: 520),
                              curve: Curves.elasticOut,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 260),
                                curve: Curves.easeOutCubic,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(RainbowRadius.full),
                                  gradient: i == currentIndex
                                      ? LinearGradient(
                                          colors: [
                                            AppColors.accent.withValues(alpha: 0.22),
                                            AppColors.accentSecondary.withValues(alpha: 0.12),
                                          ],
                                        )
                                      : null,
                                  border: Border.all(
                                    color: i == currentIndex
                                        ? AppColors.accent.withValues(alpha: 0.35)
                                        : Colors.transparent,
                                  ),
                                  boxShadow: i == currentIndex
                                      ? [
                                          BoxShadow(
                                            color: AppColors.accent.withValues(alpha: 0.2),
                                            blurRadius: 14,
                                            spreadRadius: -2,
                                            offset: const Offset(0, 4),
                                          ),
                                        ]
                                      : null,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      items[i].icon,
                                      size: 22.sp,
                                      color: i == currentIndex ? AppColors.accent : AppColors.labelSecondary,
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      items[i].label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontSize: 10.sp,
                                            fontWeight: i == currentIndex ? FontWeight.w700 : FontWeight.w500,
                                            color: i == currentIndex ? AppColors.label : AppColors.labelSecondary,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
