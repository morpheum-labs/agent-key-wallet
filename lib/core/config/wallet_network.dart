import 'package:rainbow_flutter/core/config/chain_config.dart';
import 'package:rainbow_flutter/core/config/chain_family.dart';

/// Describes a network the wallet can target (EVM, Solana, Bitcoin, …).
///
/// Persistence uses [id] (e.g. `evm:1`, `solana:mainnet-beta`). Balance fetchers and
/// key derivation are selected by [family] — only [EvmWalletNetwork] is fully wired today.
sealed class WalletNetwork {
  const WalletNetwork({
    required this.id,
    required this.name,
    required this.family,
    required this.nativeSymbol,
  });

  final String id;
  final String name;
  final ChainFamily family;
  final String nativeSymbol;

  /// Block explorer URL for a transaction id/hash (format differs by chain).
  String txExplorerUrl(String txHash);
}

/// Ethereum / EVM L1 or L2 — uses [web3dart] [Web3Client] + ERC-20.
final class EvmWalletNetwork extends WalletNetwork {
  EvmWalletNetwork._({
    required super.id,
    required super.name,
    required this.chainConfig,
    required super.nativeSymbol,
  }) : super(family: ChainFamily.evm);

  factory EvmWalletNetwork.fromChainConfig(ChainConfig config) {
    return EvmWalletNetwork._(
      id: 'evm:${config.chainId}',
      name: config.name,
      chainConfig: config,
      nativeSymbol: nativeSymbolForEvmChainId(config.chainId),
    );
  }

  final ChainConfig chainConfig;

  int get chainId => chainConfig.chainId;
  String get rpcUrl => chainConfig.rpcUrl;
  String get explorerPrefix => chainConfig.explorerPrefix;

  /// Extend when you add Polygon, Base, Arbitrum, etc.
  static String nativeSymbolForEvmChainId(int chainId) {
    switch (chainId) {
      case 137:
        return 'MATIC';
      default:
        return 'ETH';
    }
  }

  static final EvmWalletNetwork mainnet = EvmWalletNetwork.fromChainConfig(ChainConfig.mainnet);
  static final EvmWalletNetwork sepolia = EvmWalletNetwork.fromChainConfig(ChainConfig.sepolia);

  @override
  String txExplorerUrl(String txHash) {
    final h = txHash.startsWith('0x') ? txHash : '0x$txHash';
    return '${chainConfig.explorerPrefix}/tx/$h';
  }
}

/// Solana cluster — RPC + SPL wiring lives in future datasources / use cases.
final class SolanaWalletNetwork extends WalletNetwork {
  const SolanaWalletNetwork({
    required super.id,
    required super.name,
    required this.cluster,
    required this.rpcUrl,
    required this.explorerTxBase,
  }) : super(
          family: ChainFamily.solana,
          nativeSymbol: 'SOL',
        );

  final String cluster;
  final String rpcUrl;
  final String explorerTxBase;

  static const SolanaWalletNetwork mainnetBeta = SolanaWalletNetwork(
    id: 'solana:mainnet-beta',
    name: 'Solana',
    cluster: 'mainnet-beta',
    rpcUrl: 'https://api.mainnet-beta.solana.com',
    explorerTxBase: 'https://solscan.io/tx',
  );

  @override
  String txExplorerUrl(String txHash) => '$explorerTxBase/$txHash';
}

/// Bitcoin mainnet — UTXO signing and explorers are separate from EVM.
final class BitcoinWalletNetwork extends WalletNetwork {
  const BitcoinWalletNetwork({
    required super.id,
    required super.name,
    required this.explorerTxBase,
  }) : super(
          family: ChainFamily.utxo,
          nativeSymbol: 'BTC',
        );

  final String explorerTxBase;

  static const BitcoinWalletNetwork mainnet = BitcoinWalletNetwork(
    id: 'bitcoin:mainnet',
    name: 'Bitcoin',
    explorerTxBase: 'https://mempool.space/tx',
  );

  @override
  String txExplorerUrl(String txHash) => '$explorerTxBase/$txHash';
}

extension WalletNetworkUi on WalletNetwork {
  String get settingsSubtitle {
    return switch (this) {
      EvmWalletNetwork(:final chainId) => 'Chain ID $chainId',
      SolanaWalletNetwork(:final cluster) => 'Cluster $cluster · SPL balances next',
      BitcoinWalletNetwork() => 'UTXO · signing path not wired yet',
    };
  }
}
