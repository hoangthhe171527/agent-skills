#!/usr/bin/env bash
# change-context.sh — read-only overview to seed a commit message + PR description.
# Usage: bash change-context.sh [base]   (default: auto-detect base branch)
set -u
cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)" || { echo "Not a git repo"; exit 1; }

if [ -n "${1:-}" ]; then BASE="$1"; else
  BASE=""; for b in develop main master; do git show-ref -q --verify "refs/heads/$b" && BASE="$b" && break; done
  [ -z "$BASE" ] && BASE="$(git remote show origin 2>/dev/null | sed -n 's/.*HEAD branch: //p')"
  [ -z "$BASE" ] && BASE="HEAD~1"
fi
MB=$(git merge-base "$BASE" HEAD 2>/dev/null || echo "$BASE")
CUR=$(git rev-parse --abbrev-ref HEAD)

echo "pr-prep :: change context"
echo "  branch: $CUR   base: $BASE   merge-base: $MB"

echo
echo "== Commits on this branch =="
git log --no-merges --pretty='  %h %s' "$MB..HEAD" 2>/dev/null | head -40

echo
echo "== Changed files =="
git diff --stat "$MB"...HEAD 2>/dev/null | sed 's/^/  /'

echo
echo "== Repo commit style (recent subjects — match this) =="
git log -n 15 --pretty='  %s' 2>/dev/null

echo
echo "== Conventions detected =="
for t in .github/pull_request_template.md .github/PULL_REQUEST_TEMPLATE.md docs/pull_request_template.md; do
  [ -f "$t" ] && echo "  PR template: $t"
done
[ -d .github/PULL_REQUEST_TEMPLATE ] && echo "  PR templates dir: .github/PULL_REQUEST_TEMPLATE/"
[ -f CHANGELOG.md ] && echo "  CHANGELOG.md present (update if convention requires)"
git config --get commit.gpgsign | grep -qi true && echo "  ⚠ commit signing ON — don't bypass"
[ -d .husky ] || [ -f .pre-commit-config.yaml ] && echo "  ⚠ git hooks present — don't use --no-verify"
echo "  issue ref in branch name: $(echo "$CUR" | grep -oiE '[A-Z]+-[0-9]+|#?[0-9]{2,}' | head -1 || echo none)"

echo
echo "Done. Describe what the diff actually does; match the repo's commit style & language."
