# rpi — Research, Plan, Implement

Markdown-driven engineering workflow for coding agents. Separates research, planning, and implementation into fresh-context phases; writes short artifacts the human and agent share; runs an agent review before each human gate; ships durable docs in the feature PR at the end.

**When to use:** mid-size feature work that needs research and a written plan before coding, with cheap human checkpoints after the agent has already self-revised. Each gate explains the app change in plain language and surfaces ambiguity as questions with recommendations.

**Not for:** tiny one-shot fixes (`doit` / plain implement) or heavy compliance / formal-spec work (`sdd`). The skill starts with a fit check and can hand off.

**Core ideas:** fresh subagent per phase; artifacts under `docs/decisions/<feature>/` while active (each file has a `human` / `agent` / `hybrid` audience — see [`artifacts.md`](artifacts.md)); TDD by default; verify (format/lint/typecheck/tests) before each implementation review; specialized reviewers (PRD critic, architecture-security, QA-testability, adversarial code); optional `docs/contracts.md` + ADRs; freeze into the feature PR (no dangling drafts).

Install:

```bash
npx skills add drmaas/utility-skills --skill rpi
```

Full orchestrator instructions: [`SKILL.md`](SKILL.md). Role-based model routing (identical to `sdd` / `doit`): [`models.md`](models.md).

## High-level sequence

1. **Fit check** — Is RPI right? If not, recommend another path and offer to continue there.
2. **PRD** — Use an existing PRD or create one; product-requirements critic; human gate; ask about contracts + tooling.
3. **Worktree** — Enter a feature worktree (path depends on the coding agent).
4. **Research** → write `research.md` → agent review → human gate.
5. **Plan** → write `plan.md` + `checklist.md` (and update `docs/contracts.md` if opted in).
6. **Plan review** — Architecture-security then QA-testability; ADRs; set TDD vs Code first → human gate.
7. **Per checklist phase:** implement → verify → adversarial code review → human gate → commit (asked, never auto).
8. **Final review** → human gate.
9. **Refactor** — optional, only if you opt in.
10. **Freeze** — Move durable docs to final paths, remove the decisions folder, commit into the feature PR.

```
Fit → PRD → Worktree → Research ⇄ gate → Plan ⇄ gate
  → (Implement → Verify → Review ⇄ gate → Commit) × N
  → Final review ⇄ gate → [Refactor?] → Freeze into PR
```

## Context engineering references

This skill builds on published context-engineering practice for coding agents:

- [Advanced Context Engineering for Coding Agents (HumanLayer / ace-fca)](https://github.com/humanlayer/advanced-context-engineering-for-coding-agents/blob/main/ace-fca.md) — RPI-style research → plan → implement, fresh context between phases, and managing the “dumb zone” when context fills up.
- [Research, Plan, Implement, Review: My Agentic Engineering Workflow (Tyler Burleigh, 2026-02-22)](https://tylerburleigh.com/blog/2026/02/22/) — artifact-driven stages, agent-then-human review gates, small phases, and over-engineering checks.

Read those before changing core workflow shape (fresh subagents, markdown artifacts, review gates).
