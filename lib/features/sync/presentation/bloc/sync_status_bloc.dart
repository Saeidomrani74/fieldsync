import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:fieldsync/core/result/result.dart';
import 'package:fieldsync/features/sync/domain/sync_repository.dart';
import 'package:fieldsync/features/sync/domain/sync_status.dart';
import 'package:fieldsync/features/sync/presentation/bloc/sync_event.dart';
import 'package:fieldsync/features/sync/presentation/bloc/sync_state.dart';

class SyncStatusBloc extends Bloc<SyncEvent, SyncState> {
  final SyncRepository _repository;

  SyncStatusBloc({required this._repository}) : super(const SyncState()) {
    on<WatchStarted>((event, emit) async {
      await emit.forEach<SyncStatus>(
        _repository.watchStatus(),
        onData: (data) => state.copyWith(status: data),
      );
    }, transformer: restartable());

    on<SyncRequested>((event, emit) async {
      emit(state.copyWith(status: const SyncSyncing()));
      final result = await _repository.sync();
      switch (result) {
        case Ok():
          emit(state.copyWith(status: const SyncIdle()));
        case Err(:final error):
          emit(state.copyWith(status: SyncFailed(error)));
      }
    }, transformer: droppable());
  }
}
