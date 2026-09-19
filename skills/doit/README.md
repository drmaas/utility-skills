# doit — Do-It (fast path)

Lightweight execution workflow for well-scoped changes: worktree → ephemeral brainstorm → architecture note + short plan → tests-first → verify → fresh-context review → docs → release. Skips formal specification and the pre-implementation human gate.

**When to use:** clear request, bounded behavior change, formal SDD overhead would add little value.

**Not for:** ambiguous product decisions, cross-cutting architecture, compliance-heavy work ([`sdd`](../sdd/README.md)), or mid-size features that need multi-gate research ([`rpi`](../rpi/README.md)). Escalate to `sdd` when discovery or review shows the change was not actually well-scoped.

**Needs:** Git worktrees, host repo tools, fresh-context review (Task/`generalPurpose` or harness equivalent). Optional [graphify](https://github.com/Graphify-Labs/graphify) for cheaper codebase orientation.

Install:

```bash
npx skills add drmaas/utility-skills --skill doit
```

Agent instructions: [`SKILL.md`](SKILL.md). Role-based model routing (same file as `rpi` / `sdd`): [`models.md`](models.md). Markdown artifact audiences (`human` / `agent` / `hybrid`) are listed under **Workflow state and artifacts** in `SKILL.md`.

## Stages (summary)

0. Isolated worktree  
1. Brainstorm and scope (+ adversarial; escalate to `sdd` if fuzzy; blocking questions include recommendations)  
2. Architecture note + lightweight plan  
3. Tests first  
4. Implementation  
5. Verification (real commands)  
6. Fresh-context review (≤3 rounds; hard stop → `sdd` on mis-scope)  
7. Documentation  
8. Freeze docs, then commit / push / PR / merge / cleanup (user auth; frozen decision docs in the feature PR when files exist; plain-language change explanation + open questions with recommendations)

## Token spend

- Prefer graphify before broad repo reads; recommend install once if missing — do not block.
- Keep brainstorm ephemeral; retain only architecture note + plan / notes.
- Persist `notes.md` only when work spans sessions or the plan has ≥5 tasks; else task/PR description.
- Fresh review gets a minimal packet — not prior chat.
- Subagents get a stage brief + artifact paths, not the full skill.

## Determinism

- Stable `AC-*` IDs when useful; tests map to them.
- Canonical validation command is evidence; model narrative is not.
- Fixed review → stage routing; max three rounds then human.
- Stage checklist updated every stage; skips need a recorded reason.
- Plan append-only once Stage 2 is recorded (no formal approval gate).
- Model choice locked per role unless constraints change; no silent substitution.

## Related skills

| Skill | Fit |
| --- | --- |
| [`sdd`](../sdd/README.md) | Formal spec + human gate before implement |
| [`rpi`](../rpi/README.md) | PRD + multi-gate research → plan → implement |
