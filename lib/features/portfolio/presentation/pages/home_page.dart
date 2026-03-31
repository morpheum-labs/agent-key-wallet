import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rainbow_flutter/core/widgets/glass_card.dart';
import 'package:rainbow_flutter/core/widgets/primary_button.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/gradients.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/data/mock_portfolio_tokens.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/utils/eth_balance_ui.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/widgets/eth_balance_future_builder.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/widgets/token_list_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const Scaffold(body: SizedBox.shrink());
        }
        final address = state.summary.ethereumAddressHex;

        return EthBalanceFutureBuilder(
          address: address,
          builder: (context, snap) {
            final tokens = applyEthSnapshot(mockPortfolioTokens(), snap);

            return Scaffold(
              body: Stack(
                children: [
                  const _HeroGlows(),
                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: RainbowSpacing.xxl.w,
                        vertical: RainbowSpacing.lg.h,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Wallet',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 32.sp,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.8,
                                ),
                          ),
                          SizedBox(height: RainbowSpacing.sm.h),
                          Text(
                            state.summary.shortAddress,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 15.sp,
                                ),
                          ),
                          SizedBox(height: RainbowSpacing.xxl.h),
                          GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Total balance',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontSize: 14.sp,
                                        color: AppColors.labelSecondary,
                                      ),
                                ),
                                SizedBox(height: RainbowSpacing.sm.h),
                                Text(
                                  ethBalanceHeadline(snap),
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                        fontSize: 42.sp,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -1.2,
                                      ),
                                ),
                                SizedBox(height: RainbowSpacing.xs.h),
                                Text(
                                  'Ethereum mainnet · fiat when price feeds land',
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontSize: 13.sp,
                                        color: AppColors.labelSecondary,
                                      ),
                                ),
                              ],
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 420.ms, curve: Curves.easeOutCubic)
                              .moveY(begin: 14, end: 0, curve: Curves.easeOutBack),
                          SizedBox(height: RainbowSpacing.xl.h),
                          Text(
                            'Tokens',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          SizedBox(height: RainbowSpacing.sm.h),
                          Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemCount: tokens.length,
                              separatorBuilder: (_, __) => Divider(
                                height: 1,
                                color: AppColors.borderGlass,
                              ),
                              itemBuilder: (context, index) {
                                final t = tokens[index];
                                return TokenListTile(
                                  token: t,
                                  onTap: () => context.push('/wallet/token/${t.routeSlug}'),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: RainbowSpacing.md.h),
                          Row(
                            children: [
                              Expanded(
                                child: PrimaryButton(
                                  label: 'Receive',
                                  icon: Icons.south_west_rounded,
                                  onPressed: () => context.push('/wallet/receive'),
                                ),
                              ),
                              SizedBox(width: RainbowSpacing.md.w),
                              Expanded(
                                child: PrimaryButton(
                                  label: 'Send',
                                  icon: Icons.north_east_rounded,
                                  onPressed: () => context.push('/wallet/send'),
                                ),
                              ),
                            ],
                          )
                              .animate()
                              .fadeIn(delay: 80.ms, duration: 400.ms)
                              .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
                          SizedBox(height: RainbowSpacing.sm.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _HeroGlows extends StatelessWidget {
  const _HeroGlows();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: -70.w,
          top: 90.h,
          child: IgnorePointer(
            child: Container(
              width: 260.w,
              height: 260.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RainbowGradients.radialGlow(
                  AppColors.accentSecondary,
                  opacity: 0.32,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          right: -50.w,
          top: 200.h,
          child: IgnorePointer(
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RainbowGradients.radialGlow(
                  AppColors.accentPurple,
                  opacity: 0.22,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
