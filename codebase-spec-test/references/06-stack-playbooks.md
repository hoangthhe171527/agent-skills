# Stack playbooks — runners, conventions, run commands

Pick the playbook matching the detected stack. Always prefer the project's **own** script (Makefile/CI/npm script/`composer test`) over a generic command. If services run only in containers, wrap with `docker compose exec <svc> …` or `docker exec <container> …`.

---

## PHP / Laravel
- **Frameworks:** PHPUnit, Pest. **Factories:** `database/factories`, model `factory()`. **Feature tests** hit routes; **Unit** for pure logic.
- **Run:** `php artisan test` · `./vendor/bin/pest` · `./vendor/bin/phpunit --filter=Name` · `php artisan test --testsuite=Feature`.
- **DB:** `RefreshDatabase`/`DatabaseTransactions` traits; `phpunit.xml` test DB (often sqlite `:memory:`). Time: `Carbon::setTestNow()`. HTTP: `Http::fake()`. Events: `Event::fake()`, `Queue::fake()`, `Mail::fake()`.
- **Modular/DDD apps:** tests may live per-module (`modules/*/Tests`) — match the existing location.

## Node / TypeScript (Jest · Vitest · Mocha)
- **Run:** `npm test` / `pnpm test` / `yarn test` · `npx jest path -t "name"` · `npx vitest run`.
- **Data:** factories via `fishery`/`@faker-js/faker`; in-memory or testcontainers DB. **Mocks:** `jest.mock`/`vi.mock`; `nock`/`msw` for HTTP; fake timers `jest.useFakeTimers()`/`vi.useFakeTimers()`.
- **TS:** ensure `ts-jest`/`vitest` transform is configured (it usually already is).

## Front-end (React/Vue/Svelte components)
- **Run:** Vitest/Jest + Testing Library (`@testing-library/{react,vue,svelte}`). Component logic & state, not pixel design.
- **E2E:** Playwright/Cypress for documented user workflows — see **End-to-end / integration harness** below (the real stack must be up first).

## Python (Pytest · Django · unittest)
- **Run:** `pytest -q` · `pytest path -k name` · `python -m pytest`. Django: `pytest` (pytest-django) or `python manage.py test`.
- **Data:** `factory_boy`/`model_bakery`, `pytest` fixtures, `@pytest.mark.parametrize` for boundary tables. **Mocks:** `unittest.mock`/`pytest-mock`; `responses`/`respx` for HTTP; `freezegun` for time. DB: `pytest-django` transactional DB or testcontainers.

## Go
- **Run:** `go test ./...` · `go test ./pkg -run TestName` · `-race` for concurrency rules.
- **Data:** table-driven tests (`[]struct{...}`) are idiomatic for boundary sets; `testify` for assertions/mocks; `httptest` for handlers; interfaces for stubbing external seams.

## Java / Kotlin (JUnit 5)
- **Run:** `mvn test` · `mvn -Dtest=ClassName#method test` · `./gradlew test --tests "*Name"`.
- **Data:** builders/`@ParameterizedTest`; Mockito for mocks; Testcontainers for DB; `@SpringBootTest`/`@DataJpaTest` slices for Spring.

## Ruby / Rails (RSpec · Minitest)
- **Run:** `bundle exec rspec spec/path -e "name"` · `bin/rails test`.
- **Data:** FactoryBot, fixtures; `WebMock`/`VCR` for HTTP; `Timecop`/`travel_to` for time; transactional fixtures for isolation.

## C# / .NET (xUnit · NUnit)
- **Run:** `dotnet test` · `dotnet test --filter FullyQualifiedName~Name`.
- **Data:** builders/`[Theory]`+`[InlineData]`; Moq for mocks; `WebApplicationFactory` for integration; EF Core in-memory or Testcontainers.

---

## Generic fallback (unknown stack)
1. Open the CI config — it lists the real install + test commands. Reproduce them.
2. Read the manifest's scripts/test section.
3. Find the existing test dir and copy its conventions for a new test.
4. If **no** framework exists: stop and confirm with the user before adding one; then pick the ecosystem-standard runner, add the minimal config, and document it in `test-plan.md`.

## Container-bound services
If env points at service hostnames (`mongodb`, `postgres`, `redis`) that don't resolve from the host:
- Inspect `docker-compose*.yml` for the app service name; run tests/seeds inside it: `docker compose exec app <test-cmd>` or `docker exec <container> <test-cmd>`.
- Use the container's network for the test DB; keep a separate test database to avoid touching dev data.

## End-to-end / integration harness (real stack required)
Cross-boundary flow tests (UI ↔ API ↔ DB) need the whole stack up — see the discipline in `references/05-execution-and-reporting.md`. Quick reference:
- **Bring up & verify:** `docker compose -f docker-compose*.yml up -d` then check `docker ps` healthchecks; **reuse already-running containers** instead of restarting.
- **Web E2E:** Playwright (`npm i -D @playwright/test && npx playwright install`; then `npx playwright test`) or Cypress (`npx cypress run`). Set `baseURL` to the running app; persist auth via `storageState` / a seeded token rather than logging in each test.
- **Backend feature/integration (in container):** `docker compose exec app php artisan test --testsuite=Feature` (Laravel) · `docker compose exec app <runner>` for other stacks.
- **Seed/reset test data (in container):** `docker compose exec app <seeder>`; use a dedicated test DB/namespace **and** a test object-storage bucket (e.g. MinIO `*-test`), never dev/prod.
- **Teardown:** reset state, or `docker compose down` for ephemeral environments. Record the full bring-up→seed→run→teardown sequence in `test-plan.md`.
