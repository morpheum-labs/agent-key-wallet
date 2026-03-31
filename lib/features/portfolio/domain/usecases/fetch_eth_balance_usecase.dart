import 'package:web3dart/web3dart.dart';

import 'package:rainbow_flutter/features/portfolio/data/datasources/eth_balance_remote_datasource.dart';

class FetchEthBalanceUseCase {
  FetchEthBalanceUseCase(this._remote);

  final EthBalanceRemoteDataSource _remote;

  Future<EtherAmount> call(String addressEip55) {
    return _remote.getNativeBalance(addressEip55);
  }
}
