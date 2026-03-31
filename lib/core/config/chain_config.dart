/// Public RPC endpoints (replace with your own / Alchemy / Infura in production).
const String kMainnetRpcUrl = 'https://cloudflare-eth.com';
const String kSepoliaRpcUrl = 'https://rpc.sepolia.org';

/// Supported L1 networks for RPC + block explorer links.
class ChainConfig {
  const ChainConfig({
    required this.chainId,
    required this.name,
    required this.rpcUrl,
    required this.explorerPrefix,
  });

  final int chainId;
  final String name;
  final String rpcUrl;

  /// Base URL for Etherscan-style explorers (no trailing slash).
  final String explorerPrefix;

  String txExplorerUrl(String txHash) {
    final h = txHash.startsWith('0x') ? txHash : '0x$txHash';
    return '$explorerPrefix/tx/$h';
  }

  static const ChainConfig mainnet = ChainConfig(
    chainId: 1,
    name: 'Ethereum Mainnet',
    rpcUrl: kMainnetRpcUrl,
    explorerPrefix: 'https://etherscan.io',
  );

  static const ChainConfig sepolia = ChainConfig(
    chainId: 11155111,
    name: 'Sepolia',
    rpcUrl: kSepoliaRpcUrl,
    explorerPrefix: 'https://sepolia.etherscan.io',
  );

  static ChainConfig fromId(int id) {
    switch (id) {
      case 11155111:
        return sepolia;
      default:
        return mainnet;
    }
  }
}
