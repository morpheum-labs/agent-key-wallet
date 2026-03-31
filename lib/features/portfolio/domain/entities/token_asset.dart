import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Portfolio token row (MVP — replace with API + chain data later).
class TokenAsset extends Equatable {
  const TokenAsset({
    required this.symbol,
    required this.name,
    required this.balanceDisplay,
    required this.fiatDisplay,
    required this.accentColor,
  });

  final String symbol;
  final String name;
  final String balanceDisplay;
  final String fiatDisplay;
  final Color accentColor;

  /// URL segment for [GoRouter], e.g. `eth` → `/wallet/token/eth`.
  String get routeSlug => symbol.toLowerCase();

  TokenAsset copyWith({
    String? symbol,
    String? name,
    String? balanceDisplay,
    String? fiatDisplay,
    Color? accentColor,
  }) {
    return TokenAsset(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      balanceDisplay: balanceDisplay ?? this.balanceDisplay,
      fiatDisplay: fiatDisplay ?? this.fiatDisplay,
      accentColor: accentColor ?? this.accentColor,
    );
  }

  @override
  List<Object?> get props => [symbol, name, balanceDisplay, fiatDisplay, accentColor];
}
