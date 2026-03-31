import 'package:rainbow_flutter/core/error/failures.dart';
import 'package:rainbow_flutter/features/auth/domain/repositories/wallet_repository.dart';
import 'package:rainbow_flutter/features/portfolio/domain/utils/parse_ether_input.dart';
import 'package:web3dart/web3dart.dart';

class SendEthUseCase {
  SendEthUseCase(this._client, this._wallet);

  final Web3Client _client;
  final WalletRepository _wallet;

  /// Broadcasts a legacy-type native ETH transfer on the connected chain.
  /// Returns transaction hash (0x…).
  Future<String> call({
    required String toAddressHex,
    required String amountEthString,
  }) async {
    final to = _parseRecipient(toAddressHex);
    final EtherAmount value;
    try {
      value = parseEtherInput(amountEthString);
    } on FormatException catch (e) {
      throw ValidationFailure(e.message ?? 'Invalid amount');
    }

    final keyBytes = await _wallet.loadEthereumPrivateKeyBytes();
    final credentials = EthPrivateKey(keyBytes);

    final gasPrice = await _client.getGasPrice();
    final nonce = await _client.getTransactionCount(
      credentials.address,
      atBlock: BlockNum.pending(),
    );
    final chainId = await _client.getChainId();

    return _client.sendTransaction(
      credentials,
      Transaction(
        to: to,
        value: value,
        gasPrice: gasPrice,
        maxGas: 21000,
        nonce: nonce,
      ),
      chainId: chainId,
    );
  }

  EthereumAddress _parseRecipient(String raw) {
    final t = raw.trim();
    if (t.isEmpty) {
      throw const ValidationFailure('Recipient address is required');
    }
    try {
      return EthereumAddress.fromHex(t.startsWith('0x') ? t : '0x$t');
    } catch (_) {
      throw const ValidationFailure('Invalid recipient address');
    }
  }
}
