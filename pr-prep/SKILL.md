---
name: pr-prep
description: "Turns a set of code changes into a clean Conventional-Commits commit message and a high-quality Pull Request description — derived from the actual diff, filling the repo's PR template if present, linking issues, and including a test plan and risk notes. Optionally creates the commit, pushes the branch, and opens the PR (gh / API / paste-ready URL), always confirming before any outward-facing action. Use before committing or opening a PR, when the user asks to 'write a commit message', 'prepare a PR', 'open a pull request', 'describe my changes', or invokes the skill. Pairs with code review: pr-prep opens a good PR, a reviewer reviews it. Stack- and repo-agnostic; prose follows the repo's language."
---

# pr-prep

Prepare a changeset for review: a crisp **commit message** and a **PR description** that a reviewer can trust at a glance — both grounded in the *actual* diff and the repo's own conventions. Then, on request, create the commit / push / open the PR.

This skill is the front half of a clean review loop: **pr-prep** produces a well-described PR; a code-review skill (or a human) reviews it.

## Golden rules

1. **Describe what actually changed.** Read the diff; don't restate the branch name or a vague intent. The summary must match the code, including side effects and migrations.
2. **Follow the repo's conventions.** Detect the existing commit style (Conventional Commits? scopes? language?) and the PR template — match them rather than imposing a new format.
3. **Why over what.** The diff already shows *what*. The message/description's job is *why* and *impact* — the context a reviewer needs.
4. **Honest test plan & risk.** State how it was verified (or wasn't), and call out risk: breaking changes, migrations, security/perf surface, follow-ups. Don't claim tests that don't exist.
5. **Confirm before outward actions.** Generating text is safe. Committing, pushing, and opening a PR are not — confirm first unless the user explicitly said `auto`/`pr`. Never force-push or touch `main` directly.
6. **No scope inflation.** Describe the change as-is; flag unrelated drive-by edits instead of narrating them as features.

## Inputs (arguments)

Invoke as `pr-prep [target] [mode]`:

- **target** — what to describe: *(omitted)* the current branch vs its base; `staged`; `working` (all uncommitted); or `<base>..<head>`.
- **mode** — `message` (commit message only) · `pr` (commit/push if needed + open the PR) · `auto` (run end-to-end, create commit + PR non-interactively) · omitted → produce both texts and **offer** to commit/open.

Default: describe the current branch, output a commit message + PR description, and ask whether to commit/open the PR.

## Workflow

Track with `TodoWrite`. Read the linked reference per phase.

### Phase 0 — Gather diff, intent & conventions → read `references/00-gather.md`
Resolve the range, read the diff + commits, and detect: the repo's commit style (run `git log` — Conventional? scoped? language?), the PR template (`.github/pull_request_template*`), issue references, and changelog norms. Run `scripts/change-context.sh` for a fast overview. Produce a one-paragraph change summary.

### Phase 1 — Commit message → read `references/01-commit-message.md` (+ `templates/commit-message.md`)
Compose a Conventional-Commits message (or match the repo's style): `type(scope): subject`, an informative body (*why* + notable details), and footers (`Closes #…`, `BREAKING CHANGE: …`). If the change is really several logical changes, recommend splitting and propose per-commit messages.

### Phase 2 — PR description → read `references/02-pr-description.md` (+ `templates/pr-description.md`)
If a PR template exists, **fill it**. Otherwise use the standard structure: Summary / Why / What changed / Test plan / Risk & rollout / Screenshots (if UI) / Checklist / Linked issues. Keep it skimmable; link don't dump.

### Phase 3 — Create commit / open PR (on request) → read `references/03-creating-commit-and-pr.md`
With `pr`/`auto` (or after the user agrees): stage & commit, push the branch, and open the PR via `gh` (preferred), the GitHub API, or output the prefilled compare URL. Respect commit-signing/hooks. Print links. **Confirm the target branch before pushing.**

## Definition of done
- A commit message in the repo's style, describing *why*, with correct footers.
- A PR description that fills the template (or the standard structure) with a real test plan + risk.
- If requested: commit created, branch pushed, PR opened (links returned) — with confirmation.
- Nothing fabricated; no unrequested pushes; this skill untouched.

## Usage & install
See `README.md`.
