import 'package:hive_flutter/hive_flutter.dart';

import 'package:rainbow_flutter/core/config/chain_config.dart';

/// Persists selected EVM chain id (Hive `settings` box).
class ChainSettingsRepository {
  ChainSettingsRepository(this._box);

  final Box<dynamic> _box;

  static const String _keyChainId = 'chain_id';

  int readChainIdSync() {
    final v = _box.get(_keyChainId, defaultValue: ChainConfig.mainnet.chainId);
    if (v is int) return v;
    return ChainConfig.mainnet.chainId;
  }

  ChainConfig get selectedSync => ChainConfig.fromId(readChainIdSync());

  Future<void> setChainId(int chainId) async {
    await _box.put(_keyChainId, chainId);
  }
}
