<!-- Output → docs/business-logic/flow-test-spec.md. One spec per documented workflow (WF-###): a detailed, executable scenario that chains the steps end-to-end. Pairs with test-plan.md (per-rule unit cases) and the traceability matrix. -->

# Flow Test Spec: <Scope>

> A **flow/scenario test** proves the parts *compose*: it runs a workflow's steps in sequence, feeding each step's output into the next input, and asserts the end-to-end result. **One spec per `WF-###`.** Per-rule unit cases live in [test-plan.md](test-plan.md); these specs cover the workflows those rules participate in. The unique value here is catching when one step emits a shape/value the next step can't consume — a gap unit tests never see.

## Index
| Flow | Workflow | Level | Status |
|---|---|---|---|
| FLOW-001 | WF-001 — <name> | unit-flow / integration / E2E | 🟡 planned |
| FLOW-002 | WF-002 — <name> | … | 🟡 planned |

**Level legend:** *unit-flow* = chained pure functions · *integration* = hook/repository/API seam · *E2E* = UI ↔ API ↔ DB (real stack — see `references/05-execution-and-reporting.md`).

---

### FLOW-001 — <Workflow name>  ·  pins WF-001
- **Goal:** <the user/business journey this proves end-to-end.>
- **Composes rules:** BR-xxx, BR-yyy, INV-zzz (the units chained here).
- **Level:** unit-flow | integration | E2E.
- **Preconditions / initial state:** <entities, statuses, auth/role, seeded data — link factories>.
- **Clock / determinism:** <injected `now`/`today`, frozen timestamps, fixed seeds>.

**Happy path — steps run in sequence**
| # | Action / call | Input (incl. output carried from prior step) | Expected result / state after | Evidence |
|---|---|---|---|---|
| 1 | <function / request> | <args> | <intermediate assertion> | `<path:line>` |
| 2 | <next step, fed by step 1's output> | <prev output → here> | <…> | `<path:line>` |
| 3 | <…> | <…> | <…> | `<path:line>` |
| ✔ | **End-state assertions** | — | <invariants that must hold after the *whole* flow — e.g. `paid == sum(milestones)`, `status == COMPLETED`, no orphan records> | <BR/INV ids> |

**Negative / alternate flows**
| Variant | Diverges at step | Trigger | Expected outcome (specific error/rejection; sequence halts) | Evidence |
|---|---|---|---|---|
| <name> | step N | <bad input / disallowed transition / double-submit> | <exact error/code; state unchanged> | `<path:line>` |

- **Test data:** <factories/fixtures + the exact boundary values this flow needs>.
- **External seams:** <stubbed vs hit-real — HTTP / payment / storage / clock / randomness>.
- **Run notes:** <command; for E2E: stack bring-up → seed → run → teardown, per `references/05-...`>.
- **Maps to test:** <file::name of the implemented flow test> (filled in Phase 5).
- **Open questions:** <if any>.

<!-- repeat per workflow. Every WF-### in 03-workflows.md must have a FLOW spec, or an explicit "no flow test — reason" row in the Index. -->

## Coverage
- Workflows total: **<n>** · with a flow spec: **<n>** (**<%>**) · without (reason): **<n>**.
