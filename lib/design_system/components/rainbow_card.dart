import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/core/widgets/glass_card.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';

/// Glassmorphic surface — design-system name; implemented by [GlassCard] (blur + gradient + shadow).
class RainbowCard extends StatelessWidget {
  const RainbowCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = RainbowRadius.xl,
  });

  final Widget child;
  final EdgeInsets? padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: padding ?? EdgeInsets.all(RainbowSpacing.lg.w),
      borderRadius: borderRadius,
      child: child,
    );
  }
}
