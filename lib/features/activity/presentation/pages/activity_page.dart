import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rainbow_flutter/core/config/wallet_network.dart';
import 'package:rainbow_flutter/core/di/injection.dart';
import 'package:rainbow_flutter/core/locator.dart';
import 'package:rainbow_flutter/core/widgets/glass_card.dart';
import 'package:rainbow_flutter/core/widgets/wallet_flow_background.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/gradients.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';
import 'package:rainbow_flutter/features/activity/domain/entities/evm_tx_history_item.dart';
import 'package:rainbow_flutter/features/activity/domain/usecases/fetch_evm_tx_history_usecase.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/utils/format_ether.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web3dart/web3dart.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: WalletFlowBackground(
              orbAccent: AppColors.accentGreen,
              child: const SafeArea(
                child: Center(child: Text('Sign in to see activity')),
              ),
            ),
          );
        }

        final net = AppLocator.network;
        if (net is! EvmWalletNetwork) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: WalletFlowBackground(
              orbAccent: AppColors.accentGreen,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(RainbowSpacing.xxl.w),
                  child: GlassCard(
                    padding: EdgeInsets.all(RainbowSpacing.xl.w),
                    child: Text(
                      'Transaction history is available on Ethereum (mainnet or Sepolia) in this build. '
                      'Switch network in Profile.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.labelSecondary,
                            height: 1.45,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }

        return _ActivityTxList(address: state.summary.ethereumAddressHex);
      },
    );
  }
}

class _ActivityTxList extends StatefulWidget {
  const _ActivityTxList({required this.address});

  final String address;

  @override
  State<_ActivityTxList> createState() => _ActivityTxListState();
}

class _ActivityTxListState extends State<_ActivityTxList> {
  late Future<List<EvmTxHistoryItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<EvmTxHistoryItem>> _load() =>
      getIt<FetchEvmTxHistoryUseCase>()(widget.address);

  Future<void> _refresh() async {
    setState(() {
      _future = _load();
    });
    await _future;
  }

  @override
  Widget build(BuildContext context) {
    final net = AppLocator.network as EvmWalletNetwork;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: WalletFlowBackground(
        orbAccent: AppColors.accentGreen,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: RainbowSpacing.xxl.w),
                child: Row(
                  children: [
                    Container(
                      width: 3.w,
                      height: 20.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(RainbowRadius.full),
                        gradient: RainbowGradients.accentRibbon(),
                      ),
                    ),
                    SizedBox(width: RainbowSpacing.sm.w),
                    Expanded(
                      child: Text(
                        'Activity',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.8,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: RainbowSpacing.sm.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: RainbowSpacing.xxl.w),
                child: Text(
                  'Normal transfers on ${net.name} (via Blockscout). Tap a row to open the explorer.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 13.sp,
                        color: AppColors.labelSecondary,
                        height: 1.45,
                      ),
                ),
              ),
              SizedBox(height: RainbowSpacing.md.h),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.accentSecondary,
                  backgroundColor: AppColors.surfaceElevated,
                  onRefresh: _refresh,
                  child: FutureBuilder<List<EvmTxHistoryItem>>(
                    future: _future,
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          children: [
                            SizedBox(height: 80.h),
                            Center(
                              child: SizedBox(
                                width: 28.w,
                                height: 28.w,
                                child: const CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                          ],
                        );
                      }

                      final items = snap.data ?? [];
                      if (items.isEmpty) {
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(
                            parent: BouncingScrollPhysics(),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: RainbowSpacing.xxl.w),
                          children: [
                            SizedBox(height: 48.h),
                            GlassCard(
                              padding: EdgeInsets.all(RainbowSpacing.xl.w),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.receipt_long_rounded,
                                    size: 28.sp,
                                    color: AppColors.accentGreen,
                                  ),
                                  SizedBox(width: RainbowSpacing.lg.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'No transfers yet',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        SizedBox(height: RainbowSpacing.xs.h),
                                        Text(
                                          'Send or receive on the Wallet tab — history loads from the public explorer.',
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: AppColors.labelSecondary,
                                                height: 1.4,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }

                      return ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: EdgeInsets.fromLTRB(
                          RainbowSpacing.xxl.w,
                          0,
                          RainbowSpacing.xxl.w,
                          RainbowSpacing.xxl.h,
                        ),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => SizedBox(height: RainbowSpacing.sm.h),
                        itemBuilder: (context, i) {
                          final t = items[i];
                          return _ActivityTxRow(
                            item: t,
                            symbol: net.nativeSymbol,
                            explorerTxUrl: net.txExplorerUrl(t.hash),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityTxRow extends StatelessWidget {
  const _ActivityTxRow({
    required this.item,
    required this.symbol,
    required this.explorerTxUrl,
  });

  final EvmTxHistoryItem item;
  final String symbol;
  final String explorerTxUrl;

  @override
  Widget build(BuildContext context) {
    final wei = BigInt.tryParse(item.valueWei) ?? BigInt.zero;
    final amount = formatEtherForUi(
      EtherAmount.fromBigInt(EtherUnit.wei, wei),
      maxDecimals: 6,
    );

    final (IconData icon, Color accent, String label) = switch (item.kind) {
      EvmTxKind.incoming => (
          Icons.south_west_rounded,
          AppColors.accentGreen,
          'Received',
        ),
      EvmTxKind.outgoing => (
          Icons.north_east_rounded,
          AppColors.accentSecondary,
          'Sent',
        ),
      EvmTxKind.selfTransfer => (
          Icons.compare_arrows_rounded,
          AppColors.accentPurple,
          'Self',
        ),
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(RainbowRadius.md),
        onTap: () async {
          final uri = Uri.parse(explorerTxUrl);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(RainbowRadius.md),
            border: Border.all(color: AppColors.borderGlass),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surfacePrimary.withValues(alpha: 0.72),
                AppColors.surfaceSecondary.withValues(alpha: 0.45),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: RainbowSpacing.lg.w,
              vertical: RainbowSpacing.md.h,
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accent.withValues(alpha: 0.18),
                    border: Border.all(color: AppColors.borderGlass),
                  ),
                  child: Icon(icon, size: 20.sp, color: accent),
                ),
                SizedBox(width: RainbowSpacing.md.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        _relTime(item.timestampSec),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.labelSecondary,
                              fontSize: 12.sp,
                            ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$amount $symbol',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${item.hash.substring(0, 6)}…${item.hash.substring(item.hash.length - 4)}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.labelSecondary,
                            fontSize: 10.sp,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _relTime(int timestampSec) {
  final t = DateTime.fromMillisecondsSinceEpoch(timestampSec * 1000);
  final d = DateTime.now().difference(t);
  if (d.inSeconds < 45) return 'Just now';
  if (d.inMinutes < 60) return '${d.inMinutes}m ago';
  if (d.inHours < 24) return '${d.inHours}h ago';
  if (d.inDays < 8) return '${d.inDays}d ago';
  return '${t.month}/${t.day}/${t.year}';
}
