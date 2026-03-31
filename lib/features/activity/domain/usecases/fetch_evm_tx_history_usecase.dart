import 'package:rainbow_flutter/core/config/wallet_network.dart';
import 'package:rainbow_flutter/core/data/chain_settings_repository.dart';
import 'package:rainbow_flutter/features/activity/data/datasources/evm_tx_history_remote_datasource.dart';
import 'package:rainbow_flutter/features/activity/domain/entities/evm_tx_history_item.dart';

class FetchEvmTxHistoryUseCase {
  FetchEvmTxHistoryUseCase(this._remote, this._chains);

  final EvmTxHistoryRemoteDataSource _remote;
  final ChainSettingsRepository _chains;

  Future<List<EvmTxHistoryItem>> call(String address) async {
    final net = _chains.selectedNetwork;
    if (net is! EvmWalletNetwork) return [];
    return _remote.fetchRecent(chainId: net.chainId, address: address);
  }
}
