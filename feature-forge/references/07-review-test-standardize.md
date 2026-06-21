# Phase 5 — Review, test & standardize

Goal: make the generated code trustworthy and maintainable before it's considered done. Don't reinvent review/test methodology — **compose the sibling skills** in this `agent-skills` repo.

## 1. Review → `senior-review`
Run a senior review over the generated diff (the new modules, infra, wiring). Treat its findings seriously — generated code is exactly where inconsistencies and missing edge cases hide. Fix 🔴/🟠 before proceeding; record 🟡/🔵 as follow-ups. Verdict should be at least approve-with-nits before you ship.

## 2. Contract check → `api-contract-guard`
Run it across backend ↔ web and backend ↔ app for the new modules. There must be **zero drift** — the three layers were generated from one contract, so any mismatch is a generation bug. Fix until clean.

## 3. Tests → `codebase-spec-test` (test phases)
For **every** new module, derive and write test cases and run them:
- Backend: feature/integration tests for each CRUD op + the invariants and any state transitions/rules (validation rejects, uniqueness, auth, pagination/filter). Run via `docker compose exec <app>` to green.
- Web/app: at least the mapping/serialization and a critical-path test where the repo has a harness.
- Use the traceability idea: every business rule from Phase 0 maps to ≥1 test. Aim for the rules that matter, not 100% line coverage.

## 4. Standardize for maintainability → `context-bootstrap`
- Generate/refresh `CLAUDE.md` (root and, if greenfield, per repo) so the new structure, run/test commands, and conventions are captured — future work stays consistent.
- Ensure formatting/lint passes everywhere (the repos' formatters own style).
- Confirm the new modules are **structurally identical** to each other and to existing modules (same files, same layering). Consistency is what keeps a codebase from rotting.

## 5. Final report
Summarize:
- Modules built (with their canonical names), entities, and endpoints.
- Infra brought up (Mongo + MinIO) and how to run the whole stack.
- Review verdict + resolved/open findings; contract status; test results (counts, how to run).
- Open questions from Phase 0 still needing the owner.
- Next steps (further modules, perf, hardening).

## Why this order
Build → **review** (catch structural issues) → **contract** (catch cross-layer drift) → **test** (lock behaviour) → **standardize** (lock structure + context). That sequence is what "chuẩn hóa quy trình từ ban đầu" means in practice: the codebase is consistent, proven, and documented before it grows — so it scales without breaking.
