import 'package:web3dart/web3dart.dart';

import 'package:rainbow_flutter/features/portfolio/data/erc20_abi.dart';

class Erc20BalanceRemoteDataSource {
  Erc20BalanceRemoteDataSource({required Web3Client client}) : _client = client;

  final Web3Client _client;

  Future<BigInt> balanceOf({
    required String contractAddressEip55,
    required String holderAddressEip55,
  }) async {
    final abi = ContractAbi.fromJson(kErc20BalanceOfAbiJson, 'ERC20');
    final contract = DeployedContract(
      abi,
      EthereumAddress.fromHex(contractAddressEip55),
    );
    final result = await _client.call(
      contract: contract,
      function: contract.function('balanceOf'),
      params: [EthereumAddress.fromHex(holderAddressEip55)],
    );
    return result.first as BigInt;
  }
}
