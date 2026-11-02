import 'dart:async';

import 'package:fieldsync/core/error/failure.dart';
import 'package:fieldsync/core/result/result.dart';
import 'package:fieldsync/features/sync/domain/sync_repository.dart';
import 'package:fieldsync/features/sync/domain/sync_status.dart';

final class FakeSyncRepository implements SyncRepository {
  FakeSyncRepository({this.syncResult = const Ok(null)});

  final Result<void, Failure> syncResult;
  final _controller = StreamController<SyncStatus>.broadcast();

  int _watchCalls = 0;
  int _syncCalls = 0;
  int get watchCalls => _watchCalls;
  int get syncCalls => _syncCalls;

  bool get hasListeners => _controller.hasListener;

  @override
  Stream<SyncStatus> watchStatus() {
    _watchCalls++;
    return _controller.stream;
  }

  @override
  Future<Result<void, Failure>> sync() async {
    _syncCalls++;
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return syncResult;
  }

  void push(SyncStatus status) {
    _controller.add(status);
  }

  void dispose() {
    _controller.close();
  }
}
