import 'package:web3dart/web3dart.dart';

/// Snapshot of native balance + optional USDC on EVM for the wallet overview.
///
/// Non-EVM networks return [evmNative] == null until a family-specific fetcher exists.
class PortfolioBalances {
  const PortfolioBalances({
    this.evmNative,
    this.usdcRaw,
    this.usdcError,
    this.usdcSkipped = false,
  });

  /// Native EVM balance (wei) when the active network is EVM.
  final EtherAmount? evmNative;
  final BigInt? usdcRaw;
  final Object? usdcError;

  /// When true, no USDC contract exists for this chain — UI keeps mock USDC row.
  final bool usdcSkipped;
}
