# Phase 10 — Refactor (opt-in)

This phase only runs if the user opts in. The skill always asks first; it never auto-runs refactoring.

## Opt-in gate

At the start of this phase, call `question` with options:

- **Yes, refactor** — proceed to the subagent prompt below.
- **No, finish** — skip refactor; go to `phases/11-freeze.md`.

The user picks. The skill does not interpret silence as a yes.

## Subagent prompt (only if user opted in)

Spawn a fresh subagent via the `task` tool with `subagent_type: generalPurpose` (or `general-purpose` if that is the harness name). Select the model for role `docs` via `../models.md` (phase → role → fit / complexity / constraints). Pass the chosen id through the harness native model mechanism (Task `model` parameter, prompt prefix, or CLI flag).

Prompt template: `templates/refactor-prompt.md`.

The subagent must:

- Read `docs/decisions/<feature>/plan.md`, `docs/decisions/<feature>/checklist.md`, and `docs/decisions/<feature>/research.md`.
- Run `git diff <base-branch>..HEAD` to see every change.
- Identify high-leverage refactoring opportunities. Look for: duplicated logic introduced across phases, awkward type signatures, ad-hoc error handling that should be unified, missed abstractions that would make the next change cheaper, patterns that diverge from the rest of the codebase.
- For each candidate, document: what to refactor, expected benefit, risk, scope, test plan.
- Do not implement. Write `docs/decisions/<feature>/refactor.md` only.
- Self-review once. Reject candidates whose expected benefit is small or whose risk is high.
- Return a numbered list of candidates and a recommendation per candidate.

## Human gate after the proposal

Follow `human-gates.md`. Print the **refactor** phase summary (numbered candidates from `refactor.md`) plus any agent notes. Then `question` with options:

- **Approved as proposed** — proceed to implement every candidate.
- **Approve some** — user lists the candidates to implement.
- **None worth pursuing** — skip refactor implement; go to `phases/11-freeze.md`.
- **Abort** — stop.

## Implementation (only if user approved candidates)

For each approved candidate, follow the implementation loop:

1. Phase 5: implement the refactor in a fresh subagent.
2. Phase 6: verify.
3. Phase 7: implementation review.
4. Phase 8: commit (asked, never auto).

Run phases 5, 6, 7, 8 once per approved candidate. After all candidates are done, end the workflow.

## Exit conditions

- The user opted out: move to `phases/11-freeze.md`.
- The user opted in and approved candidates: refactor loop runs, then move to `phases/11-freeze.md`.
- The user approved no candidates: move to `phases/11-freeze.md`.

Never end the workflow without freeze (or an explicit Abort that accepts incomplete freeze).
