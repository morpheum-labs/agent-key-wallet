import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rainbow_flutter/core/data/chain_settings_repository.dart';
import 'package:rainbow_flutter/core/di/injection.dart';
import 'package:rainbow_flutter/core/error/failures.dart';
import 'package:rainbow_flutter/core/widgets/glass_card.dart';
import 'package:rainbow_flutter/core/widgets/primary_button.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';
import 'package:rainbow_flutter/features/portfolio/domain/usecases/send_eth_usecase.dart';
import 'package:url_launcher/url_launcher.dart';

class SendPage extends StatefulWidget {
  const SendPage({super.key});

  @override
  State<SendPage> createState() => _SendPageState();
}

class _SendPageState extends State<SendPage> {
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
      final explorerUrl = getIt<ChainSettingsRepository>().selectedSync.txExplorerUrl(hash);
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: AppColors.surfaceElevated,
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
      if (mounted) context.pop();
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: AppColors.label,
          onPressed: _submitting ? null : () => context.pop(),
        ),
        title: Text('Send ETH', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: RainbowSpacing.xxl.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: RainbowSpacing.lg.h),
              Text(
                'Send native ETH on ${getIt<ChainSettingsRepository>().selectedSync.name} (same RPC as balance). Gas is paid in ETH.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      color: AppColors.labelSecondary,
                    ),
              ),
              SizedBox(height: RainbowSpacing.xxl.h),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Recipient',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.labelSecondary,
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
                      'Amount (ETH)',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.labelSecondary,
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
          ),
        ),
      ),
    );
  }
}
