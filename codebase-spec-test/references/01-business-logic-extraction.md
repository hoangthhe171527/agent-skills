# Phase 1 — Business-logic extraction

Goal: produce a **rules inventory** — the *as-built* behaviour within scope, each item with a stable ID and `path:line` evidence. Docs (Phase 2) and tests (Phase 3) are both generated from this single artifact, so invest here.

## The sources of truth (in priority order)

1. **Schema & migrations** — NOT NULL, UNIQUE, FK, enums, defaults, CHECK constraints, indexes. These are invariants the DB enforces.
2. **Domain/model code** — entity methods, value objects, guards, computed properties, lifecycle hooks.
3. **Services / use-cases / handlers** — orchestration, the "verbs" of the system, transaction boundaries.
4. **Validation layer** — request/form validators, DTO constraints, serializer rules.
5. **Authorization** — policies, guards, middleware, role/permission checks.
6. **Entrypoints** — controllers/commands/jobs/listeners: what triggers what, and with which inputs.
7. **Config & feature flags** — branches that change behaviour.
8. **Existing tests & docs** — intent, expected values, named edge cases.

Code beats comments; comments beat commit messages; never trust a stale README over the code.

## What to extract (checklist)

For the scope, hunt each category. Don't stop at the happy path.

- **Entities & invariants** — fields, types, required/optional, uniqueness, relationships, allowed ranges. → `INV-###`
- **Validation rules** — per input: required, format, length, range, cross-field, conditional. → `BR-###`
- **State machines / lifecycles** — statuses and allowed transitions, who/what triggers them, guards, terminal states. → `WF-###`
- **Calculations** — pricing, tax, discounts, proration, scoring, aggregation. Capture the exact formula, rounding, and units. → `BR-###`
- **Authorization** — who can do what, ownership/tenancy scoping, role/permission gates. → `BR-###`
- **Side effects** — emails/notifications, events, webhooks, audit logs, cache invalidation, async jobs. → `BR-###`
- **Integrations** — external APIs/payment/storage: inputs, failure handling, retries, idempotency keys. → `BR-###`
- **Error handling** — what's rejected, error codes/messages, partial-failure behaviour, rollback. → `BR-###`
- **Concurrency/time** — locks, unique-window constraints, schedules, expiry, time zones. → `BR-###`
- **Edge cases** — empty/null, zero/negative, max bounds, duplicates, out-of-order, large inputs.

## Tracing technique

- Start from an **entrypoint** and follow the call chain to the data layer; note each decision point (`if`, guard, validation, status change).
- Then start from the **schema** and ask "what code maintains this invariant?" — gaps between schema and code are prime `❓` items.
- Grep for signals: status/`enum` names, `throw`/`raise`/`abort`, permission/`can(`/`authorize(`, `transaction`, `dispatch`/`emit`, money/`price`/`tax`/`round`, `unique`, `lock`.
- Diff intent vs. implementation: where a validator and the DB disagree, document **both** and flag it.

## Recording a rule

Each inventory item is one row:

```
ID:        BR-014
Title:     Reservation hold expires after N hours
Statement: A reservation becomes EXPIRED when now() > reserved_until; expired holds
           free their inventory and cannot be converted.
Type:      business-rule | invariant | workflow
Trigger:   <entrypoint / job / transition>
Inputs:    <fields/params that matter>
Outcome:   <result, side effects, error on violation>
Evidence:  src/modules/reservation/...Service.php:88-121; migration ...:reserved_until
Confidence: high | medium | ❓assumption (needs confirmation)
Edge cases: exactly-at-boundary; already-converted; already-cancelled
Open Qs:   <anything ambiguous>
```

Keep the inventory in a working file (e.g. `docs/business-logic/_rules-inventory.md` in the target repo, or a scratch note) — it becomes the `business-rules.md` doc and the traceability matrix.

## Anti-patterns to avoid

- **Inventing requirements.** If it's not in the code/schema/config, it's an `❓ASSUMPTION`, not a rule.
- **Documenting framework boilerplate** as if it were business logic. Focus on domain decisions.
- **Stopping at one layer.** A "required" field may be enforced in the validator, the model, *and* the DB — note where, since tests target specific layers.
- **Skipping the unhappy paths.** The negative/boundary behaviour is the part most worth pinning with tests.

Proceed to Phase 2 (`references/02-documentation-spec.md`).
