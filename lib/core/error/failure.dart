import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  const Failure();
}

final class NetworkFailure extends Failure {
  const NetworkFailure();

  @override
  List<Object?> get props => [];
}

final class ServerFailure extends Failure {
  const ServerFailure(this.code);
  final int code;

  @override
  List<Object?> get props => [code];
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();

  @override
  List<Object?> get props => [];
}

String failureMessage(Failure failure) => switch (failure) {
  NetworkFailure() => 'No internet',
  ServerFailure(:final code) => 'Server error $code',
  UnauthorizedFailure() => 'Please log in again',
};
