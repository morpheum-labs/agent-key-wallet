import 'package:rainbow_flutter/features/auth/domain/entities/wallet_summary.dart';

abstract class WalletRepository {
  Future<bool> hasWallet();

  /// Persists mnemonic only after user confirmation — never log or expose in analytics.
  Future<void> saveMnemonicWallet(String mnemonic);

  Future<void> savePrivateKeyWallet(String privateKeyHex);

  Future<WalletSummary> loadWalletSummary();

  Future<void> clearWallet();
}
