<#
detect-stack.ps1 — read-only heuristic scan of a project to seed Phase 0.
Usage:  pwsh ./detect-stack.ps1 [-Root <path>]   (defaults to CWD)
Prints languages/frameworks, package managers, test runners, run hints,
container setup, and likely directories. Heuristics only — verify the files.
Works in Windows PowerShell 5.1 and PowerShell 7+.
#>
param([string]$Root = ".")

$ErrorActionPreference = "SilentlyContinue"
try { Set-Location -Path $Root -ErrorAction Stop } catch { Write-Host "Cannot cd into $Root"; exit 1 }

function Have($p) { Test-Path -LiteralPath $p }
function Section($t) { Write-Host "`n== $t ==" }
function FileHas($file, $pattern) { (Have $file) -and (Select-String -LiteralPath $file -Pattern $pattern -Quiet) }

Write-Host "codebase-spec-test :: stack detection for: $((Get-Location).Path)"

Section "Manifests & languages"
if (Have composer.json)    { "PHP        (composer.json)" }
if (Have package.json)     { "JS/TS      (package.json)" }
if ((Have pyproject.toml) -or (Have requirements.txt) -or (Have setup.py) -or (Have Pipfile)) { "Python     (pyproject/requirements/Pipfile)" }
if (Have go.mod)           { "Go         (go.mod)" }
if ((Have pom.xml) -or (Have build.gradle) -or (Have build.gradle.kts)) { "Java/Kotlin (maven/gradle)" }
if (Have Gemfile)          { "Ruby       (Gemfile)" }
if (Get-ChildItem -Filter *.csproj -ErrorAction SilentlyContinue) { ".NET/C#    (*.csproj)" }
if (Have Cargo.toml)       { "Rust       (Cargo.toml)" }
if (Have tsconfig.json)    { "TypeScript (tsconfig.json)" }

Section "Frameworks (heuristic)"
if (FileHas composer.json 'laravel/framework') { "Laravel" }
if (FileHas composer.json 'symfony/')          { "Symfony" }
if (FileHas package.json  '"next"')            { "Next.js" }
if (FileHas package.json  '"react"')           { "React" }
if (FileHas package.json  '"vue"')             { "Vue" }
if (FileHas package.json  'svelte')            { "Svelte" }
if (FileHas package.json  '@nestjs/')          { "NestJS" }
if (FileHas package.json  'express')           { "Express" }
if ((FileHas requirements.txt 'django') -or (FileHas pyproject.toml 'django') -or (Have manage.py)) { "Django" }
if ((FileHas requirements.txt 'fastapi') -or (FileHas pyproject.toml 'fastapi')) { "FastAPI" }
if ((FileHas requirements.txt 'flask') -or (FileHas pyproject.toml 'flask'))     { "Flask" }
if (FileHas Gemfile 'rails')                   { "Rails" }
if ((FileHas pom.xml 'spring-boot') -or (FileHas build.gradle 'spring-boot')) { "Spring Boot" }

Section "Package managers / lockfiles"
if (Have package-lock.json) { "npm" }
if (Have pnpm-lock.yaml)    { "pnpm" }
if (Have yarn.lock)         { "yarn" }
if (Have composer.lock)     { "composer" }
if (Have poetry.lock)       { "poetry" }
if (Have Pipfile.lock)      { "pipenv" }
if (Have go.sum)            { "go modules" }

Section "Test runners (heuristic)"
if (FileHas composer.json 'phpunit')  { "PHPUnit" }
if (FileHas composer.json 'pestphp')  { "Pest" }
if (FileHas package.json  'jest')     { "Jest" }
if (FileHas package.json  'vitest')   { "Vitest" }
if (FileHas package.json  'mocha')    { "Mocha" }
if (FileHas package.json  'playwright') { "Playwright (E2E)" }
if (FileHas package.json  'cypress')  { "Cypress (E2E)" }
if ((FileHas pyproject.toml 'pytest') -or (FileHas requirements.txt 'pytest') -or (Have pytest.ini) -or (Have conftest.py)) { "Pytest" }
if (Have go.mod) { "go test (built-in)" }
if ((FileHas pom.xml 'junit') -or (FileHas build.gradle 'junit')) { "JUnit" }
if (FileHas Gemfile 'rspec') { "RSpec" }

Section "Run hints (scripts)"
if (Have package.json) {
  "[package.json scripts]"
  Select-String -LiteralPath package.json -Pattern '"(test|test:.*|build|dev|lint)"\s*:' | Select-Object -First 20 | ForEach-Object { "  " + $_.Line.Trim() }
}
if (Have composer.json) {
  "[composer scripts]"
  Select-String -LiteralPath composer.json -Pattern '"(test|test:.*)"\s*:' | Select-Object -First 10 | ForEach-Object { "  " + $_.Line.Trim() }
}
if (Have Makefile) {
  "[Makefile targets]"
  Select-String -LiteralPath Makefile -Pattern '^[a-zA-Z0-9_.-]+:' | Select-Object -First 20 | ForEach-Object { "  " + $_.Line }
}
if (Have artisan) { "  Laravel: php artisan test" }

Section "Containers & CI"
Get-ChildItem -Filter "docker-compose*.yml" -ErrorAction SilentlyContinue | ForEach-Object { "  compose: $($_.Name)" }
Get-ChildItem -Filter "compose*.yml" -ErrorAction SilentlyContinue | ForEach-Object { "  compose: $($_.Name)" }
if (Have Dockerfile) { "  Dockerfile present" }
if (Have .github/workflows) { "  CI: GitHub Actions"; Get-ChildItem .github/workflows | ForEach-Object { "    $($_.Name)" } }
if (Have .gitlab-ci.yml) { "  CI: GitLab" }
foreach ($f in @(".env", ".env.example", ".env.dev")) {
  if (Have $f) {
    Select-String -LiteralPath $f -Pattern '^(DB_HOST|DB_CONNECTION|MONGO|REDIS_HOST|DATABASE_URL)=' |
      ForEach-Object { "  [$f] " + ($_.Line -replace '=.*PASSWORD.*', '=***') }
  }
}

Section "Likely directories (entrypoints / domain / tests)"
foreach ($d in @('src','app','modules','lib','internal','pkg','packages','domain','application','infrastructure','controllers','routes','http','handlers','services','usecases','models','entities','database','migrations','tests','test','spec','__tests__')) {
  if (Test-Path -LiteralPath $d -PathType Container) { "  $d/" }
}

Section "Existing docs"
foreach ($d in @('docs','documentation')) { if (Test-Path -LiteralPath $d -PathType Container) { "  $d/" } }
Get-ChildItem -Filter "README*" -ErrorAction SilentlyContinue | ForEach-Object { "  $($_.Name)" }

Write-Host "`nDone. Verify these heuristics against the actual files before relying on them."
