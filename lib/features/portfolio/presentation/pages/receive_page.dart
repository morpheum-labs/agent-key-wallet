import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:rainbow_flutter/core/config/wallet_network.dart';
import 'package:rainbow_flutter/core/locator.dart';
import 'package:rainbow_flutter/core/widgets/primary_button.dart';
import 'package:rainbow_flutter/core/widgets/wallet_flow_background.dart';
import 'package:rainbow_flutter/design_system/blurs.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_state.dart';

class ReceivePage extends StatelessWidget {
  const ReceivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final address = state is AuthAuthenticated ? state.summary.ethereumAddressHex : null;
        final network = AppLocator.network;
        final evm = network is EvmWalletNetwork ? network : null;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: AppColors.label,
              onPressed: () => context.pop(),
            ),
            title: Text('Receive', style: Theme.of(context).textTheme.titleLarge),
          ),
          body: WalletFlowBackground(
            orbAccent: AppColors.accentSecondary,
            child: SafeArea(
              child: address == null
                  ? Center(
                      child: Text(
                        'No wallet',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: RainbowSpacing.xxl.w),
                      child: evm == null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height: RainbowSpacing.lg.h),
                                Text(
                                  'This wallet currently derives an Ethereum-style (EVM) address. '
                                  '${network.name} uses a different address format; wire Solana/Bitcoin '
                                  'derivation and show a separate receive QR when those stacks are added.',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontSize: 15.sp,
                                        color: AppColors.labelSecondary,
                                      ),
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SizedBox(height: RainbowSpacing.lg.h),
                                Text(
                                  'Send only ${evm.nativeSymbol} and ERC-20 tokens on ${evm.name} to this address.',
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontSize: 15.sp,
                                        color: AppColors.labelSecondary,
                                      ),
                                ),
                                SizedBox(height: RainbowSpacing.xxl.h),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(RainbowRadius.xl),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                      sigmaX: RainbowBlur.card,
                                      sigmaY: RainbowBlur.card,
                                    ),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(RainbowRadius.xl),
                                        border: Border.all(color: AppColors.borderGlass),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            AppColors.surfacePrimary.withValues(alpha: 0.72),
                                            AppColors.surfaceSecondary.withValues(alpha: 0.48),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.accent.withValues(alpha: 0.12),
                                            blurRadius: 32,
                                            offset: const Offset(0, 16),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(RainbowSpacing.xxl.w),
                                        child: Column(
                                          children: [
                                            QrImageView(
                                              data: address,
                                              version: QrVersions.auto,
                                              size: 200.w,
                                              eyeStyle: const QrEyeStyle(
                                                eyeShape: QrEyeShape.square,
                                                color: AppColors.label,
                                              ),
                                              dataModuleStyle: const QrDataModuleStyle(
                                                dataModuleShape: QrDataModuleShape.square,
                                                color: AppColors.label,
                                              ),
                                              gapless: true,
                                              backgroundColor: Colors.transparent,
                                            ),
                                            SizedBox(height: RainbowSpacing.xxl.h),
                                            SelectableText(
                                              address,
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                    fontSize: 14.sp,
                                                    height: 1.4,
                                                  ),
                                            ),
                                            SizedBox(height: RainbowSpacing.lg.h),
                                            OutlinedButton.icon(
                                              onPressed: () async {
                                                await Clipboard.setData(ClipboardData(text: address));
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Address copied')),
                                                  );
                                                }
                                              },
                                              icon: const Icon(Icons.copy_rounded, size: 20),
                                              label: const Text('Copy address'),
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: AppColors.label,
                                                side: const BorderSide(color: AppColors.borderGlass),
                                                padding: EdgeInsets.symmetric(
                                                  vertical: RainbowSpacing.md.h,
                                                  horizontal: RainbowSpacing.xl.w,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(RainbowRadius.md),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: RainbowSpacing.xl.h),
                                PrimaryButton(
                                  label: 'Done',
                                  icon: Icons.check_rounded,
                                  onPressed: () => context.pop(),
                                ),
                              ],
                            ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
