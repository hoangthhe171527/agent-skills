<!-- Output → docs/business-logic/test-plan.md -->

# Test Plan: <Scope>

## Strategy
- **Approach:** characterization — pin current behaviour as a regression safety net.
- **Levels used:** unit (<for what>), integration (<for what>), feature/E2E (<for what>).
- **Framework / runner:** <name> · **Run command:** `<command>` <container variant if any>
- **Test DB / isolation:** <transactional / in-memory / containerized; per-test reset>
- **External seams stubbed:** <HTTP / payment / storage / queue / clock / randomness>

## Test cases
| TC | Rule(s) | Level | Scenario | Data / boundary value | Expected |
|---|---|---|---|---|---|
| TC-001 | BR-001 | unit | <happy path> | <input> | <result> |
| TC-002 | BR-001 | unit | <boundary: max+1> | <input> | <error/code> |
| TC-010 | WF-001 | feature | <DRAFT→ACTIVE> | <state> | <result + side effect> |

## Test data
- **Factories / builders:** <existing + new, location>
- **Boundary datasets:** <parameterized tables>
- **State fixtures:** <entities pre-set to a status>

## Out of test (with reason)
| Rule | Why not tested |
|---|---|
| BR-022 | No code path (❓) |
| BR-030 | Requires third-party sandbox / manual |
