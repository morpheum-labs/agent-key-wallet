import 'package:web3dart/web3dart.dart';

/// Snapshot of native ETH + optional USDC for the wallet overview.
class PortfolioBalances {
  const PortfolioBalances({
    required this.eth,
    this.usdcRaw,
    this.usdcError,
    this.usdcSkipped = false,
  });

  final EtherAmount eth;
  final BigInt? usdcRaw;
  final Object? usdcError;

  /// When true, no USDC contract exists for this chain — UI keeps mock USDC row.
  final bool usdcSkipped;
}
