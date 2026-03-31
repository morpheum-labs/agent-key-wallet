import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/design_system/blurs.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/radius.dart';

/// Main tab shell: body is [StatefulNavigationShell], bottom bar matches Rainbow tab styling.
class RainbowShell extends StatelessWidget {
  const RainbowShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  static final List<({IconData icon, String label})> _tabs = [
    (icon: Icons.account_balance_wallet_rounded, label: 'Wallet'),
    (icon: Icons.explore_outlined, label: 'Discover'),
    (icon: Icons.swap_horiz_rounded, label: 'Activity'),
    (icon: Icons.person_outline_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final idx = navigationShell.currentIndex;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: ClipRect(
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
                    for (var i = 0; i < _tabs.length; i++)
                      Expanded(
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => navigationShell.goBranch(i),
                            splashColor: AppColors.accent.withValues(alpha: 0.12),
                            child: Center(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 240),
                                curve: Curves.easeOutCubic,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(RainbowRadius.full),
                                  gradient: i == idx
                                      ? LinearGradient(
                                          colors: [
                                            AppColors.accent.withValues(alpha: 0.22),
                                            AppColors.accentSecondary.withValues(alpha: 0.12),
                                          ],
                                        )
                                      : null,
                                  border: Border.all(
                                    color: i == idx
                                        ? AppColors.accent.withValues(alpha: 0.35)
                                        : Colors.transparent,
                                  ),
                                  boxShadow: i == idx
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
                                      _tabs[i].icon,
                                      size: 22.sp,
                                      color: i == idx ? AppColors.accent : AppColors.labelSecondary,
                                    ),
                                    SizedBox(height: 2.h),
                                    Text(
                                      _tabs[i].label,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                            fontSize: 10.sp,
                                            fontWeight: i == idx ? FontWeight.w700 : FontWeight.w500,
                                            color: i == idx ? AppColors.label : AppColors.labelSecondary,
                                          ),
                                    ),
                                  ],
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
      ),
    );
  }
}
