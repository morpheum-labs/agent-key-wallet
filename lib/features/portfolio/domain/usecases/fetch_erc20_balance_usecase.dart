import 'package:rainbow_flutter/features/portfolio/data/datasources/erc20_balance_remote_datasource.dart';

class FetchErc20BalanceUseCase {
  FetchErc20BalanceUseCase(this._remote);

  final Erc20BalanceRemoteDataSource _remote;

  Future<BigInt> call({
    required String contractAddressEip55,
    required String holderAddressEip55,
  }) {
    return _remote.balanceOf(
      contractAddressEip55: contractAddressEip55,
      holderAddressEip55: holderAddressEip55,
    );
  }
}
