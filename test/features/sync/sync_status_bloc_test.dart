import 'package:fieldsync/core/error/failure.dart';
import 'package:fieldsync/core/result/result.dart';
import 'package:fieldsync/features/sync/data/fake_sync_repository.dart';
import 'package:fieldsync/features/sync/domain/sync_status.dart';
import 'package:fieldsync/features/sync/presentation/bloc/sync_event.dart';
import 'package:fieldsync/features/sync/presentation/bloc/sync_state.dart';
import 'package:fieldsync/features/sync/presentation/bloc/sync_status_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  late FakeSyncRepository fake;

  void createFake() {
    fake = FakeSyncRepository();
  }

  void disposeFake() {
    fake.dispose();
  }

  SyncStatusBloc buildSyncBloc() {
    return SyncStatusBloc(repository: fake);
  }

  Duration waitDuration = const Duration(milliseconds: 200);

  blocTest<SyncStatusBloc, SyncState>(
    'WatchStarted emits the pushed statuses',
    build: buildSyncBloc,
    act: (bloc) async {
      bloc.add(const WatchStarted());
      await Future<void>.delayed(Duration.zero);
      fake.push(SyncOffline());
    },
    expect: () => [SyncState(status: SyncOffline())],
    setUp: createFake,
    tearDown: disposeFake,
  );

  blocTest<SyncStatusBloc, SyncState>(
    'a second WatchStarted restarts the watch',
    build: buildSyncBloc,
    act: (bloc) async {
      bloc.add(const WatchStarted());
      await Future<void>.delayed(Duration.zero);
      bloc.add(const WatchStarted());
      await Future<void>.delayed(Duration.zero);
      fake.push(const SyncOffline());
    },
    expect: () => const [SyncState(status: SyncOffline())],
    setUp: createFake,
    tearDown: disposeFake,
    wait: waitDuration,
    verify: (_) => expect(fake.watchCalls, 2),
  );

  blocTest<SyncStatusBloc, SyncState>(
    'a second SyncRequested while syncing is ignored',
    build: buildSyncBloc,
    act: (bloc) async {
      bloc.add(const SyncRequested());
      bloc.add(const SyncRequested());
    },
    expect: () => const [
      SyncState(status: SyncSyncing()),
      SyncState(status: SyncIdle()),
    ],
    setUp: createFake,
    tearDown: disposeFake,
    wait: waitDuration,
    verify: (_) => expect(fake.syncCalls, 1),
  );

  blocTest<SyncStatusBloc, SyncState>(
    'a failing repository gives SyncSyncing, then SyncFailed',
    build: buildSyncBloc,
    act: (bloc) async {
      bloc.add(SyncRequested());
    },
    expect: () => const [
      SyncState(status: SyncSyncing()),
      SyncState(status: SyncFailed(NetworkFailure())),
    ],
    setUp: () {
      fake = FakeSyncRepository(syncResult: Err(NetworkFailure()));
    },
    tearDown: disposeFake,
    wait: waitDuration,
  );

  test(
    "bloc listens to the repository and stops listening when closed",
    () async {
      final fake2 = FakeSyncRepository();
      addTearDown(fake2.dispose);
      final bloc = SyncStatusBloc(repository: fake2);
      bloc.add(const WatchStarted());
      await Future<void>.delayed(Duration.zero);
      expect(fake2.hasListeners, true);
      await bloc.close();
      expect(fake2.hasListeners, false);
    },
  );
}
