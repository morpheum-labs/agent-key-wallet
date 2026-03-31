import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:rainbow_flutter/core/locator.dart';
import 'package:rainbow_flutter/core/widgets/glass_card.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
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

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              color: AppColors.label,
              onPressed: () => context.pop(),
            ),
            title: Text('Receive', style: Theme.of(context).textTheme.titleLarge),
          ),
          body: SafeArea(
            child: address == null
                ? Center(
                    child: Text(
                      'No wallet',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: RainbowSpacing.xxl.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: RainbowSpacing.lg.h),
                        Text(
                          'Send only ETH and ERC-20 tokens on ${AppLocator.chain.name} to this address.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontSize: 15.sp,
                                color: AppColors.labelSecondary,
                              ),
                        ),
                        SizedBox(height: RainbowSpacing.xxl.h),
                        GlassCard(
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
                              FilledButton.icon(
                                onPressed: () async {
                                  await Clipboard.setData(ClipboardData(text: address));
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Address copied')),
                                    );
                                  }
                                },
                                icon: const Icon(Icons.copy_rounded),
                                label: const Text('Copy address'),
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.surfaceElevated,
                                  foregroundColor: AppColors.label,
                                  padding: EdgeInsets.symmetric(
                                    vertical: RainbowSpacing.md.h,
                                    horizontal: RainbowSpacing.xl.w,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}
