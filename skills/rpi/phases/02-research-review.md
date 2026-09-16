# Phase 2 — Research review (agent + human)

Goal: a fresh-context subagent reviews `research.md` for accuracy and completeness, revises it, then the user reviews.

## Subagent prompt

Spawn a fresh subagent via the `task` tool with `subagent_type: generalPurpose` (or `general-purpose` if that is the harness name). Select the model for role `adversarial` via `../models.md` (phase → role → active tier). For **cursor**, pass `model: <slug>` (primary → alt → cross-pool); for other tiers, prefix the prompt with `[model: <id>]`.

Prompt template: `templates/research-review-prompt.md`.

The subagent must:

- Read `docs/decisions/<feature>/research.md` and `docs/decisions/<feature>/prd.md`. No other context.
- Verify every cited file path and line number still exists.
- Check that the artifact answers the PRD problem/outcome.
- Identify missing context: error paths, edge cases, type signatures, public APIs the plan will need.
- Identify over-research: sections not load-bearing for the plan.
- Edit `research.md` in place. Do not create a separate review file.
- Keep edits brief.
- Self-review once.
- Return a one-paragraph summary of: (a) what was wrong, (b) what was fixed, (c) what was left as open questions.

## Human gate

Follow `human-gates.md`. Print the **research** phase summary plus the agent's review summary, files touched, and self-revisions. Then `question`: Approved / Revise / Ignore points / Abort.

## Exit conditions

- The user replied Approved.
- The next phase reads the same `research.md`.

Move to `phases/03-plan.md`.
