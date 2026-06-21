# agent-skills

Reusable **Claude Code / Agent skills** — stack-agnostic, project-agnostic, usable across every repository. This page is the full guide: **what each skill does · how to use it · when to use it**, plus how to **combine & automate** them. Bilingual **EN / VI**.

Bộ **skill cho Claude Code** dùng lại được cho **mọi project**. Trang này là hướng dẫn đầy đủ: **mỗi skill làm gì · dùng thế nào · khi nào dùng**, và cách **kết hợp & tự động hoá**. Song ngữ **Anh / Việt**.

> Each top-level folder is one self-contained skill (`SKILL.md` + `references/` + `templates/` + `scripts/`). Mỗi thư mục cấp 1 là một skill độc lập.

---

## Skills at a glance / Tổng quan

| Skill | One line | Command | When / Khi nào |
|---|---|---|---|
| [`feature-forge`](feature-forge/) | Requirement → full-stack feature (decompose → scaffold → review → test) | `/feature-forge` | New requirement / feature mới |
| [`codebase-spec-test`](codebase-spec-test/) | Reverse-engineer business logic → docs + test suite | `/codebase-spec-test` | Unfamiliar/legacy repo, no docs/tests |
| [`senior-review`](senior-review/) | Senior review a diff/PR, post comments | `/senior-review` | Before push / on a PR |
| [`pr-prep`](pr-prep/) | Diff → commit message + PR description, open PR | `/pr-prep` | Before commit / opening a PR |
| [`api-contract-guard`](api-contract-guard/) | Detect FE/BE/APP API contract drift | `/api-contract-guard` | Changing an endpoint/DTO, wiring FE↔BE |
| [`context-bootstrap`](context-bootstrap/) | Generate a high-signal `CLAUDE.md` | `/context-bootstrap` | New repo / no CLAUDE.md |

---

## Install / Cài đặt

These are **personal skills**: Claude Code discovers them under `~/.claude/skills/<skill>` (a folder with a `SKILL.md`). Pick one:
Đây là **personal skill**: Claude Code nhận diện ở `~/.claude/skills/<skill>`. Chọn một cách:

**A. Symlink / junction (recommended — single source of truth / khuyến nghị — một nguồn)**
```bash
git clone https://github.com/hoangthhe171527/agent-skills.git ~/code/agent-skills
# macOS / Linux — link every skill:
for s in feature-forge codebase-spec-test senior-review pr-prep api-contract-guard context-bootstrap; do
  ln -s ~/code/agent-skills/$s ~/.claude/skills/$s
done
```
```powershell
# Windows (directory junction — no admin needed / không cần admin)
foreach ($s in 'feature-forge','codebase-spec-test','senior-review','pr-prep','api-contract-guard','context-bootstrap') {
  cmd /c mklink /J "$env:USERPROFILE\.claude\skills\$s" "$env:USERPROFILE\code\agent-skills\$s"
}
```
**B. Copy** the folder(s) into `~/.claude/skills/` (simple; you maintain copies / bạn tự đồng bộ).
**C. Per-project / team:** put a skill under `<project>/.claude/skills/<skill>` to share with that repo's collaborators.

**Invoke / Gọi skill:** type `/<skill-name>` in Claude Code, or just describe the task — the descriptions auto-trigger the right skill. After installing, refresh Claude Code.
Gõ `/<tên-skill>` hoặc mô tả việc cần làm — mô tả sẽ tự kích hoạt skill. Cài xong nhớ refresh Claude Code.

---

## Skills in detail / Chi tiết từng skill

### 🏗️ `feature-forge`
**EN — What:** Orchestrator that turns a new requirement into a working full-stack feature. **Decomposes** the problem (actors, modules, entities, rules, one API contract), **scaffolds** modules across backend + web + mobile mirroring your repos' stacks, stands up **MongoDB + MinIO** on Docker, generates full **CRUD** with **domain-noun module names** (no roles), then composes the other skills to **review, test, standardize**.
**How:** `/feature-forge` (guided) · `/feature-forge plan-only` (just decomposition + plan) · `/feature-forge modules auto` (build into existing repos) · `/feature-forge greenfield ./new-app` (new project + infra) · `/feature-forge backend` (one layer). Add "use NestJS/Vue…" in the prompt to override the stack.
**When:** A new requirement/spec arrives; bootstrapping a project; adding a cohesive new module across the stack.

**VI — Cái gì:** Orchestrator biến yêu cầu mới thành tính năng full-stack. **Bóc tách** (actor, module, entity, rule, một API contract) → **scaffold** qua BE + web + app theo stack repo → dựng **MongoDB + MinIO** trên Docker → sinh **CRUD** đầy đủ, **tên module theo danh từ nghiệp vụ** (không role) → gọi các skill khác để **review, test, chuẩn hoá**.
**Dùng:** `plan-only` chỉ bóc tách; `modules auto` build thẳng 3 repo; `greenfield <dir>` dựng mới; thêm "dùng NestJS/Vue…" để đổi stack.
**Khi nào:** Có requirement mới; khởi tạo dự án; thêm module mới xuyên 3 tầng.

### 🧪 `codebase-spec-test`
**EN — What:** Reverse-engineers an existing codebase into **business-logic documentation**, then derives a **traceable test suite** (cases + data) and runs it to green. Evidence-based (`file:line`), characterization testing (pins current behaviour).
**How:** `/codebase-spec-test` (guided) · `/codebase-spec-test auto` (docs + tests + report) · `… auto src/modules/billing` (scoped) · `/codebase-spec-test docs-only` | `tests-only`.
**When:** Onboarding to an unfamiliar/legacy repo; docs missing/stale; need a regression net before refactoring.

**VI — Cái gì:** Đọc codebase có sẵn → **viết tài liệu business logic** → sinh **test case + data có truy vết** → chạy tới xanh. Dựa bằng chứng (`file:line`), ghim hành vi hiện tại.
**Dùng:** `auto` chạy trọn; thêm đường dẫn để giới hạn module; `docs-only`/`tests-only`.
**Khi nào:** Tiếp nhận codebase lạ/legacy; thiếu tài liệu/test; cần lưới an toàn trước khi refactor.

### 👀 `senior-review`
**EN — What:** Reviews a changeset like a senior engineer **before push/merge** — across correctness, design, security, performance, tests, backward-compat. Severity-tagged findings (🔴🟠🟡🔵🟢) with `file:line` + fix, a verdict, and it can **post the review onto a GitHub PR**.
**How:** `/senior-review` (branch vs base) · `/senior-review staged` | `working` · `/senior-review pr 123 post` (review PR #123 + comment) · `/senior-review develop..HEAD`.
**When:** Before you push; opening/reviewing a PR; "is this safe to merge?".

**VI — Cái gì:** Review thay đổi như senior **trước khi push/merge** — đúng/sai, thiết kế, bảo mật, hiệu năng, test, tương thích ngược. Nhận xét có mức độ (🔴🟠🟡🔵🟢) + `file:line` + cách sửa, kèm kết luận; **đăng thẳng lên PR**.
**Dùng:** không tham số = review nhánh hiện tại; `pr <n> post` = review + comment vào PR; `staged`/`working` = thay đổi chưa commit.
**Khi nào:** Trước khi push; khi mở/đi review PR; "có an toàn để merge không?".

### 📝 `pr-prep`
**EN — What:** Turns a diff into a clean **Conventional-Commits message** + a **PR description** (filling your template), then optionally **commits, pushes, opens the PR** — confirming before outward actions. Pairs with `senior-review`.
**How:** `/pr-prep` (message + PR body, then offer to open) · `/pr-prep message` · `/pr-prep pr` | `auto` (commit + open).
**When:** Before committing or opening a PR; to standardize commit/PR quality.

**VI — Cái gì:** Biến diff thành **commit message chuẩn (Conventional Commits)** + **mô tả PR** (điền template), rồi tuỳ chọn **commit, push, mở PR** — hỏi trước khi ra ngoài. Ghép với `senior-review`.
**Dùng:** `message` chỉ commit; `pr`/`auto` để tạo commit + mở PR.
**Khi nào:** Trước khi commit/mở PR; chuẩn hoá chất lượng commit/PR.

### 🔌 `api-contract-guard`
**EN — What:** Detects **drift between an API's server and its clients** — renamed/removed fields, wrong method/path, type mismatches, changed status codes — in one repo or across a separate **FE + BE + app**. Report with severity + `file:line` on both sides; runs as a **CI gate**.
**How:** `/api-contract-guard` (auto-detect) · `/api-contract-guard ../api ../web` (cross-repo) · `/api-contract-guard diff` (CI gate) · `/api-contract-guard openapi` (emit OpenAPI).
**When:** Changing an endpoint/DTO; wiring FE↔BE; hunting "API said X, client expected Y" bugs.

**VI — Cái gì:** Phát hiện **lệch hợp đồng API giữa server và client** — đổi/xoá field, sai method/path, sai kiểu, đổi status — trong 1 repo hoặc giữa **FE + BE + app**. Báo cáo có mức độ + `file:line` 2 phía; chạy được như **cổng CI**.
**Dùng:** không tham số = tự dò; 2 đường dẫn = cross-repo; `diff` = cổng CI; `openapi` = sinh tài liệu.
**Khi nào:** Đổi endpoint/DTO; nối FE↔BE; truy bug "API trả X, client mong Y".

### 📘 `context-bootstrap`
**EN — What:** Generates/refreshes a **high-signal `CLAUDE.md`** (+ optional architecture map & glossary) — verified commands, real architecture, conventions, gotchas — merged with any existing file. Makes every later task and every other skill smarter.
**How:** `/context-bootstrap` (full) · `/context-bootstrap refresh` (update existing) · `/context-bootstrap claude-md apps/web` (nested for a monorepo package).
**When:** New/unfamiliar repo; no `CLAUDE.md` (or thin/stale); agent output poor for lack of context.

**VI — Cái gì:** Sinh/cập nhật **`CLAUDE.md` ngắn gọn, đúng bằng chứng** (+ bản đồ kiến trúc & glossary) — lệnh đã verify, kiến trúc thật, quy ước, "bẫy" — gộp với file có sẵn. Làm mọi tác vụ sau & skill khác thông minh hơn.
**Dùng:** `refresh` để cập nhật; truyền đường dẫn package để tạo file lồng nhau.
**Khi nào:** Repo mới/lạ; chưa có `CLAUDE.md` (hoặc sơ sài/cũ); agent kém vì thiếu ngữ cảnh.

---

## Combine & automate / Kết hợp & tự động hoá

**A. In Claude Code — one command, a chain / Một lệnh, cả chuỗi.** `feature-forge` orchestrates `context-bootstrap → scaffold → senior-review → api-contract-guard → codebase-spec-test`. Any skill can hand off to another. `feature-forge` tự gọi các skill còn lại; skill nào cũng chuyển tiếp được.

**B. Hands-off via GitHub Actions / Không cần lệnh — GitHub Actions.** Drop [`examples/github/pr-review.yml`](examples/github/pr-review.yml) into a repo's `.github/workflows/` → **every PR** is auto contract-checked (`api-contract-guard`) + reviewed (`senior-review`). Setup once: install the Claude GitHub App + add secret `ANTHROPIC_API_KEY`. Bỏ file đó vào `.github/workflows/` → mỗi PR tự kiểm hợp đồng + review.

**C. Other triggers / Trigger khác.** Hooks in `settings.json` (run a skill on a local event via `claude -p "/skill"`); cron/routines (periodic `codebase-spec-test` or a security/contract audit). Hooks chạy skill theo sự kiện local; cron chạy định kỳ.

**Recommended pipelines / Pipeline gợi ý**
```
New feature / Feature mới:
  /feature-forge ─▶ decompose ─▶ scaffold (BE·Web·App) ─▶ senior-review ─▶ api-contract-guard ─▶ codebase-spec-test ─▶ CLAUDE.md

Everyday change / Thay đổi hằng ngày:
  edit ─▶ /pr-prep (open PR) ─▶ [CI] api-contract-guard (gate) + senior-review (comment) ─▶ merge

New repo / Repo mới:
  /context-bootstrap (CLAUDE.md) ─▶ everything above works better / mọi thứ trên chạy tốt hơn
```

---

## Conventions & tips / Quy ước & lưu ý
- **Outputs land in the target project**, never in this skills repo. Kết quả ghi vào project đích, không vào repo này.
- **Default = mirror your repos** (stack & conventions); override only when you mean to. Mặc định mirror repo của bạn; chỉ override khi cố ý.
- **Naming:** domain-noun, never roles/permissions/technical names (`booking`, not `adminPanel`). Đặt tên theo danh từ nghiệp vụ, không role/permission/kỹ thuật.
- **CI model & cost:** defaults to `claude-sonnet-4-6` (cheaper); use `claude-opus-4-8` for deeper analysis. Each CI run costs API tokens + Actions minutes — tune `--max-turns` / gate behind a label. CI mặc định `sonnet-4-6`, đổi `opus-4-8` khi cần sâu; lưu ý chi phí.
- **Skill `Skill`-tool execution** needs a Claude Code restart after install to register; until then skills still run (the model follows each workflow). Để `Skill` tool *thực thi* skill mới cần khởi động lại Claude Code.
- Authoring a skill: one folder, `SKILL.md` with `name` (= folder) + `description` frontmatter; keep it lean, push depth into `references/`.

## License
MIT — see [LICENSE](LICENSE).
