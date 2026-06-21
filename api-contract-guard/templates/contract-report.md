<!-- Output → print, or save to docs/api-contract-report.md in the target repo. -->

# API Contract Report — <scope>

> Provider: `<path / spec>` · Consumer: `<path>` · Style: <REST/GraphQL/RPC> · Date: <date>
> Endpoints compared: <n> · Matched: <n> · Unmatched (client→server): <n> · Unmatched (server unused): <n>

## Verdict
**<✅ no drift | 🟡 minor drift | 🔴 contract broken>** — drift: 🔴 <n> · 🟠 <n> · 🟡 <n> · 🔵 <n>

## Drift findings

### 🔴 Breaking
- **`<METHOD /path>` — <field/endpoint>: <what differs>.**
  Provider: `<server file:line>` · Consumer: `<client file:line>`.
  **Fix:** <which side + concrete change>.

### 🟠 Major
- **`<METHOD /path>` — <request/status/enum mismatch>.** Provider `<file:line>` · Consumer `<file:line>`. **Fix:** <…>.

### 🟡 / 🔵 Minor / Info
- **`<METHOD /path>` — <auth gap / new optional field>.** <evidence>. <note>.

## Coverage gaps
| Client call (no server endpoint) | Evidence |
|---|---|
| `<METHOD /path>` | `<client file:line>` |

| Server endpoint (no client) | Evidence | Note |
|---|---|---|
| `<METHOD /path>` | `<server file:line>` | dead / external consumer? |

## Contract (normalized)  <!-- optional, or link generated openapi.yaml -->
| Method | Path | Request | Response (fields:type) | Auth | Provider |
|---|---|---|---|---|---|
| GET | /… | — | `{ id:string, … }` | <perm> | `<file:line>` |
