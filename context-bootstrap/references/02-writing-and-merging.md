# Phase 2 — Write & merge CLAUDE.md

Goal: produce a concise, accurate `CLAUDE.md` (and optional deeper docs), preserving any existing human-written guidance.

## Merge, don't clobber
1. If `CLAUDE.md` exists, **read it fully first.** Keep correct human guidance verbatim where possible.
2. Fill gaps (missing run/test commands, conventions, gotchas), fix stale facts, and tighten bloat.
3. If guidance conflicts with the code, the code wins — update the line and note the change in your summary.
4. Migrating from `AGENTS.md`/`.cursorrules`? Fold their still-true rules into `CLAUDE.md`; don't silently delete the original — mention it in the report and let the user decide.

## Structure (from `templates/claude-md.md`)
Keep sections short; drop any that don't apply:
- **Title + 1–2 line summary** (what it is + stack).
- **Commands** — build / run / test / lint, code-fenced, with wrappers.
- **Architecture** — a handful of bullets; link `docs/architecture.md` for depth.
- **Conventions** — naming, error handling, reuse-these utilities, style authority.
- **Key paths** — where to start for common tasks.
- **Gotchas** — the non-obvious footguns.
- **Do / Don't** — crisp imperatives.
- **Glossary** — only if the domain vocabulary needs it (or link `docs/glossary.md`).

## Monorepo: nested files
- Root `CLAUDE.md` = repo-wide essentials (shared commands, cross-cutting rules).
- Add `apps/<x>/CLAUDE.md` (or `packages/<x>/CLAUDE.md`) **only** where setup/conventions materially differ. Put just the **delta** there — don't repeat the root.
- Keep each file short; nested files stack with the root in context.

## Optional deeper docs
- `docs/architecture.md` — the longer narrative (module responsibilities, data flow, diagrams). Link it from `CLAUDE.md`; don't inline it.
- `docs/glossary.md` — full domain vocabulary if too long for `CLAUDE.md`.

## After writing — self-check
Re-read as a fresh agent and cut ruthlessly:
- Could I build/run/test from this alone? Are commands exact?
- Is every line either non-obvious or a real rule? Delete the rest.
- Is it under ~120 lines at the root? If not, move depth to linked docs.
- Any secret/volatile detail to strip?

## Report
Summarize: files created/updated, what was merged vs added, verified commands, and any `❓` items (e.g. an unverifiable command, an ambiguous convention) for the owner to confirm.
