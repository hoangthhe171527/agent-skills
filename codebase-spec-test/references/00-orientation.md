# Phase 0 — Orientation & stack detection

Goal: in one focused pass, know **what the project is, how it's built, how it's tested, and which slice you'll work on**. Do not start documenting rules yet.

## 1. Run the detector, then verify

Run the helper for a fast inventory, then **confirm against real files** (detectors are heuristics). The script lives in this skill's own `scripts/` directory — pass the target project path as the argument:

```bash
# POSIX (use the absolute path to THIS skill's scripts/detect-stack.sh)
bash <skill-dir>/scripts/detect-stack.sh <target-project-dir>

# Windows PowerShell
& '<skill-dir>\scripts\detect-stack.ps1' -Root '<target-project-dir>'
```

It reports likely languages, frameworks, package managers, test runners, container setup, and entrypoint/test directories. Treat the output as a lead list, not gospel. (The script is optional — if it's unavailable, do the same mapping by hand from the manifests below.)

## 2. Map the repository

Build a mental (and written) model:

- **Manifests** — `composer.json`, `package.json`, `pyproject.toml`/`requirements.txt`, `go.mod`, `pom.xml`/`build.gradle`, `*.csproj`, `Gemfile`. These name the framework, scripts, and test deps.
- **Entrypoints** — HTTP routes/controllers, CLI commands, queue/cron workers, event listeners, GraphQL resolvers, public API/SDK surface. These are where business logic is *triggered*.
- **Domain core** — models/entities, services/use-cases, domain/aggregate classes, repositories, policies. These are where business logic *lives*.
- **Data layer** — migrations, schema files, ORM models, seeders. The schema encodes invariants (NOT NULL, unique, FK, enums, defaults, check constraints).
- **Config & flags** — env samples, feature flags, config files. Behaviour often branches on these.
- **Existing tests** — they are free documentation of intended behaviour and reveal the test framework, factories, and conventions.

Write a short **module map**: for each module/bounded context in scope, note its entrypoints, core classes, and data tables.

## 3. Identify the test setup

Record exactly how tests run today (you'll reuse it in Phase 5):

- Framework (PHPUnit/Pest, Jest/Vitest, Pytest, `go test`, JUnit, RSpec, xUnit…).
- Runner command(s) and any wrapper (Makefile target, npm script, `artisan test`, Docker exec).
- Test DB / environment strategy (in-memory, transactional rollback, dedicated test DB, containers).
- Fixtures/factories/seeders already present.
- CI config (`.github/workflows`, `.gitlab-ci.yml`) — the canonical "how to run everything".

> **Environment gotcha:** services (DB, cache, queue) may only be reachable inside a container/compose network, not from the host shell. Detect this early (host name like `mongodb`/`postgres` in env, a `docker-compose*.yml`). If so, run tests via `docker compose exec <svc> …` / `docker exec <container> …`.

## 4. Lock the scope

Documenting an entire large system at once is rarely the goal. Pick a **bounded, high-value slice** unless told otherwise:

- Prefer a single module/bounded context, a critical workflow (checkout, billing, auth), or the area the user named.
- State the scope explicitly and (guided mode) confirm it. In `auto` mode, proceed with the inferred scope but write it into the orientation note and the final report.

## 5. Output: the orientation note

Keep it short (it seeds the docs). Capture:

- Stack & versions; how to run the app and the tests.
- Module map for the chosen scope.
- Test/data strategy and any container/run caveats.
- The locked scope + what's explicitly out of scope.
- Initial list of `❓` unknowns to resolve while extracting.

Proceed to Phase 1 (`references/01-business-logic-extraction.md`).
