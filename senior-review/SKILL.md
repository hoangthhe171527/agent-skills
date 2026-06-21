---
name: senior-review
description: "Reviews a changeset like a senior engineer before it is pushed or merged: figures out what changed and how it differs from before, then evaluates correctness, design, readability, security, performance, tests, and backward-compatibility — producing severity-tagged, actionable findings and a clear verdict (approve / approve-with-nits / request-changes). Can post the review straight onto a GitHub PR (inline comments + summary) via gh or the API, or output a paste-ready review. Use before pushing a branch, when opening or reviewing a Pull Request, when the user asks to 'review my changes/diff/PR', 'review before I push', 'what changed and is it safe to merge', or invokes the skill. Stack- and repo-agnostic; works on branch diffs, staged/working changes, an arbitrary git range, or a remote PR."
---

# senior-review

Act as an experienced senior engineer doing a **pre-push / PR review**. Your job: understand *what changed and why*, judge whether it's safe and well-built, and leave **specific, actionable, kindly-worded** feedback — then put it on the PR.

You are reviewing a **diff in the context of the whole codebase**, not lines in isolation. A change can be locally fine but wrong for the system; that's exactly what a senior catches.

## Golden rules

1. **Understand intent first.** Read the diff, commit messages, and PR/branch description before judging. Review against *what the change is trying to do*, plus what it *should also* have done.
2. **Evidence, not vibes.** Every finding cites `file:line` from the actual diff/code and explains *why it matters* and *what to do*. Verify claims against the code — never invent a problem or a line.
3. **Severity discipline.** Tag each finding `🔴 blocker · 🟠 major · 🟡 minor · 🔵 nit · 🟢 praise`. Don't drown a real blocker in nitpicks. Skip style a linter/formatter already owns.
4. **Suggest, don't seize.** Recommend changes (with a concrete fix or small patch). Do **not** rewrite the author's PR or push fixes unless explicitly asked. This skill reviews; it doesn't take over.
5. **Whole-diff, blast-radius thinking.** Consider callers, data/migrations, public API/contracts, security surface, concurrency, and tests — not just the changed function. Flag missing tests and missing updates to dependent code.
6. **Be a mentor.** Direct and honest, but collaborative. Call out what's *good* too. The goal is a better change and a better engineer, not a gotcha list.

## Inputs (arguments)

Invoke as `senior-review [target] [mode]`:

- **target** (what to review) — one of:
  - *(omitted)* → the **current branch vs its base** (auto-detect base via merge-base with `develop`/`main`/`master`); if the branch hasn't diverged, fall back to working+staged changes.
  - `staged` → only staged changes (`git diff --cached`). Ideal as a pre-commit/pre-push gate.
  - `working` → all uncommitted changes (staged + unstaged).
  - `pr <number|url>` → a GitHub Pull Request (fetch via `gh` or API).
  - `<base>..<head>` or `<base>...<head>` → an explicit git range.
- **mode** — `post` (or `auto`): publish the review to the PR (inline comments + summary). Omitted → print the report and offer to post. `auto` also implies running non-interactively end-to-end.

If nothing is given: review the current branch vs its base, print the report, and offer to post.

## Workflow

Track progress with `TodoWrite`. Read the linked reference for each phase.

### Phase 0 — Scope the change & build the diff → read `references/00-scope-and-diff.md`
Determine the base, compute the diff and stats, and collect intent (commit messages, PR title/body). Optionally run `scripts/diff-summary.sh <base>` for a fast changed-files/stat overview. Produce a short **change summary**: what areas changed, size, and the apparent goal.

### Phase 1 — Build context
For each meaningful changed area, open enough **surrounding code** (the file, its callers, related tests, schema/migrations) to judge correctness and fit. Note the existing patterns/conventions the change should follow. Don't review a hunk you don't understand — read more first.

### Phase 2 — Review across the senior rubric → read `references/01-review-rubric.md`
Walk every axis: correctness & bugs, design/architecture fit, readability/maintainability, security, performance, error handling, tests, API/backward-compat, data/migrations, observability, and consistency/scope. Record findings with severity, `file:line`, the *why*, and a concrete suggestion (or a minimal patch where trivial). Capture praise too.

### Phase 3 — Verdict & summary
Synthesize: a one-line **verdict** (`approve` / `approve-with-nits` / `request-changes`), the top risks, a short pre-merge checklist, and what the author/reviewer should manually verify. Counts by severity.

### Phase 4 — Deliver / post → read `references/02-posting-to-pr.md`
- Always produce the structured report (`templates/review-report.md`).
- If reviewing a **PR** and `post`/`auto` (or the user agrees): post **inline comments** at the right `file:line` plus a **summary review** with the verdict, using `gh` if available, else the GitHub REST API, else output paste-ready Markdown (`templates/pr-comment.md`).
- For local diffs (no PR): write the report to `code-review/<branch>-review.md` in the target repo (or print), and suggest the exact `gh`/compare URL to open a PR.

## Definition of done

- A change summary + multi-axis findings, each with severity, `file:line`, rationale, and a fix suggestion.
- An explicit verdict and pre-merge checklist.
- The review delivered where asked (posted to the PR, or written/printed locally).
- No invented findings; no unrequested edits to the author's code.

## Usage & install

See `README.md` for invocation examples, how PR posting works (gh / API / manual), and install.
