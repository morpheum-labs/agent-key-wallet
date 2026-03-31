import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:rainbow_flutter/core/widgets/wallet_flow_background.dart';
import 'package:rainbow_flutter/design_system/colors.dart';
import 'package:rainbow_flutter/design_system/spacing.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:rainbow_flutter/features/portfolio/presentation/widgets/receive_sheet_content.dart';

class ReceivePage extends StatelessWidget {
  const ReceivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
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
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: RainbowSpacing.xxl.w),
                child: ReceiveSheetContent(
                  onClose: () => context.pop(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
