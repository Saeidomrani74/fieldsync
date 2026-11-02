import 'package:equatable/equatable.dart';
import 'package:fieldsync/core/error/failure.dart';

sealed class SyncStatus extends Equatable {
  const SyncStatus();
}

final class SyncIdle extends SyncStatus {
  const SyncIdle();
  @override
  List<Object?> get props => [];
}

final class SyncSyncing extends SyncStatus {
  const SyncSyncing();
  @override
  List<Object?> get props => [];
}

final class SyncOffline extends SyncStatus {
  const SyncOffline();

  @override
  List<Object?> get props => [];
}

final class SyncFailed extends SyncStatus {
  const SyncFailed(this.failure);
  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
