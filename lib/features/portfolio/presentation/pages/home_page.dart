import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rainbow_flutter/core/theme/app_colors.dart';
import 'package:rainbow_flutter/core/widgets/glass_card.dart';
import 'package:rainbow_flutter/core/widgets/primary_button.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final summary = state is AuthAuthenticated ? state.summary : null;

        return Scaffold(
          body: Stack(
            children: [
              const _HeroGlow(),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Portfolio',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 32,
                                ),
                          ),
                          IconButton(
                            onPressed: () => context.read<AuthBloc>().add(
                                  const AuthLogoutRequested(),
                                ),
                            icon: const Icon(Icons.logout_rounded),
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        summary?.shortAddress ?? '—',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 28),
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total balance',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              r'$0.00',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                    fontSize: 40,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'ETH · MVP — price feeds next',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms)
                          .moveY(begin: 10, end: 0, curve: Curves.easeOutCubic),
                      const Spacer(),
                      Row(
                        children: [
                          Expanded(
                            child: PrimaryButton(
                              label: 'Receive',
                              icon: Icons.south_west_rounded,
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PrimaryButton(
                              label: 'Send',
                              icon: Icons.north_east_rounded,
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroGlow extends StatelessWidget {
  const _HeroGlow();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -60,
      top: 120,
      child: IgnorePointer(
        child: Container(
          width: 220,
          height: 220,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.accentSecondary.withValues(alpha: 0.25),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
