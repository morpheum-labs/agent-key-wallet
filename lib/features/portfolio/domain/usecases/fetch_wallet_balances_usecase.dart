import 'package:rainbow_flutter/core/config/token_contracts.dart';
import 'package:rainbow_flutter/core/data/chain_settings_repository.dart';
import 'package:rainbow_flutter/features/portfolio/domain/entities/portfolio_balances.dart';
import 'package:rainbow_flutter/features/portfolio/domain/usecases/fetch_erc20_balance_usecase.dart';
import 'package:rainbow_flutter/features/portfolio/domain/usecases/fetch_eth_balance_usecase.dart';

/// Loads native ETH and USDC (when configured for the current chain) in one place.
class FetchWalletBalancesUseCase {
  FetchWalletBalancesUseCase(
    this._fetchEth,
    this._fetchErc20,
    this._chainSettings,
  );

  final FetchEthBalanceUseCase _fetchEth;
  final FetchErc20BalanceUseCase _fetchErc20;
  final ChainSettingsRepository _chainSettings;

  Future<PortfolioBalances> call(String holderAddressEip55) async {
    final eth = await _fetchEth(holderAddressEip55);
    final usdcAddr = TokenContracts.usdcAddressForChain(
      _chainSettings.selectedSync.chainId,
    );
    if (usdcAddr == null) {
      return PortfolioBalances(eth: eth, usdcSkipped: true);
    }
    try {
      final usdc = await _fetchErc20(
        contractAddressEip55: usdcAddr,
        holderAddressEip55: holderAddressEip55,
      );
      return PortfolioBalances(eth: eth, usdcRaw: usdc, usdcSkipped: false);
    } catch (e) {
      return PortfolioBalances(eth: eth, usdcError: e, usdcSkipped: false);
    }
  }
}
