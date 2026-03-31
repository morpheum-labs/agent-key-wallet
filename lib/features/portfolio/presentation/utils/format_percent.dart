/// Formats 24h % for portfolio rows (mock or API).
String formatPercentChange(double? p, {int fractionDigits = 2}) {
  if (p == null) return '—';
  final sign = p >= 0 ? '+' : '';
  return '$sign${p.toStringAsFixed(fractionDigits)}%';
}
