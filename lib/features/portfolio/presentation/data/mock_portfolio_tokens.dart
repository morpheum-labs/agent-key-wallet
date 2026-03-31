import 'package:flutter/material.dart';

import 'package:rainbow_flutter/core/config/chain_family.dart';
import 'package:rainbow_flutter/core/config/token_contracts.dart';
import 'package:rainbow_flutter/core/config/wallet_network.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/features/portfolio/domain/entities/token_asset.dart';

/// Static MVP list; extend per [ChainFamily] as you add RPC + token programs.
List<TokenAsset> mockPortfolioTokens(WalletNetwork network) {
  switch (network.family) {
    case ChainFamily.evm:
      final evm = network as EvmWalletNetwork;
      final usdc = TokenContracts.usdcAddressForChain(evm.chainId);
      return [
        TokenAsset(
          symbol: evm.nativeSymbol,
          name: _nativeNameForSymbol(evm.nativeSymbol),
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
    case ChainFamily.solana:
      return [
        const TokenAsset(
          symbol: 'SOL',
          name: 'Solana',
          balanceDisplay: '0.00',
          fiatDisplay: r'$—',
          accentColor: AppColors.accentSecondary,
        ),
        const TokenAsset(
          symbol: 'USDC',
          name: 'USD Coin',
          balanceDisplay: '0.00',
          fiatDisplay: r'$—',
          accentColor: AppColors.accentBlue,
          unitDecimals: 6,
        ),
      ];
    case ChainFamily.utxo:
      return [
        const TokenAsset(
          symbol: 'BTC',
          name: 'Bitcoin',
          balanceDisplay: '0.00',
          fiatDisplay: r'$—',
          accentColor: AppColors.accentSecondary,
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
