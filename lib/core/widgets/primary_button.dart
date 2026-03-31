import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../design_system/colors.dart';
import '../../design_system/gradients.dart';

class PrimaryButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: RainbowGradients.ctaShimmer(),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20, color: AppColors.label),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
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
    )
        .animate(target: onPressed == null ? 0 : 1)
        .scale(
          duration: 140.ms,
          curve: Curves.easeOutBack,
          begin: const Offset(0.96, 0.96),
          end: const Offset(1, 1),
        );
  }
}
