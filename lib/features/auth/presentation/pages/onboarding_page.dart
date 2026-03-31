import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/primary_button.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          const _AmbientGlow(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Your keys,\nyour crypto.',
                    style: textTheme.displayLarge?.copyWith(
                      fontSize: 36,
                      height: 1.05,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 450.ms)
                      .slideX(begin: -0.04, end: 0, curve: Curves.easeOutCubic),
                  const SizedBox(height: 12),
                  Text(
                    'Create a new wallet or import an existing one. Keys stay on-device.',
                    style: textTheme.bodyMedium,
                  ).animate().fadeIn(delay: 120.ms, duration: 400.ms),
                  const Spacer(),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        PrimaryButton(
                          label: 'Create a new wallet',
                          icon: Icons.add_rounded,
                          onPressed: () => context.push('/create'),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () => context.push('/import'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppColors.borderGlass),
                            foregroundColor: AppColors.textPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'I already have a wallet',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 200.ms).moveY(begin: 12, end: 0),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmbientGlow extends StatelessWidget {
  const _AmbientGlow();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: -80,
      top: -40,
      child: IgnorePointer(
        child: Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.accent.withValues(alpha: 0.35),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
