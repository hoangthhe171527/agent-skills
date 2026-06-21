<!-- Output → docs/business-logic/final-report.md -->

# codebase-spec-test — Final Report: <Scope>

> Run date: <date> · Commit: <sha> · Mode: <guided|auto>

## 1. Scope
- Covered: <…> · Excluded: <…>

## 2. Documentation produced
- [Overview](00-overview.md) · [Domain model](01-domain-model.md) · [Business rules](02-business-rules.md) · [Workflows](03-workflows.md) · [Interfaces](04-interfaces.md) · [Glossary](05-glossary.md)
- Counts: **<n>** business rules · **<n>** invariants · **<n>** workflows.

## 3. Test coverage of rules
- From [traceability matrix](traceability-matrix.md): **<n>/<N>** rules have ≥1 passing test (**<%>**).
- Not tested (with reasons): <list / link>.

## 4. Test results
- Suite: **<n>** tests across <levels>. Result: **<pass>/<total>** · runtime **<t>**.
- Run command: `<command>` <container variant>
- Environment notes: <test DB, stubs, container exec>

## 5. Suspected issues (as-built ≠ expected)
| Rule | Observation | Pinned by | Severity (guess) |
|---|---|---|---|
| BR-xxx | <discrepancy/quirk> | TC-xxx | low/med/high |

## 6. Open questions (❓ need owner input)
- <ID> — <question>

## 7. How to run & extend
1. <install/setup>
2. `<run command>`  ·  filter a single test: `<example>`
3. Add a case: copy <example test file>, add to the matrix, follow `02-business-rules.md` IDs.

## 8. Recommended next steps
- <Highest-value rules/areas still undocumented or untested beyond this scope.>
