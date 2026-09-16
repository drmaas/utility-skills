# Artifact convention

Active RPI drafts live under `docs/decisions/<feature>/`. Contracts and ADRs use durable host paths during the feature. At freeze (`phases/11-freeze.md`), move drafts to final paths, delete the decisions folder, and commit everything into the feature PR.

All generated docs are brief, use simple language, stay to the point, and contain no unnecessary words.

## Path layout (active)

```
docs/decisions/<feature>/
  prd.md          # PRD phase
  research.md     # research phase
  plan.md         # plan phase
  checklist.md    # plan phase; updated through implement
  refactor.md     # optional refactor phase
  workflow.md     # optional human-requested log

docs/contracts.md           # single contracts file (if opted in)
docs/adrs/NNNN-slug.md      # locked architecture decisions
```

`<feature>` is kebab-case, lowercased, no spaces, no leading or trailing dashes.

Derive `<feature>` from the PRD/problem at workflow start. Do not ask for a slug. Only re-ask on collision with an existing `docs/decisions/<feature>/` or worktree.

If the decisions directory does not exist, create it before writing. Never use `docs/rpi/`.

## prd.md

Sections:

- **Status** — honest readiness (draft / ready for research / blocked / …).
- **Problem** — what hurts.
- **User** — who it is for.
- **Outcome** — what success looks like.
- **Scope / Non-goals** — matching pair.
- **Requirements** — each traces to an outcome.
- **Metrics** — value, owner, date, source; omit if none sourced (never invent).
- **Open questions** — each owned, or `none`.

Update protocol: product-requirements critic edits in place. Human gate approves or requests revisions.

On freeze: move to `docs/plans/<feature>-prd.md`.

## research.md

Sections:

- **Problem restatement** — from the PRD/problem.
- **Codebase findings** — paths, signatures, behavior, edge cases.
- **External findings** (greenfield only) — libraries, tradeoffs, citations.
- **Constraints and invariants**
- **Open questions**

On freeze: move to `docs/research/<feature>.md`.

## plan.md

Sections:

- **Implementation strategy** — `TDD` (default) or `Code first` with one-line justification. Set by QA-testability in plan review.
- **Goal** — one short paragraph.
- **Non-goals**
- **Architecture** — choices; list ADR candidates as title + one-line choice.
- **Phases** — ordered; each points at a checklist range.
- **Risks**
- **Acceptance criteria** — observable conditions.
- **Contracts** — note if `docs/contracts.md` was updated (or `skipped`).

On freeze: move to `docs/plans/<feature>.md`.

## checklist.md

Implementation tracker. Markdown checkboxes by phase. Implementer checks off tasks. Plan review initializes it. May include contract tooling tasks if user opted in.

On freeze: **delete**.

## docs/contracts.md

Single host file for all contracts. See [`contracts.md`](contracts.md). Sections point at tooling (OpenAPI, GraphQL, Storybook, …). Not moved at freeze; ship as-is in the feature PR.

## docs/adrs/

See [`adrs.md`](adrs.md). Written at plan review when decisions lock. Not moved at freeze; ship in the feature PR.

## refactor.md

Only if user opts into refactor. Sections: Candidate, Expected benefit, Risk, Scope, Test plan.

On freeze: move to `docs/plans/<feature>-refactor.md`.

## Freeze (feature PR)

After final review (+ optional refactor), run `phases/11-freeze.md`:

1. Move durable drafts to final paths (table in that phase file).
2. Keep `docs/contracts.md` and `docs/adrs/*` final on their paths.
3. Delete checklist; remove empty `docs/decisions/<feature>/`.
4. Ask user to commit freeze on the feature branch and include it in the feature PR.

No dangling decision drafts. No docs-only follow-up PR by default.

## File hygiene

- Never commit artifacts automatically without a commit/freeze gate choice.
- Never delete artifacts during an active feature without asking (except freeze deletes checklist + empty decisions folder after moves).
- If abandoned: leave a top note `ABANDONED — superseded by …` or remove only with user OK.
- Never hardcode foreign feature paths; use the slug.
