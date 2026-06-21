# agent-skills

A personal collection of reusable **Claude Code / Agent skills** — stack-agnostic, project-agnostic, usable across every repository.

Each top-level folder is one self-contained skill (`SKILL.md` + supporting `references/`, `templates/`, `scripts/`).

## Skills

| Skill | What it does |
|---|---|
| [`codebase-spec-test`](codebase-spec-test/) | Reverse-engineers an existing codebase into business-logic documentation, then derives a traceable test suite (cases + data) and runs it to green. Guided or fully autonomous. |
| [`senior-review`](senior-review/) | Senior-engineer code review of a changeset (branch/PR/working diff) **before** it's pushed/merged: what changed, what's risky, multi-axis findings with severities — and posts the review to the PR. Works on any repo. |

## Install

These are **personal skills**: Claude Code discovers them under `~/.claude/skills/<skill>` (a folder containing `SKILL.md`). Pick one approach:

**A. Symlink / junction each skill (recommended — single source of truth)**

Clone this repo once, then link each skill folder into your skills dir:

```bash
git clone https://github.com/hoangthhe171527/agent-skills.git ~/code/agent-skills

# macOS / Linux
ln -s ~/code/agent-skills/codebase-spec-test ~/.claude/skills/codebase-spec-test
ln -s ~/code/agent-skills/senior-review      ~/.claude/skills/senior-review
```

```powershell
# Windows (directory junction — no admin needed)
cmd /c mklink /J "%USERPROFILE%\.claude\skills\codebase-spec-test" "%USERPROFILE%\code\agent-skills\codebase-spec-test"
cmd /c mklink /J "%USERPROFILE%\.claude\skills\senior-review"      "%USERPROFILE%\code\agent-skills\senior-review"
```

**B. Copy** the skill folder(s) into `~/.claude/skills/` (simple, but you maintain copies).

**C. Per-project / team:** put a skill under `<project>/.claude/skills/<skill>` to share it with collaborators of that repo.

After installing, refresh Claude Code; the skills appear by name.

## Usage

Invoke by name (or just describe the task — the descriptions trigger the right skill):

```
/codebase-spec-test auto            # document business logic + build & run tests
/senior-review                      # review the current branch vs its base
/senior-review pr 123               # review GitHub PR #123 and post comments
```

See each skill's own `README.md` for full options and autonomous-mode behaviour.

## Conventions for skills in this repo
- One folder per skill; `SKILL.md` at its root with `name` + `description` frontmatter (`name` must equal the folder name).
- Keep `SKILL.md` lean; push depth into `references/` (progressive disclosure).
- Outputs of a skill land in the **target project**, never in this repo.
- Helper `scripts/` are read-only and optional.

## License
MIT — see [LICENSE](LICENSE).
