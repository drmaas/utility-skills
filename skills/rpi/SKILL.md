---
name: rpi
description: Run a research-plan-implement workflow with review cycles and human gates after each agent review. Starts with a fit check (offer sdd/doit/plain implement if unfit), then PRD create-or-review, optional docs/contracts.md + tooling, ADRs under docs/adrs/, specialized reviewer agents, verify before each implementation review, and a final freeze that commits durable docs into the feature PR. Distinct from sdd (formal spec) and doit (no formal gate). Plan review sets TDD by default (Code first only with justification). Trigger on RPI, research-plan-implement, or a gated research → plan → implement loop.
compatibility: Requires Git with worktree support, the host repository's existing development tools, and the ability to spawn fresh-context subagents per phase.
metadata:
  repository: https://github.com/drmaas/utility-skills
---

# Research, Plan, Implement, Review (RPI)

A markdown-driven engineering workflow. Each phase is a fresh-context session that writes or reads artifacts under `docs/decisions/<feature>/` while active. After final review, freeze durable docs onto final paths, delete the decisions folder, and commit them on the feature branch as part of the feature PR — no dangling drafts for a later commit. After every agent review, a human review gate pauses so the user sees findings before continuing.

Specialized reviewers live under [`agents/`](agents/README.md). Contracts: single host file `docs/contracts.md` ([`contracts.md`](contracts.md)). ADRs: [`adrs.md`](adrs.md).

All generated docs are brief, use simple language, stay to the point, and contain no unnecessary words.

## Steps

1. Fit check (`phases/00-fit.md`). If unfit: recommend `sdd` / `doit` / plain implement, offer to continue under that path, leave RPI.
2. PRD (`phases/01-prd.md`): ask existing vs create → `docs/decisions/<feature>/prd.md` → product-requirements critic → human gate → ask contracts + tooling preference.
3. Derive feature slug from PRD/problem; capture base branch and provider tier; enter a feature worktree (`worktree.md`).
4. Research → `docs/decisions/<feature>/research.md`.
5. Research review (agent + human gate).
6. Planning → `plan.md`, `checklist.md`; if contracts in scope, update `docs/contracts.md`.
7. Plan review: architecture-security then QA-testability (agent + human gate); write ADRs; harden contracts; set implementation strategy.
8. Implementation (per phase in `checklist.md`; default TDD from `plan.md`).
9. Verify per phase — format, lint, typecheck, tests; fix mechanical failures.
10. Implementation review per phase (adversarial-code-reviewer + human gate).
11. Commit (asked, never auto).
12. Final review (adversarial-code-reviewer + human gate).
13. Refactor — only if user opts in.
14. Freeze (`phases/11-freeze.md`) — move durable docs, remove drafts, commit into feature PR.

```
[Fit check] --unfit--> recommend + offer other path --> leave RPI
    |
   fit
    v
[PRD] --> prd.md --> critic --> human gate --> contracts ask
    |
    v
[Research] --> research.md --> review --> human gate
    |
    v
[Plan] --> plan.md, checklist.md, optional docs/contracts.md
    |
    v
[Plan review: arch-sec then QA] --> ADRs, contracts, strategy --> human gate
    |
    v
[Implement → Verify → Review → Commit] x N
    |
    v
[Final review] --> human gate
    |
    v
[Refactor?] --optional--> ...
    |
    v
[Freeze docs + commit into feature PR] --> done
```

## Operating rules

- Always run the fit check first. Do not start RPI artifacts if unfit.
- Enter a dedicated feature worktree before edits (see `worktree.md`); never edit in the main checkout. Worktree paths differ by coding agent — do not hardcode a vendor directory.
- Before editing with multiple worktrees, verify `git rev-parse --show-toplevel`, the current branch, `git worktree list`, and repository status; use the confirmed root for absolute paths.
- Every phase runs in a fresh-context subagent (no carry-over from prior phases). The user-visible summary is composed in the main thread, not the subagent.
- Load the matching brief from `agents/` when spawning critic/review roles (see [`agents/README.md`](agents/README.md)).
- Agent review always happens before the human review gate. The agent must self-revise first; the human only reads when obvious problems are already addressed.
- Human gates are mandatory after PRD, research review, plan review, per-phase implementation review, and final review. See `human-gates.md`.
- The skill never commits, pushes, opens a PR, or deletes files without explicit per-action user authorization — but freeze must complete (or user Abort) before the workflow claims done.
- Active drafts: `docs/decisions/<feature>/[prd|research|plan|checklist|refactor].md`. On freeze: `prd` → `docs/plans/<feature>-prd.md`, `research` → `docs/research/<feature>.md`, `plan` → `docs/plans/<feature>.md`, `refactor` → `docs/plans/<feature>-refactor.md`, optional `workflow` → `docs/workflows/<feature>-workflow.md`; delete `checklist.md`; remove the decisions folder. `docs/contracts.md` and `docs/adrs/*` stay on those paths and ship in the same PR.
- `checklist.md` is the implementation tracker; the implementer updates it as work progresses.
- If the user did not supply a problem statement and chose create-PRD, gather enough problem text before drafting. Do not invent the problem.
- Derive `<feature>` slug automatically (kebab-case, lowercased, concise). Never ask for the slug. Confirm only on collision.
- The user picks the provider tier (`cursor` | `free` | `normal` | `freebuff`; aliases `opencode-zen`/`openrouter`→`free`, `opencode-go`→`normal`) at workflow start. Resolve models via [`models.md`](models.md).
- Prefer **cursor** when the session already runs in Cursor. Outside Cursor, prefer **free**. If no no-retention free model fits a phase, pause and ask before using a retaining model.
- After every implementation phase, run the repository's canonical validation command. CI should run that same command.
- Default implementation strategy is **TDD**. QA-testability (plan review) records it in `plan.md` under `## Implementation strategy` and may flip to Code first only when testing first is impossible (one-line reason). User may override before approving the plan-review gate.
- After each implementation iteration and before implementation review, run verify (format → lint → typecheck → tests). Spawn implementation review only after verify is green.
- Watch for over-engineering at every review pass.
- Treat untrusted values and unusual object behavior defensively when relevant.
- Keep public diagnostics and serialized output deterministic.
- Approved `prd.md`, `research.md`, `plan.md`, and `refactor.md` are append-only until freeze moves them. After freeze they live on final paths inside the feature PR.
- RPI artifacts are decision records once approved, not behavior specs. Prefer code → tests → architecture docs → decision records when the host does not define priority.
- All RPI-generated docs are brief, use simple language, stay to the point, and contain no unnecessary words.

## Agent Model Tiers

Canonical definitions: [`models.md`](models.md).

Choose exactly one provider tier at workflow start. Prefer **cursor** in Cursor sessions, **free** otherwise. If unspecified, ask before delegating. On **cursor**, do not use Fable without explicit approval.

| Phase | Role |
| --- | --- |
| PRD / PRD review | `adversarial` |
| Research | `reasoning` |
| Research review | `adversarial` |
| Plan | `plan` |
| Plan review (arch-sec, QA) | `adversarial` |
| Implementation | `coding` |
| Verify | `verify` |
| Implementation review | `review` |
| Final review | `review` |
| Refactor | `docs` |

On **cursor**, walk primary → alt → **cross-pool** when a usage pool is maxed. Verify availability at start; record tier, models, fallbacks, and exhausted pools. A model report is not verification evidence.

## Workflow at a glance

1. Run `phases/00-fit.md`. On unfit: recommend and offer handoff; stop RPI if user declines or after handoff.
2. Run `phases/01-prd.md` (PRD ask → write/review → critic → gate → contracts ask). Derive `<feature>`; `question` for base branch and provider tier if not yet recorded.
3. Run `worktree.md` and enter a feature worktree. Refuse to proceed in the main checkout.
4. Read `artifacts.md`, then `phases/01-research.md`.
5. After every agent review, follow `human-gates.md`.
6. At commit steps, follow `phases/08-commit.md`: never commit without asking.
7. After final review (and optional refactor), run `phases/11-freeze.md`.

## Related skills

- **`sdd`** — heavier: formal specification, single human review gate before implementation. Use when large, cross-cutting, or compliance/security heavy.
- **`doit`** — lighter: no formal spec, no human approval gate. Use when well-scoped and bounded.
- **rpi** (this skill) — middle ground: PRD + markdown artifacts under `docs/decisions/<feature>/`, review cycles, contracts/ADRs as needed, freeze into the feature PR.

## Source / further reading

- [Advanced Context Engineering for Coding Agents (HumanLayer / ace-fca)](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/ace-fca.md)
- [Research, Plan, Implement, Review: My Agentic Engineering Workflow (Tyler Burleigh, 2026-02-22)](https://tylerburleigh.com/blog/2026/02/22/)

Adapted from Burleigh’s workflow and HumanLayer’s RPI / context-engineering guidance. Modified for checklist naming, agent-before-human gates, opt-in refactor, shared `docs/decisions/<feature>/` active tree, PRD + fit check, specialized reviewer agents, `docs/contracts.md` + ADRs, agent-agnostic worktrees, and freeze-into-PR (no dangling drafts).
