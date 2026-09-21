# Phase 7 — Implementation review (agent; conditional human intervention)

Goal: adversarial-code-reviewer reviews the just-completed phase against `plan.md`, fixes what it can, and the workflow continues automatically unless an unresolved material decision needs the user's choice.

## Subagent prompt

Spawn a fresh subagent via the `task` tool with `subagent_type: generalPurpose` (or `general-purpose` if that is the harness name). Select the model for role `review` via `../models.md` (phase → role → fit / complexity / constraints). Pass the chosen id through the harness native model mechanism (Task `model` parameter, prompt prefix, or CLI flag).

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

## Conditional human intervention

Do not stop for a routine approval. After self-review, apply a reasonable recommendation for findings that are mechanical or within the approved behavior and rerun verification as needed. Continue automatically when the implementation matches the plan and no material decision remains unresolved.

Escalate through `human-gates.md` only when the reviewer cannot safely choose among materially different behavior, scope, compatibility, security, or architecture outcomes. Include the preferred recommendation and alternatives. If the user chooses Revise or Ignore points, resume the review loop and verify again; Abort stops the workflow.

## Exit conditions

- Review findings were fixed, deferred within approved scope, or escalated and resolved.
- The implementation matches the plan for the current phase.
- Verification is green after any review fixes.

Move to `phases/08-commit.md` once these conditions hold.
