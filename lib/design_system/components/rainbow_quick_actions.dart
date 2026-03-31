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
          _SpringSwapOutlineButton(
            enabled: swapEnabled,
            onPressed: onSwap!,
          ),
        ],
      ],
    );
  }
}

class _SpringSwapOutlineButton extends StatefulWidget {
  const _SpringSwapOutlineButton({
    required this.enabled,
    required this.onPressed,
  });

  final bool enabled;
  final VoidCallback onPressed;

  @override
  State<_SpringSwapOutlineButton> createState() => _SpringSwapOutlineButtonState();
}

class _SpringSwapOutlineButtonState extends State<_SpringSwapOutlineButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        child: AnimatedScale(
          scale: _pressed && enabled ? 0.97 : 1.0,
          duration: Duration(milliseconds: _pressed && enabled ? 90 : 400),
          curve: _pressed && enabled ? Curves.easeOut : Curves.easeOutBack,
          child: OutlinedButton.icon(
            onPressed: enabled ? widget.onPressed : null,
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
      ),
    );
  }
}
