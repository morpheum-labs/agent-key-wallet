import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:rainbow_flutter/core/config/wallet_network.dart';
import 'package:rainbow_flutter/core/di/injection.dart';
import 'package:rainbow_flutter/core/error/failures.dart';
import 'package:rainbow_flutter/core/locator.dart';
import 'package:rainbow_flutter/core/widgets/glass_card.dart';
import 'package:rainbow_flutter/core/widgets/primary_button.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';
import 'package:rainbow_flutter/features/portfolio/domain/usecases/send_eth_usecase.dart';
import 'package:url_launcher/url_launcher.dart';

/// Shared body for [SendPage] and [showWalletSendSheet].
class SendSheetContent extends StatefulWidget {
  const SendSheetContent({
    super.key,
    required this.onDismiss,
  });

  /// Called after a successful send (after the tx hash dialog), or when the caller
  /// wants to close the host (sheet or route).
  final VoidCallback onDismiss;

  @override
  State<SendSheetContent> createState() => _SendSheetContentState();
}

class _SendSheetContentState extends State<SendSheetContent> {
  final _toController = TextEditingController();
  final _amountController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _toController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    if (_submitting) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitting = true);
    try {
      final hash = await getIt<SendEthUseCase>()(
        toAddressHex: _toController.text,
        amountEthString: _amountController.text,
      );
      if (!mounted) return;
      final explorerUrl = AppLocator.network.txExplorerUrl(hash);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surfaceElevated,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(RainbowRadius.xl),
          ),
          title: Text('Sent', style: Theme.of(ctx).textTheme.titleLarge),
          content: SelectableText(
            hash,
            style: Theme.of(ctx).textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                final uri = Uri.parse(explorerUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: const Text('View on explorer'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      if (mounted) widget.onDismiss();
    } on ValidationFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } on WalletFailure catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final network = AppLocator.network;
    final evm = network is EvmWalletNetwork ? network : null;

    if (evm == null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: RainbowSpacing.lg.h),
          Text(
            'Native transfers for ${network.name} are not wired in this build. '
            'Switch to an EVM network in Profile to send with the current key, '
            'or add a Solana/Bitcoin signer and RPC stack.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15.sp,
                  color: AppColors.labelSecondary,
                ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: RainbowSpacing.lg.h),
        Text(
          'Send native ${evm.nativeSymbol} on ${evm.name} (same RPC as balance). '
          'Gas is paid in ${evm.nativeSymbol}.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14.sp,
                color: AppColors.labelSecondary,
              ),
        ),
        SizedBox(height: RainbowSpacing.xxl.h),
        GlassCard(
          padding: EdgeInsets.all(RainbowSpacing.xl.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Recipient',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.labelSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: RainbowSpacing.sm.h),
              TextField(
                controller: _toController,
                enabled: !_submitting,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: const InputDecoration(
                  hintText: '0x…',
                  border: InputBorder.none,
                  isDense: true,
                ),
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
              ),
              SizedBox(height: RainbowSpacing.xl.h),
              Text(
                'Amount (${evm.nativeSymbol})',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.labelSecondary,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              SizedBox(height: RainbowSpacing.sm.h),
              TextField(
                controller: _amountController,
                enabled: !_submitting,
                style: Theme.of(context).textTheme.bodyLarge,
                decoration: const InputDecoration(
                  hintText: '0.0',
                  border: InputBorder.none,
                  isDense: true,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _onSend(),
              ),
            ],
          ),
        ),
        SizedBox(height: RainbowSpacing.xxl.h),
        _submitting
            ? Center(
                child: SizedBox(
                  width: 28.w,
                  height: 28.w,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            : PrimaryButton(
                label: 'Send',
                icon: Icons.north_east_rounded,
                onPressed: _onSend,
              ),
        SizedBox(height: RainbowSpacing.xxl.h),
      ],
    );
  }
}
