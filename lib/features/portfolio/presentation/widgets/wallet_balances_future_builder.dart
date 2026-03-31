import 'package:flutter/material.dart';
import 'package:rainbow_flutter/core/di/injection.dart';
import 'package:rainbow_flutter/features/portfolio/domain/entities/portfolio_balances.dart';
import 'package:rainbow_flutter/features/portfolio/domain/usecases/fetch_wallet_balances_usecase.dart';

/// Fetches [PortfolioBalances] once per [address] change; child builds from snapshot.
///
/// Call [WalletBalancesFutureBuilderState.reload] (via [GlobalKey]) to refetch after pull-to-refresh.
class WalletBalancesFutureBuilder extends StatefulWidget {
  const WalletBalancesFutureBuilder({
    super.key,
    required this.address,
    required this.builder,
  });

  final String address;
  final Widget Function(BuildContext context, AsyncSnapshot<PortfolioBalances> snapshot) builder;

  @override
  WalletBalancesFutureBuilderState createState() => WalletBalancesFutureBuilderState();
}

class WalletBalancesFutureBuilderState extends State<WalletBalancesFutureBuilder> {
  late Future<PortfolioBalances> _future;

  Future<PortfolioBalances> _createFuture() =>
      getIt<FetchWalletBalancesUseCase>()(widget.address);

  /// Refetches balances; await to keep [RefreshIndicator] visible until complete.
  Future<void> reload() async {
    setState(() {
      _future = _createFuture();
    });
    await _future;
  }

  @override
  void initState() {
    super.initState();
    _future = _createFuture();
  }

  @override
  void didUpdateWidget(WalletBalancesFutureBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.address != widget.address) {
      _future = _createFuture();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PortfolioBalances>(
      future: _future,
      builder: widget.builder,
    );
  }
}
