import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rainbow_flutter/core/theme/app_colors.dart';
import 'package:rainbow_flutter/core/widgets/glass_card.dart';
import 'package:rainbow_flutter/core/widgets/primary_button.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_state.dart';

class ImportWalletPage extends StatefulWidget {
  const ImportWalletPage({super.key});

  @override
  State<ImportWalletPage> createState() => _ImportWalletPageState();
}

class _ImportWalletPageState extends State<ImportWalletPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _mnemonicController = TextEditingController();
  final _pkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    _mnemonicController.dispose();
    _pkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/wallet');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
          title: const Text('Import wallet'),
          bottom: TabBar(
            controller: _tabs,
            indicatorColor: AppColors.accent,
            labelColor: AppColors.textPrimary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: const [
              Tab(text: 'Recovery phrase'),
              Tab(text: 'Private key'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabs,
          children: [
            _ImportBody(
              hint: 'Enter your 12 or 24 word phrase',
              controller: _mnemonicController,
              onSubmit: () {
                context.read<AuthBloc>().add(
                      AuthImportMnemonicRequested(_mnemonicController.text),
                    );
              },
            ),
            _ImportBody(
              hint: '0x… (64 hex characters)',
              controller: _pkController,
              onSubmit: () {
                context.read<AuthBloc>().add(
                      AuthImportPrivateKeyRequested(_pkController.text.trim()),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ImportBody extends StatelessWidget {
  const _ImportBody({
    required this.hint,
    required this.controller,
    required this.onSubmit,
  });

  final String hint;
  final TextEditingController controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        GlassCard(
          child: TextField(
            controller: controller,
            maxLines: hint.contains('12') ? 5 : 2,
            style: const TextStyle(fontSize: 15),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.textSecondary.withValues(alpha: 0.85),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        PrimaryButton(
          label: 'Import',
          icon: Icons.download_rounded,
          onPressed: onSubmit,
        ),
      ],
    );
  }
}
