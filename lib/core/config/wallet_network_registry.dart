import 'package:rainbow_flutter/core/config/wallet_network.dart';

/// Supported networks for the network picker and [ChainSettingsRepository].
abstract final class WalletNetworkRegistry {
  static final List<WalletNetwork> all = [
    EvmWalletNetwork.mainnet,
    EvmWalletNetwork.sepolia,
    SolanaWalletNetwork.mainnetBeta,
    BitcoinWalletNetwork.mainnet,
  ];

  static WalletNetwork byId(String id) {
    for (final n in all) {
      if (n.id == id) return n;
    }
    return EvmWalletNetwork.mainnet;
  }
}
