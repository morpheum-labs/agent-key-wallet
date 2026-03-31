import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rainbow_flutter/core/locator.dart';
import 'package:rainbow_flutter/core/widgets/glass_card.dart';
import 'package:rainbow_flutter/core/widgets/primary_button.dart';
import 'package:rainbow_flutter/core/widgets/rainbow_hero_glows.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/gradients.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/data/mock_portfolio_tokens.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/mappers/portfolio_token_mapper.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/widgets/token_list_tile.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/widgets/wallet_balances_future_builder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const _tabBarPad = 72.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const Scaffold(body: SizedBox.shrink());
        }
        final address = state.summary.ethereumAddressHex;
        final network = AppLocator.network;
        final base = mockPortfolioTokens(network);

        return WalletBalancesFutureBuilder(
          address: address,
          builder: (context, snap) {
            final tokens = portfolioTokenMapper.mapHomeRows(base, snap, network.nativeSymbol);
            final headline = portfolioTokenMapper.nativeBalanceHeadline(snap, network.nativeSymbol);

            return Scaffold(
              backgroundColor: AppColors.background,
              body: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RainbowGradients.walletBackdrop(),
                      ),
                    ),
                  ),
                  const RainbowHeroGlows(),
                  CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverSafeArea(
                        bottom: false,
                        sliver: SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              RainbowSpacing.xxl.w,
                              RainbowSpacing.md.h,
                              RainbowSpacing.xxl.w,
                              0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _WalletHeader(
                                  shortAddress: state.summary.shortAddress,
                                  networkName: network.name,
                                )
                                    .animate()
                                    .fadeIn(duration: 380.ms, curve: Curves.easeOutCubic)
                                    .slideX(begin: -0.02, end: 0, curve: Curves.easeOutCubic),
                                SizedBox(height: RainbowSpacing.xxl.h),
                                GlassCard(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: RainbowSpacing.xl.w,
                                    vertical: RainbowSpacing.xxl.h,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total balance',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                              fontSize: 14.sp,
                                              color: AppColors.labelSecondary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      SizedBox(height: RainbowSpacing.md.h),
                                      Text(
                                        headline,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                              fontSize: 40.sp,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: -1.1,
                                              height: 1.05,
                                            ),
                                      ),
                                      SizedBox(height: RainbowSpacing.sm.h),
                                      Text(
                                        '${network.name} · fiat when price feeds land',
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                              fontSize: 12.5.sp,
                                              color: AppColors.labelSecondary,
                                            ),
                                      ),
                                    ],
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 450.ms, curve: Curves.easeOutCubic)
                                    .moveY(begin: 18, end: 0, curve: Curves.easeOutBack),
                                SizedBox(height: RainbowSpacing.lg.h),
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
                                    .fadeIn(delay: 90.ms, duration: 420.ms, curve: Curves.easeOutCubic)
                                    .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                                SizedBox(height: RainbowSpacing.xxl.h),
                                Row(
                                  children: [
                                    Container(
                                      width: 3.w,
                                      height: 18.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(RainbowRadius.full),
                                        gradient: RainbowGradients.accentRibbon(),
                                      ),
                                    ),
                                    SizedBox(width: RainbowSpacing.sm.w),
                                    Text(
                                      'Your tokens',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontSize: 18.sp,
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.35,
                                          ),
                                    ),
                                  ],
                                )
                                    .animate()
                                    .fadeIn(delay: 120.ms, duration: 380.ms),
                                SizedBox(height: RainbowSpacing.md.h),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: RainbowSpacing.xxl.w),
                        sliver: SliverList.separated(
                          itemCount: tokens.length,
                          separatorBuilder: (_, __) => SizedBox(height: RainbowSpacing.sm.h),
                          itemBuilder: (context, index) {
                            final t = tokens[index];
                            return TokenListTile(
                              token: t,
                              onTap: () => context.push('/wallet/token/${t.routeSlug}'),
                            )
                                .animate()
                                .fadeIn(
                                  delay: (40 * index).ms,
                                  duration: 320.ms,
                                  curve: Curves.easeOutCubic,
                                )
                                .slideX(
                                  begin: 0.04,
                                  end: 0,
                                  delay: (40 * index).ms,
                                  duration: 380.ms,
                                  curve: Curves.easeOutCubic,
                                );
                          },
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(height: _tabBarPad.h),
                      ),
                    ],
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

class _WalletHeader extends StatelessWidget {
  const _WalletHeader({
    required this.shortAddress,
    required this.networkName,
  });

  final String shortAddress;
  final String networkName;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Wallet',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.6,
                    ),
              ),
              SizedBox(height: RainbowSpacing.xs.h),
              Text(
                shortAddress,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.labelSecondary,
                    ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: RainbowSpacing.md.w,
            vertical: RainbowSpacing.sm.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RainbowRadius.full),
            border: Border.all(color: AppColors.borderGlass),
            gradient: LinearGradient(
              colors: [
                AppColors.surfacePrimary.withValues(alpha: 0.85),
                AppColors.surfaceSecondary.withValues(alpha: 0.65),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Text(
            networkName,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.label,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }
}
