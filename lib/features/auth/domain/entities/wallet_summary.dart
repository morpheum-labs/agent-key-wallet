import 'package:equatable/equatable.dart';

class WalletSummary extends Equatable {
  const WalletSummary({
    required this.ethereumAddressHex,
  });

  final String ethereumAddressHex;

  String get shortAddress {
    if (ethereumAddressHex.length < 10) return ethereumAddressHex;
    return '${ethereumAddressHex.substring(0, 6)}…${ethereumAddressHex.substring(ethereumAddressHex.length - 4)}';
  }

  @override
  List<Object?> get props => [ethereumAddressHex];
}
