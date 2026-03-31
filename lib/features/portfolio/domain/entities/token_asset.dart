import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Portfolio token row (MVP — replace with API + chain data later).
///
/// [erc20ContractAddress] applies to EVM; future Solana rows can add an SPL mint field
/// in the same model without changing list UI.
class TokenAsset extends Equatable {
  const TokenAsset({
    required this.symbol,
    required this.name,
    required this.balanceDisplay,
    required this.fiatDisplay,
    required this.accentColor,
    this.erc20ContractAddress,
    this.unitDecimals = 18,
    this.percentChange24h,
    this.sparklinePoints,
  });

  final String symbol;
  final String name;
  final String balanceDisplay;
  final String fiatDisplay;
  final Color accentColor;

  /// If set, balance is read via ERC-20 [balanceOf] on this contract.
  final String? erc20ContractAddress;

  /// ERC-20 decimals for formatting (ETH native uses 18 for display only).
  final int unitDecimals;

  /// Mock / API: 24h % change (e.g. +2.35).
  final double? percentChange24h;

  /// Normalized 0..1 samples for sparkline (oldest → newest).
  final List<double>? sparklinePoints;

  /// URL segment for [GoRouter], e.g. `eth` → `/wallet/token/eth`.
  String get routeSlug => symbol.toLowerCase();

  TokenAsset copyWith({
    String? symbol,
    String? name,
    String? balanceDisplay,
    String? fiatDisplay,
    Color? accentColor,
    String? erc20ContractAddress,
    int? unitDecimals,
    double? percentChange24h,
    List<double>? sparklinePoints,
  }) {
    return TokenAsset(
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      balanceDisplay: balanceDisplay ?? this.balanceDisplay,
      fiatDisplay: fiatDisplay ?? this.fiatDisplay,
      accentColor: accentColor ?? this.accentColor,
      erc20ContractAddress: erc20ContractAddress ?? this.erc20ContractAddress,
      unitDecimals: unitDecimals ?? this.unitDecimals,
      percentChange24h: percentChange24h ?? this.percentChange24h,
      sparklinePoints: sparklinePoints ?? this.sparklinePoints,
    );
  }

  @override
  List<Object?> get props => [
        symbol,
        name,
        balanceDisplay,
        fiatDisplay,
        accentColor,
        erc20ContractAddress,
        unitDecimals,
        percentChange24h,
        sparklinePoints,
      ];
}
