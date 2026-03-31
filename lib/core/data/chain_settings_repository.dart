import 'package:hive_flutter/hive_flutter.dart';

import 'package:rainbow_flutter/core/config/chain_config.dart';
import 'package:rainbow_flutter/core/config/wallet_network.dart';
import 'package:rainbow_flutter/core/config/wallet_network_registry.dart';

/// Persists selected [WalletNetwork.id] (Hive `settings` box).
///
/// Migrates legacy `chain_id` (EVM int) to `evm:<chainId>` on first read.
class ChainSettingsRepository {
  ChainSettingsRepository(this._box);

  final Box<dynamic> _box;

  static const String _keyNetworkId = 'network_id';
  static const String _keyChainId = 'chain_id';

  String readNetworkIdSync() {
    final stored = _box.get(_keyNetworkId);
    if (stored is String && stored.isNotEmpty) {
      return stored;
    }
    final legacy = _box.get(_keyChainId, defaultValue: ChainConfig.mainnet.chainId);
    final cid = legacy is int ? legacy : ChainConfig.mainnet.chainId;
    return 'evm:$cid';
  }

  Future<void> setNetworkId(String id) async {
    await _box.put(_keyNetworkId, id);
  }

  WalletNetwork get selectedNetwork => WalletNetworkRegistry.byId(readNetworkIdSync());
}
