# Phase 0 — Scope the change & build the diff

Goal: know exactly **what changed, how much, and why** before judging anything. Garbage scope → garbage review.

## 1. Resolve the target

- **Current branch vs base (default):** find the base branch and the merge-base.
  ```bash
  cur=$(git rev-parse --abbrev-ref HEAD)
  # pick the first base that exists; prefer the repo's integration branch
  for b in develop main master; do git show-ref -q --verify "refs/heads/$b" && base="$b" && break; done
  base=${base:-$(git remote show origin 2>/dev/null | sed -n 's/.*HEAD branch: //p')}
  merge_base=$(git merge-base "$base" HEAD)
  git diff "$merge_base"...HEAD        # the change introduced by this branch
  ```
  Use `git log --no-merges "$merge_base"..HEAD` for the commits and their messages (intent).
- **`staged`:** `git diff --cached`.
- **`working`:** `git diff` plus `git diff --cached` (everything uncommitted).
- **`<base>..<head>`:** use the range verbatim (`...` = changes on head since divergence; `..` = direct diff — prefer `...` for branch reviews).
- **`pr <number|url>`:** fetch with `gh` if present (`gh pr view <n> --json …`, `gh pr diff <n>`), else the REST API. See `references/02-posting-to-pr.md`.

> If `origin` differs from local (reviewing what will be pushed), compare against the **remote** base: `git fetch origin` then use `origin/<base>`.

## 2. Get the diff + a map

- Stats first: `git diff --stat <range>` and `git diff --name-status <range>` — added/modified/deleted/renamed files. Optionally `scripts/diff-summary.sh <base>` for a one-shot overview.
- Then the full patch: `git diff <range>`. For large diffs, prioritize: production code > config/migrations > tests > generated/lock files. Note (but don't deep-review) generated files, lockfiles, vendored code.
- Renames/moves: use `git diff -M` so a move isn't read as delete+add.

## 3. Capture intent

A review is "does this achieve its goal, safely?" — so pin the goal:
- Commit messages (`git log` on the range) and the **PR title/description** (the *why*, linked issues, "out of scope" notes).
- If intent is unclear or the description is empty, say so — an unexplained change is itself a finding, and you should review against the most reasonable inferred goal.

## 4. Output: change summary

A few lines that frame the review:
- **Goal:** <what this change is for>.
- **Scope:** N files (+a/-d lines); main areas: <modules>.
- **Type:** feature / bugfix / refactor / config / migration / mixed.
- **Risk surface (first read):** touches <auth / money / data migration / public API / concurrency / none obvious>.
- **Unknowns to resolve while reading:** <…>.

Proceed to build context (read surrounding code), then Phase 2 (`references/01-review-rubric.md`).

## Environment notes
- Run git from the repo root. If the change spans submodules or a monorepo package, scope per package.
- Never modify the working tree while reviewing (no checkout/stash that discards the author's state). Reviewing is read-only.
