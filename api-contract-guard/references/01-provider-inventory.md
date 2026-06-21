# Phase 1 — Provider inventory (what the server exposes)

Goal: one row per endpoint the server actually serves, with request/response shapes and `file:line`. If an OpenAPI/GraphQL schema exists, start from it and confirm against code.

## Per endpoint, capture
- **Operation:** HTTP method + normalized path (REST) / query|mutation name (GraphQL) / procedure (RPC).
- **Path & query params:** names + types + required.
- **Request body:** field names + types + required/nullable — from the validator/DTO/serializer, not guesses.
- **Response:** field names + types (+ nullability, arrays, nested shapes) for success; the error/status codes returned.
- **Auth:** required permission/role/middleware.
- **Evidence:** `route-file:line` → `controller/handler:line` (and validator/resource file).

## Where to read it (by ecosystem)
- **Laravel:** route files (`routes/*.php`, module route files) → controllers; `FormRequest`/`$request->validate([...])` for request shape; API Resources / returned arrays for response shape; `middleware('permission:…')` for auth.
- **Express/NestJS:** routers/decorators (`@Get`, `@Post`), DTOs/class-validator, return types/serializers, guards.
- **FastAPI/DRF:** path operations + Pydantic models / serializers (these *are* the schema); permissions.
- **Spring:** `@RestController` mappings + request/response DTOs; security annotations.
- **GraphQL:** the SDL/type definitions + resolvers — types and nullability come straight from the schema.

## Technique
- Enumerate routes first (the index of the surface), then open each handler + its request/response types. Don't infer a response shape from the handler name — read what it returns.
- Note where validation and the DB schema disagree with the serialized response (a field required in the DB may be optional in the API, etc.).
- Record enums and their exact values (enum drift is a common client breaker).

## Output
A provider table: `method+path | params | request fields(type) | response fields(type) | status codes | auth | evidence`. This is the contract the consumers will be checked against (and the basis for `openapi` mode).

Proceed to Phase 2 (`references/02-consumer-inventory.md`).
