<!-- Output → docs/business-logic/04-interfaces.md. Entrypoints that trigger business logic. -->

# Interfaces & Entrypoints: <Scope>

> HTTP routes, CLI commands, queue jobs, scheduled tasks, event listeners, public SDK methods. Each links to the rules it enforces.

## HTTP API
| Method/Path | Auth / permission | Inputs (key fields + validation) | Success | Errors (code → cause) | Rules | Evidence |
|---|---|---|---|---|---|---|
| `POST /…` | <perm> | <field: rule> | 201 <shape> | 422 <validation>, 403 <authz> | BR-xxx | `<controller:line>` |

## CLI commands
| Command | Args / options | Effect | Idempotent? | Rules | Evidence |
|---|---|---|---|---|---|
| `<cmd>` | `--x` | <…> | yes/no | BR-xxx | `<path:line>` |

## Jobs / scheduled / events
| Trigger | When | Effect & side effects | Rules | Evidence |
|---|---|---|---|---|
| <job/cron/event> | <schedule/condition> | <…> | WF-xxx | `<path:line>` |

## Notes
- <Auth model, tenancy scoping, rate limits, common error envelope, etc.>
