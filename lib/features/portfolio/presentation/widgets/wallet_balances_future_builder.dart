import 'package:flutter/material.dart';
import 'package:rainbow_flutter/core/di/injection.dart';
import 'package:rainbow_flutter/features/portfolio/domain/entities/portfolio_balances.dart';
import 'package:rainbow_flutter/features/portfolio/domain/usecases/fetch_wallet_balances_usecase.dart';

/// Fetches [PortfolioBalances] once per [address] change; child builds from snapshot.
class WalletBalancesFutureBuilder extends StatefulWidget {
  const WalletBalancesFutureBuilder({
    super.key,
    required this.address,
    required this.builder,
  });

  final String address;
  final Widget Function(BuildContext context, AsyncSnapshot<PortfolioBalances> snapshot) builder;

  @override
  State<WalletBalancesFutureBuilder> createState() => _WalletBalancesFutureBuilderState();
}

class _WalletBalancesFutureBuilderState extends State<WalletBalancesFutureBuilder> {
  late Future<PortfolioBalances> _future;

  @override
  void initState() {
    super.initState();
    _future = getIt<FetchWalletBalancesUseCase>()(widget.address);
  }

  @override
  void didUpdateWidget(WalletBalancesFutureBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.address != widget.address) {
      _future = getIt<FetchWalletBalancesUseCase>()(widget.address);
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
