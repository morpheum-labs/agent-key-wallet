import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rainbow_flutter/core/di/injection.dart';
import 'package:rainbow_flutter/core/theme/app_colors.dart';
import 'package:rainbow_flutter/core/widgets/glass_card.dart';
import 'package:rainbow_flutter/core/widgets/primary_button.dart';
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
          context.go('/home');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () => context.pop(),
          ),
          title: const Text('Back up phrase'),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          children: [
            Text(
              'Write these 12 words in order and store them offline. Anyone with this phrase controls your funds.',
              style: Theme.of(context).textTheme.bodyMedium,
            ).animate().fadeIn(duration: 350.ms),
            const SizedBox(height: 20),
            GlassCard(
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: words.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 2.4,
                ),
                itemBuilder: (context, i) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.borderGlass),
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${i + 1}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            words[i],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
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
            const SizedBox(height: 20),
            CheckboxListTile(
              value: _confirmed,
              onChanged: (v) => setState(() => _confirmed = v ?? false),
              activeColor: AppColors.accent,
              title: const Text(
                'I have saved my recovery phrase in a safe place',
                style: TextStyle(fontSize: 14),
              ),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: 12),
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
    );
  }
}
