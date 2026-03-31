import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/repositories/wallet_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required WalletRepository walletRepository})
      : _walletRepository = walletRepository,
        super(const AuthLoading()) {
    on<AuthStarted>(_onStarted);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthPersistMnemonicRequested>(_onPersistMnemonic);
    on<AuthImportMnemonicRequested>(_onImportMnemonic);
    on<AuthImportPrivateKeyRequested>(_onImportPrivateKey);
  }

  final WalletRepository _walletRepository;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final has = await _walletRepository.hasWallet();
      if (!has) {
        emit(const AuthUnauthenticated());
        return;
      }
      final summary = await _walletRepository.loadWalletSummary();
      emit(AuthAuthenticated(summary));
    } on Failure catch (e) {
      emit(AuthError(_failureMessage(e)));
    } catch (_) {
      emit(const AuthError('Could not unlock wallet'));
    }
  }

  Future<void> _onLogout(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    await _walletRepository.clearWallet();
    emit(const AuthUnauthenticated());
  }

  Future<void> _onPersistMnemonic(
    AuthPersistMnemonicRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _walletRepository.saveMnemonicWallet(event.mnemonic);
      final summary = await _walletRepository.loadWalletSummary();
      emit(AuthAuthenticated(summary));
    } on Failure catch (e) {
      emit(AuthError(_failureMessage(e)));
    } catch (_) {
      emit(const AuthError('Could not save wallet'));
    }
  }

  Future<void> _onImportMnemonic(
    AuthImportMnemonicRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _walletRepository.saveMnemonicWallet(event.mnemonic);
      final summary = await _walletRepository.loadWalletSummary();
      emit(AuthAuthenticated(summary));
    } on Failure catch (e) {
      emit(AuthError(_failureMessage(e)));
    } catch (_) {
      emit(const AuthError('Could not import wallet'));
    }
  }

  Future<void> _onImportPrivateKey(
    AuthImportPrivateKeyRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      await _walletRepository.savePrivateKeyWallet(event.privateKeyHex);
      final summary = await _walletRepository.loadWalletSummary();
      emit(AuthAuthenticated(summary));
    } on Failure catch (e) {
      emit(AuthError(_failureMessage(e)));
    } catch (_) {
      emit(const AuthError('Could not import private key'));
    }
  }

  String _failureMessage(Failure f) {
    return switch (f) {
      WalletFailure(:final message) => message,
      ValidationFailure(:final message) => message,
      _ => 'Something went wrong',
    };
  }
}
