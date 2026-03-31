import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rainbow_flutter/core/locator.dart';
import 'package:rainbow_flutter/core/widgets/rainbow_hero_glows.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/components/rainbow_balance_hero.dart';
import 'package:rainbow_flutter/design_system/components/rainbow_card.dart';
import 'package:rainbow_flutter/design_system/components/rainbow_quick_actions.dart';
import 'package:rainbow_flutter/design_system/components/rainbow_section_title.dart';
import 'package:rainbow_flutter/design_system/components/rainbow_wallet_header.dart';
import 'package:rainbow_flutter/design_system/gradients.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/data/mock_portfolio_tokens.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/mappers/portfolio_token_mapper.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/widgets/token_list_tile.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/widgets/wallet_balances_future_builder.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return const Scaffold(body: SizedBox.shrink());
        }
        return _HomeWalletContent(
          address: state.summary.ethereumAddressHex,
          shortAddress: state.summary.shortAddress,
        );
      },
    );
  }
}

class _HomeWalletContent extends StatefulWidget {
  const _HomeWalletContent({
    required this.address,
    required this.shortAddress,
  });

  final String address;
  final String shortAddress;

  @override
  State<_HomeWalletContent> createState() => _HomeWalletContentState();
}

class _HomeWalletContentState extends State<_HomeWalletContent> {
  final GlobalKey<WalletBalancesFutureBuilderState> _balancesKey = GlobalKey();

  static const _tabBarPad = 72.0;

  @override
  Widget build(BuildContext context) {
    final network = AppLocator.network;
    final base = mockPortfolioTokens(network);

    return WalletBalancesFutureBuilder(
      key: _balancesKey,
      address: widget.address,
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
              Positioned.fill(
                child: RefreshIndicator(
                  color: AppColors.accentSecondary,
                  backgroundColor: AppColors.surfaceElevated,
                  displacement: 48,
                  onRefresh: () async {
                    final s = _balancesKey.currentState;
                    if (s != null) await s.reload();
                  },
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
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
                                RainbowWalletHeader(
                                  title: 'Wallet',
                                  addressLine: widget.shortAddress,
                                  networkLabel: network.name,
                                )
                                    .animate()
                                    .fadeIn(duration: 380.ms, curve: Curves.easeOutCubic)
                                    .slideX(begin: -0.02, end: 0, curve: Curves.easeOutCubic),
                                SizedBox(height: RainbowSpacing.xxl.h),
                                RainbowCard(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: RainbowSpacing.xl.w,
                                    vertical: RainbowSpacing.xxl.h,
                                  ),
                                  child: RainbowBalanceHero(
                                    caption: 'Total balance',
                                    balanceText: headline,
                                    footer: '${network.name} · fiat when price feeds land',
                                  ),
                                )
                                    .animate()
                                    .fadeIn(duration: 450.ms, curve: Curves.easeOutCubic)
                                    .moveY(begin: 18, end: 0, curve: Curves.easeOutBack),
                                SizedBox(height: RainbowSpacing.lg.h),
                                RainbowQuickActions(
                                  onReceive: () => context.push('/wallet/receive'),
                                  onSend: () => context.push('/wallet/send'),
                                  onSwap: () => context.go('/discover'),
                                  swapEnabled: true,
                                )
                                    .animate()
                                    .fadeIn(delay: 90.ms, duration: 420.ms, curve: Curves.easeOutCubic)
                                    .slideY(begin: 0.08, end: 0, curve: Curves.easeOutCubic),
                                SizedBox(height: RainbowSpacing.xxl.h),
                                const RainbowSectionTitle(title: 'Your tokens')
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
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
