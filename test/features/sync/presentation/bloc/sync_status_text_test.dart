import 'package:fieldsync/core/error/failure.dart';
import 'package:fieldsync/features/sync/domain/sync_status.dart';
import 'package:fieldsync/features/sync/presentation/bloc/sync_status_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('syncStatusText', () {
    test('SyncIdle gives Idle', () {
      expect(syncStatusText(const SyncIdle()), equals('Idle'));
    });

    test('SyncSyncing gives Syncing', () {
      expect(syncStatusText(const SyncSyncing()), equals('Syncing'));
    });

    test('SyncOffline gives Offline', () {
      expect(syncStatusText(const SyncOffline()), equals('Offline'));
    });

    test('SyncFailed gives Failed', () {
      expect(
        syncStatusText(const SyncFailed(NetworkFailure())),
        equals('Failed'),
      );
    });
  });
}
