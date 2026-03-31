import 'dart:typed_data';

import 'package:rainbow_flutter/features/auth/domain/entities/wallet_summary.dart';

abstract class WalletRepository {
  Future<bool> hasWallet();

  /// Persists mnemonic only after user confirmation — never log or expose in analytics.
  Future<void> saveMnemonicWallet(String mnemonic);

  Future<void> savePrivateKeyWallet(String privateKeyHex);

  Future<WalletSummary> loadWalletSummary();

  /// 32-byte secp256k1 key for default ETH account — use only for signing, never persist or log.
  Future<Uint8List> loadEthereumPrivateKeyBytes();

  Future<void> clearWallet();
}
