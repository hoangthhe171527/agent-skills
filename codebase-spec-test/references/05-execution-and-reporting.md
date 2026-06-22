# Phase 5 & 6 — Implementation, execution & reporting

## Phase 5 — Implement and run

Implement the planned cases in the project's framework (see `references/06-stack-playbooks.md` for exact commands), then **actually run them**. A test suite that hasn't run proves nothing.

### Implementation order

1. Wire data (Phase 4 factories/fixtures) first; confirm a baseline entity persists.
2. Implement **happy-path** cases per rule and get them green — this validates the harness/env before you pile on edge cases.
3. Add **boundary/negative/transition/permission** cases.
4. Add **side-effect, idempotency, time, concurrency** cases where the rules call for them.
5. Keep the **traceability matrix** updated as each `TC` goes `planned → passing`.

### Iterating on failures — the discipline

A red test means exactly one of two things. Decide which, every time:

- **The test misread the code.** Your expectation was wrong → fix the test to match real behaviour. (Most early failures are this.)
- **You found a real discrepancy** between documented intent and actual behaviour. → Keep the test asserting the **current** behaviour (characterization), mark it, and log it under "Suspected issues" in the report. Do **not** change product code to make a test pass unless the user explicitly asked you to fix bugs — this skill documents and pins behaviour, it doesn't refactor.

Never weaken an assertion just to get green (no deleting checks, no `assertTrue(true)`, no broad try/catch swallowing). If a case can't be made meaningful, mark it "not tested — reason" in the matrix instead of faking a pass.

### Quality bar for the suite

- Deterministic (run twice → same result), isolated, fast where possible.
- Readable: the test name states the rule; the body shows the boundary value.
- No reliance on external network unless explicitly integration-marked and documented.
- Run the **whole** suite at the end to confirm nothing else broke.

### Environment reminders

- Run via the project's canonical command (CI is the reference). If DB/cache/queue live only in containers, exec into them.
- Use a dedicated test database/profile; never run destructive tests against dev/prod data.

### Running E2E / integration tests (real stack)

Unit and pure-logic flow tests need no services; **E2E / integration tests do** — they cross the UI ↔ API ↔ datastore boundary, so the real stack must be **up and healthy before a single test runs**. Reserve this level for documented user **workflows** (`WF-###`) that pure-logic tests can't reach; keep per-rule `BR` checks at the unit level. The rules:

1. **Bring the stack up first — reuse what's already running.** Detect the run topology (`docker-compose*.yml`, `Procfile`, dev scripts). Start services with the project's own command (e.g. `docker compose -f docker-compose.dev.yml up -d`), then **confirm health** (`docker ps` healthchecks + a probe request) before running. If containers are already up, reuse them — don't restart blindly.
2. **Dedicated test data & datastore — never dev/prod.** Point E2E at an isolated test database/namespace and test bucket (e.g. a Mongo test DB, a `*-test` S3/MinIO bucket). Seed deterministic fixtures through the app's own seeders/factories (often `docker compose exec app <seed-cmd>`); reset/clean between runs.
3. **Bootstrap auth/session programmatically.** A journey needs a logged-in state: seed a user + obtain a token / set Playwright `storageState`, instead of driving the login form in every test. Record the (fake) test account in `test-plan.md` — never real creds.
4. **Wire base URLs via env.** Point the runner at the running app (`baseURL`) and the app at the test API. Secrets stay in env/test config, never in fixtures.
5. **Stability — wait on signals, not sleeps.** Await network-idle / a visible role / a 2xx response; allow retries only at the harness level; freeze/inject the clock where the app supports it. A flaky E2E is worse than none.
6. **Run + tear down.** Use the project's E2E command (see `references/06-stack-playbooks.md`); on finish, reset state or tear down ephemeral services. E2E is slow and costly — cover the **critical** workflows, not every rule.
7. **Make it reproducible.** Put the exact *bring-up → seed → run → teardown* commands in `test-plan.md` and the final report, and mark each flow's level (unit-flow vs E2E) in the matrix. A green E2E nobody else can reproduce isn't done.

## Phase 6 — Final report

Write `docs/business-logic/final-report.md` from `templates/final-report.md`. It must let a newcomer trust and run everything:

- **Scope** — what was covered / explicitly excluded.
- **Documentation** — links to the doc set; counts of `BR/WF/INV`.
- **Coverage** — from the traceability matrix: rules with tests vs. without (and why). A simple % + the "not tested" list.
- **Results** — suite size, pass/fail, run command, runtime, environment notes.
- **Suspected issues** — discrepancies/quirks found, each linked to a rule ID and the pinning test.
- **Open questions** — unresolved `❓ASSUMPTION` items needing product/owner input.
- **How to run** — copy-pasteable commands (incl. container variants) and how to extend the suite.
- **Next steps** — highest-value rules still undocumented/untested beyond the scope.

## Definition of done (recap)

Docs exist with evidence-cited IDs · matrix complete (every rule → test or justified gap) · suite runs green (or red only on documented, intentionally-pinned suspected bugs) · report written · this skill's files untouched · all artifacts in the target project.
