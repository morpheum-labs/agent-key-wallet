import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:rainbow_flutter/core/config/wallet_network.dart';
import 'package:rainbow_flutter/core/locator.dart';
import 'package:rainbow_flutter/core/widgets/glass_card.dart';
import 'package:rainbow_flutter/core/widgets/primary_button.dart';
import 'package:rainbow_flutter/core/widgets/wallet_flow_background.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:rainbow_flutter/features/portfolio/domain/entities/token_asset.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/data/mock_portfolio_tokens.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/mappers/portfolio_token_mapper.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/utils/format_token_units.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/widgets/erc20_balance_future_builder.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/widgets/eth_balance_future_builder.dart';

class TokenDetailPage extends StatelessWidget {
  const TokenDetailPage({
    super.key,
    required this.symbol,
  });

  final String symbol;

  TokenAsset? get _token {
    final upper = symbol.toUpperCase();
    final network = AppLocator.network;
    try {
      return mockPortfolioTokens(network).firstWhere((t) => t.symbol == upper);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = _token;
    final network = AppLocator.network;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: AppColors.label,
          onPressed: () => context.pop(),
        ),
        title: Text(
          token?.symbol ?? symbol.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: token == null
          ? WalletFlowBackground(
              child: SafeArea(
                child: Center(
                  child: Text(
                    'Unknown token',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            )
          : WalletFlowBackground(
              orbAccent: token.accentColor,
              child: SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: RainbowSpacing.xxl.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: RainbowSpacing.lg.h),
                      Center(
                        child: Container(
                          width: 80.w,
                          height: 80.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                token.accentColor.withValues(alpha: 0.55),
                                token.accentColor.withValues(alpha: 0.14),
                              ],
                            ),
                            border: Border.all(color: AppColors.borderGlass),
                            boxShadow: [
                              BoxShadow(
                                color: token.accentColor.withValues(alpha: 0.25),
                                blurRadius: 28,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            token.symbol.length >= 2
                                ? token.symbol.substring(0, 2)
                                : token.symbol,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                        ),
                      )
                          .animate()
                          .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
                          .scale(
                            begin: const Offset(0.92, 0.92),
                            curve: Curves.easeOutBack,
                          ),
                      SizedBox(height: RainbowSpacing.md.h),
                      Text(
                        token.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.4,
                            ),
                      ),
                      SizedBox(height: RainbowSpacing.xxl.h),
                      if (token.symbol == network.nativeSymbol && network is EvmWalletNetwork)
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, authState) {
                            if (authState is! AuthAuthenticated) {
                              return GlassCard(
                                child: Text(
                                  'Sign in required',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              );
                            }
                            return EthBalanceFutureBuilder(
                              address: authState.summary.ethereumAddressHex,
                              builder: (context, snap) {
                                final row = portfolioTokenMapper
                                    .mapNativeEvmDetailRow([token], snap, network.nativeSymbol)
                                    .first;
                                return _BalanceGlassCard(
                                  balanceLabel: '${row.balanceDisplay} ${row.symbol}',
                                  fiatLabel: row.fiatDisplay,
                                );
                              },
                            );
                          },
                        )
                      else if (token.erc20ContractAddress != null &&
                          token.erc20ContractAddress!.isNotEmpty &&
                          network is EvmWalletNetwork)
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, authState) {
                            if (authState is! AuthAuthenticated) {
                              return GlassCard(
                                child: Text(
                                  'Sign in required',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              );
                            }
                            return Erc20BalanceFutureBuilder(
                              contractAddress: token.erc20ContractAddress,
                              holderAddress: authState.summary.ethereumAddressHex,
                              builder: (context, snap) {
                                String display;
                                if (snap.hasError) {
                                  display = '—';
                                } else if (snap.connectionState == ConnectionState.waiting &&
                                    !snap.hasData) {
                                  display = '…';
                                } else if (snap.hasData && snap.data != null) {
                                  display = formatTokenUnits(snap.data!, token.unitDecimals);
                                } else {
                                  display = token.balanceDisplay;
                                }
                                return _BalanceGlassCard(
                                  balanceLabel: '$display ${token.symbol}',
                                  fiatLabel: token.fiatDisplay,
                                );
                              },
                            );
                          },
                        )
                      else
                        _BalanceGlassCard(
                          balanceLabel: '${token.balanceDisplay} ${token.symbol}',
                          fiatLabel: token.fiatDisplay,
                        ),
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
                          .fadeIn(delay: 80.ms, duration: 420.ms)
                          .slideY(begin: 0.06, end: 0, curve: Curves.easeOutCubic),
                      SizedBox(height: RainbowSpacing.xxl.h),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class _BalanceGlassCard extends StatelessWidget {
  const _BalanceGlassCard({
    required this.balanceLabel,
    required this.fiatLabel,
  });

  final String balanceLabel;
  final String fiatLabel;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: EdgeInsets.symmetric(
        horizontal: RainbowSpacing.xl.w,
        vertical: RainbowSpacing.xxl.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Balance',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.labelSecondary,
                  fontWeight: FontWeight.w500,
                ),
          ),
          SizedBox(height: RainbowSpacing.sm.h),
          Text(
            balanceLabel,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.8,
                  height: 1.1,
                ),
          ),
          SizedBox(height: RainbowSpacing.xs.h),
          Text(
            fiatLabel,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.labelSecondary,
                ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 380.ms, curve: Curves.easeOutCubic)
        .moveY(begin: 12, end: 0, curve: Curves.easeOutCubic);
  }
}
