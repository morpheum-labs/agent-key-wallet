import 'package:web3dart/web3dart.dart';

/// Display-friendly ETH string from on-chain [EtherAmount] (mainnet native).
String formatEtherForUi(EtherAmount amount, {int maxDecimals = 6}) {
  final v = amount.getValueInUnit(EtherUnit.ether);
  if (v == 0) return '0';
  final s = v.toStringAsFixed(maxDecimals);
  return s.replaceFirst(RegExp(r'\.?0+$'), '');
}
