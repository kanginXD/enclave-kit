# AGENTS

## MUST

- **Code:** production-ready for what you touch; repo conventions; no stray
  debug or unfinished paths unless the task requires them.
- **Text in tree** (Markdown, comments, specs, docs, examples): write for a
  third party. Contracts, invariants, and how to run or extend only. No chat
  context, narration, reasoning, process, or padding. Imperative or neutral
  third person. PR/issue material stays in PRs/issues.
- **Commits:** [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/);
  imperative subject only. Write a body only when there are several distinct
  changes: `-` bullets, one per line, no subject restatement. Body text follows
  the same third-party rules as text in tree. If signing fails, abort; do not
  retry it unsigned.

### Security

- No secrets in the tree; env, secret stores, or untracked local config only.
- Prefer maintained dependencies; skip opaque or abandoned ones.
- No hardcoded sensitive values anywhere (tests, fixtures, examples included):
  placeholders, fakes, or runtime injection only.
