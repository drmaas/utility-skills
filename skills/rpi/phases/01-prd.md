# Phase 0b — PRD

Goal: obtain an approved `docs/decisions/<feature>/prd.md` before research.

## Entry conditions

- Fit check passed (`phases/00-fit.md`).
- Problem statement known (from user or PRD path below). Derive `<feature>` slug from problem/PRD; never ask for the slug.
- Provider tier and base branch may be asked here or immediately after PRD approval; capture before entering a worktree.

## Ask first

Call `question`:

- **I have a PRD** — user points at a path or pastes content; copy/normalize into `docs/decisions/<feature>/prd.md`, then review.
- **Create a PRD** — draft from the problem statement.
- **Abort** — stop.

## Write or normalize

Sections (brief, simple language):

- Status
- Problem
- User
- Outcome
- Scope / Non-goals
- Requirements (each traces to an outcome)
- Metrics (value, owner, date, source — or omit if none sourced)
- Open questions (each owned, or `none`)

Create `docs/decisions/<feature>/` if missing. Enter a feature worktree after this gate per `worktree.md` if not already in one.

## Product-requirements critic

Spawn Task `generalPurpose`. Model role `adversarial` via `../models.md`.

Load:

1. `agents/product-requirements-critic.md`
2. `templates/prd-review-prompt.md` (existing PRD) or `templates/prd-prompt.md` (new)

Critic must enforce:

1. Problem, user, and outcome are all present and coherent.
2. Scope has matching non-goals.
3. Every requirement traces to an outcome.
4. Every metric owner and date is sourced not invented.
5. Open questions are owned or set to none.
6. The PRD status is honest and reflects the current state of the future.

## Human gate

Follow `human-gates.md` (PRD gate). Options: Approved / Revise / Ignore points / Abort.

## After approval — contracts ask

Call `question`:

- **Contracts + tooling** — update `docs/contracts.md` and create/update stack tooling (OpenAPI, GraphQL, Storybook, etc.) in implement.
- **Contracts only** — update `docs/contracts.md`; no new tooling.
- **Skip contracts** — do not edit `docs/contracts.md` for this feature.
- **Abort**

Record the choice in conversation state. Plan and plan-review read it.

## Exit conditions

- User Approved the PRD.
- Contracts preference recorded.
- Enter a worktree if needed (`worktree.md`), then `phases/01-research.md`.
