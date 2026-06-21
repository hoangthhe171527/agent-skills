<!-- Output → docs/business-logic/02-business-rules.md. The heart of the docs. One block per rule. -->

# Business Rules: <Scope>

> Every rule has a stable ID, a single-sentence statement, and code evidence. IDs are referenced by the [traceability matrix](traceability-matrix.md) and the tests. Do not renumber.

## Index
| ID | Title | Type | Confidence |
|---|---|---|---|
| BR-001 | <title> | rule | high |
| INV-007 | <title> | invariant | high |
| BR-022 | <title> | rule | ❓ |

---

### BR-001 — <Title>
- **Statement:** <one sentence describing the as-built behaviour.>
- **Trigger:** <entrypoint / job / transition that exercises it>
- **Inputs:** <fields/params that matter>
- **Outcome:** <result + side effects; error/code on violation>
- **Edge cases:** <boundary, null, duplicate, already-X…>
- **Evidence:** `<path:line>`<, …>
- **Confidence:** high | medium | ❓assumption
- **Tests:** TC-xxx<, …> (filled in Phase 3)
- **Open questions:** <if any>

<!-- repeat per rule. Group related rules with ## sub-headings (Validation, Pricing, Authorization, Lifecycle, Side effects, Integrations, Errors). -->

## Suspected issues (as-built ≠ expected)
- <Rule ID> — <what looks wrong and why> — pinned by TC-xxx
