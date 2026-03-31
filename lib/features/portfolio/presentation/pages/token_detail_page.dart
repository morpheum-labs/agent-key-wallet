import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:rainbow_flutter/core/locator.dart';
import 'package:rainbow_flutter/core/widgets/glass_card.dart';
import 'package:rainbow_flutter/core/widgets/primary_button.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/gradients.dart';
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
    final chain = AppLocator.chain;
    try {
      return mockPortfolioTokens(chain).firstWhere((t) => t.symbol == upper);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = _token;

    return Scaffold(
      appBar: AppBar(
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
          ? Center(
              child: Text(
                'Unknown token',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )
          : Stack(
              children: [
                Positioned(
                  right: -40.w,
                  top: 40.h,
                  child: IgnorePointer(
                    child: Container(
                      width: 200.w,
                      height: 200.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RainbowGradients.radialGlow(
                          token.accentColor,
                          opacity: 0.25,
                        ),
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: RainbowSpacing.xxl.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: RainbowSpacing.lg.h),
                        Center(
                          child: Container(
                            width: 72.w,
                            height: 72.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  token.accentColor.withValues(alpha: 0.5),
                                  token.accentColor.withValues(alpha: 0.15),
                                ],
                              ),
                              border: Border.all(color: AppColors.borderGlass),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              token.symbol.length >= 2
                                  ? token.symbol.substring(0, 2)
                                  : token.symbol,
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(height: RainbowSpacing.md.h),
                        Text(
                          token.name,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontSize: 20.sp,
                              ),
                        ),
                        SizedBox(height: RainbowSpacing.xxl.h),
                        if (token.symbol == 'ETH')
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
                                  final row =
                                      portfolioTokenMapper.mapEthDetailRow([token], snap).first;
                                  return GlassCard(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Balance',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: AppColors.labelSecondary,
                                              ),
                                        ),
                                        SizedBox(height: RainbowSpacing.sm.h),
                                        Text(
                                          '${row.balanceDisplay} ${row.symbol}',
                                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                                fontSize: 28.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        SizedBox(height: RainbowSpacing.xs.h),
                                        Text(
                                          row.fiatDisplay,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: AppColors.labelSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        else if (token.erc20ContractAddress != null &&
                            token.erc20ContractAddress!.isNotEmpty)
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
                                    display =
                                        formatTokenUnits(snap.data!, token.unitDecimals);
                                  } else {
                                    display = token.balanceDisplay;
                                  }
                                  return GlassCard(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Balance',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: AppColors.labelSecondary,
                                              ),
                                        ),
                                        SizedBox(height: RainbowSpacing.sm.h),
                                        Text(
                                          '$display ${token.symbol}',
                                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                                fontSize: 28.sp,
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        SizedBox(height: RainbowSpacing.xs.h),
                                        Text(
                                          token.fiatDisplay,
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                color: AppColors.labelSecondary,
                                              ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        else
                          GlassCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Balance',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.labelSecondary,
                                      ),
                                ),
                                SizedBox(height: RainbowSpacing.sm.h),
                                Text(
                                  '${token.balanceDisplay} ${token.symbol}',
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                                SizedBox(height: RainbowSpacing.xs.h),
                                Text(
                                  token.fiatDisplay,
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        color: AppColors.labelSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(height: RainbowSpacing.xxl.h),
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
                        ),
                        SizedBox(height: RainbowSpacing.xxl.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
