# context-bootstrap

A reusable **Claude Code skill** that generates or refreshes a high-signal **`CLAUDE.md`** (+ optional architecture map & glossary) for any repo — so AI agents and humans onboard faster and make fewer mistakes. Derived from the actual code, merged with anything that already exists.

> 🇻🇳 Bản tiếng Việt ở [dưới](#tiếng-việt).

## Why
`CLAUDE.md` is loaded into the model's context **every session**. A good one — exact build/run/test commands, real architecture boundaries, conventions, and the non-obvious gotchas — makes every later task (and every other skill, and your CI review bot) noticeably better. A bad/missing one makes the agent guess.

## What it produces
- **`CLAUDE.md`** at the repo root (and nested ones in monorepo packages where setup differs) — concise (~30–120 lines), verified, high-signal.
- Optional **`docs/architecture.md`** (deeper) and **`docs/glossary.md`**, linked from `CLAUDE.md`.

It **merges** with an existing `CLAUDE.md`/`AGENTS.md`/`.cursorrules` instead of overwriting.

## Usage
```
/context-bootstrap                 # full: CLAUDE.md + architecture map + glossary
/context-bootstrap refresh         # update an existing CLAUDE.md
/context-bootstrap claude-md       # just the CLAUDE.md
/context-bootstrap auto            # run end-to-end
/context-bootstrap claude-md apps/web   # nested CLAUDE.md for a monorepo package
```
Or ask: *"set up a CLAUDE.md for this repo"*, *"bootstrap agent context"*.

## Principles
- **Concise > complete** — it's in every prompt; signal per token matters.
- **Evidence-based** — commands are verified (CI/package scripts are the source of truth); no invented facts.
- **Merge, never clobber** — preserves human-written guidance.
- **Capture what bites** — the gotchas that waste an hour (container-only DB, codegen steps, "run X before Y").

## Install
```bash
ln -s "$PWD/context-bootstrap" ~/.claude/skills/context-bootstrap            # macOS/Linux
cmd /c mklink /J "%USERPROFILE%\.claude\skills\context-bootstrap" "%CD%\context-bootstrap"  # Windows
```
(See the repo root `README.md` for symlink/junction/plugin options.)

## Structure
```
context-bootstrap/
  SKILL.md
  references/
    00-what-goes-in-claude-md.md   # include/exclude, size discipline, nesting & precedence
    01-extraction.md               # survey the repo, verify commands, harvest conventions/gotchas
    02-writing-and-merging.md      # write/merge, monorepo nesting, self-check
  templates/claude-md.md
  scripts/repo-survey.sh           # read-only survey to seed the file
```

---

## Tiếng Việt

**context-bootstrap** — skill sinh/cập nhật **`CLAUDE.md`** (+ bản đồ kiến trúc & glossary tuỳ chọn) cho **mọi repo**, để agent AI và người mới vào việc nhanh hơn, ít sai hơn. Nội dung **rút từ code thật**, **gộp** với file đã có (không ghi đè).

**Vì sao:** `CLAUDE.md` được nạp vào ngữ cảnh **mỗi phiên** — lệnh build/run/test chính xác, ranh giới kiến trúc thật, quy ước, và các "bẫy" khó đoán giúp mọi tác vụ sau (và các skill khác, và bot review CI) tốt lên rõ rệt.

**Tạo ra:** `CLAUDE.md` ngắn gọn (~30–120 dòng) ở gốc (và file lồng nhau cho từng package monorepo nếu khác setup); tuỳ chọn `docs/architecture.md` + `docs/glossary.md`.

**Dùng:**
```
/context-bootstrap            # đầy đủ
/context-bootstrap refresh    # cập nhật CLAUDE.md hiện có
/context-bootstrap auto       # chạy thẳng
```
Hoặc nói: *"tạo CLAUDE.md cho repo này"*.

**Nguyên tắc:** ngắn gọn > đầy đủ · dựa bằng chứng (lệnh phải verify) · gộp chứ không ghi đè · ưu tiên ghi lại "bẫy" (DB chỉ trong Docker, bước codegen, "chạy X trước Y").

## License
MIT — see repository `LICENSE`.
