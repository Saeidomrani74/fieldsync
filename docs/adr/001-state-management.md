# ADR-001: State management

Status: Draft

## Context
Lists watch the local database as a stream, so screens update by themselves.
The outbox worker and delta pull are background side effects with retries.
Sync status (idle, syncing, offline, error, pending count) is global state that many screens read.
SignalR events write into the local database, not straight into UI state.
Login and logout: the state must be cleared when the user changes.
Tests need fake repositories and a chaos test.

## Options
- Riverpod: Riverpod is better at status changing as it is global state that many screens can read.
- Bloc: 
  1. App-wide Blocs (theme, sync queue) live as long as the app. All other Blocs live as long as one screen. with BlocProvider(create: ...) the provider closes the Bloc automatically, so the screen does not need to. BlocProvider.value does not close it.
  2. by get_it, it is easy to use and strong, all the work is in one place and use in every file
  3. in repository implementation, droppable handles repeated taps, and idempotency keys handle repeated requests
  4. when nothing changes, nothing must rebuild. using BlocSelector to say what is changed and the rebuild must call
  5. blocTest with mocktail fakes, asserting the sequence of states.

## Decision
We use Bloc, because its strength in predictability in status changing

## Consequences
Good: strong for explicit events, event transformers for sync triggers, BlocObserver logs, and bloc_test
Bad / cost: more boilerplate, and Drift streams need emit.forEach. A Drift query returns a stream. A Bloc event handler must stay alive while the stream emits, and it must cancel the stream when the Bloc closes. emit.forEach does both.