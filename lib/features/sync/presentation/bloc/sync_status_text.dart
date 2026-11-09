import 'package:fieldsync/features/sync/domain/sync_status.dart';

String syncStatusText(SyncStatus status) {
  switch (status) {
    case SyncIdle():
      return 'Idle';
    case SyncSyncing():
      return 'Syncing';
    case SyncOffline():
      return 'Offline';
    case SyncFailed():
      return 'Failed';
  }
}
