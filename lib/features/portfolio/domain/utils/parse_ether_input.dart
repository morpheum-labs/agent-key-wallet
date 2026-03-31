import 'package:web3dart/web3dart.dart';

/// Parses a decimal ETH string (e.g. `0.01`, `1.25`) into wei. Max 18 fractional digits.
EtherAmount parseEtherInput(String input) {
  final s = input.trim();
  if (s.isEmpty) {
    throw FormatException('Amount is empty');
  }
  if (s.startsWith('-')) {
    throw FormatException('Amount must be positive');
  }
  final parts = s.split('.');
  if (parts.length > 2) {
    throw FormatException('Invalid amount');
  }
  var wholeStr = parts[0].isEmpty ? '0' : parts[0];
  if (wholeStr.isEmpty) wholeStr = '0';
  var fracStr = parts.length > 1 ? parts[1] : '';
  if (fracStr.length > 18) {
    fracStr = fracStr.substring(0, 18);
  }
  fracStr = fracStr.padRight(18, '0');
  final whole = BigInt.tryParse(wholeStr);
  if (whole == null) {
    throw FormatException('Invalid amount');
  }
  final fracWei = BigInt.tryParse(fracStr.isEmpty ? '0' : fracStr) ?? BigInt.zero;
  final wei = whole * BigInt.from(10).pow(18) + fracWei;
  if (wei <= BigInt.zero) {
    throw FormatException('Amount must be greater than zero');
  }
  return EtherAmount.fromBigInt(EtherUnit.wei, wei);
}
