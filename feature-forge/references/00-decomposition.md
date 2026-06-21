# Phase 0 — Decompose the requirement

Goal: turn prose into a precise, buildable model. This is the most important phase — everything downstream is generated from it. No code yet.

## Steps

1. **Restate the goal** in 1–2 sentences. If the requirement is ambiguous or missing pieces (who uses it, what states an entity has, what "done" means), ask — don't guess silently. List open questions.
2. **Actors & use-cases.** Who does what. Each use-case becomes one or more CRUD operations or a workflow.
3. **Bounded contexts → modules.** Group use-cases by cohesive business area. Each area = one **module** (a domain noun). Keep modules cohesive and loosely coupled; a module owns its entities.
4. **Entities per module.** For each: fields (name + type + required/nullable), identity, **invariants** (uniqueness, ranges, enums), and **relationships** (belongs-to / has-many, and which module owns the link).
5. **Operations per entity.** The CRUD set (list w/ filters & pagination, show, create, update, delete) plus any **non-CRUD actions** (state transitions, e.g. `activate`, `cancel`) — each with its rule/guard.
6. **Business rules.** Validation, authorization (who can do what — captured as a permission, but the **module is not named after the role**), calculations, side effects (events/files/notifications), lifecycle/state machines.
7. **API contract.** For each operation: method + path, request shape, response shape, status/errors. This single contract drives backend, web, and app generation (so they can't drift).
8. **Cross-module concerns.** Shared lookups, file storage (→ MinIO), auth/tenant scoping, audit. Reuse existing shared infra rather than re-inventing.

## Output (`templates/decomposition.md` + `templates/module-plan.md`)
- **Decomposition doc:** goal, actors, module list (with one-line purpose each), an entity/relationship sketch, cross-cutting concerns, open questions.
- **Module plan (per module):** entities + fields + invariants, operations + rules, the API contract table, and which layers it targets (backend/web/app).

## Quality bar & checkpoint
- Every module is a domain noun with a single clear responsibility.
- Every entity has typed fields, invariants, and a full operation list.
- The API contract is explicit enough to generate all three layers from it.
- **Guided mode:** present this for sign-off before Phase 1. Confirm the module breakdown, names, and any open questions. In `auto`, proceed but surface open questions in the final report. `plan-only` stops here.

> Reuse the analysis muscle of [`codebase-spec-test`]'s extraction approach, but in reverse: there you derive rules *from* code; here you derive the model *for* code. Same rigor (typed entities, explicit rules), opposite direction.
