# sdd — Spec-Driven Development

Disciplined brainstorm → architecture → specification → human gate → plan → tests-first → verify → fresh-context review → docs → release. Makes intended behavior explicit before code; maps tests to acceptance criteria; catches implementer-blind spots with an independent review.

**When to use:** non-trivial, cross-cutting, compliance/security-sensitive, or ambiguous product changes that need a formal spec and one hard approval before implementation.

**Not for:** tiny well-scoped fixes ([`doit`](../doit/README.md)) or mid-size work that wants multi-gate research/plan loops ([`rpi`](../rpi/README.md)).

**Needs:** Git worktrees, host repo tools, fresh-context review (Task/`generalPurpose` or harness equivalent). Optional [graphify](https://github.com/Graphify-Labs/graphify) for cheaper codebase orientation.

Install:

```bash
npx skills add drmaas/utility-skills --skill sdd
```

Agent instructions: [`SKILL.md`](SKILL.md). Role-based model routing (same file as `rpi` / `doit`): [`models.md`](models.md).

## Stages (summary)

0. Isolated worktree  
1. Ephemeral brainstorm (+ adversarial)  
2. Architecture  
3. Specification (`docs/decisions/<feature>/spec.md`)  
4. Human review gate (hard stop)  
5. Implementation plan  
6. Tests first  
7. Implementation  
8. Verification (real commands)  
9. Fresh-context review (≤3 rounds)  
10. Documentation  
11. Commit / push / PR / merge / cleanup (user auth)

## Token spend

- Prefer graphify (`graphify-out/graph.json`) before broad repo reads; recommend install once if missing — do not block.
- Keep brainstorm ephemeral; retain only synthesized decisions.
- Fresh review gets a minimal packet (request, approved spec, architecture, plan, diff, verification) — not prior chat.
- Subagents get a stage brief + artifact paths, not the full skill.

## Determinism

- Stable `REQ-*` / `AC-*` IDs; tests map to them.
- Canonical validation command is evidence; model narrative is not.
- Fixed review → stage routing; max three rounds then human.
- Stage checklist updated every stage; skips need a recorded reason.
- Model choice locked per role unless constraints change; no silent substitution.

## Related skills

| Skill | Fit |
| --- | --- |
| [`doit`](../doit/README.md) | Fast path; no formal spec/gate |
| [`rpi`](../rpi/README.md) | PRD + multi-gate research → plan → implement |
