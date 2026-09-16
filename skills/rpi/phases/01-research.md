# Phase 1 — Research

Goal: produce `docs/decisions/<feature>/research.md` from the approved PRD and codebase (or web, for greenfield).

## Entry conditions

- Fit check passed; PRD approved (`phases/01-prd.md`).
- Contracts preference recorded.
- `<feature>` slug derived (never asked).
- Provider tier and base branch captured.
- Shell is in a feature worktree (not the main checkout).
- Optional pointers from the user (paths, docs, examples).

## Subagent prompt

Use the `task` tool with `subagent_type: generalPurpose` (or `general-purpose` if that is the harness name). Select the model for role `reasoning` via `../models.md` (phase → role → active tier). For **cursor**, pass `model: <slug>` (primary → alt → cross-pool); for other tiers, prefix the prompt with `[model: <id>]`.

Prompt template: `templates/research-prompt.md`, parameterized with `<feature>`, `<repo-root>`, `<worktree-path>`, problem from `prd.md`, and path to `prd.md`.

The subagent must:

- Read no prior chat context. Inputs: PRD path + optional pointers.
- Read `docs/decisions/<feature>/prd.md`.
- Create `docs/decisions/<feature>/` if missing.
- Write `research.md` with the sections in `artifacts.md`.
- Cite every claim with a file path, line number, or URL.
- List open questions at the bottom.
- Keep the doc brief and simple.
- Self-review once before returning.
- Return a one-paragraph summary plus the artifact path.

## Human gate

No human gate after research write. Gate is in `phases/02-research-review.md`.

## Exit conditions

- `docs/decisions/<feature>/research.md` exists with required sections.
- Subagent returned its summary.

Move to `phases/02-research-review.md`.
