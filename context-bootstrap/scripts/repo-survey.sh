#!/usr/bin/env bash
# repo-survey.sh — read-only survey to seed CLAUDE.md. Usage: bash repo-survey.sh [dir]
# Surfaces stack, run/test commands, containers, CI, entrypoints, and existing context files.
set -u
cd "${1:-.}" 2>/dev/null || { echo "Cannot cd into ${1:-.}"; exit 1; }
have() { [ -e "$1" ]; }
sec() { printf '\n== %s ==\n' "$1"; }
fgrepq() { [ -f "$1" ] && grep -qiE "$2" "$1" 2>/dev/null; }

echo "context-bootstrap :: repo survey — $(pwd)"

sec "Existing context files (MERGE, don't overwrite)"
for f in CLAUDE.md AGENTS.md .cursorrules .cursor/rules .windsurfrules README.md CONTRIBUTING.md; do
  have "$f" && echo "  $f"
done

sec "Stack / manifests"
have composer.json && echo "  PHP (composer.json)"
have package.json && echo "  JS/TS (package.json)"
{ have pyproject.toml || have requirements.txt; } && echo "  Python"
have go.mod && echo "  Go"
{ have pom.xml || have build.gradle; } && echo "  Java/Kotlin"
have Gemfile && echo "  Ruby"
ls -1 *.csproj >/dev/null 2>&1 && echo "  .NET"
fgrepq composer.json 'laravel/framework' && echo "  → Laravel"
fgrepq package.json '"next"' && echo "  → Next.js"
fgrepq package.json '"react"' && echo "  → React"
fgrepq package.json '"vue"' && echo "  → Vue"

sec "Run / build / test commands (verify these!)"
if have package.json; then echo "[package.json scripts]"; grep -nE '"[a-z:.-]+"\s*:' package.json 2>/dev/null | grep -iE 'dev|start|build|test|lint|typecheck|gen' | sed 's/^/  /' | head -20; fi
if have composer.json; then echo "[composer scripts]"; grep -nE '"[a-z:.-]+"\s*:' composer.json 2>/dev/null | grep -iE 'test|lint|stan|pint|dev' | sed 's/^/  /' | head -12; fi
have Makefile && { echo "[Makefile targets]"; grep -nE '^[a-zA-Z0-9_.-]+:' Makefile 2>/dev/null | sed 's/^/  /' | head -20; }
have artisan && echo "  Laravel: php artisan serve | php artisan test"

sec "Containers & CI (canonical commands live here)"
ls -1 docker-compose*.yml compose*.yml Dockerfile 2>/dev/null | sed 's/^/  /'
[ -d .github/workflows ] && { echo "  CI: GitHub Actions"; ls -1 .github/workflows | sed 's/^/    /'; }
have .gitlab-ci.yml && echo "  CI: GitLab"
for f in .env .env.example; do [ -f "$f" ] && grep -hiE '^(DB_HOST|DB_CONNECTION|MONGO|REDIS_HOST|DATABASE_URL)=' "$f" 2>/dev/null | sed 's/=.*PASSWORD.*/=***/' | sed "s/^/  [$f] /"; done

sec "Entrypoints / domain / generated"
for d in src app modules lib internal pkg routes controllers http handlers services domain models database migrations tests test spec __tests__; do
  [ -d "$d" ] && echo "  $d/"
done
echo "[generated artifacts — do NOT hand-edit]"
ls -1 2>/dev/null | grep -iE '\.gen\.|generated|openapi|swagger' | sed 's/^/  /' | head
find . -maxdepth 3 -name '*.gen.*' 2>/dev/null | sed 's/^/  /' | head

echo
echo "Done. Verify commands before writing them into CLAUDE.md. Keep CLAUDE.md short & high-signal."
