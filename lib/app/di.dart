import 'package:fieldsync/core/result/result.dart';
import 'package:fieldsync/features/sync/data/fake_sync_repository.dart';

import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDi() {
  getIt.registerSingleton<Result>(Ok('value'));
  getIt.registerLazySingleton<FakeSyncRepository>(
    () => FakeSyncRepository(syncResult: getIt<Result>()),
  );
}
