<!-- Conventional Commits message. Match the repo's existing style/language. Keep the type(scope): prefix in English. -->

<type>(<scope>): <imperative, lower-case subject, ≤72 chars, no period>

<Body (optional): why this change exists, notable details/trade-offs. Wrap ~72 cols.
Use bullets if the commit bundles distinct parts.>

<Footers (optional):>
Closes #<issue>
BREAKING CHANGE: <what breaks + how to migrate>
Co-Authored-By: <Name> <<email>>

<!--
type: feat|fix|refactor|perf|docs|test|build|ci|chore|style|revert
Examples:
  feat(inventory): add province filter to routes list
  fix(auth): reject expired reservation holds on convert
  refactor(api)!: rename `district` field to `province`   (the ! marks a breaking change)
-->
