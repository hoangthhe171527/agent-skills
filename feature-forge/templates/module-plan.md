<!-- One per module. Drives backend/web/app scaffolding for that module. -->

# Module plan — `<module>`

**Purpose:** <1 line.> · **Targets:** BE · Web · App

## Entities
### <Entity>  (collection `<entities>`)
| Field | Type | Required | Constraints / default |
|---|---|---|---|
| id | string | yes | PK |
| <field> | <type> | <y/n> | <unique / enum / range / default> |

**Invariants:** <INV-…>
**Status/lifecycle:** <values + allowed transitions, if any>
**Relationships:** <belongs-to / has-many + owning side>

## Operations & rules
| Op | Method · Path | Request | Response | Rules / guards |
|---|---|---|---|---|
| list | GET `/<entities>` | filters, page | `{data[], pagination}` | scope by tenant/owner |
| show | GET `/<entities>/{id}` | — | `<Entity>` | 404 if missing |
| create | POST `/<entities>` | `{…}` | `<Entity>` | validate invariants; unique |
| update | PUT `/<entities>/{id}` | `{…}` | `<Entity>` | validate; partial allowed |
| delete | DELETE `/<entities>/{id}` | — | `{success}` | block if has children |
| <action> | PATCH `/<entities>/{id}/<action>` | — | `<Entity>` | <transition guard> |

## Name map (per layer)
| BE module | BE entity | Endpoint | Web module | Web type | App feature |
|---|---|---|---|---|---|
| `<Pascal>` | `<Pascal>` | `/<entities>` | `<slug>` | `<Pascal>` | `<slug>` |

## Permissions
`<module>.read` · `<module>.create` · `<module>.update` · `<module>.delete` <(+ action perms)>
