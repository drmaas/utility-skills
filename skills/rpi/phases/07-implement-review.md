# Phase 7 — Implementation review (agent + human)

Goal: adversarial-code-reviewer reviews the just-completed phase against `plan.md`, fixes what it can, then human gate.

## Subagent prompt

Spawn a fresh subagent via the `task` tool with `subagent_type: generalPurpose` (or `general-purpose` if that is the harness name). Select the model for role `review` via `../models.md` (phase → role → active tier). For **cursor**, pass `model: <slug>` (primary → alt → cross-pool); for other tiers, prefix the prompt with `[model: <id>]`.

Load `agents/adversarial-code-reviewer.md` + prompt template `templates/implement-review-prompt.md`.

The subagent must:

- Read `plan.md`, `checklist.md`, `research.md`, and `prd.md` as needed.
- Read `## Implementation strategy` from `plan.md`. Verify it was followed.
- Run `git diff <base-branch>..HEAD -- <files touched in the current phase>`.
- Run the repository's canonical validation command.
- Review for: type errors, missing tests, missed edge cases, scope creep, off-plan refactors, dead code, secrets, contract/ADR drift vs code.
- Fix issues in place. Update `checklist.md` if tasks were falsely marked done.
- Amend `docs/contracts.md` or ADRs only when the interface/decision actually changed.
- Keep any doc edits brief.
- Self-review once.
- Return a numbered list: issues found, fixed, and unfixed.

## Human gate

Follow `human-gates.md`. Print the **implementation** phase summary plus the agent's numbered list. By default, do not print the full diff. Options: Approved / Revise / Ignore points / Abort.

## Exit conditions

- The user replied Approved.
- The implementation matches the plan for the current phase.

Move to `phases/08-commit.md`.
