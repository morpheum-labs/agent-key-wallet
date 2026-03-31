import 'package:flutter/material.dart';

import 'package:rainbow_flutter/core/config/chain_config.dart';
import 'package:rainbow_flutter/core/config/token_contracts.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/features/portfolio/domain/entities/token_asset.dart';

/// Static MVP list; USDC uses live ERC-20 balance when [chain] has a known contract.
List<TokenAsset> mockPortfolioTokens(ChainConfig chain) {
  final usdc = TokenContracts.usdcAddressForChain(chain.chainId);
  return [
    const TokenAsset(
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
      fiatDisplay: r'$—',
      accentColor: AppColors.accentBlue,
      erc20ContractAddress: usdc,
      unitDecimals: 6,
    ),
    const TokenAsset(
      symbol: 'OP',
      name: 'Optimism',
      balanceDisplay: '0.00',
      fiatDisplay: r'$—',
      accentColor: AppColors.accentRed,
    ),
  ];
}
