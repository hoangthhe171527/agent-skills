# Phase 4 — Test data

Goal: the **minimum deterministic data** each case needs — reusing the project's existing fixtures/factories/seeders. Bad test data is the #1 cause of flaky, unreadable suites.

## Reuse before you invent

- Look for existing **factories** (`database/factories`, `*Factory`, FactoryBot, `factory-bot`/`fishery`, `model_bakery`, faker helpers) and **seeders**. Extend them; don't fork a parallel system.
- Mirror the project's conventions for building an entity in a valid state (required FKs, default statuses, tenant scoping).

## Principles

- **Deterministic.** No reliance on "today", random values, or seed data ordering for assertions. If randomness exists, fix the seed or inject values. Freeze/inject the clock for time-based rules.
- **Minimal & explicit.** Build only the graph a case needs. Make the field-under-test explicit in the test (don't hide the boundary value inside a factory default).
- **Isolated.** Each test starts from a known state and cleans up — transactional rollback, fresh in-memory DB, or per-test truncation. Tests must not depend on each other's order.
- **Boundary-oriented.** Materialize the exact edge values the design calls for: `0`, `-1`, max length, the timestamp one second past expiry, the duplicate key, the empty collection.
- **Realistic shape, fake content.** Valid formats (emails, currencies, IDs) but obviously-fake values; never real PII or secrets.

## Patterns by need

- **Valid baseline** — a factory producing a persistable, valid entity; tweak one field per case.
- **Boundary set** — a small table/data-provider of `(input, expected)` rows for calculation/validation rules; drives parameterized tests (one rule → many cheap cases).
- **Relationship graph** — helper that wires the minimal related records (e.g. tenant → user → contract → line) so workflow tests have a valid starting state.
- **State fixtures** — builders that return an entity already in a given status, so transition tests don't re-run the whole lifecycle.
- **External boundaries** — stub/mock/fake HTTP, payment, storage, queue, clock, and randomness at the seam. Record the contract you're stubbing in `test-plan.md`.

## Environment & data store

- Use the project's test DB strategy (transactional, in-memory, containerized). If services run only in Docker/compose, generate and run data through the container (see `references/06-stack-playbooks.md`).
- Keep secrets out of fixtures; use env/test config. Never commit credentials.

## Output

- New/extended factories & fixtures in the project's conventional location.
- A short "Test data" section appended to `test-plan.md`: what factories/builders exist, the boundary datasets, and which external seams are stubbed.

Proceed to Phase 5 (`references/05-execution-and-reporting.md`).
