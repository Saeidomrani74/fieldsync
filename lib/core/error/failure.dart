sealed class Failure {
  const Failure();
}

final class NetworkFailure extends Failure {
  const NetworkFailure();
}

final class ServerFailure extends Failure {
  const ServerFailure(this.code);
  final int code;
}

final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure();
}

String failureMessage(Failure failure) => switch (failure) {
  NetworkFailure() => 'No internet',
  ServerFailure(:final code) => 'Server error $code',
  UnauthorizedFailure() => 'Please log in again',
};
