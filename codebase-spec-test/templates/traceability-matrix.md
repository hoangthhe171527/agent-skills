<!-- Output → docs/business-logic/traceability-matrix.md. Keep updated through Phase 5. -->

# Traceability Matrix: <Scope>

> Every business rule/invariant/workflow maps to ≥1 test case, or states why not. This is the coverage source of truth.

| Rule | Title | Test case(s) | Level | Status |
|---|---|---|---|---|
| BR-001 | <title> | TC-001, TC-002 | unit | ✅ passing |
| INV-007 | <title> | TC-040 | integration | ✅ passing |
| WF-001 | <title> | TC-010..014 | feature | 🟡 planned |
| BR-022 | <title> | — | — | ⛔ not tested — no code path (❓) |

**Legend:** ✅ passing · 🟡 planned/in-progress · 🔴 failing (pinned suspected bug — see report) · ⛔ not tested (reason required)

## Flow coverage (workflows)
> A `WF-###` is only covered when a **flow/scenario test chains its steps** end-to-end — not when its component `BR`s are merely unit-tested.

| Workflow | Flow test(s) | Steps chained | Status |
|---|---|---|---|
| WF-001 | <flow test id/name> | <step1 → step2 → …> | ✅ passing |

## Coverage summary
- Rules total: **<n>** · with ≥1 passing test: **<n>** (**<%>**) · planned: **<n>** · not tested: **<n>**
- Workflows total: **<n>** · with ≥1 flow/scenario test: **<n>** (**<%>**)
