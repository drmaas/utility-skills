# Phase 3 — Planning

Goal: produce `docs/decisions/<feature>/plan.md` and `checklist.md`. If contracts were opted in, update `docs/contracts.md`.

## Graphify (token reduction)

Before spawning the planning subagent, check the worktree (and repo root if different) for `graphify-out/graph.json`.

- **Present:** nothing to do — the plan subagent queries the graph per its prompt rules.
- **Absent but the `graphify` CLI is installed** (check with `command -v graphify`): ask the user once whether to run graphify in the worktree now (e.g. `graphify` from the worktree root) so the plan and later implementation/review phases can leverage it. With consent, run it and wait for `graphify-out/graph.json`; on refusal or failure, continue without it and do not ask again this workflow.
- **CLI missing:** do not ask. If not already recommended in research (see `phases/01-research.md`), recommend the user install [graphify](https://github.com/Graphify-Labs/graphify) once; do not block.

## Subagent prompt

Spawn a fresh subagent via the `task` tool with `subagent_type: generalPurpose` (or `general-purpose` if that is the harness name). Select the model for role `plan` via `../models.md` (phase → role → fit / complexity / constraints). Pass the chosen id through the harness native model mechanism (Task `model` parameter, prompt prefix, or CLI flag).

Prompt template: `templates/plan-prompt.md`.

The subagent must:

- Read `prd.md`, `research.md`, and the contracts preference (`contracts+tooling` | `contracts-only` | `skip`).
- If graphify is present in the worktree, query it for orientation before broad file reads; if absent, investigate normally. Do not install or build the graph yourself.
- Write `plan.md` per `artifacts.md`: goal, non-goals, architecture (with ADR candidates as title + one-line choice), phases, risks, acceptance criteria, contracts note.
- Write `checklist.md` with phases and tasks. If contracts+tooling: add checklist tasks for tooling (OpenAPI, GraphQL, Storybook, etc.).
- If contracts in scope: create or update sections in `docs/contracts.md` per `../contracts.md`.
- For each phase, specify acceptance and what tests prove it.
- Add `## Implementation strategy` with literal placeholder `TBD — set by plan reviewer`.
- Keep all docs brief and simple.
- Self-review once: scope creep, missing acceptance criteria, oversized phases.
- Return a one-paragraph summary plus artifact paths (and contracts path if touched).

## Scope discipline

- Flag over-engineering in risks.
- Call out public API or wire-format changes.
- Split phases that are too large for one human-gate pass (~10+ tasks or unrelated files).

## Human gate

No human gate after plan write. Gate is in `phases/04-plan-review.md`.

## Exit conditions

- `plan.md` and `checklist.md` exist and align.
- `## Implementation strategy` is the TBD placeholder.
- If contracts in scope: `docs/contracts.md` has the new/updated sections.

Move to `phases/04-plan-review.md`.
