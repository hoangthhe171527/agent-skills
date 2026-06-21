---
name: feature-forge
description: "Turns a new requirement into a working full-stack feature: first decomposes the business problem (actors, bounded contexts, modules, entities, rules, API contract), then scaffolds modules across the workspace's reference repos — backend, web frontend, and mobile app — using each repo's existing tech stack and conventions by default (overridable). Stands up infrastructure (MongoDB + MinIO on Docker), generates full CRUD per module with standardized, domain-noun module names (no role/permission/technical names), then composes sibling skills to review the code, write test cases for every module, and run them. Use when a new requirement/spec arrives and you need to design + build it cleanly from scratch, scaffold new modules, bootstrap a new project, or when the user asks to 'bóc tách nghiệp vụ rồi build', 'build from this requirement', 'scaffold a full-stack module', or invokes the skill. Greenfield or add-to-existing; stack-agnostic, mirrors the reference repos."
---

# feature-forge

Take a raw requirement and produce a **clean, consistent, full-stack feature** — decomposed first, then built across backend + web + mobile following the workspace's own conventions, with infra, CRUD, review, and tests. The point is a codebase that is **maintainable and scalable from line one**, not a pile of generated code.

This skill is an **orchestrator**: it does the analysis and scaffolding, and **composes sibling skills** for the closeout — [`senior-review`], [`codebase-spec-test`], [`context-bootstrap`], [`api-contract-guard`] (all in this `agent-skills` repo).

## Golden rules

1. **Decompose before you build.** No code until the business problem is broken into modules → entities → rules → API contract, and that decomposition is agreed. Building the wrong thing cleanly is still wrong.
2. **Mirror the reference repos.** Default tech stack and structure come from the existing workspace repos (detected, not assumed). The new code should look like it was written by the same team. The user may override the stack; default is the repos'.
3. **One contract, three layers.** Backend, web, and app share one API contract. Generate them to match so `api-contract-guard` passes — no FE/BE/APP drift.
4. **Standardized, domain-noun names.** Modules are business nouns (`booking`, `inventory`, `billing`), consistent across all three repos. **Never** name a business module after a role, permission, actor, or technical concern (`admin`, `manager`, `userRole`, `service`, `utils`). See `references/02-naming-standard.md`.
5. **Incremental & green.** Build one module end-to-end across the layers, get it to compile/lint/test green, then the next. Never dump many half-wired modules — that's how codebases break. Reuse existing shared infra (auth, base classes, base widgets); don't re-implement cross-cutting concerns.
6. **Full CRUD, real wiring.** Each module ships list/detail/create/update/delete wired through every layer (repo → API → UI/screens), not stubs.

## Inputs (arguments)

Invoke as `feature-forge [target] [mode]` (the requirement itself comes from the user's message, a file, or an issue):

- **target** — `modules` (default: add modules to the existing reference repos) · `greenfield <dir>` (bootstrap new FE/BE/APP from the reference conventions) · a specific layer (`backend`/`web`/`app`) to scaffold one side.
- **mode** — *(omitted)* guided: stop for sign-off after decomposition and after each module · `auto` run end-to-end · `plan-only` stop after the decomposition + module plan.
- **stack override** — e.g. "use NestJS for backend" in the prompt; otherwise the reference repos' stacks are used.

## Workflow

Drive with `TodoWrite` (one item per phase, then one per module). Read the linked reference for each phase.

### Phase 0 — Decompose the requirement → read `references/00-decomposition.md` (+ `templates/decomposition.md`)
Analyze the problem: actors, use-cases, bounded contexts, **modules** (domain nouns), per-module **entities** (fields + types + invariants), relationships, **CRUD + business rules**, and the **API contract**. Output the decomposition doc + a per-module plan. **Checkpoint** (guided): agree this before building. `plan-only` stops here.

### Phase 1 — Stack & conventions → read `references/01-stack-and-conventions.md`
Detect the reference repos and their stacks/structure (run `scripts/detect-conventions.sh`). Confirm the stack (default = repos'; apply any override). Capture the exact per-layer module layout to mirror.

### Phase 2 — Naming standard → read `references/02-naming-standard.md`
Fix the canonical name + casing per layer for each module/entity from Phase 0 (one concept → one consistent slug across BE/web/app). Reject role/permission/technical names. Produce the name map used by all scaffolding.

### Phase 3 — Infrastructure → read `references/03-infrastructure.md` (+ `templates/docker-compose.yml`)
Stand up **MongoDB + MinIO** on Docker (matching how the backend already expects them), with env wiring, healthchecks, bucket creation, and (for greenfield) the app service(s). Verify the stack comes up.

### Phase 4 — Scaffold per module (loop) → read `references/04-scaffold-backend.md`, `05-scaffold-frontend.md`, `06-scaffold-app.md`
For each module, in order, scaffold full CRUD across the layers it targets, mirroring each repo's structure, wired to the shared contract. Build/lint after each layer; get the module green before the next module.

### Phase 5 — Review, test & standardize → read `references/07-review-test-standardize.md`
Compose the sibling skills: `senior-review` on the generated diff → `codebase-spec-test` to write test cases for every module + run them to green → `api-contract-guard` to confirm no FE/BE/APP drift → `context-bootstrap` to write `CLAUDE.md`. Then a final report (modules, endpoints, coverage, how to run).

## Definition of done
- A decomposition doc + module plan that the user agreed to.
- Infra (Mongo + MinIO) up; new modules build/lint green across their layers; full CRUD wired to one contract.
- Standardized domain-noun names, consistent across repos; no role/technical module names.
- Code reviewed, tested (cases + passing run), contract-checked; `CLAUDE.md` written.
- No half-wired modules; reused shared infra; this skill untouched.

## Usage & install
See `README.md`.
