import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rainbow_flutter/features/auth/domain/entities/wallet_summary.dart';
import 'package:rainbow_flutter/features/auth/domain/repositories/wallet_repository.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:rainbow_flutter/features/auth/presentation/bloc/auth_state.dart';

class _MockWalletRepository extends Mock implements WalletRepository {}

void main() {
  late _MockWalletRepository repo;

  setUp(() {
    repo = _MockWalletRepository();
  });

  blocTest<AuthBloc, AuthState>(
    'AuthStarted emits unauthenticated when no wallet',
    build: () => AuthBloc(walletRepository: repo),
    act: (bloc) => bloc.add(const AuthStarted()),
    setUp: () {
      when(() => repo.hasWallet()).thenAnswer((_) async => false);
    },
    expect: () => [const AuthUnauthenticated()],
  );

  blocTest<AuthBloc, AuthState>(
    'AuthStarted emits authenticated when wallet exists',
    build: () => AuthBloc(walletRepository: repo),
    act: (bloc) => bloc.add(const AuthStarted()),
    setUp: () {
      when(() => repo.hasWallet()).thenAnswer((_) async => true);
      when(() => repo.loadWalletSummary()).thenAnswer(
        (_) async => const WalletSummary(
          ethereumAddressHex: '0x0000000000000000000000000000000000000001',
        ),
      );
    },
    expect: () => [
      const AuthAuthenticated(
        WalletSummary(
          ethereumAddressHex: '0x0000000000000000000000000000000000000001',
        ),
      ),
    ],
  );

  blocTest<AuthBloc, AuthState>(
    'AuthLogoutRequested clears wallet and emits unauthenticated',
    build: () => AuthBloc(walletRepository: repo),
    act: (bloc) => bloc.add(const AuthLogoutRequested()),
    setUp: () {
      when(() => repo.clearWallet()).thenAnswer((_) async {});
    },
    expect: () => [const AuthUnauthenticated()],
  );
}
