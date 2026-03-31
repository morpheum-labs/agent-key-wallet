import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:rainbow_flutter/core/di/injection.dart';
import 'package:rainbow_flutter/core/theme/app_colors.dart';
import 'package:rainbow_flutter/core/widgets/glass_card.dart';
import 'package:rainbow_flutter/core/widgets/primary_button.dart';
import 'package:rainbow_flutter/core/widgets/wallet_flow_background.dart';
import 'package:rainbow_flutter/design_system/radius.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';
import 'package:rainbow_flutter/features/auth/domain/usecases/generate_mnemonic_usecase.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_state.dart';

class CreateWalletPage extends StatefulWidget {
  const CreateWalletPage({super.key});

  @override
  State<CreateWalletPage> createState() => _CreateWalletPageState();
}

class _CreateWalletPageState extends State<CreateWalletPage> {
  late final String _mnemonic;
  var _confirmed = false;

  @override
  void initState() {
    super.initState();
    _mnemonic = getIt<GenerateMnemonicUseCase>()();
  }

  @override
  Widget build(BuildContext context) {
    final words = _mnemonic.split(' ');

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/wallet');
        }
      },
      child: Scaffold(
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
          title: const Text('Back up phrase'),
        ),
        body: WalletFlowBackground(
          orbAccent: AppColors.accentPurple,
          child: SafeArea(
            top: false,
            child: ListView(
              padding: EdgeInsets.fromLTRB(
                RainbowSpacing.xxl.w,
                RainbowSpacing.sm.h,
                RainbowSpacing.xxl.w,
                RainbowSpacing.xxl.h,
              ),
              children: [
                Text(
                  'Write these 12 words in order and store them offline. Anyone with this phrase controls your funds.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 15.sp,
                        height: 1.45,
                        color: AppColors.labelSecondary,
                      ),
                ).animate().fadeIn(duration: 350.ms),
                SizedBox(height: RainbowSpacing.lg.h),
                GlassCard(
                  padding: EdgeInsets.all(RainbowSpacing.lg.w),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: words.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10.h,
                      crossAxisSpacing: 10.w,
                      childAspectRatio: 2.4,
                    ),
                    itemBuilder: (context, i) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceElevated.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(RainbowRadius.sm),
                          border: Border.all(color: AppColors.borderGlass),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${i + 1}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.labelSecondary,
                                    fontSize: 11.sp,
                                  ),
                            ),
                            SizedBox(width: 6.w),
                            Expanded(
                              child: Text(
                                words[i],
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13.sp,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ).animate().fadeIn(delay: 100.ms).scale(
                      begin: const Offset(0.98, 0.98),
                      curve: Curves.easeOutCubic,
                    ),
                SizedBox(height: RainbowSpacing.lg.h),
                Theme(
                  data: Theme.of(context).copyWith(
                    checkboxTheme: CheckboxThemeData(
                      fillColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return AppColors.accent;
                        }
                        return null;
                      }),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _confirmed,
                        onChanged: (v) => setState(() => _confirmed = v ?? false),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Text(
                            'I have saved my recovery phrase in a safe place',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 15.sp,
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: RainbowSpacing.md.h),
                PrimaryButton(
                  label: 'Continue',
                  onPressed: _confirmed
                      ? () => context.read<AuthBloc>().add(
                            AuthPersistMnemonicRequested(_mnemonic),
                          )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
