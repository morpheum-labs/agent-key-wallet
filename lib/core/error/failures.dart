import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure();

  @override
  List<Object?> get props => [];
}

class WalletFailure extends Failure {
  const WalletFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ValidationFailure extends Failure {
  const ValidationFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
