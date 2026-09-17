# Phase 9 — Final review (agent + human)

Goal: adversarial-code-reviewer reviews the cumulative branch, fixes what it can, then human gate.

## Subagent prompt

Spawn a fresh subagent via the `task` tool with `subagent_type: generalPurpose` (or `general-purpose` if that is the harness name). Select the model for role `review` via `../models.md` (phase → role → fit / complexity / constraints). Pass the chosen id through the harness native model mechanism (Task `model` parameter, prompt prefix, or CLI flag).

Load `agents/adversarial-code-reviewer.md` + prompt template `templates/final-review-prompt.md`.

The subagent must:

- Read `plan.md`, `checklist.md`, `research.md`, and `prd.md` as needed.
- Run `git diff <base-branch>..HEAD`.
- Run the repository's canonical validation command.
- Review for: cross-phase issues, missed acceptance criteria, scope drift, over-engineering, weak tests, undocumented public API/wire-format changes, contract/ADR drift.
- Fix what it can in place.
- Amend contracts/ADRs only when needed for real drift.
- Self-review once.
- Return a numbered list: issues found, fixed, unfixed.

## Human gate

Follow `human-gates.md`. Print the **final** phase summary plus the agent's numbered list and file count changed. By default, do not print the full diff. Options: Approved / Revise / Ignore points / Abort.

## Exit conditions

- The user replied Approved.
- All `checklist.md` items are complete or explicitly deferred.

Move to `phases/10-refactor.md` (always starts with the opt-in question).
