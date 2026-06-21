---
name: context-bootstrap
description: "Generates or refreshes a high-signal CLAUDE.md (agent context file) plus an architecture map and domain glossary for any repository, so both AI agents and humans work faster and make fewer mistakes. Derives the essentials from the actual code — how to build/run/test, architecture & module boundaries, conventions, key entrypoints, gotchas (env/containers), and do/don't rules — and writes a concise, evidence-based context file, merging with any existing one instead of clobbering it. Use when onboarding to a new or unfamiliar repo, when there's no CLAUDE.md (or it's stale/thin), when agent output quality is poor for lack of context, or when the user asks to 'set up CLAUDE.md', 'bootstrap context', 'document how this repo works', or invokes the skill. Stack- and project-agnostic; supports monorepos with nested context files."
---

# context-bootstrap

Give an agent (and a new teammate) the **minimum high-signal context** to be productive in a repo: a concise `CLAUDE.md`, an architecture map, and a domain glossary — all **derived from the code**, not guessed.

`CLAUDE.md` is loaded into the model's context **every session**, so it must be **short, accurate, and high-leverage**. This skill optimizes for signal-per-token: the things an agent gets wrong without being told, and nothing it can trivially discover.

## Golden rules

1. **Concise > complete.** `CLAUDE.md` earns its place in every prompt. Prefer ~30–120 lines of essentials over an exhaustive manual. Depth goes in `docs/architecture.md`, linked — not inline.
2. **Evidence-based.** Every command, path, and convention must be verified against the repo (run it / read it). No aspirational rules, no invented scripts. If unsure, omit or mark `❓`.
3. **Merge, never clobber.** If a `CLAUDE.md` (or `AGENTS.md`/Cursor rules) already exists, read and improve it in place — preserve human-written guidance; fill gaps; fix what's stale.
4. **Capture what bites.** The highest-value lines are the non-obvious gotchas: container-only services, codegen steps, "run X before Y", a test DB quirk, a naming convention, a "don't edit generated file Z".
5. **Do/Don't over prose.** Agents follow crisp imperatives ("Use `rg`, not `grep`"; "Never edit `*.gen.ts`") better than paragraphs.
6. **Outputs land in the target repo.** `CLAUDE.md` at the relevant root(s); optional `docs/architecture.md` + glossary. Never modify this skill.

## Inputs (arguments)

Invoke as `context-bootstrap [mode] [scope]`:

- **mode** — *(omitted)* full bootstrap (CLAUDE.md + architecture map + glossary). `refresh` = update an existing CLAUDE.md only. `claude-md` = just the CLAUDE.md. `auto` = run end-to-end without pausing.
- **scope** — a subdir/package for a **nested** `CLAUDE.md` in a monorepo (e.g. `apps/web`). Omitted → repo root, plus propose nested files for clearly-separable packages.

## Workflow

Track with `TodoWrite`. Read the linked reference for each phase.

### Phase 0 — Survey the repo → read `references/01-extraction.md`
Detect stack, package managers, build/test/run commands, entrypoints, module layout, data layer, config/env, containers, CI, and existing context files (`CLAUDE.md`, `AGENTS.md`, `.cursorrules`, `README`, `CONTRIBUTING`). Run `scripts/repo-survey.sh` for a fast first pass, then verify. **Verify run/build/test commands actually exist** (CI and package scripts are the source of truth).

### Phase 1 — Decide what belongs → read `references/00-what-goes-in-claude-md.md`
Select only high-signal items: project purpose (1–2 lines), the exact build/run/test commands, architecture & boundaries (brief), conventions the agent must follow, key entrypoints/paths, gotchas, and explicit do/don't. Drop anything trivially discoverable or generic.

### Phase 2 — Write / merge → read `references/02-writing-and-merging.md` (+ `templates/`)
Write `CLAUDE.md` from `templates/claude-md.md`, merging with any existing file. For a monorepo, add **nested** `CLAUDE.md` in packages with materially different setups (root stays general; nested holds package specifics). Optionally write `docs/architecture.md` (deeper) and a glossary, and link them from `CLAUDE.md`.

### Phase 3 — Verify & report
Re-read the result as if you were a fresh agent: are the commands runnable, the rules unambiguous, the file short? Trim filler. Summarize what was created/updated and any `❓` items needing the owner's confirmation.

## Definition of done
- A concise, **accurate** `CLAUDE.md` at the right root(s); existing guidance preserved.
- Commands verified; conventions and gotchas captured; do/don't explicit.
- Optional architecture map + glossary written and linked.
- No invented facts; this skill's files untouched.

## Usage & install
See `README.md`.
