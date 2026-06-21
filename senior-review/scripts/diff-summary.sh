#!/usr/bin/env bash
# diff-summary.sh — read-only overview of a changeset to seed a review (Phase 0).
# Usage:
#   bash diff-summary.sh                 # current branch vs auto-detected base
#   bash diff-summary.sh <base>          # vs an explicit base ref
#   bash diff-summary.sh <base> <head>   # explicit range
# Prints: base/head, commits & messages, changed-file stat, and risk-flag hints.

set -u
cd "$(git rev-parse --show-toplevel 2>/dev/null || echo .)" || { echo "Not a git repo"; exit 1; }

HEAD_REF="${2:-HEAD}"
if [ -n "${1:-}" ]; then
  BASE="$1"
else
  BASE=""
  for b in develop main master; do
    git show-ref -q --verify "refs/heads/$b" && BASE="$b" && break
  done
  [ -z "$BASE" ] && BASE="$(git remote show origin 2>/dev/null | sed -n 's/.*HEAD branch: //p')"
  [ -z "$BASE" ] && BASE="HEAD~1"
fi

MB=$(git merge-base "$BASE" "$HEAD_REF" 2>/dev/null || echo "$BASE")
RANGE="$MB..$HEAD_REF"

echo "senior-review :: diff summary"
echo "  base:  $BASE   head: $HEAD_REF"
echo "  merge-base: $MB"

echo
echo "== Commits ($(git rev-list --count "$RANGE" 2>/dev/null || echo 0)) =="
git log --no-merges --pretty='  %h %s' "$RANGE" 2>/dev/null | head -40

echo
echo "== Changed files =="
git diff --stat "$MB"..."$HEAD_REF" 2>/dev/null | sed 's/^/  /'

echo
echo "== Name-status =="
git diff --name-status -M "$MB"..."$HEAD_REF" 2>/dev/null | sed 's/^/  /' | head -200

echo
echo "== Risk-flag hints (heuristic — verify in the diff) =="
DIFF=$(git diff "$MB"..."$HEAD_REF" 2>/dev/null)
flag() { printf '%s' "$DIFF" | grep -qiE "$1" && echo "  ⚠ $2"; }
printf '%s' "$DIFF" | grep -qiE '^\+\+\+ .*(migrat|schema|\.sql)' && echo "  ⚠ DB migration/schema touched — check reversibility & locks"
flag '(password|secret|api[_-]?key|token|private[_-]?key)' "possible secret/credential in diff"
flag '(authoriz|permission|->can\(|isAdmin|role)' "authorization logic touched — verify access checks"
flag '(SELECT |->where\(|find\(|query\()' "query code touched — watch N+1 / missing index"
flag '(eval\(|exec\(|system\(|child_process|Runtime\.exec)' "dynamic exec — injection risk"
flag '(TODO|FIXME|XXX|console\.log|dd\(|var_dump|dbg!)' "debug leftovers / TODO markers"
printf '%s' "$DIFF" | grep -qiE '^\-.*(test|spec)' && echo "  ⚠ test lines removed — confirm coverage not weakened"
[ -z "$DIFF" ] && echo "  (no diff — branch may not have diverged; try 'staged'/'working')"

echo
echo "Done. Use this as a map; read the full diff + surrounding code before judging."
