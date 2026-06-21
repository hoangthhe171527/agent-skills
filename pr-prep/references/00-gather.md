# Phase 0 — Gather diff, intent & conventions

Goal: know what changed, why, and the repo's writing conventions — before drafting anything.

## 1. Resolve the range & read the diff
- Default (branch vs base): detect base (`develop`/`main`/`master` or `origin` HEAD), then `git diff <merge-base>...HEAD` and `git log --no-merges <merge-base>..HEAD`.
- `staged` → `git diff --cached`; `working` → staged + unstaged; `<base>..<head>` → verbatim.
- Run `scripts/change-context.sh [base]` for a one-shot overview (stats, commits, template/issue detection).
- Read enough of the diff to describe it truthfully — including migrations, config, and side effects, not just the headline file.

## 2. Capture intent
- Commit messages on the range, the issue/ticket (number in branch name or commits), and any existing PR draft. The *why* usually lives here.
- If intent is unclear, infer the most reasonable goal from the diff and note the assumption — don't invent a motivation.

## 3. Detect the repo's conventions (match, don't impose)
- **Commit style:** `git log -n 30 --pretty=%s`. Are they Conventional Commits (`feat:`, `fix(scope):`)? What scopes are used? What language (English/Vietnamese/…)? Match it. If the repo has no consistent style, default to Conventional Commits.
- **PR template:** look for `.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE/*`, or `docs/`. If present, you must fill its sections.
- **Issue linking:** how do they close issues (`Closes #`, `Fixes #`, Jira keys)? Mirror it.
- **Changelog:** is there a `CHANGELOG.md` / "Keep a Changelog" / release-please convention to respect?
- **Commit hooks / signing:** note `commit-msg`/`pre-commit` hooks and GPG signing so you don't bypass them later.

## 4. Output: change summary
One short paragraph that anchors the message and PR body:
- **Goal:** <why this change exists>.
- **What changed:** <areas + the few notable specifics>.
- **Type:** feat / fix / refactor / chore / docs / perf / test (+ scope).
- **Flags:** breaking change? migration? UI (needs screenshots)? security/perf surface? linked issue?
- **Split?** if it's multiple unrelated logical changes, note that you'll recommend separate commits.

Proceed to Phase 1 (`references/01-commit-message.md`).
