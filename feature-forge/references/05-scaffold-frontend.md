# Phase 4b — Scaffold the web module (CRUD)

Goal: a full-CRUD web module mirroring the frontend's layout, consuming the **same** contract as the backend (so `api-contract-guard` passes).

## Files per module (React + TS + Vite + TanStack — mirror an existing module)
Under `src/modules/<module>/`:
- **domain**
  - `domain/types.ts` — API record types (snake_case, matching the backend response) + view-model types + write-payload types.
  - `domain/mappers.ts` — `to<Entity>View(record)` (record → view model), `…FormToPayload(form)`; status/enum ↔ UI label maps.
- **application**
  - `application/<entity>-api.ts` — typed `apiFetch` calls for the 5 CRUD endpoints (reuse the shared API client + pagination helper).
  - `application/query-keys.ts` — stable query keys.
  - `application/hooks/<entity>.ts` — React Query hooks: `use<Entities>List`, `use<Entity>Detail`, `useCreate/useUpdate/useDelete<Entity>` (with invalidation), exported via the module's `hooks` barrel.
- **ui**
  - `ui/app/<entities>-page.tsx` — list (table + filters + pagination + create button).
  - `ui/app/<entity>-detail-page.tsx` — detail/edit (inline edit or form).
  - `ui/shared/…` — reusable bits (form dialog, status badge usage).
- **routing**
  - route files registering the pages (mirror the repo's file-based routing; let the router plugin regenerate the tree).
- Add nav/menu entry + permission gating using the existing pattern.

## CRUD specifics
- Types must match the backend response field-for-field (names + types) — this is the contract. Mappers convert snake_case records to view models.
- Hooks: list (with filters/pagination), detail, create, update, delete — each invalidates the right query keys.
- Forms: validate the same invariants as the backend; show server errors.
- Reuse shared UI (table, dialog, inputs, status badge, permission gate) — don't fork them.

## Keep it green
Run the web build + type-check (`npm run build` regenerates the route tree; `tsc --noEmit` for types) and confirm **no new type errors in the new files** (the repo may have pre-existing errors elsewhere — filter to your files). Lint. Then verify the list/detail/create flow against the running backend.

The web types are the **client contract** — Phase 5's `api-contract-guard` diffs them against the backend.
