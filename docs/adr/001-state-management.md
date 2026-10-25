# ADR-001: State management

Status: Accepted (25 Oct 2026)

## Context

FieldSync must work with bad internet: screens must open instantly, and sync must be safe. The same
data comes from the database, sync, and realtime events.

## Options

- Riverpod:
    1. No `BuildContext` needed, built-in injection and test overrides, `autoDispose`, `AsyncValue` for
     streams. The cost is that teams with less discipline may end up with inconsistent code, that
     Riverpod can hide side effects inside providers, and that it has no built-in event log.

- Bloc:
    1. App-wide Blocs (theme, sync queue) live as long as the app. All other Blocs live as long as
       one screen. With `BlocProvider(create: ...)` the provider closes the Bloc automatically, so
       the screen does not need to. `BlocProvider.value` does not close it.
    2. `get_it` is a global. If any file calls `getIt()`, the dependencies of that file are hidden,
       and tests must reset the container. Call `get_it` only at the app start (`main`), and pass
       objects through constructors. The outbox worker runs outside the widget tree, in a background
       isolate with its own memory, so `RepositoryProvider` cannot reach it.
    3. Network and database calls run in the repository implementation. `droppable` handles repeated
       taps in the Bloc, and idempotency keys handle repeated requests on the server.
    4. When nothing changes, nothing must rebuild. We use `BlocSelector` so a widget rebuilds only
       when the part of the state it reads changes. States must be comparable with `Equatable` or
       `freezed`. Otherwise, `BlocSelector` and `buildWhen` cannot tell what changed.
    5. We test Blocs with `blocTest` and `mocktail` fakes, asserting the sequence of states.

## Decision

We use Bloc because the sync status is a state machine, events and transformers control the
triggers, and `BlocObserver` logs every transition. We accept the cost of more code.

## Consequences

Good: strong for explicit events, event transformers for sync triggers, `BlocObserver` logs, and
`bloc_test`. We use `restartable` for the event that starts watching a Drift stream. When a second
event arrives while the first stream is still open, `restartable` cancels the old handler and its
stream and starts the new one, so the latest query wins. With `concurrent`, the old stream could
overwrite new data.

Bad / cost: more boilerplate, and Drift streams need `emit.forEach`. A Drift query returns a stream.
A Bloc event handler must stay alive while the stream emits, and it must cancel the stream when the
Bloc closes. `emit.forEach` does both.