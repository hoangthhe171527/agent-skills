# Phase 4c — Scaffold the mobile module (CRUD)

Goal: a full-CRUD Flutter feature mirroring the app's feature-first layout, consuming the **same** contract.

## Files per feature (Flutter + Riverpod + Dio + Freezed — mirror an existing feature)
Under `lib/features/<feature>/`:
- **data**
  - `data/<entity>_dto.dart` — Freezed DTO with `fromJson`/`toJson` matching the backend response (snake_case via json keys).
  - `data/<entity>_remote_data_source.dart` — Dio calls for the 5 CRUD endpoints (reuse the core Dio client + error mapping).
  - `data/<entity>_repository.dart` — wraps the data source, maps DTO ↔ domain entity, handles failures.
- **domain**
  - `domain/<entity>.dart` — the domain entity (Freezed), independent of transport.
- **application**
  - `application/<entity>_providers.dart` — Riverpod providers (list/detail) + an `AsyncNotifier`/controller for create/update/delete with state + invalidation (use `riverpod_generator` if the repo does).
- **presentation**
  - `presentation/<entities>_screen.dart` — list (pull-to-refresh, pagination, FAB to create).
  - `presentation/<entity>_detail_screen.dart` — detail/edit form.
  - `presentation/widgets/…` — reusable item/card/form widgets.
- **routing**
  - register routes (mirror the app's router pattern); add to the feature's routing + the app router.
- Localization keys if the app uses l10n (mirror the existing approach).

## CRUD specifics
- DTO json keys must match the backend exactly (the contract). Keep `domain` entities transport-agnostic; map in the repository.
- Providers: list (with filters/pagination), detail, and a controller for mutations that refreshes the list on success.
- Presentation: loading/error/empty states (reuse the app's shared states/widgets), permission gating via the core permissions util.
- Reuse `lib/core` (network, auth, routing) and `lib/shared` (widgets, status options) — don't duplicate.

## Keep it green
Run `flutter analyze` (and `build_runner` if freezed/riverpod codegen is used: `dart run build_runner build`). Fix issues before the next module. `flutter test` for any added tests.

The app DTOs are another **client contract** — Phase 5's `api-contract-guard` checks them against the backend too.
