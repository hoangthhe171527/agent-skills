# Phase 3 — Diff & report

Goal: match consumer calls to provider endpoints and surface every disagreement with severity, evidence on both sides, and a fix.

## Matching
1. Pair each **consumer call** with a **provider endpoint** by normalized method + path (REST) / operation name (GraphQL/RPC).
2. Unmatched consumer call → the client hits something the server doesn't provide. Unmatched provider endpoint → dead/unused (informational, unless it's a removed endpoint clients *used to* call).
3. For matched pairs, compare request params/body and the relied-on response fields field-by-field (name, type, nullability, enum values, array-vs-scalar).

## Mismatch taxonomy & severity
- 🔴 **Missing/renamed endpoint** — client calls a path/method the server doesn't expose. Runtime 404/405.
- 🔴 **Removed/renamed response field a client reads** — client gets `undefined`; silent UI/logic breakage.
- 🔴 **Type mismatch on a used field** — `string` vs `number`, object vs array, nullable-now-but-client-assumes-present.
- 🟠 **Request mismatch** — client sends a field name/type the server doesn't accept or validates differently (rejected/ignored).
- 🟠 **Status-code / error-shape change** — client error handling keys off a code/shape that changed.
- 🟠 **Enum value drift** — server returns a value the client doesn't handle.
- 🟡 **Auth mismatch** — client doesn't send / server newly requires a permission.
- 🔵 **New optional provider field** unused by clients — informational (or a hint to surface it).

## Each finding records
`severity · operation · what differs · provider side file:line · consumer side file:line · suggested fix (which side, concretely)`. Point the fix at the correct side — don't assume the client is always wrong (the server may have shipped a breaking change).

## Output (`templates/contract-report.md`)
- **Summary:** endpoints compared, matched/unmatched counts, drift counts by severity, verdict (in CI: pass only if no 🔴/🟠).
- **Drift findings** grouped by severity, each with both-side evidence + fix.
- **Coverage gaps:** consumer calls with no matching provider (and vice-versa).
- (Optional) the normalized contract table.

## Modes
- **`diff` / CI:** restrict the comparison to endpoints/fields touched by the current branch diff; **exit non-zero on 🔴/🟠** so it gates a PR. Keep output focused on the regressions the branch introduces.
- **`openapi`:** additionally emit/refresh an OpenAPI (REST) or print the canonical SDL, derived from the provider inventory, so the contract is captured as an artifact.

## Don't
- Don't auto-edit code to "fix" drift unless asked — report with suggestions. When asked, change the side the user designates (usually align the client to the server, or restore a removed field).
- Don't flag fields a client never uses as breakage (only as informational if typed).
