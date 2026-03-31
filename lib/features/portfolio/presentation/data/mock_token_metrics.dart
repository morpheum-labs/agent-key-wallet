import 'dart:math';

/// Deterministic mock metrics until a price API is wired.
double mockPercent24h(String symbol) {
  final h = symbol.hashCode.abs();
  return (h % 2000 - 1000) / 100.0;
}

/// Normalized 0..1 points for a mini sparkline (stable per symbol).
List<double> mockSparklinePoints(String symbol) {
  final rnd = Random(symbol.hashCode);
  var v = 0.45 + rnd.nextDouble() * 0.1;
  return List.generate(14, (_) {
    v += (rnd.nextDouble() - 0.48) * 0.12;
    return v.clamp(0.08, 0.92);
  });
}
