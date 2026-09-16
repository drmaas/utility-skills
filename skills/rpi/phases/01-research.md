# Phase 1 — Research

Goal: produce `docs/decisions/<feature>/research.md` from the approved PRD and codebase (or web, for greenfield). Prefer a graphify knowledge graph when present so research spends fewer tokens on broad repo reads.

## Entry conditions

- Fit check passed; PRD approved (`phases/01-prd.md`).
- Contracts preference recorded.
- `<feature>` slug derived (never asked).
- Provider tier and base branch captured.
- Shell is in a feature worktree (not the main checkout).
- Optional pointers from the user (paths, docs, examples).

## Graphify (token reduction)

Before spawning the research subagent, check the worktree (and repo root if different) for `graphify-out/graph.json`.

**If present:** set `<graphify-status>` to `present` and tell the subagent to start from graphify (see prompt). Prefer `graphify query`, `graphify path`, `graphify explain`, and `graphify-out/GRAPH_REPORT.md` over blind multi-file exploration. Still open source files to verify citations (path + line).

**If absent:** set `<graphify-status>` to `absent`. Before or right after starting research, recommend the user install and run [graphify](https://github.com/Graphify-Labs/graphify) so later RPI (and re-runs) can query a persistent graph instead of re-reading the tree. Do not block research on install — continue with normal codebase investigation. One short recommendation is enough; do not nag every phase.

## Subagent prompt

Use the `task` tool with `subagent_type: generalPurpose` (or `general-purpose` if that is the harness name). Select the model for role `reasoning` via `../models.md` (phase → role → active tier). For **cursor**, pass `model: <slug>` (primary → alt → cross-pool); for other tiers, prefix the prompt with `[model: <id>]`.

Prompt template: `templates/research-prompt.md`, parameterized with `<feature>`, `<repo-root>`, `<worktree-path>`, problem from `prd.md`, path to `prd.md`, and `<graphify-status>` (`present` | `absent`).

The subagent must:

- Read no prior chat context. Inputs: PRD path + optional pointers + graphify status.
- Read `docs/decisions/<feature>/prd.md`.
- If graphify is present: query the graph first for architecture, call sites, and related modules; use `GRAPH_REPORT.md` for community/god-node orientation; then verify load-bearing claims in source.
- If graphify is absent: investigate the repository as usual (no install step inside the subagent).
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
