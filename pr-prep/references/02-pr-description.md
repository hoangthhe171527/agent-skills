# Phase 2 — PR description

Goal: a description a reviewer can act on fast — what/why, how to verify, and the risks. Match the repo's template.

## If a PR template exists → fill it
Detect `.github/pull_request_template.md` (or `PULL_REQUEST_TEMPLATE/*`). **Fill every section** with real content from the diff; don't leave placeholder text or tick boxes you haven't satisfied. Keep the template's structure and headings.

## Otherwise → standard structure (`templates/pr-description.md`)
- **Title** — same shape as the commit subject: `type(scope): concise summary`.
- **Summary** — 1–3 sentences: what this PR does and why. The reviewer's TL;DR.
- **Why / context** — the problem or motivation; link the issue.
- **What changed** — bullets of the meaningful changes (group by area). Note migrations, config, new deps, generated files.
- **Test plan** — how it was verified: commands run, cases covered, what to check manually. Be honest if coverage is partial.
- **Risk & rollout** — breaking changes, migration/ordering, feature flags, perf/security surface, how to roll back. "Low risk" only if true.
- **Screenshots / recordings** — for any UI change (before/after).
- **Checklist** — tests added/updated, docs updated, no secrets, self-reviewed.
- **Linked issues** — `Closes #…`.

## Writing standards
- Skimmable: short bullets, clear headings, link don't paste. A reviewer should grasp the PR in ~30 seconds.
- Match the repo's language. Reference files/areas so reviewers know where to look.
- Don't oversell ("perfect", "fully tested") — calibrated, honest descriptions build trust.
- Keep it proportional: a one-line fix gets a few lines; a feature gets the full structure.

## Output
Provide the final **title** and **body** as ready-to-use text (Markdown). If creating the PR (Phase 3), this body is what gets posted.

Proceed to Phase 3 (`references/03-creating-commit-and-pr.md`) only if asked to create the commit/PR.
