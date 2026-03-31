import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restart_app/restart_app.dart';

import 'package:rainbow_flutter/core/config/wallet_network.dart';
import 'package:rainbow_flutter/core/config/wallet_network_registry.dart';
import 'package:rainbow_flutter/core/locator.dart';
import 'package:rainbow_flutter/core/widgets/primary_button.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/gradients.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final chainRepo = AppLocator.chainSettings;
    final selectedId = chainRepo.readNetworkIdSync();

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final summary = state is AuthAuthenticated ? state.summary : null;

        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                right: -20.w,
                bottom: 120.h,
                child: IgnorePointer(
                  child: Container(
                    width: 200.w,
                    height: 200.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RainbowGradients.radialGlow(
                        AppColors.accentPurple,
                        opacity: 0.15,
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: RainbowSpacing.xxl.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Profile',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.8,
                            ),
                      ),
                      SizedBox(height: RainbowSpacing.xxl.h),
                      Text(
                        'Address',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 13.sp,
                              color: AppColors.labelSecondary,
                            ),
                      ),
                      SizedBox(height: RainbowSpacing.xs.h),
                      SelectableText(
                        summary?.shortAddress ?? '—',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 16.sp,
                            ),
                      ),
                      SizedBox(height: RainbowSpacing.xxl.h),
                      Text(
                        'Network',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      SizedBox(height: RainbowSpacing.sm.h),
                      Text(
                        'Balance, send, and receive follow the active network family. '
                        'The app restarts after you switch.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 13.sp,
                              color: AppColors.labelSecondary,
                            ),
                      ),
                      SizedBox(height: RainbowSpacing.md.h),
                      ...WalletNetworkRegistry.all.map(
                        (WalletNetwork n) => RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            n.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          subtitle: Text(
                            n.settingsSubtitle,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.labelSecondary,
                                ),
                          ),
                          value: n.id,
                          groupValue: selectedId,
                          onChanged: (v) async {
                            if (v == null || v == selectedId) return;
                            await chainRepo.setNetworkId(v);
                            Restart.restartApp();
                          },
                        ),
                      ),
                      SizedBox(height: RainbowSpacing.xxl.h),
                      PrimaryButton(
                        label: 'Log out',
                        icon: Icons.logout_rounded,
                        onPressed: () => context.read<AuthBloc>().add(
                              const AuthLogoutRequested(),
                            ),
                      ),
                      SizedBox(height: RainbowSpacing.xxl.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
