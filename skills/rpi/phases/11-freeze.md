# Phase 11 — Freeze into PR

Goal: freeze all durable docs onto final paths, remove draft trees, and commit them on the feature branch for the feature PR. Leave no dangling docs for a later commit.

## Entry conditions

- Final review Approved (`phases/09-final-review.md`).
- Optional refactor finished or user opted out (`phases/10-refactor.md`).

## Freeze moves

From `docs/decisions/<feature>/` (skip missing files). Move (not copy); add `> Status: frozen <YYYY-MM-DD>` at the top of each moved file:

| Draft | Final path |
| --- | --- |
| `prd.md` | `docs/plans/<feature>-prd.md` |
| `research.md` | `docs/research/<feature>.md` |
| `plan.md` | `docs/plans/<feature>.md` |
| `refactor.md` | `docs/plans/<feature>-refactor.md` |
| `workflow.md` | `docs/workflows/<feature>-workflow.md` |

Also ensure on the branch in final form:

- `docs/contracts.md` (if contracts were in scope)
- any new/updated `docs/adrs/*`

Then:

1. Delete `docs/decisions/<feature>/checklist.md`.
2. Remove `docs/decisions/<feature>/` when empty.
3. Do not leave drafts under `docs/decisions/<feature>/`.

## Commit + PR gate

Print a freeze gate packet (also follow `human-gates.md`):

```
=== Human gate: Freeze + PR ===

## What this changes (plain language)
<non-jargon explanation of the finished feature in the application>

## Freeze summary
- Paths moved, contracts/ADRs touched, checklist removed

## Open questions
<none | Qn / Why / Recommendation / Alternatives>

=== end gate ===
```

Call `question`:

- **Commit freeze as suggested** — stage freeze paths + contracts/ADRs; run user-authorized commit with suggested message.
- **Commit with my message** — user supplies exact command; run it.
- **Open / update PR** — after commit (or if already committed), open or update the feature PR so frozen docs are in that PR. Ask before `gh pr create` / push.
- **Abort** — stop; warn that draft freeze is incomplete if moves already happened.

Rules:

- Never auto-commit, push, or open a PR without explicit choice.
- Workflow must not claim done while `docs/decisions/<feature>/` still holds unfrozen durable drafts.
- Workflow must not claim done while freeze moves exist only as uncommitted local edits after the user chose a commit option.
- Mid-feature phase commits may already exist; this step only finishes docs into the same PR.
- When the user authorizes open/update PR, confirm the PR diff includes the frozen final paths (and removals under `docs/decisions/<feature>/`).

## Exit conditions

- Durable docs on final paths with freeze status headers.
- Checklist and decisions folder gone.
- Freeze committed (or user explicitly aborted).
- PR includes frozen docs when user authorized open/update.

Workflow ends.
