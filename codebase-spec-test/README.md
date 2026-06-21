# codebase-spec-test

A reusable **Claude Code skill** that reverse-engineers any existing codebase into **business-logic documentation**, then derives a **traceable test suite** (cases + data) that proves that behaviour — and runs it to green.

Stack-agnostic (PHP/Laravel, JS/TS, Python, Go, Java/Kotlin, Ruby/Rails, C#/.NET, …). Works **guided** (sign-off per phase) or **fully autonomous** (`auto`).

> 🇻🇳 Bản tiếng Việt ở [phần dưới](#tiếng-việt).

---

## What it does

Given a target project, the skill runs a 6-phase pipeline:

1. **Orientation** — detect stack, test runner, entrypoints; lock a scope.
2. **Extraction** — harvest the *as-built* business rules with stable IDs and `path:line` evidence.
3. **Documentation** — write a doc set to `docs/business-logic/` (overview, domain model, rules, workflows, interfaces, glossary).
4. **Test design** — derive test cases + a traceability matrix (`rule → test → status`).
5. **Test data** — minimal deterministic fixtures/factories reusing the project's patterns.
6. **Implement, run & report** — write tests in the project's framework, run to green, write a final report.

Key properties: **evidence over assumption** (no invented requirements), **characterization testing** (pins current behaviour as a safety net), and **outputs land in the target project**, never in this skill.

## Install

This is a self-contained skill folder. Pick one:

**A. Personal skill (all your projects)** — recommended
```bash
git clone <your-repo-url> ~/.claude/skills/codebase-spec-test
# or copy/symlink this folder to ~/.claude/skills/codebase-spec-test
```

**B. Project skill (one repo / share with a team)**
```bash
git clone <your-repo-url> <project>/.claude/skills/codebase-spec-test
```

**C. Plugin** — add to a plugin marketplace and `/plugin install`. The folder layout is already plugin-compatible.

After installing, restart/refresh Claude Code; the skill appears as `codebase-spec-test`.

## Usage

In Claude Code, invoke it (the model runs the workflow):

```
/codebase-spec-test                 # guided, model proposes a scope
/codebase-spec-test auto            # fully autonomous → docs + tests + report
/codebase-spec-test auto src/modules/billing   # autonomous, scoped to a module
/codebase-spec-test docs-only       # stop after documentation
/codebase-spec-test tests-only      # assume docs exist, build tests
```

You can also just ask in natural language ("document the business logic of the billing module and write tests for it") — the description triggers the skill.

### Modes

| Mode | Behaviour |
|---|---|
| *(none)* / `guided` | Pauses for your sign-off after each phase (esp. after docs, before tests). Best for high-stakes code. |
| `auto` | Runs all phases autonomously to a final report; stops only on blocking ambiguity or unresolvable test failures. **As hands-off as possible after the command.** |
| `docs-only` | Phases 0–2 only (documentation, no tests). |
| `tests-only` | Phases 3–6 (assumes docs already exist). |

### Output (in the TARGET project)
```
docs/business-logic/
  00-overview.md  01-domain-model.md  02-business-rules.md
  03-workflows.md 04-interfaces.md    05-glossary.md
  test-plan.md    traceability-matrix.md   final-report.md
<project test dir>/  ← new tests + fixtures, in the project's own convention
```

## What you get

- A documented, **evidence-cited** model of how the system actually behaves (every rule links to `path:line`).
- A **traceability matrix** so you can see, at a glance, which rules are covered by tests.
- A **running** regression test suite in the project's existing framework.
- A **final report** with coverage %, suspected bugs (pinned, not silently "fixed"), open questions, and how to run/extend.

## Requirements
- Claude Code (or compatible Agent runtime). The model performs the analysis; the included scripts (`scripts/detect-stack.*`) are optional read-only helpers.
- The target project's test toolchain installed (or permission to scaffold one if none exists).

## Folder structure
```
codebase-spec-test/
  SKILL.md                  # model-facing workflow (entry point)
  README.md                 # this file
  references/               # per-phase deep guidance (progressive disclosure)
  templates/                # doc + matrix + report templates
  scripts/detect-stack.*    # read-only stack/runner detection (sh + ps1)
```

## Push to your own git repo
This folder is already a git repo (initial commit included). To publish:
```bash
cd ~/.claude/skills/codebase-spec-test     # or wherever it lives
git remote add origin <your-repo-url>
git push -u origin main
```
It is intentionally **not** tied to any specific project, so it's safe to share and reuse everywhere.

## Design notes / guardrails
- **Does not modify product code** to make tests pass (unless you explicitly ask it to fix bugs). It documents and pins behaviour.
- **No fake-green tests** (no weakened assertions); untestable rules are marked with a reason in the matrix.
- **Container-aware:** if DB/cache run only inside Docker, it runs tests/seeds via `docker compose exec`.

---

## Tiếng Việt

**codebase-spec-test** là một **skill cho Claude Code**, dùng chung cho **mọi project**: đọc codebase có sẵn → **nghiên cứu & viết tài liệu business logic** → **sinh test case + test data** → **chạy test tới xanh** → **viết báo cáo**. Không phụ thuộc ngôn ngữ/framework.

### Quy trình 6 pha
1. **Định hướng** — dò stack, test runner, entrypoint; chốt phạm vi.
2. **Trích xuất** — bóc tách nghiệp vụ *đúng như code đang chạy*, gán ID ổn định + dẫn chứng `path:line`.
3. **Tài liệu** — ghi bộ doc vào `docs/business-logic/` (tổng quan, mô hình miền, quy tắc, luồng/state machine, giao diện/API, thuật ngữ).
4. **Thiết kế test** — sinh test case + ma trận truy vết (`quy tắc → test → trạng thái`).
5. **Test data** — fixtures/factory tối thiểu, tất định, tái dùng pattern sẵn có của dự án.
6. **Hiện thực + chạy + báo cáo** — viết test theo framework của dự án, chạy tới xanh, xuất báo cáo cuối.

Nguyên tắc cốt lõi: **bằng chứng thay vì phỏng đoán** (không bịa yêu cầu), **characterization testing** (ghim hành vi hiện tại làm lưới an toàn), **kết quả ghi vào project đích** chứ không vào skill.

### Cài đặt
- **Cá nhân (mọi project):** `git clone <repo> ~/.claude/skills/codebase-spec-test`
- **Theo project:** clone vào `<project>/.claude/skills/codebase-spec-test`
- **Plugin:** cấu trúc thư mục đã tương thích plugin.

### Cách dùng (gõ lệnh trong Claude Code)
```
/codebase-spec-test                 # có kiểm soát, AI đề xuất phạm vi
/codebase-spec-test auto            # tự động hoàn toàn → doc + test + báo cáo
/codebase-spec-test auto <đường-dẫn-module>   # tự động, giới hạn 1 module
/codebase-spec-test docs-only       # chỉ tới bước tài liệu
/codebase-spec-test tests-only      # đã có doc, chỉ làm test
```
Hoặc nói tự nhiên: *"viết tài liệu business logic module billing rồi viết test"* — skill tự kích hoạt.

> **`auto` = càng ít can thiệp càng tốt sau khi ra lệnh.** Chỉ dừng khi gặp mơ hồ chặn đường hoặc test fail không tự giải được.

### Bạn nhận được gì
- Mô hình nghiệp vụ **có dẫn chứng** (mỗi quy tắc link tới `path:line`).
- **Ma trận truy vết** để thấy ngay quy tắc nào đã có test.
- Bộ test **chạy được** theo đúng framework của dự án.
- **Báo cáo cuối**: % bao phủ, nghi vấn bug (ghim lại, không tự ý sửa), câu hỏi mở, cách chạy/mở rộng.

### Lưu ý an toàn
- **Không sửa code nghiệp vụ** để test xanh (trừ khi bạn yêu cầu sửa bug) — chỉ tài liệu hoá và ghim hành vi.
- **Không tạo test xanh giả**; quy tắc không test được sẽ ghi rõ lý do trong ma trận.
- **Hiểu Docker:** nếu DB/cache chỉ chạy trong container, test/seed sẽ chạy qua `docker compose exec`.

### Đẩy lên repo riêng của bạn
Thư mục này đã là git repo (đã commit lần đầu). Khi có repo:
```bash
cd ~/.claude/skills/codebase-spec-test
git remote add origin <repo-url-của-bạn>
git push -u origin main
```

## License
MIT — see [LICENSE](LICENSE).
