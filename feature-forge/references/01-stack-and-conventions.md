# Phase 1 — Stack & conventions (mirror the reference repos)

Goal: the generated code must look native to this workspace. Detect the reference repos' stacks and **exact module layout**, and reuse them by default.

## Detect, don't assume
Run `scripts/detect-conventions.sh <workspace-dir>` to list the repos and their stacks, then open one representative module per repo and read its real structure. Confirm:
- Each repo's framework, language, package manager, test runner, and **how a module/feature is laid out** (folders + the files a typical module contains).
- Shared infra to reuse: base controller/repository, auth/tenant scoping, the API client wrapper, base widgets, query-key helpers, error handling.

## Default layout to mirror (this workspace — verify against the repos)
- **Backend — Laravel + MongoDB, DDD modular monolith** (`modules/<PascalModule>/`):
  `Application/{DTOs,Services,UseCases}` · `Domain/{Enums,Repositories,Services}` · `Infrastructure/{Persistence/Mongo/{Models,Repositories},Providers,Console}` · `Interfaces/Http/{Controllers,Requests}` + `routes.php`. Repository **interface** in `Domain/Repositories`, **Mongo impl** in `Infrastructure`; a `ServiceProvider` binds them and registers routes.
- **Web — React + TypeScript + Vite + TanStack Router/Query** (`src/modules/<module>/`):
  `domain/{types,mappers}` · `application/{<entity>-api,hooks/,query-keys}` · `ui/{app,shared}` · `routing/`. API records (snake_case) → view models via mappers; hooks wrap React Query.
- **App — Flutter + Riverpod + Dio + Freezed** (`lib/features/<feature>/`):
  `data/` (Dio data source + DTOs) · `domain/` (entities/models, freezed) · `application/` (riverpod providers/controllers) · `presentation/` (screens + widgets) · `routing/`. Core in `lib/core/` (network, auth, routing), shared in `lib/shared/`.

## Stack override
If the user specifies a different stack (e.g. "NestJS backend", "Vue web", "Compose Multiplatform"), honor it — but **keep the layered separation** (domain / application/use-cases / infrastructure-data / interface-ui) and the one-contract rule. Note the override in the plan.

## Output
A short conventions note per layer: the folder template, the files a new module needs, the shared pieces to reuse, and the build/lint/test command for each repo (used to keep each module green in Phase 4).

Proceed to Phase 2 (`references/02-naming-standard.md`).
