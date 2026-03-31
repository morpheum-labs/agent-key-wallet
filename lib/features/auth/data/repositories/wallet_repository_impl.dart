import 'package:bip39/bip39.dart' as bip39;

import '../../../../core/error/failures.dart';
import '../../domain/entities/wallet_summary.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../crypto/ethereum_wallet_derivation.dart';
import '../datasources/wallet_local_datasource.dart';
import '../datasources/wallet_private_key_datasource.dart';

class WalletRepositoryImpl implements WalletRepository {
  WalletRepositoryImpl({
    required WalletLocalDataSource mnemonicStore,
    required WalletPrivateKeyDataSource privateKeyStore,
  })  : _mnemonic = mnemonicStore,
        _pk = privateKeyStore;

  final WalletLocalDataSource _mnemonic;
  final WalletPrivateKeyDataSource _pk;

  @override
  Future<bool> hasWallet() async {
    final m = await _mnemonic.hasMnemonic();
    final p = await _pk.hasPrivateKey();
    return m || p;
  }

  @override
  Future<void> saveMnemonicWallet(String mnemonic) async {
    final normalized = mnemonic.trim().split(RegExp(r'\s+')).join(' ');
    if (!bip39.validateMnemonic(normalized)) {
      throw const ValidationFailure('Invalid recovery phrase');
    }
    await _pk.clearPrivateKey();
    await _mnemonic.writeMnemonic(normalized);
  }

  @override
  Future<void> savePrivateKeyWallet(String privateKeyHex) async {
    try {
      EthereumWalletDerivation.addressHexFromPrivateKeyHex(privateKeyHex);
    } catch (_) {
      throw const ValidationFailure('Invalid private key');
    }
    await _mnemonic.clearMnemonic();
    final hex = privateKeyHex.startsWith('0x')
        ? privateKeyHex.substring(2)
        : privateKeyHex;
    await _pk.writePrivateKey(hex);
  }

  @override
  Future<WalletSummary> loadWalletSummary() async {
    final mnemonic = await _mnemonic.readMnemonic();
    if (mnemonic != null && mnemonic.isNotEmpty) {
      final addr = EthereumWalletDerivation.addressHexFromMnemonic(mnemonic);
      return WalletSummary(ethereumAddressHex: addr);
    }
    final pk = await _pk.readPrivateKey();
    if (pk != null && pk.isNotEmpty) {
      final addr = EthereumWalletDerivation.addressHexFromPrivateKeyHex(pk);
      return WalletSummary(ethereumAddressHex: addr);
    }
    throw const WalletFailure('No wallet found');
  }

  @override
  Future<void> clearWallet() async {
    await _mnemonic.clearMnemonic();
    await _pk.clearPrivateKey();
  }
}
