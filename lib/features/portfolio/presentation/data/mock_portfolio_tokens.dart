import 'package:flutter/material.dart';

import 'package:rainbow_flutter/core/config/chain_family.dart';
import 'package:rainbow_flutter/core/config/token_contracts.dart';
import 'package:rainbow_flutter/core/config/wallet_network.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/features/portfolio/domain/entities/token_asset.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/data/mock_token_metrics.dart';

/// Static MVP list; extend per [ChainFamily] as you add RPC + token programs.
List<TokenAsset> mockPortfolioTokens(WalletNetwork network) {
  switch (network.family) {
    case ChainFamily.evm:
      final evm = network as EvmWalletNetwork;
      final usdc = TokenContracts.usdcAddressForChain(evm.chainId);
      final sym = evm.nativeSymbol;
      return [
        TokenAsset(
          symbol: sym,
          name: _nativeNameForSymbol(sym),
          balanceDisplay: '0.00',
          fiatDisplay: r'$0.00',
          accentColor: AppColors.accentSecondary,
          percentChange24h: mockPercent24h(sym),
          sparklinePoints: mockSparklinePoints(sym),
        ),
        TokenAsset(
          symbol: 'USDC',
          name: 'USD Coin',
          balanceDisplay: '0.00',
          fiatDisplay: r'$—',
          accentColor: AppColors.accentBlue,
          erc20ContractAddress: usdc,
          unitDecimals: 6,
          percentChange24h: mockPercent24h('USDC'),
          sparklinePoints: mockSparklinePoints('USDC'),
        ),
        TokenAsset(
          symbol: 'OP',
          name: 'Optimism',
          balanceDisplay: '0.00',
          fiatDisplay: r'$—',
          accentColor: AppColors.accentRed,
          percentChange24h: mockPercent24h('OP'),
          sparklinePoints: mockSparklinePoints('OP'),
        ),
      ];
    case ChainFamily.solana:
      return [
        TokenAsset(
          symbol: 'SOL',
          name: 'Solana',
          balanceDisplay: '0.00',
          fiatDisplay: r'$—',
          accentColor: AppColors.accentSecondary,
          percentChange24h: mockPercent24h('SOL'),
          sparklinePoints: mockSparklinePoints('SOL'),
        ),
        TokenAsset(
          symbol: 'USDC',
          name: 'USD Coin',
          balanceDisplay: '0.00',
          fiatDisplay: r'$—',
          accentColor: AppColors.accentBlue,
          unitDecimals: 6,
          percentChange24h: mockPercent24h('USDC-SOL'),
          sparklinePoints: mockSparklinePoints('USDC-SOL'),
        ),
      ];
    case ChainFamily.utxo:
      return [
        TokenAsset(
          symbol: 'BTC',
          name: 'Bitcoin',
          balanceDisplay: '0.00',
          fiatDisplay: r'$—',
          accentColor: AppColors.accentSecondary,
          percentChange24h: mockPercent24h('BTC'),
          sparklinePoints: mockSparklinePoints('BTC'),
        ),
      ];
  }
}

String _nativeNameForSymbol(String symbol) {
  switch (symbol) {
    case 'MATIC':
      return 'Polygon';
    default:
      return 'Ethereum';
  }
}
