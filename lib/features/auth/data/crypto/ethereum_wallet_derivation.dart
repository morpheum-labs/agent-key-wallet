import 'dart:typed_data';

import 'package:bip32/bip32.dart' as bip32;
import 'package:bip39/bip39.dart' as bip39;
import 'package:convert/convert.dart';
import 'package:web3dart/web3dart.dart';

import '../../../../core/config/app_constants.dart';

/// Derives the default Ethereum account (BIP44 path) from a BIP39 mnemonic.
abstract final class EthereumWalletDerivation {
  static String addressHexFromMnemonic(String mnemonic) {
    if (!bip39.validateMnemonic(mnemonic)) {
      throw ArgumentError('Invalid mnemonic');
    }
    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);
    final child = root.derivePath(kEthereumDerivationPath);
    final pk = child.privateKey;
    if (pk == null) {
      throw StateError('Could not derive private key');
    }
    final hexKey = bytesToHex(pk, include0x: true);
    final ethKey = EthPrivateKey.fromHex(hexKey);
    return ethKey.address.eip55With0x;
  }

  static String addressHexFromPrivateKeyHex(String hex) {
    final normalized = hex.startsWith('0x') ? hex : '0x$hex';
    if (normalized.length != 66) {
      throw ArgumentError('Private key must be 32 bytes (64 hex chars)');
    }
    final key = EthPrivateKey.fromHex(normalized);
    return key.address.eip55With0x;
  }

  /// 32-byte secp256k1 secret for the default account (same path as address helpers).
  static Uint8List privateKeyBytesFromMnemonic(String mnemonic) {
    if (!bip39.validateMnemonic(mnemonic)) {
      throw ArgumentError('Invalid mnemonic');
    }
    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);
    final child = root.derivePath(kEthereumDerivationPath);
    final pk = child.privateKey;
    if (pk == null) {
      throw StateError('Could not derive private key');
    }
    return Uint8List.fromList(pk);
  }

  static Uint8List privateKeyBytesFromPkHex(String hexString) {
    final normalized = hexString.startsWith('0x') ? hexString.substring(2) : hexString;
    if (normalized.length != 64) {
      throw ArgumentError('Private key must be 32 bytes (64 hex chars)');
    }
    return Uint8List.fromList(hex.decode(normalized));
  }
}
