import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/config/app_constants.dart';

class WalletLocalDataSource {
  WalletLocalDataSource(this._storage);

  final FlutterSecureStorage _storage;

  Future<bool> hasMnemonic() async {
    final v = await _storage.read(key: kSecureStorageMnemonicKey);
    return v != null && v.isNotEmpty;
  }

  Future<void> writeMnemonic(String mnemonic) {
    return _storage.write(key: kSecureStorageMnemonicKey, value: mnemonic);
  }

  Future<String?> readMnemonic() {
    return _storage.read(key: kSecureStorageMnemonicKey);
  }

  Future<void> clearMnemonic() {
    return _storage.delete(key: kSecureStorageMnemonicKey);
  }
}
