import 'package:flutter/material.dart';
import 'package:rainbow_flutter/core/di/injection.dart';
import 'package:rainbow_flutter/features/portfolio/domain/usecases/fetch_eth_balance_usecase.dart';
import 'package:web3dart/web3dart.dart';

/// Fetches mainnet ETH once per [address] (re-fetches when address changes).
class EthBalanceFutureBuilder extends StatefulWidget {
  const EthBalanceFutureBuilder({
    super.key,
    required this.address,
    required this.builder,
  });

  final String address;
  final Widget Function(
    BuildContext context,
    AsyncSnapshot<EtherAmount> snapshot,
  ) builder;

  @override
  State<EthBalanceFutureBuilder> createState() => _EthBalanceFutureBuilderState();
}

class _EthBalanceFutureBuilderState extends State<EthBalanceFutureBuilder> {
  late Future<EtherAmount> _future;

  @override
  void initState() {
    super.initState();
    _future = getIt<FetchEthBalanceUseCase>()(widget.address);
  }

  @override
  void didUpdateWidget(EthBalanceFutureBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.address != widget.address) {
      _future = getIt<FetchEthBalanceUseCase>()(widget.address);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<EtherAmount>(
      future: _future,
      builder: widget.builder,
    );
  }
}
