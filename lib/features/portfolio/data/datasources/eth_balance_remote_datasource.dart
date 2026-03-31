import 'package:web3dart/web3dart.dart';

/// Native ETH balance via JSON-RPC (mainnet).
class EthBalanceRemoteDataSource {
  EthBalanceRemoteDataSource({required Web3Client client}) : _client = client;

  final Web3Client _client;

  Future<EtherAmount> getNativeBalance(String addressEip55) async {
    final addr = EthereumAddress.fromHex(addressEip55);
    return _client.getBalance(addr);
  }
}
