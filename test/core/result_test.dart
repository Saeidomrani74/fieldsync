import 'package:fieldsync/core/error/failure.dart';
import 'package:fieldsync/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

String describe(Result<int, Failure> r) => switch (r) {
  Ok(:final value) => 'ok $value',
  Err(:final error) => 'err ${failureMessage(error)}',
};

void main() {
  group('Result', () {
    test('Ok holds its value', () {
      expect(describe(const Ok(5)), 'ok 5');
    });

    test('Err holds its error', () {
      expect(describe(const Err(NetworkFailure())), 'err No internet');
    });
  });
}
