# Phase 1 — Commit message

Goal: a message that explains *why* and is correct for the repo's style. Default to **Conventional Commits** unless the repo clearly uses another style.

## Conventional Commits shape
```
<type>(<scope>): <subject>

<body — why this change, notable details, trade-offs>

<footers — issue refs, breaking changes, co-authors>
```

- **type:** `feat` · `fix` · `refactor` · `perf` · `docs` · `test` · `build` · `ci` · `chore` · `style` · `revert`. Pick by the *primary* intent of the change.
- **scope:** the affected area/module (match scopes already used in the repo, e.g. `feat(inventory):`). Optional but encouraged.
- **subject:** imperative mood, lower-case, no trailing period, ≤ ~72 chars. "add route filter", not "added"/"adds".
- **body:** wrap ~72 cols. Explain *why* and anything non-obvious (approach, trade-offs, what was ruled out). Skip if the subject fully says it.
- **footers:**
  - Issues: `Closes #123` / `Fixes #123` (or the repo's convention / Jira key).
  - Breaking: a `BREAKING CHANGE: <what + migration>` footer (and/or `!` after type/scope: `feat(api)!: …`).
  - `Co-Authored-By: Name <email>` when pairing.

## Language & style
- Write in the repo's commit language (e.g. Vietnamese if that's the norm). Keep the `type(scope):` prefix in English even then — it's machine-readable.
- Be specific: name what changed, not "update code" / "fix bug".

## One change per commit
If the diff bundles unrelated logical changes (e.g. a feature + an unrelated refactor + a dependency bump):
- Recommend splitting, and propose a message per logical commit, with the exact `git add -p` / pathspec grouping.
- If the user keeps it as one commit, write a body that lists the distinct parts as bullets.

## Quality bar
A reviewer reading only the message should know *what* changed, *why*, whether it's breaking, and which issue it closes — without opening the diff.

Proceed to Phase 2 (`references/02-pr-description.md`).
