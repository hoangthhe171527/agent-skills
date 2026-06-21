<!-- Structured review output. Print it and/or save to code-review/<branch>-review.md in the target repo. -->

# Code Review — <branch / PR #n>: <short title>

> Base: `<base>` · Head: `<head/sha>` · Files: <n> (+<add>/-<del>) · Reviewer: senior-review · Date: <date>

## Verdict
**<✅ approve | 🟡 approve-with-nits | 🔴 request-changes>** — <one-line justification>

Findings: 🔴 <n> blocker · 🟠 <n> major · 🟡 <n> minor · 🔵 <n> nit · 🟢 <n> praise

## What changed (and why)
<2–4 sentences: the goal of the change and the main areas it touches.>

## Top risks
1. <risk> — <why / where>
2. <…>

## Findings

### 🔴 Blockers
- **`path:line`** — <problem>. <why it matters>. **Fix:** <suggestion / patch>.

### 🟠 Major
- **`path:line`** — <problem>. <why>. **Fix:** <suggestion>.

### 🟡 Minor
- **`path:line`** — <problem>. <suggestion>.

### 🔵 Nits
- **`path:line`** — <small suggestion>.

### 🟢 Praise
- **`path:line`** — <what was done well>.

## Tests
<Coverage of the change: what's tested, what's missing, any weakened/removed tests.>

## Pre-merge checklist
- [ ] <blocker/major resolved or acknowledged>
- [ ] Tests added/updated for changed behaviour and passing
- [ ] No breaking API/schema change without migration/versioning
- [ ] Manual verification: <what to check>

## Open questions
- <Anything where intent is unclear — phrased as a question to the author.>
