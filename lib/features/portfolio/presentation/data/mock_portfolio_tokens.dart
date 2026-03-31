import 'package:flutter/material.dart';

import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/features/portfolio/domain/entities/token_asset.dart';

/// Static MVP list until balances come from chain/indexers.
List<TokenAsset> mockPortfolioTokens() {
  return const [
    TokenAsset(
      symbol: 'ETH',
      name: 'Ethereum',
      balanceDisplay: '0.00',
      fiatDisplay: r'$0.00',
      accentColor: AppColors.accentSecondary,
    ),
    TokenAsset(
      symbol: 'USDC',
      name: 'USD Coin',
      balanceDisplay: '0.00',
      fiatDisplay: r'$0.00',
      accentColor: AppColors.accentBlue,
    ),
    TokenAsset(
      symbol: 'OP',
      name: 'Optimism',
      balanceDisplay: '0.00',
      fiatDisplay: r'$0.00',
      accentColor: AppColors.accentRed,
    ),
  ];
}
