import 'package:flutter/material.dart';
import 'package:rainbow_flutter/core/di/injection.dart';
import 'package:rainbow_flutter/features/portfolio/domain/usecases/fetch_erc20_balance_usecase.dart';

/// Fetches USDC (or any ERC-20) balance when [contractAddress] is non-null; otherwise completes with null.
class Erc20BalanceFutureBuilder extends StatefulWidget {
  const Erc20BalanceFutureBuilder({
    super.key,
    required this.contractAddress,
    required this.holderAddress,
    required this.builder,
  });

  final String? contractAddress;
  final String holderAddress;
  final Widget Function(
    BuildContext context,
    AsyncSnapshot<BigInt?> snapshot,
  ) builder;

  @override
  State<Erc20BalanceFutureBuilder> createState() => _Erc20BalanceFutureBuilderState();
}

class _Erc20BalanceFutureBuilderState extends State<Erc20BalanceFutureBuilder> {
  late Future<BigInt?> _future;

  @override
  void initState() {
    super.initState();
    _future = _resolve();
  }

  @override
  void didUpdateWidget(Erc20BalanceFutureBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.contractAddress != widget.contractAddress ||
        oldWidget.holderAddress != widget.holderAddress) {
      _future = _resolve();
    }
  }

  Future<BigInt?> _resolve() {
    final c = widget.contractAddress;
    if (c == null || c.isEmpty) {
      return Future<BigInt?>.value(null);
    }
    return getIt<FetchErc20BalanceUseCase>()(
      contractAddressEip55: c,
      holderAddressEip55: widget.holderAddress,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BigInt?>(
      future: _future,
      builder: widget.builder,
    );
  }
}
