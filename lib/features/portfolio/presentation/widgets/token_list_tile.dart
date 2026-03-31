import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';
import 'package:rainbow_flutter/features/portfolio/domain/entities/token_asset.dart';

class TokenListTile extends StatelessWidget {
  const TokenListTile({
    super.key,
    required this.token,
    required this.onTap,
  });

  final TokenAsset token;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RainbowRadius.md),
          border: Border.all(color: AppColors.borderGlass),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surfacePrimary.withValues(alpha: 0.72),
              AppColors.surfaceSecondary.withValues(alpha: 0.45),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(RainbowRadius.md),
          splashColor: AppColors.accent.withValues(alpha: 0.12),
          highlightColor: AppColors.accent.withValues(alpha: 0.06),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: RainbowSpacing.lg.w,
              vertical: RainbowSpacing.md.h,
            ),
            child: Row(
              children: [
                Container(
                  width: 46.w,
                  height: 46.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        token.accentColor.withValues(alpha: 0.5),
                        token.accentColor.withValues(alpha: 0.14),
                      ],
                    ),
                    border: Border.all(color: AppColors.borderGlass),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    token.symbol.length >= 2 ? token.symbol.substring(0, 2) : token.symbol,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.label,
                        ),
                  ),
                ),
                SizedBox(width: RainbowSpacing.lg.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        token.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                      ),
                      SizedBox(height: RainbowSpacing.xxs.h),
                      Text(
                        '${token.balanceDisplay} ${token.symbol}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 13.sp,
                              color: AppColors.labelSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
                Text(
                  token.fiatDisplay,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                ),
                SizedBox(width: RainbowSpacing.xs.w),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22.sp,
                  color: AppColors.labelSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
