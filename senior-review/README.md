# senior-review

A reusable **Claude Code skill** that reviews a changeset like a **senior engineer before push/merge**: it works out *what changed and how it differs from before*, judges correctness/design/security/perf/tests/compat, and leaves **severity-tagged, actionable** feedback with a clear verdict — then can **post the review onto the GitHub PR**.

Repo- and stack-agnostic. Reviews a branch diff, staged/working changes, an arbitrary git range, or a remote PR.

> 🇻🇳 Bản tiếng Việt ở [phần dưới](#tiếng-việt).

## What it does
1. **Scope the change** — detect the base branch, compute the diff + stats, read commit messages/PR description for intent.
2. **Build context** — read the surrounding code, callers, tests, and schema so the review judges *fit*, not just the hunk.
3. **Review the rubric** — correctness, design/architecture, readability, security, performance, error handling, tests, API/backward-compat, data/migrations, observability, consistency/scope.
4. **Verdict** — `approve` / `approve-with-nits` / `request-changes`, severity counts, top risks, pre-merge checklist.
5. **Deliver** — post inline comments + a summary review to the PR (via `gh` or the API), or output a paste-ready review / save it locally.

Findings are tagged 🔴 blocker · 🟠 major · 🟡 minor · 🔵 nit · 🟢 praise — each with `file:line`, *why it matters*, and a concrete fix.

## Usage
```
/senior-review                  # review current branch vs its base, print report
/senior-review staged           # review only staged changes (pre-commit gate)
/senior-review working          # review all uncommitted changes
/senior-review pr 123           # review GitHub PR #123
/senior-review pr 123 post      # review PR #123 and post the comments
/senior-review develop..HEAD    # review an explicit range
/senior-review post             # review current branch and post to its PR
```
Or just ask: *"review my changes before I push"*, *"senior review of PR 88 and comment on it"*.

### Modes
- **default** — produce the report; if a PR exists, offer to post.
- **`post` / `auto`** — publish to the PR (inline comments + summary). `auto` runs end-to-end non-interactively.

### Posting to a PR
- Uses **`gh`** if installed (`gh pr review`, `gh api …/pulls/{n}/reviews` for batched inline comments).
- Falls back to the **GitHub REST API** with a token from your git credential manager.
- Falls back to **paste-ready Markdown** if neither is available, plus the PR/compare URL.

> Reviewing ≠ fixing. This skill suggests changes and comments; it does **not** edit the author's code or push unless you explicitly ask.

## Automatic review on GitHub (no command)

Run the review **automatically on every PR** via GitHub Actions + the official [`anthropics/claude-code-action@v1`](https://github.com/anthropics/claude-code-action) — no one types anything.

**One-time setup**
1. Install the Claude GitHub App: <https://github.com/apps/claude> (or run `/install-github-app` inside Claude Code, which wires the app + secret for you — needs repo-admin).
2. Add the repo secret **`ANTHROPIC_API_KEY`** (Settings → Secrets and variables → Actions).
3. Copy [`examples/github-pr-review.yml`](examples/github-pr-review.yml) into the repo at `.github/workflows/senior-review.yml`.

That workflow triggers on `pull_request: [opened, synchronize, reopened]`, vendors this skill into `.claude/skills/`, and runs `/senior-review pr <n> post` so the review is posted as PR comments. Apply it to **any repo** by copying that one file.

> Tip: to gate it (not every PR), add an `if:` on a label. For Bedrock/Vertex, swap `anthropic_api_key` for `use_bedrock`/`use_vertex` per the [docs](https://code.claude.com/docs/en/github-actions). Mind the API + Actions-minutes cost.

## Install
Personal skill (all repos):
```bash
# from the agent-skills repo
ln -s "$PWD/senior-review" ~/.claude/skills/senior-review            # macOS/Linux
cmd /c mklink /J "%USERPROFILE%\.claude\skills\senior-review" "%CD%\senior-review"   # Windows
```
Or copy the folder into `~/.claude/skills/`. See the repo root `README.md` for details.

## Folder structure
```
senior-review/
  SKILL.md                     # model-facing workflow
  README.md                    # this file
  references/
    00-scope-and-diff.md       # resolve target, compute diff, capture intent
    01-review-rubric.md        # the multi-axis senior rubric + severities
    02-posting-to-pr.md        # gh / REST API / manual posting
  templates/
    review-report.md           # structured local report
    pr-comment.md              # paste-ready PR review
  scripts/diff-summary.sh      # read-only changeset overview + risk flags
```

---

## Tiếng Việt

**senior-review** là **skill cho Claude Code**: review một thay đổi như **kỹ sư senior trước khi push/merge** — hiểu *đã đổi gì, khác gì so với trước*, đánh giá đúng/sai, thiết kế, bảo mật, hiệu năng, test, tương thích ngược, rồi để lại **nhận xét có mức độ ưu tiên + gợi ý sửa cụ thể** kèm **kết luận**, và có thể **đăng nhận xét thẳng vào PR GitHub**. Dùng cho **mọi repo**.

### Quy trình
1. **Khoanh vùng thay đổi** — dò base branch, tính diff + thống kê, đọc commit/PR để hiểu mục đích.
2. **Dựng ngữ cảnh** — đọc code xung quanh, nơi gọi, test, schema để đánh giá *độ phù hợp*, không chỉ đoạn diff.
3. **Soi theo rubric** — đúng/sai, kiến trúc, dễ đọc, bảo mật, hiệu năng, xử lý lỗi, test, API/tương thích, data/migration, observability, nhất quán/phạm vi.
4. **Kết luận** — `approve` / `approve-with-nits` / `request-changes`, đếm mức độ, rủi ro chính, checklist trước merge.
5. **Bàn giao** — đăng inline comment + review tổng vào PR (qua `gh` hoặc API), hoặc xuất Markdown để dán / lưu file.

Mức độ: 🔴 blocker · 🟠 major · 🟡 minor · 🔵 nit · 🟢 khen — mỗi nhận xét có `file:line`, *vì sao quan trọng*, và cách sửa.

### Cách dùng
```
/senior-review                  # review nhánh hiện tại so với base, in báo cáo
/senior-review staged|working   # review thay đổi đã/đang stage
/senior-review pr 123           # review PR #123
/senior-review pr 123 post      # review PR #123 và đăng nhận xét lên PR
/senior-review develop..HEAD    # review một khoảng git cụ thể
```
Hoặc nói: *"review giúp tôi trước khi push"*, *"review PR 88 như senior và comment vào PR"*.

> **`post`/`auto`** = đăng thẳng lên PR. Mặc định chỉ in báo cáo và hỏi trước khi đăng (đăng PR là hành động ra ngoài).
> **Review ≠ sửa code.** Skill chỉ nhận xét/gợi ý, không tự sửa code tác giả hay push, trừ khi bạn yêu cầu.

### Đăng lên PR
Ưu tiên `gh` → nếu không có thì dùng REST API với token từ git credential manager → nếu không nữa thì xuất Markdown để bạn tự dán, kèm URL PR.

## License
MIT — see repository `LICENSE`.
