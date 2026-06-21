# Phase 2 — Naming standard

Goal: one canonical, business-meaningful name per concept, consistent across backend/web/app — so the codebase reads coherently and scales without churn.

## The rule: name by the domain, not the actor or the tech
A module/entity is named for the **business thing it manages**, never for:
- a **role / actor**: ❌ `admin`, `manager`, `staff`, `customerModule`, `sellerPanel`
- a **permission / access concept**: ❌ `userRole`, `permission`, `acl`, `authz`
- a **technical layer / pattern**: ❌ `service`, `helper`, `utils`, `manager`, `handlerModule`, `data`
- a **vague catch-all**: ❌ `common`, `misc`, `core2`, `stuff`

✅ Use the domain noun: `booking`, `inventory`, `invoice`, `shipment`, `reservation`, `campaign`, `payment`. (Authorization still exists — it's expressed as **permissions on a module**, e.g. `booking.create` — but the **module itself is the business noun**, not the role.)

## Casing & number, per layer (mirror each repo)
| Concept | Backend (Laravel DDD) | Web (TanStack) | App (Flutter) |
|---|---|---|---|
| Module / feature | `PascalCase` dir (`Booking/`) | `kebab/lower` dir (`booking/`) | `snake/lower` dir (`booking/`) |
| Entity / model | `PascalCase` (`Booking`) | `PascalCase` type (`Booking`) | `PascalCase` (`Booking`) |
| Endpoint collection | plural kebab (`/bookings`) | — | — |
| Files | framework convention | kebab-case `.ts(x)` | snake_case `.dart` |

**One concept → one slug everywhere.** The same business entity uses the same root name in all three repos (`booking` ↔ `Booking` ↔ `bookings`). Pick singular for the entity/model, plural for collections/endpoints.

## Conventions
- **Whole words, no cryptic abbreviations** (`organization`, not `org`; exception: well-established ones already used by the repos).
- **No version/number suffixes** (`bookingV2`) — evolve in place.
- Match terms to the **glossary / ubiquitous language** the business uses (and the repos already use). If unsure of the right noun, ask in Phase 0.
- Enums/status values: `UPPER_SNAKE` on the backend, mapped to UI labels — match the repos' existing pattern.

## Output: the name map
A table the scaffolders use: for each module/entity → its slug + the exact dir/type/endpoint name in each layer. This guarantees consistency before any file is created.

| Concept | Module slug | BE module | BE entity | Endpoint | Web module | Web type | App feature |
|---|---|---|---|---|---|---|---|
| Booking | booking | `Booking` | `Booking` | `/bookings` | `booking` | `Booking` | `booking` |

Proceed to Phase 3 (`references/03-infrastructure.md`).
