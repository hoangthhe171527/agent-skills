# Phase 2 — Consumer inventory (what clients rely on)

Goal: one row per call a client makes, with the request it sends and the response fields/types it **depends on**, plus `file:line`. Drift only matters where a client actually relies on something.

## Per call, capture
- **Operation:** method + the path *as the client builds it* (template literals, base URL + route, generated SDK method).
- **Request:** body/query the client sends (field names + types from the typed payload or the object literal).
- **Response reliance:** which fields/types the client reads — typed response models, destructuring, `res.data.x` access, mapping in hooks, render usage. A field the client never touches isn't a contract risk if removed (but flag if typed).
- **Evidence:** `file:line` of the call + of the type/usage.

## Where to read it (by client style)
- **fetch/axios:** search for `fetch(`, `axios.`, `.get/.post/.put/.delete(`, URL builders, and the `baseURL`/prefix config. Read the request body and how the response is consumed.
- **React Query / SWR / Vue Query:** the `queryFn`/`mutationFn` holds the call; the `select`/mapping and component usage show the relied-on fields.
- **Typed clients / generated SDKs:** the generated types *are* the client's expectation — compare them to the provider. If generated from an OpenAPI spec, staleness = the spec or the regen is behind.
- **GraphQL clients:** the query/mutation documents declare exactly which fields/types are selected — a precise consumer contract.
- **Domain types/mappers:** front-ends often map raw API records into view models (e.g. a `toXView(record)` mapper). These reveal the exact field names + types the client expects from the API — a goldmine; read them.

## Technique
- Start from the API client layer (the module wrapping fetch/axios or the hooks), then follow into mappers/types and a couple of usages to see which fields are truly required.
- Normalize the path the same way as the provider (strip base prefix, canonicalize params) so matching works.
- Note optional vs required on the client side (does it guard for `null`? assume presence?).

## Output
A consumer table: `method+path | request fields(type) | relied-on response fields(type) | optional? | evidence`. Phase 3 matches this against the provider table.

Proceed to Phase 3 (`references/03-diff-and-report.md`).
