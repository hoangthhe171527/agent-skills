# Phase 2 — The senior review rubric

Walk **every** axis below against the diff (and its blast radius). Not every axis applies to every change — but you must *consider* each. For each issue, record: **severity · `file:line` · what's wrong · why it matters · concrete fix**.

## Severity scale
- 🔴 **blocker** — must fix before merge: bugs, data loss, security holes, breaking changes without migration, broken build/tests.
- 🟠 **major** — should fix: likely-wrong behaviour, missing error handling on a real path, missing tests for risky logic, significant design problem.
- 🟡 **minor** — worth fixing: edge case, unclear naming, small inefficiency, duplication.
- 🔵 **nit** — optional/style preference (only if a linter won't catch it; don't pile these on).
- 🟢 **praise** — call out genuinely good decisions. This matters; do it.

## Axes

### 1. Correctness & bugs
Does it do what it intends, for all inputs? Off-by-one, null/empty/zero/negative, boundary values, wrong operator/condition, inverted logic, async/await misuse, unhandled promise/error, race conditions, incorrect state transitions, time zone/locale, floating-point money. Trace at least one non-happy path by hand.

### 2. Design & architecture fit
Right layer/module? Follows the codebase's existing patterns and boundaries, or introduces an inconsistent one? Leaky abstractions, wrong coupling, God objects, logic in the wrong place (e.g. business rules in a controller), reinventing an existing utility. Is the change the simplest thing that works, or over/under-engineered?

### 3. Readability & maintainability
Could the next engineer understand it in 6 months? Naming, function size, nesting depth, dead code, magic numbers, misleading comments, commented-out code, TODOs left as landmines. Would a smaller/clearer formulation exist?

### 4. Security
Untrusted input validation; injection (SQL/NoSQL/command/template); authn/authz checks (and ownership/tenant scoping); secrets in code/logs; sensitive data exposure; SSRF/path traversal/deserialization; CSRF/XSS for web; dependency with known CVEs; over-broad permissions. Treat anything touching auth, money, PII, or external input as high-attention.

### 5. Performance & scalability
N+1 queries, missing indexes for new query patterns, unbounded loops/collections/recursion, work inside hot loops, sync I/O on a request path, missing pagination, chatty external calls, missing caching where the code clearly expects it, memory blowups on large inputs. Is the cost proportional to the value?

### 6. Error handling & resilience
Failure paths covered? Swallowed exceptions, bare catches, errors logged-and-ignored, partial failure without rollback, missing timeouts/retries/idempotency on external calls, unclear error messages/codes returned to callers.

### 7. Tests
Are the changed behaviours tested? New logic without tests (🟠+ for risky code), tests that assert nothing/are tautological, happy-path-only, brittle/flaky patterns, missing boundary/negative cases. Do existing tests still cover the changed code, or were they weakened/deleted to pass?

### 8. API & backward compatibility
Public API/route/CLI/event/DB-schema changes: are they backward compatible? Breaking change without versioning/migration/deprecation, changed response shape, renamed/removed field, altered default, changed status code. Consumers updated?

### 9. Data & migrations
Schema/migration changes: reversible? Safe on a large table (locks, backfills)? Nullable vs default, destructive drops, data-loss risk, ordering with deploy. Seed/fixture impact.

### 10. Observability
Enough logging/metrics/traces to debug this in prod? Sensitive data in logs (overlaps security). Noisy logs. Missing audit trail for a sensitive action.

### 11. Consistency & scope
Matches project conventions (formatting handled by tooling — don't relitigate). Unrelated drive-by changes mixed in (scope creep) → note them. Docs/changelog/config updated to match? Feature flags respected?

## How to write a finding (be actionable & kind)

> 🟠 **`src/billing/invoice.ts:142` — total can go negative on full refund.**
> When `refund >= subtotal`, `total` becomes negative and the PDF renders "-$0.00". Clamp at zero (or assert `refund <= subtotal` upstream):
> ```ts
> const total = Math.max(0, subtotal - refund);
> ```

Each finding: **one problem, one place, one suggestion.** Lead with severity + location. Explain *why it matters* (impact), not just *what*. Offer the fix. Group related nits. Add 🟢 praise where deserved.

## Calibration
- Don't block on taste; block on correctness/security/breakage.
- Prefer fewer high-signal findings over an exhaustive nit dump.
- If you're unsure whether something is a bug, ask a question rather than asserting — phrase it as "is X intended?".
- Stay within the change's scope; mention adjacent issues briefly without expanding the review into a rewrite.

Proceed to Phase 3 (verdict) then Phase 4 (`references/02-posting-to-pr.md`).
