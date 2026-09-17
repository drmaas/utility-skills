# Model selection (shared)

Identical rules for `rpi`, `sdd`, and `doit`. Do not hardcode vendor names or model IDs. Do not fork this file per skill — keep the three copies in sync. Workflows only differ by which stage→role map they use.

Resolve: **workflow stage/phase → role → fit / complexity / constraints → harness allowlist → inject**.

## Shared roles

Picks are by **role** plus task fit — not by workflow name or vendor catalog.

| Role | Used for |
| --- | --- |
| `reasoning` | Brainstorm, architecture, specification, research, heavy planning |
| `adversarial` | Adversarial brainstorm / critique, research/plan review (different family from author when possible) |
| `plan` | Implementation plan, lightweight plan, architecture+plan combo |
| `coding` | Tests-first, implementation |
| `verify` | Format/lint/typecheck/tests loops, debug |
| `review` | Independent review, implementation review, final review |
| `docs` | Documentation, refactor write-ups |

## Selection checklist (fit / complexity / constraints)

For each stage/phase that needs a model:

1. Resolve **role** from this workflow’s map below (`rpi`, `sdd`, or `doit`).
2. Score the stage on three dimensions (no vendor names):
   - **Fit** — tool-use need, long-context need, critique vs synthesis vs implementation.
   - **Complexity** — scope breadth, ambiguity, security/migration/public-API surface.
   - **Constraints** — cost/latency budget, data-retention policy, and the **allowlist of models the current harness exposes**.
3. Choose the best **available** model on that allowlist for the role and scores. Prefer a **different model family** for `adversarial` / `review` than the authoring role used earlier in the workflow.
4. Inject the choice via the harness’s native mechanism (Task `model` parameter, prompt prefix, CLI flag, etc.). Do not embed concrete IDs in skill, phase, or agent brief files.
5. Lock the choice per role for the rest of the workflow unless the user changes constraints. If the preferred model is unavailable, ask or walk only harness fallbacks the user approved — never silently substitute.

Record in conversation state and the workflow log (or task notes): role, fit/complexity/constraints rationale, chosen model id (as the harness names it), and any fallbacks.

Honor user constraints on retention/training: if no allowlisted model satisfies the retention policy for a stage, pause and ask before using a retaining model.

A model report is not verification evidence; required repo commands still run for real.

## Passing the model to a subagent

After selection:

- If the harness accepts a model parameter on spawn (e.g. Task `model`), pass the chosen id there.
- Otherwise prefix the subagent prompt with a harness-conventional marker such as `[model: <id>]`, or use the host CLI’s model flag.
- Templates may keep a `[model: <model-id>]` placeholder; the orchestrator fills it after selection.

## Workflow stage → role maps

### rpi

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
| Commit / human gates | _(no model; user auth)_ |

### sdd

| Stage | Phase | Role |
| --- | --- | --- |
| 1 | Brainstorm (primary) | `reasoning` |
| 1 | Adversarial brainstorm | `adversarial` |
| 2 | Architecture | `reasoning` |
| 3 | Specification | `reasoning` |
| 4 | Human review gate | _(no model)_ |
| 5 | Implementation plan | `plan` |
| 6 | Tests first | `coding` |
| 7 | Implementation | `coding` |
| 8 | Verification and tests | `verify` |
| 9 | Independent fresh-context review | `review` |
| 10 | Documentation | `docs` |
| 11 | Release actions | _(no model; user auth)_ |

### doit

| Stage | Phase | Role |
| --- | --- | --- |
| 1 | Brainstorm and scope (primary) | `reasoning` |
| 1 | Adversarial pass | `adversarial` |
| 2 | Architecture note and lightweight plan | `plan` |
| 3 | Tests first | `coding` |
| 4 | Implementation | `coding` |
| 5 | Verification and tests | `verify` |
| 6 | Independent fresh-context review | `review` |
| 7 | Documentation | `docs` |
| 8 | Release actions | _(no model; user auth)_ |
