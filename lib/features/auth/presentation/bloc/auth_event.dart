import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

final class AuthPersistMnemonicRequested extends AuthEvent {
  const AuthPersistMnemonicRequested(this.mnemonic);

  final String mnemonic;

  @override
  List<Object?> get props => [mnemonic];
}

final class AuthImportMnemonicRequested extends AuthEvent {
  const AuthImportMnemonicRequested(this.mnemonic);

  final String mnemonic;

  @override
  List<Object?> get props => [mnemonic];
}

final class AuthImportPrivateKeyRequested extends AuthEvent {
  const AuthImportPrivateKeyRequested(this.privateKeyHex);

  final String privateKeyHex;

  @override
  List<Object?> get props => [privateKeyHex];
}
