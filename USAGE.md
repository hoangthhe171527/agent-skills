# Using the agent-skills — Complete Guide / Hướng dẫn sử dụng đầy đủ

Bilingual guide to every skill in this collection: **what it does · how to use it · when to use it**, plus how to **combine and automate** them.
Hướng dẫn song ngữ cho từng skill: **làm gì · dùng thế nào · khi nào dùng**, và cách **kết hợp + tự động hoá**.

> Install: see the root [README](README.md). Each skill is a folder under `~/.claude/skills/` (symlink/junction from this repo). Invoke by name (`/skill-name`) or just describe the task — the descriptions auto-trigger the right skill.
> Cài đặt: xem [README](README.md). Mỗi skill là một thư mục trong `~/.claude/skills/` (symlink/junction từ repo này). Gọi bằng tên (`/skill-name`) hoặc mô tả việc cần làm — mô tả sẽ tự kích hoạt skill phù hợp.

---

## Quick reference / Tra nhanh

| Skill | One line | Command | When / Khi nào |
|---|---|---|---|
| **feature-forge** | Requirement → full-stack feature (decompose → scaffold → review → test) | `/feature-forge` | Có yêu cầu/feature mới cần dựng từ đầu |
| **codebase-spec-test** | Reverse-engineer business logic → docs + test suite | `/codebase-spec-test` | Codebase lạ/legacy, thiếu tài liệu/test |
| **senior-review** | Senior review a diff/PR, post comments | `/senior-review` | Trước khi push / khi mở PR |
| **pr-prep** | Diff → commit message + PR description, open PR | `/pr-prep` | Trước khi commit / mở PR |
| **api-contract-guard** | Detect FE/BE/APP API contract drift | `/api-contract-guard` | Đổi endpoint/DTO, nối FE↔BE |
| **context-bootstrap** | Generate a high-signal `CLAUDE.md` | `/context-bootstrap` | Repo mới/không có CLAUDE.md |

**Pipelines:** New feature → `feature-forge` (orchestrates the rest). Everyday change → `pr-prep` → CI runs `api-contract-guard` + `senior-review`.
**Pipeline:** Feature mới → `feature-forge` (tự gọi các skill khác). Thay đổi hằng ngày → `pr-prep` → CI chạy `api-contract-guard` + `senior-review`.

---

## 1. `feature-forge`

**EN — What:** An orchestrator that turns a new requirement into a working full-stack feature. It first **decomposes** the business problem (actors, modules, entities, rules, one API contract), then **scaffolds** modules across backend + web + mobile mirroring your repos' stacks, stands up **MongoDB + MinIO** on Docker, generates full **CRUD** with **domain-noun module names** (no roles), and finishes by composing the other skills to **review, test, and standardize**.
**How:**
- `/feature-forge` — decompose the requirement in your message, then build (guided, checkpoints).
- `/feature-forge plan-only` — stop after decomposition + module plan (design review).
- `/feature-forge modules auto` — add modules to existing repos, end-to-end.
- `/feature-forge greenfield ./new-app` — bootstrap a brand-new BE/web/app + infra.
- `/feature-forge backend` — scaffold one layer only.
**When:** A new requirement/spec arrives; bootstrapping a new project; adding a cohesive new module across the stack.
**Output:** `docs/decomposition.md` + per-module plans, scaffolded code, infra, a final report.

**VI — Cái gì:** Orchestrator biến yêu cầu mới thành tính năng full-stack. **Bóc tách** nghiệp vụ (actor, module, entity, rule, một API contract) → **scaffold** module qua BE + web + app theo stack repo → dựng **MongoDB + MinIO** trên Docker → sinh **CRUD** đầy đủ với **tên module theo danh từ nghiệp vụ** (không role) → kết hợp các skill khác để **review, test, chuẩn hoá**.
**Dùng thế nào:** `plan-only` để chỉ bóc tách; `modules auto` để build thẳng vào 3 repo; `greenfield <dir>` để dựng mới; thêm "dùng NestJS/Vue…" để đổi stack.
**Khi nào:** Có requirement mới; khởi tạo dự án mới; thêm module mới xuyên suốt 3 tầng.

---

## 2. `codebase-spec-test`

**EN — What:** Reverse-engineers an existing codebase into **business-logic documentation**, then derives a **traceable test suite** (cases + data) and runs it to green. Evidence-based (every rule cites `file:line`); characterization testing (pins current behaviour).
**How:**
- `/codebase-spec-test` — guided, proposes a scope.
- `/codebase-spec-test auto` — full run: docs + tests + report.
- `/codebase-spec-test auto src/modules/billing` — scoped to one module.
- `/codebase-spec-test docs-only` / `tests-only`.
**When:** Onboarding to an unfamiliar/legacy repo; docs missing or stale; need a regression safety net before refactoring.
**Output:** `docs/business-logic/` (overview, domain model, rules, workflows), traceability matrix, a passing test suite, a final report.

**VI — Cái gì:** Đọc codebase có sẵn → **viết tài liệu business logic** → sinh **test case + data có truy vết** → chạy tới xanh. Dựa bằng chứng (`file:line`); ghim hành vi hiện tại làm lưới an toàn.
**Dùng thế nào:** `auto` chạy trọn; thêm đường dẫn để giới hạn 1 module; `docs-only`/`tests-only` để tách giai đoạn.
**Khi nào:** Tiếp nhận codebase lạ/legacy; thiếu tài liệu/test; cần lưới an toàn trước khi refactor.

---

## 3. `senior-review`

**EN — What:** Reviews a changeset like a senior engineer **before push/merge** — what changed, what's risky — across correctness, design, security, performance, tests, and backward-compatibility. Severity-tagged findings (🔴🟠🟡🔵🟢) with `file:line` + a fix, a verdict, and it can **post the review onto a GitHub PR**.
**How:**
- `/senior-review` — review current branch vs base, print report.
- `/senior-review staged` / `working` — review uncommitted changes.
- `/senior-review pr 123 post` — review PR #123 and post comments.
- `/senior-review develop..HEAD` — an explicit range.
**When:** Before you push; when opening/reviewing a PR; "is this safe to merge?".
**Output:** A structured review (verdict + findings + pre-merge checklist), posted to the PR or saved locally.

**VI — Cái gì:** Review thay đổi như senior **trước khi push/merge** — đổi gì, rủi ro gì — về đúng/sai, thiết kế, bảo mật, hiệu năng, test, tương thích ngược. Nhận xét có mức độ (🔴🟠🟡🔵🟢) + `file:line` + cách sửa, kèm kết luận; **đăng thẳng vào PR GitHub**.
**Dùng thế nào:** không tham số = review nhánh hiện tại; `pr <n> post` = review + comment vào PR; `staged`/`working` = review thay đổi chưa commit.
**Khi nào:** Trước khi push; khi mở/đi review PR; "có an toàn để merge không?".

---

## 4. `pr-prep`

**EN — What:** Turns a diff into a clean **Conventional-Commits message** and a **PR description** (filling your template), then optionally **creates the commit, pushes, and opens the PR** — always confirming before outward actions. Pairs with `senior-review`.
**How:**
- `/pr-prep` — commit message + PR description, then offer to open.
- `/pr-prep message` — message only.
- `/pr-prep pr` / `auto` — also commit/push and open the PR.
**When:** Before committing or opening a PR; to standardize commit/PR quality.
**Output:** A commit message + PR body; optionally a created commit and an opened PR (links returned).

**VI — Cái gì:** Biến diff thành **commit message chuẩn (Conventional Commits)** + **mô tả PR** (điền template repo), rồi tuỳ chọn **tạo commit, push, mở PR** — hỏi xác nhận trước khi ra ngoài. Ghép với `senior-review`.
**Dùng thế nào:** `message` chỉ commit; `pr`/`auto` để tạo commit + mở PR.
**Khi nào:** Trước khi commit/mở PR; để chuẩn hoá chất lượng commit/PR.

---

## 5. `api-contract-guard`

**EN — What:** Detects **drift between an API's server and its clients** — renamed/removed fields, wrong method/path, type mismatches, changed status codes — within one repo or across a separate **frontend + backend + app**. Report with severity + `file:line` on both sides; runs as a **CI gate**.
**How:**
- `/api-contract-guard` — auto-detect in this repo, full report.
- `/api-contract-guard ../api ../web` — cross-repo (provider path + consumer path).
- `/api-contract-guard diff` — only drift from the current branch (CI gate).
- `/api-contract-guard openapi` — also generate/update an OpenAPI doc.
**When:** Changing an endpoint or DTO; wiring FE↔BE; hunting "API said X, client expected Y" bugs.
**Output:** A contract drift report (or "no drift"); optionally an OpenAPI artifact; a CI pass/fail.

**VI — Cái gì:** Phát hiện **lệch hợp đồng API giữa server và client** — đổi/xoá field, sai method/path, sai kiểu, đổi status — trong 1 repo hoặc giữa **FE + BE + app** tách rời. Báo cáo có mức độ + `file:line` 2 phía; chạy được như **cổng CI**.
**Dùng thế nào:** không tham số = tự dò trong repo; truyền 2 đường dẫn = cross-repo; `diff` = cổng CI; `openapi` = sinh tài liệu.
**Khi nào:** Đổi endpoint/DTO; nối FE↔BE; truy bug "API trả X, client mong Y".

---

## 6. `context-bootstrap`

**EN — What:** Generates or refreshes a **high-signal `CLAUDE.md`** (+ optional architecture map & glossary) for any repo — verified commands, real architecture, conventions, gotchas — merged with any existing file. Makes every later task and every other skill smarter.
**How:**
- `/context-bootstrap` — full (CLAUDE.md + architecture + glossary).
- `/context-bootstrap refresh` — update an existing CLAUDE.md.
- `/context-bootstrap claude-md apps/web` — nested file for a monorepo package.
**When:** New/unfamiliar repo; no CLAUDE.md (or it's thin/stale); agent output quality is poor for lack of context.
**Output:** `CLAUDE.md` at the relevant root(s); optional `docs/architecture.md` + glossary.

**VI — Cái gì:** Sinh/cập nhật **`CLAUDE.md` ngắn gọn, đúng bằng chứng** (+ bản đồ kiến trúc & glossary tuỳ chọn) — lệnh đã verify, kiến trúc thật, quy ước, "bẫy" — gộp với file có sẵn. Làm mọi tác vụ sau & skill khác thông minh hơn.
**Dùng thế nào:** `refresh` để cập nhật; truyền đường dẫn package để tạo file lồng nhau (monorepo).
**Khi nào:** Repo mới/lạ; chưa có CLAUDE.md (hoặc sơ sài/cũ); chất lượng agent kém vì thiếu ngữ cảnh.

---

## Combining & automating / Kết hợp & tự động hoá

### A. In Claude Code — one command, a chain / Một lệnh, cả chuỗi
`feature-forge` is the **orchestrator**: it composes `context-bootstrap → scaffold → senior-review → api-contract-guard → codebase-spec-test`. Any skill can also hand off to another by name. Just run one command and the chain follows.
`feature-forge` là **orchestrator**: tự gọi `context-bootstrap → scaffold → senior-review → api-contract-guard → codebase-spec-test`. Skill nào cũng có thể chuyển tiếp sang skill khác. Chạy 1 lệnh là cả chuỗi nối tiếp.

> Note: for the `Skill` tool to *execute* a junctioned skill, restart Claude Code once so it registers. Until then the chain still runs (the model follows each skill's workflow).
> Lưu ý: để `Skill` tool *thực thi* skill junction, khởi động lại Claude Code một lần để đăng ký. Trước đó chuỗi vẫn chạy (model bám theo workflow từng skill).

### B. Fully hands-off — GitHub Actions / Hoàn toàn không cần lệnh — GitHub Actions
Drop [`examples/github/pr-review.yml`](examples/github/pr-review.yml) into a repo's `.github/workflows/` → **every PR** is automatically contract-checked (`api-contract-guard`) and reviewed (`senior-review`), no command typed. Setup once: install the Claude GitHub App + add secret `ANTHROPIC_API_KEY`. See also [`senior-review/examples/github-pr-review.yml`](senior-review/examples/github-pr-review.yml).
Bỏ [`examples/github/pr-review.yml`](examples/github/pr-review.yml) vào `.github/workflows/` của repo → **mỗi PR** tự động kiểm hợp đồng + review, không gõ lệnh. Cài 1 lần: GitHub App Claude + secret `ANTHROPIC_API_KEY`.

### C. Other triggers / Trigger khác
- **Hooks** (`settings.json`): fire a skill on a local event (after edits, on stop) via headless `claude -p "/skill"`.
- **Cron / routines**: run a skill periodically — e.g. nightly `codebase-spec-test` or a contract/security audit.
- **Hooks** (`settings.json`): chạy skill theo sự kiện local (sau khi sửa, khi dừng) qua `claude -p "/skill"`.
- **Cron / routine**: chạy skill định kỳ — ví dụ `codebase-spec-test` hằng đêm hoặc audit hợp đồng/bảo mật.

### Recommended pipelines / Pipeline gợi ý
```
New feature / Feature mới:
  /feature-forge ─▶ decompose ─▶ scaffold (BE·Web·App) ─▶ senior-review ─▶ api-contract-guard ─▶ codebase-spec-test ─▶ CLAUDE.md

Everyday change / Thay đổi hằng ngày:
  edit ─▶ /pr-prep (open PR) ─▶ [CI] api-contract-guard (gate) + senior-review (comment) ─▶ merge
                                └▶ periodically / định kỳ: codebase-spec-test, security/contract audit

New repo / Repo mới:
  /context-bootstrap (CLAUDE.md) ─▶ then everything above works better / mọi thứ trên chạy tốt hơn
```

---

## Tips / Lưu ý
- **Default = mirror your repos.** Skills detect and follow your stack/conventions; override only when you mean to.
- **Outputs land in the target project**, never in this skills repo.
- **Model & cost:** CI uses `claude-sonnet-4-6` by default (cheaper); switch to `claude-opus-4-8` for deeper analysis on critical repos. Each CI run costs API tokens + Actions minutes — tune `--max-turns` / gate behind a label.
- **Naming:** business-domain nouns, never roles/permissions/technical names (`booking`, not `adminPanel`).
- **Mặc định = mirror repo của bạn**; chỉ override khi cố ý. Kết quả ghi vào project đích, không vào repo skill. CI mặc định `claude-sonnet-4-6` (rẻ), đổi `claude-opus-4-8` khi cần sâu. Đặt tên theo danh từ nghiệp vụ, không role/permission/kỹ thuật.
