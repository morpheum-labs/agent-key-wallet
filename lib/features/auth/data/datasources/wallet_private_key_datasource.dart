import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String _kPrivateKeyKey = 'wallet_private_key_v1';

/// Optional path for wallets imported from raw hex (no mnemonic on device).
class WalletPrivateKeyDataSource {
  WalletPrivateKeyDataSource(this._storage);

  final FlutterSecureStorage _storage;

  Future<bool> hasPrivateKey() async {
    final v = await _storage.read(key: _kPrivateKeyKey);
    return v != null && v.isNotEmpty;
  }

  Future<void> writePrivateKey(String hex) {
    return _storage.write(key: _kPrivateKeyKey, value: hex);
  }

  Future<String?> readPrivateKey() {
    return _storage.read(key: _kPrivateKeyKey);
  }

  Future<void> clearPrivateKey() {
    return _storage.delete(key: _kPrivateKeyKey);
  }
}
