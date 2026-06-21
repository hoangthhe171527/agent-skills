# pr-prep

A reusable **Claude Code skill** that turns your changes into a clean **Conventional-Commits message** and a **high-quality PR description** — grounded in the real diff, matching your repo's template and style — then optionally creates the commit, pushes, and opens the PR.

Pairs with a code-review skill: **pr-prep opens a good PR → a reviewer reviews it.** Stack- and repo-agnostic.

> 🇻🇳 Bản tiếng Việt ở [dưới](#tiếng-việt).

## What it does
1. **Gather** — read the diff, commits, and intent; detect the repo's commit style, PR template, issue-linking, and hooks/signing.
2. **Commit message** — `type(scope): subject` + a *why* body + footers (`Closes #…`, `BREAKING CHANGE:`). Recommends splitting if the diff bundles unrelated changes.
3. **PR description** — fills your `.github/pull_request_template.md` (or a standard Summary / Why / What / Test plan / Risk / Checklist structure).
4. **Create (optional)** — commit, push the branch, and open the PR via `gh` / API / prefilled compare URL — **with confirmation** before any outward action.

## Usage
```
/pr-prep                 # describe current branch → commit message + PR description, then offer to open
/pr-prep message         # commit message only
/pr-prep staged          # base it on staged changes (pre-commit)
/pr-prep pr              # also create the commit/push and open the PR
/pr-prep auto            # end-to-end: commit + open PR non-interactively
```
Or ask: *"viết commit message + mô tả PR cho thay đổi này"*, *"prepare and open a PR"*.

## Principles
- **Describe what actually changed** (read the diff; no vague restatements).
- **Match the repo** — its commit style, PR template, language, issue-linking.
- **Why over what**; honest **test plan & risk** (no claiming tests that don't exist).
- **Confirm before outward actions**; never force-push or commit to `main`; never bypass hooks/signing.

## Install
```bash
ln -s "$PWD/pr-prep" ~/.claude/skills/pr-prep            # macOS/Linux
cmd /c mklink /J "%USERPROFILE%\.claude\skills\pr-prep" "%CD%\pr-prep"   # Windows
```

## Structure
```
pr-prep/
  SKILL.md
  references/
    00-gather.md                 # diff, intent, repo conventions
    01-commit-message.md         # Conventional Commits rules, splitting, breaking changes
    02-pr-description.md          # fill template / standard structure
    03-creating-commit-and-pr.md # git/gh/API mechanics + safety
  templates/commit-message.md  templates/pr-description.md
  scripts/change-context.sh      # read-only diff + convention detector
```

---

## Tiếng Việt

**pr-prep** — skill biến thay đổi của bạn thành **commit message chuẩn (Conventional Commits)** + **mô tả PR chất lượng**, bám sát diff thật và quy ước/template của repo, rồi tuỳ chọn tạo commit, push, mở PR. Ghép với skill review: **pr-prep mở PR ngon → reviewer review.** Dùng cho mọi repo.

**Quy trình:** đọc diff & ý định → soạn commit `type(scope): ...` + thân *vì sao* + footer (`Closes #…`, `BREAKING CHANGE:`) → điền PR template (hoặc cấu trúc chuẩn: Tóm tắt / Vì sao / Thay đổi gì / Test plan / Rủi ro / Checklist) → tuỳ chọn commit + push + mở PR (gh / API / URL compare), **hỏi xác nhận trước khi đẩy**.

**Dùng:**
```
/pr-prep            # commit message + mô tả PR cho nhánh hiện tại, rồi hỏi mở PR
/pr-prep message    # chỉ commit message
/pr-prep pr|auto    # tạo commit + mở PR
```
Hoặc nói: *"viết commit message + mô tả PR giúp tôi"*.

**Nguyên tắc:** mô tả đúng diff · bám quy ước repo (style/template/ngôn ngữ) · ưu tiên *vì sao* · test plan & rủi ro trung thực · **xác nhận trước khi push**, không force-push, không commit thẳng `main`, không bỏ qua hook/signing.

## License
MIT — see repository `LICENSE`.
