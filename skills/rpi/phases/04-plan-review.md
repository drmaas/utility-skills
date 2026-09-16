# Phase 4 — Plan review (agent + human)

Goal: architecture-security then QA-testability review `plan.md` / `checklist.md` (and contracts/ADRs), revise, then human gate.

## Subagent prompts (sequential)

Spawn two fresh Task subagents (`generalPurpose`). Model role `adversarial` via `../models.md` for both. For **cursor**, pass `model: <slug>`; else prefix `[model: <id>]`.

### 1. Architecture-security

Load `agents/architecture-security-reviewer.md` + `templates/plan-review-prompt.md` (arch-sec mode).

Must:

- Read `prd.md`, `research.md`, `plan.md`, `checklist.md`, and `docs/contracts.md` if in scope.
- Review architecture, trust boundaries, over-engineering, API/wire-format risk.
- Write/update locked ADRs under `docs/adrs/` per `../adrs.md`.
- Harden `docs/contracts.md` sections if in scope.
- Edit plan/checklist/contracts/ADRs in place.
- Return numbered issues, fixes, ADR paths, contract sections touched.

### 2. QA-testability

Load `agents/qa-testability-reviewer.md` + `templates/plan-review-prompt.md` (QA mode).

Must:

- Read the same artifacts after arch-sec edits.
- Review acceptance criteria, test gaps, phase size, contract verification notes.
- Set `## Implementation strategy` to `TDD` or `Code first` (one-line reason if Code first).
- Edit `plan.md` and `checklist.md` in place.
- Return numbered issues, fixes, and chosen strategy.

Do not spawn the human gate until both have finished and self-revised.

## Human gate

Follow `human-gates.md`. Print plan summary (including strategy, ADRs, contracts) plus both agents' findings. User may override strategy by editing `plan.md` before Approved, or Revise naming the strategy. Options: Approved / Revise / Ignore points / Abort.

On Revise: re-run the relevant reviewer(s) with user notes.

## Exit conditions

- User replied Approved.
- `plan.md` and `checklist.md` stable.
- `## Implementation strategy` is `TDD` or `Code first` (with justification if Code first).
- Locked ADRs written when decisions exist.
- Contracts hardened if in scope.

Move to `phases/05-implement.md`.
