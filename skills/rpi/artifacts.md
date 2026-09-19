# Artifact convention

Active RPI drafts live under `docs/decisions/<feature>/`. Contracts and ADRs use durable host paths during the feature. At freeze (`phases/11-freeze.md`), move drafts to final paths, delete the decisions folder, and commit everything into the feature PR.

Write each Markdown file for its **audience mode** (`human` | `agent` | `hybrid`) per the `clear-markdown` skill. Frozen copies keep the same mode as the draft. All generated docs stay brief and to the point.

## Audience modes

| Mode | Write for |
| --- | --- |
| `human` | People scanning and deciding (plain language, a11y) |
| `agent` | Models following instructions (imperative, precise, token-lean) |
| `hybrid` | Humans edit; agents execute (default when both read the file) |

## Path layout (active) and audience

| Path | Phase / role | Audience |
| --- | --- | --- |
| `docs/decisions/<feature>/prd.md` | PRD | `hybrid` |
| `docs/decisions/<feature>/research.md` | Research | `hybrid` |
| `docs/decisions/<feature>/plan.md` | Plan | `hybrid` |
| `docs/decisions/<feature>/checklist.md` | Plan → implement (deleted at freeze) | `agent` |
| `docs/decisions/<feature>/refactor.md` | Optional refactor | `hybrid` |
| `docs/decisions/<feature>/workflow.md` | Optional gate/decision log | `agent` |
| `docs/contracts.md` | Opt-in contracts | `hybrid` |
| `docs/adrs/NNNN-slug.md` | Locked ADRs at plan review | `hybrid` |
| Gate packets in chat (`human-gates.md`) | Every human gate | `human` |
| Feature PR body / commit message | Freeze / release | `hybrid` |

### Freeze destinations (same audience as draft)

| Draft | Final path | Audience |
| --- | --- | --- |
| `prd.md` | `docs/plans/<feature>-prd.md` | `hybrid` |
| `research.md` | `docs/research/<feature>.md` | `hybrid` |
| `plan.md` | `docs/plans/<feature>.md` | `hybrid` |
| `refactor.md` | `docs/plans/<feature>-refactor.md` | `hybrid` |
| `workflow.md` | `docs/workflows/<feature>-workflow.md` | `agent` |
| `checklist.md` | *(deleted)* | — |
| `docs/contracts.md`, `docs/adrs/*` | unchanged paths | `hybrid` |

`<feature>` is kebab-case, lowercased, no spaces, no leading or trailing dashes.

Derive `<feature>` from the PRD/problem at workflow start. Do not ask for a slug. Only re-ask on collision with an existing `docs/decisions/<feature>/` or worktree.

If the decisions directory does not exist, create it before writing. Never use `docs/rpi/`.

## prd.md

**Audience:** `hybrid` — product-readable Problem/User/Outcome; precise Requirements agents can execute.

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

**Audience:** `hybrid` — engineers and later agents both consume findings.

Sections:

- **Problem restatement** — from the PRD/problem.
- **Codebase findings** — paths, signatures, behavior, edge cases.
- **External findings** (greenfield only) — libraries, tradeoffs, citations.
- **Constraints and invariants**
- **Open questions**

On freeze: move to `docs/research/<feature>.md`.

## plan.md

**Audience:** `hybrid` — humans approve strategy; agents implement phases.

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

**Audience:** `agent` — implementation tracker for the implementer; humans may glance at gates, but write it imperative and checkbox-dense.

Implementation tracker. Markdown checkboxes by phase. Implementer checks off tasks. Plan review initializes it. May include contract tooling tasks if user opted in.

On freeze: **delete**.

## docs/contracts.md

**Audience:** `hybrid`. Single host file for all contracts. See [`contracts.md`](contracts.md). Sections point at tooling (OpenAPI, GraphQL, Storybook, …). Not moved at freeze; ship as-is in the feature PR.

## docs/adrs/

**Audience:** `hybrid`. See [`adrs.md`](adrs.md). Written at plan review when decisions lock. Not moved at freeze; ship in the feature PR.

## refactor.md

**Audience:** `hybrid`. Only if user opts into refactor. Sections: Candidate, Expected benefit, Risk, Scope, Test plan.

On freeze: move to `docs/plans/<feature>-refactor.md`.

## workflow.md

**Audience:** `agent`. Optional human-requested gate/decision log. Dense status and decisions; not a teaching doc.

## Freeze (feature PR)

After final review (+ optional refactor), run `phases/11-freeze.md`:

1. Move durable drafts to final paths (table in that phase file).
2. Keep `docs/contracts.md` and `docs/adrs/*` final on their paths.
3. Delete checklist; remove empty `docs/decisions/<feature>/`.
4. Ask user to commit freeze on the feature branch and include it in the feature PR. Confirm the PR contains the frozen paths.

No dangling decision drafts. No docs-only follow-up PR by default.

## File hygiene

- Never commit artifacts automatically without a commit/freeze gate choice.
- Never delete artifacts during an active feature without asking (except freeze deletes checklist + empty decisions folder after moves).
- If abandoned: leave a top note `ABANDONED — superseded by …` or remove only with user OK.
- Never hardcode foreign feature paths; use the slug.

## Skill-bundle Markdown (this package)

| Path | Audience |
| --- | --- |
| `README.md` | `human` |
| `SKILL.md`, `models.md`, `worktree.md`, `artifacts.md`, `contracts.md`, `adrs.md`, `human-gates.md` | `agent` (hybrid only when editing for human maintainers of the skill) |
| `phases/*.md`, `templates/*.md`, `agents/*.md` | `agent` |
