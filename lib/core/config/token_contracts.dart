/// Known ERC-20 addresses per chain (extend as you add tokens).
abstract final class TokenContracts {
  /// Circle USDC on Ethereum mainnet.
  static const String usdcMainnet = '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';

  /// USDC on Sepolia (official test token).
  static const String usdcSepolia = '0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238';

  static String? usdcAddressForChain(int chainId) {
    switch (chainId) {
      case 1:
        return usdcMainnet;
      case 11155111:
        return usdcSepolia;
      default:
        return null;
    }
  }
}
