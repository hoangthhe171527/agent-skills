#!/usr/bin/env bash
# detect-stack.sh — read-only heuristic scan of a project to seed Phase 0.
# Usage: bash detect-stack.sh [project_dir]   (defaults to CWD)
# Prints: languages/frameworks, package managers, test runners, run hints,
# container setup, and likely entrypoint/domain/test directories.
# Heuristics only — always verify against the real files.

set -u
ROOT="${1:-.}"
cd "$ROOT" 2>/dev/null || { echo "Cannot cd into $ROOT"; exit 1; }

have() { [ -e "$1" ]; }
hasdir() { [ -d "$1" ]; }
section() { printf '\n== %s ==\n' "$1"; }
# grep a file quietly for a token
fgrepq() { [ -f "$1" ] && grep -qiE "$2" "$1" 2>/dev/null; }

echo "codebase-spec-test :: stack detection for: $(pwd)"

section "Manifests & languages"
have composer.json      && echo "PHP        (composer.json)"
have package.json       && echo "JS/TS      (package.json)"
{ have pyproject.toml || have requirements.txt || have setup.py || have Pipfile; } && echo "Python     (pyproject/requirements/Pipfile)"
have go.mod             && echo "Go         (go.mod)"
{ have pom.xml || have build.gradle || have build.gradle.kts; } && echo "Java/Kotlin (maven/gradle)"
have Gemfile            && echo "Ruby       (Gemfile)"
ls -1 *.csproj >/dev/null 2>&1 && echo ".NET/C#    (*.csproj)"
have Cargo.toml         && echo "Rust       (Cargo.toml)"
have tsconfig.json      && echo "TypeScript (tsconfig.json)"

section "Frameworks (heuristic)"
fgrepq composer.json 'laravel/framework'  && echo "Laravel"
fgrepq composer.json 'symfony/'           && echo "Symfony"
fgrepq package.json  '\"next\"'            && echo "Next.js"
fgrepq package.json  '\"react\"'           && echo "React"
fgrepq package.json  '\"vue\"'             && echo "Vue"
fgrepq package.json  'svelte'              && echo "Svelte"
fgrepq package.json  '\"@nestjs/'          && echo "NestJS"
fgrepq package.json  'express'             && echo "Express"
{ fgrepq requirements.txt 'django' || fgrepq pyproject.toml 'django' || have manage.py; } && echo "Django"
fgrepq requirements.txt 'fastapi' || fgrepq pyproject.toml 'fastapi' && echo "FastAPI"
fgrepq requirements.txt 'flask'   || fgrepq pyproject.toml 'flask'   && echo "Flask"
fgrepq Gemfile 'rails'                     && echo "Rails"
fgrepq pom.xml 'spring-boot' || fgrepq build.gradle 'spring-boot' && echo "Spring Boot"

section "Package managers / lockfiles"
have package-lock.json && echo "npm"
have pnpm-lock.yaml    && echo "pnpm"
have yarn.lock         && echo "yarn"
have composer.lock     && echo "composer"
have poetry.lock       && echo "poetry"
have Pipfile.lock      && echo "pipenv"
have go.sum            && echo "go modules"

section "Test runners (heuristic)"
fgrepq composer.json 'phpunit'  && echo "PHPUnit"
fgrepq composer.json 'pestphp'  && echo "Pest"
fgrepq package.json  'jest'     && echo "Jest"
fgrepq package.json  'vitest'   && echo "Vitest"
fgrepq package.json  'mocha'    && echo "Mocha"
fgrepq package.json  'playwright' && echo "Playwright (E2E)"
fgrepq package.json  'cypress'  && echo "Cypress (E2E)"
{ fgrepq pyproject.toml 'pytest' || fgrepq requirements.txt 'pytest' || have pytest.ini || have conftest.py; } && echo "Pytest"
have go.mod && echo "go test (built-in)"
fgrepq pom.xml 'junit' || fgrepq build.gradle 'junit' && echo "JUnit"
fgrepq Gemfile 'rspec' && echo "RSpec"

section "Run hints (scripts)"
if have package.json; then
  echo "[package.json scripts]"; grep -nE '"(test|test:.*|build|dev|lint)"\s*:' package.json 2>/dev/null | sed 's/^/  /' | head -20
fi
if have composer.json; then
  echo "[composer scripts]"; grep -nE '"(test|test:.*)"\s*:' composer.json 2>/dev/null | sed 's/^/  /' | head -10
fi
have Makefile && { echo "[Makefile targets]"; grep -nE '^[a-zA-Z0-9_.-]+:' Makefile 2>/dev/null | sed 's/^/  /' | head -20; }
have artisan && echo "  Laravel: php artisan test"

section "Containers & CI"
ls -1 docker-compose*.yml compose*.yml 2>/dev/null | sed 's/^/  compose: /'
have Dockerfile && echo "  Dockerfile present"
hasdir .github/workflows && { echo "  CI: GitHub Actions"; ls -1 .github/workflows | sed 's/^/    /'; }
have .gitlab-ci.yml && echo "  CI: GitLab"
# env service-host hint (container-bound services)
for f in .env .env.example .env.dev; do
  [ -f "$f" ] && grep -hiE '^(DB_HOST|DB_CONNECTION|MONGO|REDIS_HOST|DATABASE_URL)=' "$f" 2>/dev/null | sed 's/=.*PASSWORD.*/=***/' | sed "s/^/  [$f] /"
done

section "Likely directories (entrypoints / domain / tests)"
for d in src app modules lib internal pkg packages domain application infrastructure \
         controllers routes http handlers services usecases models entities database \
         migrations tests test spec __tests__ ; do
  hasdir "$d" && echo "  $d/"
done

section "Existing docs"
for d in docs documentation; do hasdir "$d" && echo "  $d/"; done
ls -1 README* 2>/dev/null | sed 's/^/  /'

echo
echo "Done. Verify these heuristics against the actual files before relying on them."
