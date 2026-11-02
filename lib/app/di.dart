import 'package:fieldsync/features/sync/data/fake_sync_repository.dart';
import 'package:fieldsync/features/sync/domain/sync_repository.dart';

import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDi() {
  getIt.registerLazySingleton<SyncRepository>(() => FakeSyncRepository());
}
