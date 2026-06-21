# Phase 0 — Scope & detect

Goal: know **where the provider and consumers live, what API style, and whether a contract already exists** — before inventorying.

## 1. Single repo vs cross-repo
- **Cross-repo / two packages:** the user passes `<provider-path> <consumer-path>` (e.g. a Laravel API dir + a React app dir). Use them directly.
- **Single repo:** auto-detect. Provider = where routes/controllers/handlers/schema live; consumer = where HTTP calls/typed clients live (often `src/` front-end calling an `api/`/`server/` back-end, or a `client` SDK).

## 2. Identify the API style
- **REST** — routes mapping `METHOD path → handler`. Most common; match by method + normalized path.
- **GraphQL** — a `schema.graphql`/SDL or code-first schema; queries/mutations on the client. Match by operation + selected fields/types.
- **RPC / tRPC / gRPC** — procedure names + input/output types. Match by procedure.
Detect from deps and files: `openapi`/`swagger`, `graphql`/`*.graphql`, `@trpc`, `.proto`, framework routers.

## 3. Find an existing contract (source of truth if present)
Look for `openapi.yaml`/`swagger.json`, `schema.graphql`, a generated client/types dir, or a published SDK. If one exists:
- Treat it as the spec; verify **both** the provider code and the consumer code against it (drift can be on either side, including a stale spec).
If none exists, the **provider code** is the de-facto contract; derive it in Phase 1.

## 4. Normalize paths
Before matching, reconcile:
- **Base URL / prefix:** server mounts `/api/v1`; client may store it in a config/`baseURL` and call relative paths. Strip/align the prefix so `/users` ↔ `/api/v1/users` match.
- **Path params:** `/users/{id}` (server) ↔ `/users/${id}` (client template) ↔ `/users/:id`. Normalize to a canonical form (`/users/{param}`).
- **Trailing slashes, query strings, casing.**

## 5. Fast first pass
Run `scripts/scan-api.sh <provider-path>` and `scripts/scan-api.sh <consumer-path>` to list candidate endpoints (server) and call sites (client). Heuristic — verify in code.

## Output: scope note
- Provider path + style + framework; consumer path(s) + client mechanism (fetch/axios/react-query/SDK).
- Existing contract file (if any) and the base-path/prefix to normalize.
- Scope: full vs `diff`-only (branch changes), single- vs cross-repo.

Proceed to Phase 1 (`references/01-provider-inventory.md`).
