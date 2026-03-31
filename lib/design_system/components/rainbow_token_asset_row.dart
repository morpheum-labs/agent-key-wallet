import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/components/rainbow_glass_surface.dart';
import 'package:rainbow_flutter/design_system/components/rainbow_mini_sparkline.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';

/// Token / asset row: avatar, titles, fiat, optional % + sparkline (Rainbow-style).
class RainbowTokenAssetRow extends StatefulWidget {
  const RainbowTokenAssetRow({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.trailingPrimary,
    this.percentLabel,
    this.showSparkline = true,
    this.sparklineSeed = 0,
    this.sparklineValues,
    this.percentIsPositive,
    required this.onTap,
  });

  final Widget leading;
  final String title;
  final String subtitle;
  final String trailingPrimary;
  final String? percentLabel;
  final bool showSparkline;
  final int sparklineSeed;
  final List<double>? sparklineValues;
  final bool? percentIsPositive;
  final VoidCallback onTap;

  @override
  State<RainbowTokenAssetRow> createState() => _RainbowTokenAssetRowState();
}

class _RainbowTokenAssetRowState extends State<RainbowTokenAssetRow> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final positive = widget.percentIsPositive ?? true;

    return AnimatedScale(
      scale: _pressed ? 0.985 : 1.0,
      duration: Duration(milliseconds: _pressed ? 90 : 420),
      curve: _pressed ? Curves.easeOut : Curves.easeOutBack,
      child: RainbowGlassSurface(
        borderRadius: BorderRadius.circular(RainbowRadius.md),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _pressed = true),
            onTapUp: (_) => setState(() => _pressed = false),
            onTapCancel: () => setState(() => _pressed = false),
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
                      widget.leading,
                      SizedBox(width: RainbowSpacing.lg.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.title,
                              style: textTheme.titleMedium?.copyWith(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.2,
                              ),
                            ),
                            SizedBox(height: RainbowSpacing.xxs.h),
                            Text(
                              widget.subtitle,
                              style: textTheme.bodySmall?.copyWith(
                                fontSize: 13.sp,
                                color: AppColors.labelSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.showSparkline) ...[
                        RainbowMiniSparkline(
                          seed: widget.sparklineSeed,
                          isPositive: positive,
                          values: widget.sparklineValues,
                        ),
                        SizedBox(width: RainbowSpacing.sm.w),
                      ],
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.trailingPrimary,
                            style: textTheme.titleMedium?.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          if (widget.percentLabel != null) ...[
                            SizedBox(height: 2.h),
                            Text(
                              widget.percentLabel!,
                              style: textTheme.labelSmall?.copyWith(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: _percentColor(widget.percentLabel!, positive),
                              ),
                            ),
                          ],
                        ],
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
          ),
    );
  }
}

/// Alias for docs / parity with Rainbow naming — same widget as [RainbowTokenAssetRow].
typedef RainbowTokenRow = RainbowTokenAssetRow;

Color _percentColor(String label, bool positive) {
  if (label == '—' || label == '--') {
    return AppColors.labelSecondary;
  }
  return positive ? AppColors.accentGreen : AppColors.accentRed;
}

