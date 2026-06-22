---
name: codebase-spec-test
description: "Reverse-engineers an existing codebase into business-logic documentation, then derives test cases and test data and runs them to green. Use when onboarding to an unfamiliar or legacy codebase, when documentation is missing/stale, when building a regression safety net before refactoring, or when the user asks to 'document the business logic', 'understand what this app does', 'write tests for existing code', 'reverse engineer the spec', or invokes the skill by name. Stack-agnostic: PHP/Laravel, JS/TS (Node/React/Vue), Python (Django/FastAPI/Flask), Go, Java/Kotlin, Ruby/Rails, C#/.NET, and more. Runs guided (checkpointed) or fully autonomous (auto)."
---

# codebase-spec-test

Turn an existing codebase into **(1) business-logic documentation**, then **(2) a traceable test suite** (cases + data) that **proves** that documented behaviour — and run it to green.

This skill does NOT invent product requirements. It **derives** the *as-built* behaviour from the actual source of truth (code, schema, config, tests) and documents it, flagging anything ambiguous as an open question rather than guessing.

## Golden rules

1. **Evidence over assumption.** Every documented rule cites where it lives in the code (`path:line`). If behaviour can't be traced to code/schema/config, mark it `❓ASSUMPTION` and ask — never silently invent.
2. **Stable IDs + traceability.** Business rules get IDs (`BR-001`), workflows `WF-001`, invariants `INV-001`, tests `TC-001`. A traceability matrix links rule → test → status. This is the backbone of the whole skill.
3. **Outputs land in the TARGET project, not in this skill.** Docs → `docs/business-logic/`. Tests → the project's existing test location/convention. Never modify this skill repo while using it.
4. **Use the project's own tooling.** Detect and reuse the existing test framework, factories/fixtures, and runner. Only scaffold a framework if none exists (and confirm first).
5. **Characterization, not aspiration.** Tests assert what the code *currently does* (including quirks). When a quirk looks like a bug, write the test to current behaviour and record it in the report's "Suspected issues" — do not "fix" it silently.
6. **Read before you write.** Load the relevant `references/*.md` for the phase you're in. Keep context lean; don't dump whole files when an excerpt proves the rule.

## Inputs (arguments)

Invoke as `codebase-spec-test [mode] [scope]`:

- **mode** — `auto` (run all phases autonomously to a final report, stopping only on blocking ambiguity or unresolvable test failures) or omitted/`guided` (default: pause for sign-off after each phase). Also accepts `docs-only` (stop after Phase 2) and `tests-only` (assume docs exist, start at Phase 3).
- **scope** — optional path/module/glob to bound the work (e.g. `src/modules/billing`). If omitted, infer the highest-value bounded scope and confirm it in Phase 0 rather than boiling the ocean.

If no argument is given, default to **guided** mode and propose a scope.

## Workflow

Drive the whole run with a `TodoWrite` checklist (one item per phase; in `auto` keep exactly one `in_progress`). At each phase, read the linked reference file first.

### Phase 0 — Orientation & stack detection → read `references/00-orientation.md`
Map the repo, detect languages/frameworks/test runners/package managers, and lock the scope.
- Run `scripts/detect-stack.sh` (POSIX) or `scripts/detect-stack.ps1` (Windows/PowerShell) for a fast first pass; verify its findings against the actual files.
- Produce a short **orientation note** (stack, entrypoints, module map, test setup, proposed scope). Confirm scope before proceeding (in `auto`, proceed with the inferred scope but state it).

### Phase 1 — Business-logic extraction → read `references/01-business-logic-extraction.md`
Systematically harvest the *as-built* rules within scope: domain entities & invariants, validations, state machines/lifecycles, permissions/authorization, pricing/calculation rules, side effects, integrations, error handling, and edge cases.
- Output a **rules inventory** with stable IDs and `path:line` evidence. This is the single source the docs and tests are both built from.

### Phase 2 — Documentation → read `references/02-documentation-spec.md` (+ `templates/`)
Write the human-readable doc set into `docs/business-logic/` of the target project, using the templates: overview, domain model, business rules, workflows, interfaces/API, glossary. Default the prose language to the codebase/user's language.
- **Checkpoint** (guided): get sign-off on the docs before building tests. `docs-only` mode stops here.

### Phase 3 — Test design → read `references/03-test-design.md` (+ `templates/test-plan.md`, `templates/traceability-matrix.md`)
Derive test cases from the documented rules (happy path, boundaries, negative, state transitions, permission matrix, idempotency, concurrency where relevant). Produce a **test plan** and a **traceability matrix** (`BR → TC → status`). Aim for every rule to have ≥1 case; flag rules that are impractical to test and why.
- **Flow/scenario tests (required).** Unit tests pin each rule in isolation but do **not** prove the parts compose. For every documented workflow (`WF-###`) design at least one **flow test** that chains the steps in sequence (output of one step is the input to the next), plus a representative negative flow. A `WF` whose parts are all unit-tested is **not** covered until a flow test exercises the sequence end-to-end.

### Phase 4 — Test data → read `references/04-test-data.md`
Design minimal, deterministic fixtures/factories/seeds reusing the project's existing patterns. Cover the boundary/edge values the cases need. Keep data isolated and reproducible.

### Phase 5 — Implementation & execution → read `references/05-execution-and-reporting.md` (+ `references/06-stack-playbooks.md`)
Implement the cases in the project's framework, then **run them**. Iterate to green: a failing test means either the test misread the code (fix the test) or you found a real discrepancy (record it, keep the test asserting current behaviour). Use the stack playbook for exact run commands.
- **E2E/integration flows** need the real stack up and healthy first (often `docker compose up -d` + healthcheck), the runner pointed at it (`baseURL`), an isolated test DB/bucket seeded, and auth bootstrapped — follow the "Running E2E / integration tests" rules in `references/05-execution-and-reporting.md`. Reserve E2E for `WF-###` user journeys; keep `BR` checks at unit level.

### Phase 6 — Reporting → read `references/05-execution-and-reporting.md` (+ `templates/final-report.md`)
Write the final report: what was documented, coverage of rules by tests (from the matrix), how to run the suite, suspected issues/open questions, and recommended next steps.

## Definition of done

- Doc set exists under `docs/business-logic/` and every rule has an ID + code evidence.
- Traceability matrix is complete: each `BR/WF/INV` maps to ≥1 `TC` (or an explicit "not tested — reason").
- **Every documented workflow (`WF-###`) has ≥1 flow/scenario test** that runs its steps in sequence — not only isolated unit tests of its parts.
- The test suite **runs** and is green (or red only on documented, intentionally-pinned suspected bugs).
- A final report explains the suite, how to run it, and open questions.
- This skill's own files are unchanged; all artifacts are in the target project.

## Usage & install

See `README.md` for installation (personal/project/plugin), invocation examples, autonomous-mode guidance, and how to push this skill to its own git repo.
