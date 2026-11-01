sealed class SyncEvent {
  const SyncEvent();
}

final class WatchStarted extends SyncEvent {
  const WatchStarted();
}

final class SyncRequested extends SyncEvent {
  const SyncRequested();
}
