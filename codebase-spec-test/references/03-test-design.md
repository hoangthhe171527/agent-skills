# Phase 3 — Test design

Goal: turn documented rules into a **test plan** plus a **traceability matrix** (`templates/test-plan.md`, `templates/traceability-matrix.md`). Design first, implement in Phase 5. No rule should silently go untested.

## Principle: characterization testing

These tests pin **current behaviour** so future changes can't break it unnoticed. If the code does something odd, the test asserts the odd thing (and you log it as a suspected issue). You are building a safety net, not enforcing an ideal.

## Derive cases from each rule

For every `BR/INV/WF`, generate the applicable case types:

- **Happy path** — valid inputs → expected outcome + side effects.
- **Boundaries** — at/just-below/just-above every numeric or length limit; first/last valid; empty and max collections.
- **Negative** — each validation violation → the specific error/code the code produces (not a generic "fails").
- **State transitions** — every allowed transition succeeds; representative disallowed transitions are rejected (a transition matrix → one case per cell that matters).
- **Permissions** — a small role × action matrix: allowed succeeds, forbidden is denied with the right status; ownership/tenant scoping respected.
- **Side effects** — assert the event/email/job/audit/cache effect actually fires (and only when it should).
- **Idempotency / retries / concurrency** — where the code claims it: double-submit, replay, unique-window, optimistic-lock conflict.
- **Time** — expiry, schedules, time zones, "now" boundaries (freeze/inject the clock).

Prefer **one assertion target per case**; name cases so the rule is obvious.

## Flow / scenario tests (compose the units) — required

Unit tests pin each rule in isolation; they do **not** prove the functions compose. For **every documented workflow (`WF-###`)** add at least one **flow test** that runs the steps in sequence and asserts the end-to-end result:

- **Chain, don't isolate.** Start from a realistic initial state and walk the whole path, feeding each step's output into the next — e.g. record installment `S1→S2→S3` and assert the running total converges to the contract value; or classify a contract's end-date → expiry *kind* → list-grouping → badge/action label and assert they all agree.
- **Output→input fidelity is the point.** The unique value of a flow test is catching when one step emits a shape/value the next step can't consume — a gap unit tests never see.
- **Include a negative flow.** At least one scenario rejected at the *right* step (e.g. paying an already-settled milestone throws the overpay error; a disallowed state transition is refused mid-sequence).
- **One flow per workflow, minimum.** Map each `WF-###` to ≥1 flow test in the matrix. A workflow whose parts are all unit-tested is **not** covered until a flow test chains them.
- **Keep them legible.** Put flow tests in a dedicated file/group (e.g. `**/workflows.*`, `*_flow_test.*`, a `Scenario:`/`describe("WF-…")` block) so they read as scenarios, separate from per-rule unit tests.

Choose the cheapest level that still exercises the real composition: for pure functions a flow is just chained calls; for stateful workflows it may need an integration/feature test that walks the entrypoints.

**Spec each flow before implementing it.** Write `docs/business-logic/flow-test-spec.md` from `templates/flow-test-spec.md` — one `FLOW-###` per `WF-###`, with preconditions, the numbered step→output→next-input chain, end-state assertions, and negative/alternate variants. This is the design that Phase 5 implements and the matrix's flow-coverage block tracks. Every `WF-###` in `03-workflows.md` gets a spec or an explicit "no flow test — reason".

## Naming & IDs

- Test case ID `TC-###`, mapped to its rule(s). Test *method* names should read as the behaviour: `test_reservation_expires_after_hold_window` / `it("denies convert on expired hold")`.
- Group by module/rule so the suite mirrors the docs.

## Choose the test level deliberately

| Level | Use for | Cost |
|---|---|---|
| **Unit** | pure calculations, validators, value objects, guards | cheap, fast — prefer for `BR` formulas |
| **Integration** | service + DB, repository invariants, transactions | medium — for `INV` and multi-step `BR` |
| **Feature / E2E (API)** | entrypoint → response, auth, side effects, `WF` | richer, slower — for workflows & permissions |

Match the level to where the rule is enforced (a DB-level `UNIQUE` invariant needs an integration test that actually hits the DB; a pure formula needs only a unit test).

## The traceability matrix (mandatory)

A table linking rules → tests → status. It is how "done" is measured and how gaps surface.

| Rule | Title | Test case(s) | Level | Status |
|---|---|---|---|---|
| BR-014 | Hold expires after N hours | TC-031, TC-032 | integration | planned |
| INV-007 | reservation_number unique | TC-040 | integration | planned |
| WF-003 | Contract activation | TC-050..054 | feature | planned |
| BR-022 | Reactivate terminated contract | — | — | not tested — no code path (❓) |

Rules with no practical test must say **why** (e.g. external-only, no code path, requires third-party sandbox). Every other rule needs ≥1 case.

Add a short **flow coverage** block under the matrix listing each `WF-###` and its flow test(s) — a workflow row is only "covered" when a flow test chains its steps, not merely when its component `BR`s are unit-tested.

## Output of this phase

- `docs/business-logic/test-plan.md` — strategy, levels, environment, run command, fixtures needed, **plus a Flow/scenario tests summary** (one row per `WF-###`).
- `docs/business-logic/flow-test-spec.md` — the detailed per-workflow flow specs (`templates/flow-test-spec.md`): steps, chained data, end-state assertions, negative variants.
- `docs/business-logic/traceability-matrix.md` — the rule table **plus the flow-coverage block**, kept updated through Phase 5.

Proceed to Phase 4 (`references/04-test-data.md`).
