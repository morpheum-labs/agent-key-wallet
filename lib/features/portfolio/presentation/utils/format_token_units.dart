/// Formats a raw [amount] with [decimals] fractional digits (e.g. USDC 6, ETH 18).
String formatTokenUnits(BigInt amount, int decimals) {
  if (decimals <= 0) return amount.toString();
  final divisor = BigInt.from(10).pow(decimals);
  final whole = amount ~/ divisor;
  final frac = amount % divisor;
  if (frac == BigInt.zero) return whole.toString();
  var fracStr = frac.toString().padLeft(decimals, '0');
  fracStr = fracStr.replaceFirst(RegExp(r'0+$'), '');
  if (fracStr.isEmpty) return whole.toString();
  return '$whole.$fracStr';
}
