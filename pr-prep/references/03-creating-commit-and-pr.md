# Phase 3 — Create the commit / open the PR

Only when the user asked (`pr`/`auto`) or agreed. These are outward-facing — confirm the target before acting.

## Safety first
- **Confirm the branch.** Never commit straight to `main`/`master`/`develop` — if HEAD is on one, create a feature branch first (`git switch -c <type>/<short-desc>`) and say so.
- **Respect hooks & signing.** Don't pass `--no-verify` or disable GPG signing unless the user explicitly asked. If a hook fails, fix the cause, don't bypass.
- **Never force-push** or rewrite shared history as part of "prep".
- In non-`auto` runs, show the message + PR body and get a yes before committing/pushing.

## Commit
```bash
# stage intentionally (prefer explicit paths or -p over blanket -A if the tree has unrelated edits)
git add <paths>
git commit -m "<subject>" -m "<body>" -m "<footers>"   # or a heredoc/-F file for long bodies
```
For multi-commit splits, stage per group (`git add -p` / pathspecs) and commit each with its message.

## Push
```bash
git push -u origin "$(git rev-parse --abbrev-ref HEAD)"
```
If the remote rejects (diverged), stop and report — don't force.

## Open the PR
- **`gh` (preferred):**
  ```bash
  gh pr create --base <base> --head <branch> --title "<title>" --body-file pr-body.md
  # draft: add --draft ; assign reviewers: --reviewer <user>
  ```
- **REST API (no gh):** get a token from the credential helper and `POST /repos/{owner}/{repo}/pulls` with `title`, `head`, `base`, `body`. Derive `{owner}/{repo}` from `git remote get-url origin`.
- **Manual fallback:** push the branch and output the prefilled compare URL:
  `https://github.com/<owner>/<repo>/compare/<base>...<branch>?expand=1` — the user clicks to open with the title/body ready (or paste the body).

## After
- Print the commit SHA(s) and the PR URL.
- If a review skill/bot is set up, mention that the PR will be (or can be) reviewed next.
- Don't re-run/duplicate: if a PR already exists for the branch, update it (`gh pr edit`) instead of creating another.
