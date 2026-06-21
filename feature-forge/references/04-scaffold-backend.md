# Phase 4a — Scaffold the backend module (CRUD)

Goal: a full-CRUD module mirroring the backend's DDD layout, wired to the contract from Phase 0. Generate one module fully, get it green, then the next.

## Files per module (Laravel + MongoDB DDD — mirror an existing module)
Under `modules/<PascalModule>/`:
- **Domain**
  - `Domain/Repositories/<Entity>RepositoryInterface.php` — the contract (find/paginate/save/update/delete).
  - `Domain/Enums/<Entity>Status.php` (if the entity has a lifecycle).
- **Application**
  - `Application/DTOs/<Entity>DTO.php` — typed DTO + `toArray()`.
  - `Application/UseCases/…` or `Application/Services/…` only if there's real logic beyond CRUD (don't over-engineer simple cruds).
- **Infrastructure**
  - `Infrastructure/Persistence/Mongo/Models/<Entity>.php` — the Mongo model (fillable, casts).
  - `Infrastructure/Persistence/Mongo/Repositories/Mongo<Entity>Repository.php` — implements the interface (toDTO mapping, filters in `paginate`).
  - `Infrastructure/Providers/ServiceProvider.php` — bind interface→impl, register `routes.php` and any commands.
- **Interfaces**
  - `Interfaces/Http/Controllers/<Entity>Controller.php` — `index/show/store/update/destroy` returning `{ success, data, pagination }`.
  - `Interfaces/Http/Requests/{Create,Update}<Entity>Request.php` — validation = the entity's invariants from Phase 0.
  - `Interfaces/routes.php` — `Route::prefix('api/v1')->middleware([...])` with the 5 CRUD routes + permission middleware.
- Register the module's ServiceProvider where the app discovers modules (mirror how existing modules are registered).
- Migration/index creation if the repo manages indexes explicitly.

## CRUD specifics
- **index**: pagination + the filters the contract lists; return the pagination block in the repo's shape.
- **store/update**: validate via FormRequest (the invariants), enforce uniqueness, set defaults; return the DTO.
- **destroy**: guard referential integrity (don't orphan children) per the rules.
- **Auth**: apply the module's permissions as route middleware (`permission:<module>.<action>`). The permission name uses the module noun — but, again, the **module is not named for a role**.
- **Tenant/ownership scoping**: reuse the existing scoping mechanism; don't bypass it.

## Keep it green
After generating, run the backend's lint/static-analysis + `php artisan test` (via `docker compose exec`), and hit the endpoints (seed a record, list it). Fix before moving on. Reuse base classes/traits the repo already provides — match an existing module's style exactly.

Then scaffold the web layer (`references/05-scaffold-frontend.md`) and app layer (`references/06-scaffold-app.md`) for the **same** contract.
