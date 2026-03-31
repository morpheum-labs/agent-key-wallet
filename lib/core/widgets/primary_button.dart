import 'package:flutter/material.dart';

import '../../design_system/colors.dart';
import '../../design_system/gradients.dart';
import '../../design_system/radius.dart';
import '../../design_system/spacing.dart';

class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = widget.onPressed != null;

    return AnimatedScale(
      scale: _pressed && enabled ? 0.94 : 1.0,
      duration: Duration(milliseconds: _pressed && enabled ? 90 : 420),
      curve: _pressed && enabled ? Curves.easeOut : Curves.easeOutBack,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RainbowRadius.md),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.38),
              blurRadius: 22,
              spreadRadius: -2,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: AppColors.accentPurple.withValues(alpha: 0.18),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(RainbowRadius.md),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onPressed,
              onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
              onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
              onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
              child: Ink(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(RainbowRadius.md),
                  gradient: RainbowGradients.ctaShimmer(),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: RainbowSpacing.lg,
                    horizontal: RainbowSpacing.xxl,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(widget.icon, size: 20, color: AppColors.label),
                        SizedBox(width: RainbowSpacing.sm),
                      ],
                      Text(
                        widget.label,
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: AppColors.label,
                          fontWeight: FontWeight.w600,
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
    );
  }
}
