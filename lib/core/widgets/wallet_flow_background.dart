import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/core/widgets/rainbow_hero_glows.dart';
import 'package:rainbow_flutter/design_system/gradients.dart';

/// Full-bleed wallet backdrop: [RainbowGradients.walletBackdrop] plus optional accent orb.
class WalletFlowBackground extends StatelessWidget {
  const WalletFlowBackground({
    super.key,
    required this.child,
    this.orbAccent,
    this.showGradient = true,
    this.showHeroGlows = false,
  });

  final Widget child;
  final Color? orbAccent;
  final bool showGradient;

  /// Decorative radial glows (same language as Wallet home) behind content.
  final bool showHeroGlows;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (showGradient)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RainbowGradients.walletBackdrop(),
              ),
            ),
          ),
        if (orbAccent != null)
          Positioned(
            right: -36.w,
            top: 0,
            child: IgnorePointer(
              child: Container(
                width: 210.w,
                height: 210.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RainbowGradients.radialGlow(
                    orbAccent!,
                    opacity: 0.26,
                  ),
                ),
              ),
            ),
          ),
        if (showHeroGlows) const Positioned.fill(child: RainbowHeroGlows()),
        child,
      ],
    );
  }
}
