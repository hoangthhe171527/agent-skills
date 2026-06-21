# What belongs in CLAUDE.md (and what doesn't)

`CLAUDE.md` is injected into the model's context **every session/turn**. Treat it like a hot path: maximize signal per token. Aim ~30–120 lines at the root; push depth into linked docs.

## Include (high signal)

- **What it is** — 1–2 lines: product/purpose + the stack in one breath.
- **Run / build / test** — the *exact* commands that work (verified). Include the non-obvious wrapper (Makefile target, `docker compose exec …`, monorepo filter). This is the single most useful section.
- **Architecture in brief** — the few boundaries that matter: layers/modules, where business logic lives, the data store, how the front end talks to the back end. 5–12 lines, not a treatise.
- **Conventions the agent must follow** — naming, error handling, the project's idioms, preferred libraries/utilities to reuse, formatting/lint authority.
- **Key entrypoints & paths** — where to start reading for common tasks ("routes live in X", "domain in Y", "tests in Z").
- **Gotchas** — the things that waste an hour: services only reachable in containers, a codegen/route-tree step, "regenerate X after Y", a flaky env var, a test DB reset trait, platform quirks (Windows shell, etc.).
- **Do / Don't** — crisp imperatives: "Use the existing `apiFetch` helper", "Never edit `*.gen.*`", "Don't push to main".

## Exclude (low signal / noise)

- Things trivially discoverable in seconds (full dependency lists, the entire folder tree, every script).
- Generic best practices the model already knows ("write clean code", "add tests").
- Aspirational rules nobody follows, or long rationale/prose. Link a doc instead.
- Volatile detail that rots fast (exact version numbers, ticket links) unless essential.
- Secrets, tokens, internal URLs.

## Size & structure discipline
- If a section grows past a few lines of *reference* material, move it to `docs/architecture.md` and leave a one-line pointer.
- Use short headings + bullets/imperatives, not paragraphs. Code-fence commands.
- One fact per line where possible — easy for an agent to apply and for a human to edit.

## Nesting & precedence (monorepos)
- A root `CLAUDE.md` holds repo-wide essentials. Add a **nested** `CLAUDE.md` inside a package/app that has a materially different setup (its own run/test commands, stack, or conventions).
- Nested files are loaded in addition to the root when working in that subtree — so don't repeat the root; only put package-specific deltas.
- Personal/global guidance belongs in the user's `~/.claude/CLAUDE.md`, not the repo. Don't put machine-specific paths in the repo file.

## Quality bar
A good `CLAUDE.md` lets a brand-new agent: build/run/test on the first try, find the right files for a typical change, and avoid the top 3 footguns — without reading the whole codebase first.
