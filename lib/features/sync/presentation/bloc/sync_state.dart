import 'package:equatable/equatable.dart';
import 'package:fieldsync/features/sync/domain/sync_status.dart';

final class SyncState extends Equatable {
  const SyncState({this.status = const SyncIdle(), this.pendingCount = 0});

  final SyncStatus status;
  final int pendingCount;

  SyncState copyWith({SyncStatus? status, int? pendingCount}) {
    return SyncState(
      status: status ?? this.status,
      pendingCount: pendingCount ?? this.pendingCount,
    );
  }

  @override
  List<Object?> get props => [status, pendingCount];
}
