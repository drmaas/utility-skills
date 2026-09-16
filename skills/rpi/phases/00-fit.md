# Phase 0 — Fit check

Goal: decide whether RPI is the right workflow for this request. Run in the main thread. No subagent.

## When to run

Always first when the user invokes RPI or the skill otherwise activates. Do not enter a worktree, write a PRD, or create artifacts until fit is confirmed.

## Fit criteria

RPI fits when most of these hold:

- Change needs research and a written plan before coding.
- Human review after research, plan, each implement phase, and final is worth the cost.
- Scope is larger than a one-shot fix but not a compliance-heavy formal spec.

Prefer another path when:

- **`doit` / plain implement** — small, well-scoped, bounded; gates would slow work without value.
- **`sdd`** — large, cross-cutting, or compliance/security surface that needs a formal spec and a single heavy gate before implement.
- **Neither** — pure Q&A, ops one-liner, or user only wants advice.

## Behavior

1. Restate the request in one or two sentences.
2. Say fit or unfit with a one-line reason.
3. If **fit**: proceed to `phases/01-prd.md`.
4. If **unfit**:
   - Recommend `sdd`, `doit`, or plain implement (name one).
   - Offer to continue under that path in this session.
   - If user accepts: leave RPI; follow the chosen path (load that skill if present).
   - If user declines: stop.

## Exit conditions

- Fit → PRD phase.
- Unfit → user chose handoff path or stopped. No RPI artifacts written.
