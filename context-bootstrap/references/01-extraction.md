# Phase 0/1 — Survey the repo & mine the essentials

Goal: gather the verified facts that will populate `CLAUDE.md`. Fast, evidence-based.

## 1. Fast first pass
Run `scripts/repo-survey.sh` (POSIX) — it reports stack, package managers, run/test scripts, containers, CI, entrypoint/test dirs, and existing context files. Treat output as leads; verify before writing.

## 2. Verify the commands (most important)
The run/build/test lines must actually work. In priority order, trust:
1. **CI config** (`.github/workflows`, `.gitlab-ci.yml`) — the canonical install + build + test commands.
2. **Package manifest scripts** (`package.json`, `composer.json`, Makefile targets, `pyproject`/tox, `go` commands).
3. **README/CONTRIBUTING** — but cross-check against the above; READMEs rot.

Note any wrapper or precondition: a Makefile target, `docker compose exec <svc> …` (services only resolve in-container), a codegen step, a required env file, a monorepo task filter.

## 3. Map the architecture (briefly)
Identify just the boundaries worth telling an agent:
- Entrypoints (HTTP routes, CLI, jobs, events) and where domain/business logic lives.
- Module/layer layout and the main data store(s).
- Front-end ↔ back-end seam (and whether they're separate repos/packages).
- Generated artifacts (route trees, client SDKs, `*.gen.*`, migrations) the agent must not hand-edit.

## 4. Harvest conventions & gotchas
- **Conventions:** naming, error handling, the project's idioms, shared utilities/helpers to reuse, the formatter/linter that owns style. Infer from a few representative files, not one.
- **Gotchas:** container-only services, codegen/regeneration steps, test DB/isolation quirks, env vars that change behaviour, platform notes (e.g. Windows shell, line endings), "run X before Y".
- **Do/Don't:** the footguns you'd warn a new hire about.

## 5. Domain glossary (if the domain has its own vocabulary)
Collect domain terms and how they map to code names (class/table/field) — especially when UI/business language differs from identifiers, or the project is non-English. This prevents the agent from misusing terms.

## 6. Reuse existing context
Read any existing `CLAUDE.md`/`AGENTS.md`/`.cursorrules`/`README`. Preserve what's correct; you'll merge, not replace (see `references/02-writing-and-merging.md`).

## Output of this phase
A short working note: verified commands, architecture bullets, conventions, gotchas, do/don't, glossary terms, and which (if any) packages warrant a nested `CLAUDE.md`. That note becomes the file.
