import 'package:fieldsync/core/error/failure.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('failureMessage', () {
    test('network', () {
      expect(failureMessage(const NetworkFailure()), 'No internet');
    });
    test('server uses the code', () {
      expect(failureMessage(const ServerFailure(500)), 'Server error 500');
    });
    test('unauthorized', () {
      expect(
        failureMessage(const UnauthorizedFailure()),
        'Please log in again',
      );
    });
  });
}
