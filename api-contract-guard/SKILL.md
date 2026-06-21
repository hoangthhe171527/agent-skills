---
name: api-contract-guard
description: "Detects drift between an API's providers (server routes/controllers/handlers, OpenAPI/GraphQL schema) and its consumers (typed clients, fetch/axios calls, generated SDKs, query hooks) — within one repo or across a separate frontend + backend. Reports mismatches with severity and file:line on both sides: missing/renamed endpoints, wrong method or path, request/response field name or type mismatches, removed fields a client still reads, changed status codes, auth gaps. Optionally generates or updates an OpenAPI/contract doc and suggests fixes; runs as a CI gate. Use when changing an endpoint or DTO, wiring a frontend to a backend, hunting 'API said X but client expected Y' bugs, or when the user asks to 'check the API contract', 'find FE/BE mismatches', or invokes the skill. Stack-agnostic: REST, GraphQL, or RPC across any framework."
---

# api-contract-guard

Catch the bug class where **the server and its clients silently disagree** about an API: a renamed field, a changed type, a removed endpoint, a wrong path/method. Works inside one repo or across a **frontend + backend pair**, on REST, GraphQL, or RPC.

The whole skill is a **diff between two inventories** — what the server *provides* and what clients *consume* — surfaced with evidence on both sides.

## Golden rules

1. **Both sides, real code.** Build the provider inventory from server source/schema and the consumer inventory from client source — each endpoint/field cites `file:line`. No guessing either side.
2. **Contract is the spec; if one exists, trust it.** An OpenAPI/GraphQL schema is the source of truth — verify both code sides against it. If none exists, derive the contract from the provider code.
3. **Name + shape + type.** Drift isn't just missing endpoints — it's field renames, type changes (`string` vs `number`, nullable, array vs object), enum value changes, and status-code changes. These cause the nastiest runtime bugs.
4. **Severity by blast radius.** A removed field a client reads, or a wrong path/method → 🔴. A new optional field unused by clients → informational. Rank by what actually breaks at runtime.
5. **Report, don't silently rewrite.** Surface drift with a concrete fix on the correct side. Apply changes or (re)generate the contract doc only when asked.
6. **Cross-repo aware.** When FE and BE are separate repos/paths, take both locations; match by method+path (REST) or operation/type (GraphQL), normalizing base paths/prefixes.

## Inputs (arguments)

Invoke as `api-contract-guard [provider] [consumer] [mode]`:

- **provider / consumer** — paths to the backend and frontend (or two packages). Omit when both live in one repo — the skill auto-detects. Order: `<provider-path> <consumer-path>`.
- **mode** — *(omitted)* full report · `diff` = only what changed in the current branch's diff (CI-gate friendly) · `openapi` = also generate/update an OpenAPI/contract doc · `auto` = run end-to-end and, in CI, exit non-zero on 🔴/🟠 drift.

If nothing is given: auto-detect provider and consumer in the current repo and produce a full report.

## Workflow

Track with `TodoWrite`. Read the linked reference for each phase.

### Phase 0 — Scope & detect → read `references/00-scope-and-detect.md`
Locate providers and consumers, identify the API style (REST/GraphQL/RPC), find any existing contract (OpenAPI/`schema.graphql`), and determine single-repo vs cross-repo (and the base-path/prefix to normalize). Run `scripts/scan-api.sh <path>` on each side for a fast endpoint/call list.

### Phase 1 — Provider inventory → read `references/01-provider-inventory.md`
Extract every endpoint the server exposes: method + path (+ route params), request shape (body/query params + validation), response shape (fields + types), status codes, and auth. Source: routes/controllers/handlers/validators/serializers, or the OpenAPI/GraphQL schema if present.

### Phase 2 — Consumer inventory → read `references/02-consumer-inventory.md`
Extract every call clients make: method + path (+ how the URL is built), request payload, and the response fields/types the client *relies on* (typed models, destructuring, `.data.x` access, query hooks, generated SDK types).

### Phase 3 — Diff & report → read `references/03-diff-and-report.md` (+ `templates/contract-report.md`)
Match consumer calls to provider endpoints; classify every mismatch (missing endpoint, wrong method/path, param/field name or type mismatch, removed-field-still-read, changed status/enum, auth gap) with severity and `file:line` on both sides + a suggested fix. In `openapi` mode, also emit/refresh the contract doc. In `diff`/CI mode, limit to endpoints touched by the branch and set exit status.

## Definition of done
- Provider and consumer inventories built from real code/schema, with evidence.
- A drift report: each mismatch with severity, both-side `file:line`, and a fix — or a clean "no drift found".
- (If asked) an updated OpenAPI/contract doc; (in CI) a pass/fail signal.
- No fabricated endpoints; no unrequested code edits; this skill untouched.

## Usage & install
See `README.md`.
