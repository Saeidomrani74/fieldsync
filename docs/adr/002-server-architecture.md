# ADR-002: F1 server architecture

Status: Accepted (18 Nov 2026)

## Context

F1 needs a server because login and session refresh MUST be handled securely rather than relying
on client-only logic. The server MUST support delta sync so clients can exchange only the changes
they need, including when connectivity is poor. It MUST also provide realtime updates so connected
clients receive important changes without waiting for another full sync.

## Options

- Fastify:
    1. We will not choose Fastify because the goal of this project is to learn and build a .NET
       backend.

- Contract-first fake server:
    1. A fake server could validate request and response shapes early, but it would not validate real
       authentication, persistence, synchronization, or realtime behavior.

- Firebase and Supabase:
    1. The Firebase, Google Cloud, and Supabase terms for Iran are unverified. These services would
       also reduce our control over the sync model and increase vendor lock-in.

## Decision

We will use ASP.NET Core for the server, SignalR for realtime communication, and PostgreSQL for
persistence. We will run the server and database with Docker Compose.

## Consequences

Server implementation and maintenance hours count inside the F1 budget. `compose.yaml` is already
in `main` (PR #11), but the server is not built yet. ASP.NET Core, SignalR, and PostgreSQL will
give us control over authentication, delta sync, realtime updates, stored data, and queries.

## Open checks

- Docker terms for Iran: unverified.
- .NET SDK and NuGet terms: unverified.
- Firebase and Google Cloud terms: unverified.
- Supabase terms: unverified.
