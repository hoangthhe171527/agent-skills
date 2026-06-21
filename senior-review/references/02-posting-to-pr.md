# Phase 4 — Delivering the review (post to the PR)

Always produce the structured report. Then deliver it where it's useful: **on the PR** when one exists, otherwise locally.

## Decide the channel
- **PR exists + `post`/`auto` (or user agrees):** post inline comments + a summary review.
- **Local diff / no PR:** write `code-review/<branch>-review.md` in the target repo (or print), and give the compare URL to open a PR.
- **Never post without intent.** Posting is outward-facing — in non-`auto` runs, show the report and confirm before publishing.

## Path A — GitHub CLI `gh` (preferred if installed)

Check: `gh --version` and `gh auth status`.

- Read the PR: `gh pr view <n> --json title,body,headRefName,baseRefName,files` · `gh pr diff <n>`.
- **Summary review with a verdict:**
  ```bash
  gh pr review <n> --comment  -F review-summary.md     # neutral comment
  gh pr review <n> --request-changes -F review-summary.md
  gh pr review <n> --approve  -F review-summary.md
  ```
- **Inline comments** (anchored to a file + line) — use the API for line anchoring:
  ```bash
  gh api repos/{owner}/{repo}/pulls/<n>/comments -f body="…" -f commit_id="$SHA" \
    -f path="src/foo.ts" -F line=142 -f side=RIGHT
  ```
  Or batch them as a single pending review via `POST …/pulls/<n>/reviews` with a `comments[]` array (preferred — one review, many inline notes, plus the verdict):
  ```bash
  gh api repos/{owner}/{repo}/pulls/<n>/reviews -X POST --input review.json
  # review.json: { "event":"REQUEST_CHANGES", "body":"<summary>",
  #   "comments":[ { "path":"src/foo.ts", "line":142, "side":"RIGHT", "body":"🟠 …" }, … ] }
  ```
  Map `event`: approve→`APPROVE`, approve-with-nits→`COMMENT`, request-changes→`REQUEST_CHANGES`.

## Path B — REST API without `gh`

The repo uses HTTPS + a credential manager, so a token usually exists. Retrieve it via the credential helper, then call the API:
```bash
TOKEN=$(printf 'protocol=https\nhost=github.com\n\n' | git credential fill | sed -n 's/^password=//p')
OWNER=hoangthhe171527 REPO=<repo> PR=<n>
curl -sS -X POST -H "Authorization: Bearer $TOKEN" -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/$OWNER/$REPO/pulls/$PR/reviews" --data @review.json
```
Same `review.json` shape as above. If no token is retrievable, fall through to Path C.

> Determine `{owner}/{repo}` from `git remote get-url origin`. Use the PR **head SHA** (`commit_id`) for inline comments; lines anchor to the diff's `RIGHT` side (new file) unless commenting on removed lines (`LEFT`).

## Path C — Manual (no gh, no token)

Output a single paste-ready Markdown review (`templates/pr-comment.md`): a summary block with the verdict + severity counts, then the findings grouped by severity with `file:line` references. Tell the user to paste it as a PR review, and provide the compare/PR URL.

## Comment style when posting
- **Summary comment** = verdict + counts + top risks + pre-merge checklist (high-level, skimmable).
- **Inline comments** = one finding each, anchored at the exact line, with severity emoji, the *why*, and a suggestion. Use GitHub ```suggestion blocks for trivial one-line fixes so the author can apply them in one click.
- Keep the tone collaborative ("consider…", "is X intended?"). Lead blockers clearly; keep nits visibly low-priority.
- Don't post hundreds of nits — fold them into one "minor/nits" comment if numerous.

## Safety
- Confirm the target PR number/repo before posting; posting is public and persists.
- Post once; don't spam re-runs. If updating, edit/replace rather than duplicate.
- Never push code or change the branch as part of "review". Review ≠ fix.
