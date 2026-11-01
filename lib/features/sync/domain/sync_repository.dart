import 'package:fieldsync/core/error/failure.dart';
import 'package:fieldsync/core/result/result.dart';
import 'package:fieldsync/features/sync/domain/sync_status.dart';

abstract interface class SyncRepository {
  Stream<SyncStatus> watchStatus();
  Future<Result<void, Failure>> sync();
}
