<!--
Output → CLAUDE.md at the repo root (or a package root for nested files).
Keep it SHORT and high-signal — it's loaded every session. Delete sections that don't apply.
Replace every <…>. Verify commands actually run. Prose in the repo's dominant language.
-->

# <Project name>

<1–2 lines: what this project does + the stack (e.g. "React + TypeScript SPA backed by a Laravel/MongoDB API").>

## Commands
```bash
# install
<install cmd>
# run (dev)
<run cmd>
# build
<build cmd>
# test            # <how the test DB / env is handled, if non-obvious>
<test cmd>
# lint / format
<lint cmd>
```
<Note any wrapper/precondition, e.g. "DB runs only in Docker — run tests via `docker compose exec app …`".>

## Architecture
- <Where business logic lives / main layers or modules.>
- <Entrypoints: HTTP routes / CLI / jobs.>
- <Data store(s); front-end ↔ back-end seam.>
- <Generated artifacts NOT to hand-edit: e.g. `*.gen.ts`, OpenAPI client, migrations.>
- Deeper detail: see [docs/architecture.md](docs/architecture.md). <!-- if created -->

## Conventions
- <Naming / structure idiom this repo follows.>
- <Error-handling pattern.>
- Reuse: <key shared utilities/helpers instead of re-implementing>.
- Style is owned by <formatter/linter> — don't hand-format.

## Key paths
- <task> → `<path>`
- <task> → `<path>`

## Gotchas
- <non-obvious footgun #1, e.g. "run `<codegen>` after changing routes">
- <#2, e.g. container-only services / env file required>

## Do / Don't
- ✅ <do this>
- ❌ <never do this, e.g. "edit generated files / push to main">

<!-- ## Glossary  (only if the domain vocabulary is non-obvious; else link docs/glossary.md)
- **<term>** — <meaning> (`<code name>`)
-->
