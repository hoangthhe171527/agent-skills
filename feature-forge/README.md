# feature-forge

A reusable **Claude Code skill** that turns a **new requirement** into a working **full-stack feature**: it decomposes the business problem first, then scaffolds modules across your **backend + web + mobile** repos using their existing tech stack and conventions, stands up **MongoDB + MinIO** on Docker, generates full **CRUD** per module with standardized **domain-noun** names, and finishes by **reviewing, testing, and standardizing** the result — so the codebase is maintainable and scalable from line one.

It's an **orchestrator**: it composes the sibling skills [`senior-review`], [`codebase-spec-test`], [`context-bootstrap`], [`api-contract-guard`].

> 🇻🇳 Bản tiếng Việt ở [dưới](#tiếng-việt).

## Pipeline
1. **Decompose** — requirement → actors, modules (domain nouns), entities + invariants, CRUD + rules, **one API contract**. *(Sign-off here.)*
2. **Stack & conventions** — detect the reference repos and mirror them (default stack = the repos'; overridable).
3. **Naming standard** — one canonical, consistent name per concept across all repos; **no role/permission/technical module names**.
4. **Infrastructure** — MongoDB (replica set) + MinIO (bucket) on Docker, wired to the backend's env.
5. **Scaffold per module** — full CRUD across backend (DDD module), web (TanStack module), app (Flutter feature), all to the same contract; each module built green before the next.
6. **Review · contract · test · standardize** — `senior-review` → `api-contract-guard` (no FE/BE/APP drift) → `codebase-spec-test` (tests for every module, run to green) → `context-bootstrap` (`CLAUDE.md`) → final report.

## Usage
```
/feature-forge                 # decompose the requirement in your message, then build (guided)
/feature-forge modules auto    # add modules to the existing repos, end-to-end
/feature-forge plan-only       # stop after decomposition + module plan (design review)
/feature-forge greenfield ./new-app   # bootstrap new BE/web/app + infra from the conventions
/feature-forge backend         # scaffold just one layer
```
Or describe it: *"bóc tách nghiệp vụ yêu cầu này rồi build full-stack theo cấu trúc 3 repo"*. The requirement text/issue is the input.

## Principles
- **Decompose before build** (don't build the wrong thing cleanly).
- **Mirror the reference repos** (same stack & structure; new code looks native).
- **One contract, three layers** (no FE/BE/APP drift).
- **Domain-noun names, no roles** (`booking`, not `adminPanel`/`userRole`).
- **Incremental & green** (one module fully wired + green at a time; reuse shared infra; never half-wire many modules).

## Install
```bash
ln -s "$PWD/feature-forge" ~/.claude/skills/feature-forge            # macOS/Linux
cmd /c mklink /J "%USERPROFILE%\.claude\skills\feature-forge" "%CD%\feature-forge"  # Windows
```
Pairs best when its sibling skills are installed too (this repo).

## Structure
```
feature-forge/
  SKILL.md
  references/
    00-decomposition.md           # requirement → modules/entities/rules/contract
    01-stack-and-conventions.md   # detect & mirror the reference repos
    02-naming-standard.md         # domain-noun names, casing per layer, no roles
    03-infrastructure.md          # MongoDB + MinIO on Docker
    04-scaffold-backend.md        # Laravel DDD module CRUD
    05-scaffold-frontend.md       # TanStack/React module CRUD
    06-scaffold-app.md            # Flutter feature CRUD
    07-review-test-standardize.md # compose sibling skills + final report
  templates/decomposition.md  templates/module-plan.md  templates/docker-compose.yml
  scripts/detect-conventions.sh   # survey workspace repos' stacks & module layout
```

---

## Tiếng Việt

**feature-forge** — skill biến **một requirement mới** thành **tính năng full-stack chạy được**: **bóc tách nghiệp vụ trước**, rồi scaffold module trên cả **backend + web + mobile** theo đúng tech stack & cấu trúc của 3 repo sẵn có, dựng **MongoDB + MinIO trên Docker**, sinh **CRUD đầy đủ** cho từng module với **tên chuẩn theo danh từ nghiệp vụ** (không chứa role/permission/tên kỹ thuật), rồi **auto review + viết test + chạy test + chuẩn hóa** — để code base dễ maintain & scale từ đầu.

Là **orchestrator**: kết hợp các skill anh em `senior-review`, `codebase-spec-test`, `context-bootstrap`, `api-contract-guard`.

### Quy trình
1. **Bóc tách** — requirement → actor, module (danh từ nghiệp vụ), entity + ràng buộc, CRUD + rule, **một API contract**. *(Chốt ở đây.)*
2. **Stack & convention** — dò 3 repo và mirror (mặc định = stack repo; có thể tùy biến).
3. **Chuẩn đặt tên** — một tên nhất quán cho mỗi khái niệm trên cả 3 repo; **không đặt tên theo role/permission/kỹ thuật**.
4. **Hạ tầng** — MongoDB (replica set) + MinIO (bucket) trên Docker, khớp env backend.
5. **Scaffold từng module** — CRUD đầy đủ qua backend (DDD), web (TanStack), app (Flutter), cùng 1 contract; mỗi module xanh rồi mới sang module kế.
6. **Review · contract · test · chuẩn hóa** — `senior-review` → `api-contract-guard` (không lệch FE/BE/APP) → `codebase-spec-test` (test mọi module, chạy xanh) → `context-bootstrap` (`CLAUDE.md`) → báo cáo cuối.

### Dùng
```
/feature-forge                # bóc tách requirement trong tin nhắn rồi build (có kiểm soát)
/feature-forge modules auto   # thêm module vào 3 repo, chạy end-to-end
/feature-forge plan-only      # dừng sau bóc tách + kế hoạch module (review thiết kế)
/feature-forge greenfield ./new-app   # dựng mới BE/web/app + hạ tầng theo convention
```
Hoặc nói: *"bóc tách nghiệp vụ yêu cầu này rồi build full-stack theo cấu trúc 3 repo"*.

### Nguyên tắc
- **Bóc tách trước khi build** · **mirror 3 repo** (stack & cấu trúc) · **một contract cho 3 tầng** (không lệch) · **tên theo danh từ nghiệp vụ, không role** · **làm tới đâu xanh tới đó** (1 module wired đầy đủ + xanh rồi mới sang cái khác; tái dùng hạ tầng chung; không wire dở dang nhiều module → tránh vỡ code base).

## License
MIT — see repository `LICENSE`.
