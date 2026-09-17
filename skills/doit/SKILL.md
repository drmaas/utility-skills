---
name: doit
description: Run a fast, execution-focused development workflow for well-understood software changes. Use this skill when the user wants to just get a clearly scoped change done, asks to skip formal specs or planning overhead, or requests the lightweight counterpart to an SDD/TDD process. It keeps an isolated worktree, ephemeral model-assisted brainstorming, a lightweight plan with a focused architecture note, tests-first model-assisted coding, model-assisted verification, fresh-context review, documentation, and release preparation, but deliberately skips the formal specification and human review gate. Distinct from sdd (formal spec + gate) and rpi (multi-gate research loop).
compatibility: Requires Git with worktree support, the repository's existing development tools, and an independent review context (fresh Task/generalPurpose or harness equivalent). Optional graphify for cheaper codebase orientation.
metadata:
  repository: https://github.com/drmaas/utility-skills
---

# Do-It Development Workflow

Use this as the fast counterpart to the `sdd` workflow. It is appropriate when the request is already clear, the behavior change is bounded, and delaying implementation for formal artifacts would add little value.

This workflow deliberately omits:

- A formal specification document.
- A formal human approval gate before implementation.

It keeps planning lightweight: a short, ordered plan with a focused architecture note (see Stage 2) is written up front rather than a heavyweight specification-and-plan package.

Do not use those omissions to hide ambiguity. Ask blocking questions during brainstorming — each with a recommendation and brief alternatives. If requirements, architecture, compatibility, security, or scope remain materially ambiguous, recommend switching to `sdd` rather than guessing.

Every human stop (blocking questions, escalate-to-`sdd`, release authorization) must include a plain-language explanation of what is changing or proposed for the application. Never leave ambiguity as a silent assumption.

Do not silently skip stages. If a stage is not applicable, record why. Keep a short status checklist and update it after each stage.

## Operating rules

- Work in a dedicated feature worktree, not the main checkout.
- Before editing with multiple worktrees, verify `git rev-parse --show-toplevel`, the current branch, `git worktree list`, and repository status; use the confirmed root for absolute paths.
- Match repository conventions, package manager, architecture, naming, and test tooling.
- Derive a concise set of behavioral notes and acceptance checks from the user's request and ephemeral brainstorming. Keep them in the task, issue, PR description, or a lightweight workflow note rather than writing a formal specification or retaining raw brainstorm files.
- Write a lightweight, ordered plan before tests or code.
- Write tests before production code whenever practical.
- Keep the change focused. Do not add speculative abstractions or unrelated refactors.
- Keep behavioral notes, architecture, plan, tests, implementation, documentation, and verification consistent.
- Use existing scripts and dependencies. Do not install new tooling without approval.
- Record stage status, verification commands, review rounds, findings, and fixes.
- Treat untrusted values and unusual object behavior defensively, including inherited properties, accessors, proxies, cycles, sparse collections, malformed encodings, and mutable shared state when relevant.
- Keep public diagnostics and serialized output deterministic and independent of third-party wording or incidental iteration order.
- After implementation or review fixes, rerun the repository's canonical validation command; CI should run that same authoritative command rather than a weaker duplicate.
- Before release operations, audit staged, unstaged, tracked, and untracked files for secrets, local settings, generated artifacts, unrelated changes, and accidental edits outside the worktree.
- Keep state-inspection commands clearly scoped so branch, path, and status output cannot be confused; a failed or malformed tool call is a no-op, not a reason to guess.
- Commit, push, PR creation, merge, and cleanup are separate release actions for audit purposes, but one explicit authorization for a clearly defined set remains valid for that set. Ask again only when authorization is absent, ambiguous, or the scope changes; never force-push or push directly to a protected default branch. Prompt immediately before deleting files/directories or removing worktrees.
- Prefer structured notes over dumping chat into the repository. Subagents receive a stage brief and artifact paths — not this full skill text.

## Model selection

Canonical definitions (identical across `rpi`, `sdd`, `doit`): [`models.md`](models.md).

Select models by **role** and task **fit / complexity / constraints** against the harness allowlist. Never hardcode vendor or model IDs. Prefer a different model family for `adversarial` / `review` than for the authoring role. Lock choices per role for the workflow unless the user changes constraints. Record rationale and chosen ids. A model report is not verification evidence.

Use the **doit** stage→role map in `models.md`.

| Stage | Phase | Role |
| --- | --- | --- |
| 1 | Brainstorm / adversarial | `reasoning` / `adversarial` |
| 2 | Architecture note + lightweight plan | `plan` |
| 3–4 | Tests, implementation | `coding` |
| 5 | Verification | `verify` |
| 6 | Independent review | `review` |
| 7 | Documentation | `docs` |

## Graphify (token reduction)

Before broad repository reads in Stage 1, check the worktree (and repo root if different) for `graphify-out/graph.json`.

- **Present:** prefer `graphify query`, `graphify path`, `graphify explain`, and `graphify-out/GRAPH_REPORT.md` over blind multi-file exploration. Still open source files to verify citations (path + line).
- **Absent:** recommend once that the user install and run [graphify](https://github.com/Graphify-Labs/graphify). Do not block; do not install inside a subagent. One short recommendation is enough.

## Determinism

- Stable `AC-*` IDs when useful; map tests to them.
- Canonical validation command is the source of truth; capture exact commands and exit codes.
- Fixed review finding → stage routing (Stage 6); max three rounds, then ask the user.
- Update the stage checklist after every stage; skipped stages need a recorded reason.
- Model choice locked per role unless constraints change.
- Failed or malformed tool calls are no-ops — never guess from partial output.

## Workflow state and artifacts

Use the repository's established locations when they exist. Otherwise use these defaults.

Write each Markdown file for its **audience mode** (`human` | `agent` | `hybrid`) per the `clear-markdown` skill. Frozen copies keep the same mode as the draft.

| Path / artifact | Purpose | Audience |
| --- | --- | --- |
| *(ephemeral brainstorm — do not write `docs/decisions/<feature>/brainstorm.md`)* | Working context only | — |
| `docs/decisions/<feature>/notes.md` | Behavioral notes + `AC-*` when multi-session or plan ≥5 tasks | `hybrid` |
| Task / issue / PR description | Default home for notes/plan when files are not warranted | `hybrid` |
| `docs/decisions/<feature>/plan.md` → `docs/plans/<feature>.md` | Lightweight ordered plan + architecture note | `hybrid` |
| Plan addendum (or amend workflow log / notes) | Post-Stage-2 plan corrections | `agent` |
| `docs/decisions/<feature>/workflow.md` → host frozen workflow path | Stage status, reviews, verify cmds, model rationale | `agent` |
| `docs/architecture.md` | Durable architecture when boundaries/decisions shift | `hybrid` |
| Host `README.md` (Stage 7) | Setup, usage, user-visible examples | `human` |
| Host `AGENTS.md` (Stage 7) | Agent orientation | `agent` |
| User guides, CLI/API refs, changelog / release notes | As touched in Stage 7 | `human` |
| Blocking-question / release gate packets (chat) | Plain-language human decision | `human` |
| Subagent stage brief (chat / Task prompt) | Fresh review context | `agent` |
| Stage status checklist (in workflow log or task notes) | Orchestration progress | `agent` |

On release, move any existing `docs/decisions/<feature>/{plan,notes,workflow}.md` to the frozen paths the host uses (`docs/plans/`, etc.), then remove the decisions folder when empty. Do not create or retain brainstorm files.

### Skill-bundle Markdown (this package)

| Path | Audience |
| --- | --- |
| `README.md` | `human` |
| `SKILL.md`, `models.md` | `agent` |

## Stage 0 — Enter an isolated worktree

1. Verify the repository root with `git rev-parse --show-toplevel`, then inspect the current branch, worktrees, status, and available package/test scripts. If the checkout has uncommitted work, do not mix it in — ask how to proceed or branch from a clean known base.
2. Create or enter the dedicated feature worktree and branch. Prefer the host repo’s naming convention when documented; otherwise use branch `feature/<feature-slug>` and a worktree path from the host agent’s usual layout, a path the user supplies, or `git worktree add` adjacent to the main checkout. Never hardcode a vendor-specific worktree directory in this skill. Confirm the shell is operating in that worktree before editing.
3. Record base commit, branch, worktree path, requested outcome, model-selection constraints, and which models will serve each role. If the user supplied a worktree, verify it is the intended feature worktree before editing.

## Stage 1 — Brainstorm and scope

Quickly establish enough context to implement safely. Apply the Graphify rules above before broad reads. Run the primary pass with the primary-brainstorm model (role `reasoning`), then give its result and repository evidence to the adversarial model (role `adversarial`, different family when possible) for a challenge. Keep both raw outputs ephemeral and do not create `docs/decisions/<feature>/brainstorm.md` files.

- Restate the requested outcome and affected users/callers.
- Inspect current behavior and the relevant code/documentation.
- Identify constraints, invariants, security/privacy concerns, compatibility requirements, and non-goals.
- Consider alternatives when the design is not obvious and choose the smallest sound approach.
- Write concise behavioral notes and acceptance checks, using stable IDs such as `AC-001` when useful.
  - Persist to `docs/decisions/<feature>/notes.md` when the work will span sessions **or** the Stage 2 plan is expected to have **five or more** tasks.
  - Otherwise keep them in the task/PR description.
- Ask only questions that block a safe implementation. Do not wait for a formal approval packet.
- When asking, present:

  ```
  ## What this changes (plain language)
  <non-jargon restatement of the proposed app change>

  ## Open questions
  Q<n>: <decision>
  Why it matters: <one sentence>
  Recommendation: <preferred option + one-line reason>
  Alternatives: <other viable options, brief>
  ```

Skip the adversarial pass only when the change is a pure documentation or config edit with no behavior, security, persistence, migration, public-API, or compatibility surface; record the skip reason.

If discovery reveals a substantial new product decision, cross-cutting architecture change, migration risk, or unclear user-visible behavior, stop and suggest using `sdd` for the change. Include the plain-language change explanation and any open questions with recommendations in that stop.

## Stage 2 — Architecture note and lightweight plan

Capture a short, ordered plan that another engineer could follow, preceded by a focused architecture note. Keep both proportional to the change — a few bulleted tasks and 2–4 architecture bullets are enough; do not produce a heavyweight specification-and-plan package.

Have the architecture+plan model (role `plan`) write them. Record:

**Architecture note (only the non-obvious parts):**

- Components/modules and responsibilities affected.
- Public APIs, data models, schemas, state transitions, and error paths that change.
- Persistence, migration, concurrency, rollback, or compatibility behavior when relevant.
- Security boundaries, permissions, secrets, input validation, and observability when relevant.
- Alternatives rejected and why, only when the choice is non-obvious.

**Plan, one bullet per task:**

- The file, module, package, or configuration area it touches.
- The behavior or invariant being added or changed.
- Ordering constraints and dependencies on earlier tasks.
- The acceptance-check IDs it covers, when useful.
- The test or verification that proves it is done.

Persist the plan to `docs/decisions/<feature>/plan.md` when the change is large enough to outlive the session; on release, move it to `docs/plans/<feature>.md` and freeze (same lifecycle as SDD/RPI — no parallel doc trees). Otherwise keep it in the task or PR description. Record durable architecture decisions in `docs/architecture.md` only when the change shifts boundaries or decisions. If planning reveals scope or architecture ambiguity, return to Stage 1 rather than guessing.

Once the Stage 2 plan is recorded (in `plan.md` or the task/PR description), it is append-only: corrections are made by amending the workflow log/notes or writing a new plan addendum, not by editing the plan in place. There is no formal approval gate — “recorded” means written for this workflow, not user-signed.

## Stage 3 — Write tests first

Have the tests-and-coding model (role `coding`) translate the behavioral notes and acceptance checks into executable tests before implementation whenever the repository permits it.

- Cover normal behavior, boundaries, invalid input, failures, security constraints, and compatibility behavior relevant to the request.
- Use the narrowest appropriate level: unit tests for deterministic logic, integration tests for component boundaries, and end-to-end tests for real user journeys.
- Prefer real serializers, schemas, parsers, and boundaries over excessive mocks.
- Follow existing test naming and fixture conventions.
- Run the new tests before implementation when useful and record the expected red state.
- Do not weaken assertions merely to make an incomplete implementation pass.

If a test cannot be written first because of an integration or UI constraint, document the reason and write the closest executable contract before coding.

## Stage 4 — Write the implementation

Have the tests-and-coding model (role `coding`) implement the smallest coherent change that satisfies the behavioral notes and tests.

- Preserve behavior outside the requested scope.
- Validate untrusted input at the correct boundary and return stable, actionable errors.
- Keep public names, schemas, migrations, generated files, and adapters synchronized.
- Avoid speculative abstractions and unrelated cleanup.
- If implementation exposes a new behavior decision, pause and ask the user rather than silently expanding scope.
- Update tests only for behavior that is within the already understood request; if behavior changes materially, switch to `sdd` or return to brainstorming.

## Stage 5 — Verification and tests

Have the verification model (role `verify`) drive the complete relevant project verification suite, not only the new tests. The workflow must still execute real commands and capture their output; a model report alone is not evidence. Use the repository's equivalents of:

- Formatting and linting.
- Type checking or static analysis.
- Unit tests.
- Relevant integration tests.
- End-to-end browser or system tests.
- Build, packaging, migration, and generated-artifact checks when applicable.

Review the diff and test output together. Confirm that each acceptance check has evidence, tests do not rely on accidental implementation details, no unrelated files changed, and no secrets or local settings are included. Fix failures before review and record exact commands and results.

## Stage 6 — Independent fresh-context review loop

Spawn a fresh Task/`generalPurpose` subagent (or harness equivalent) for review (role `review`). The reviewer must not rely on prior chat or the implementer's unstated reasoning. Give it **only**: the user request, behavioral notes, focused architecture note, plan, final diff, and verification results.

Use a maximum of **three review rounds**:

1. Round 1 is mandatory. Request findings ordered by severity: missing behavior, incorrect assumptions, security/privacy issues, regressions, test gaps, maintainability concerns, and documentation gaps.
2. If round 1 has no actionable findings, mark the review passed and continue.
3. Rounds 2 and 3 run only when round 1 produced findings. Route each finding to the earliest appropriate stage:
   - Unclear or changed behavior → Brainstorm and scope; ask the user if a decision is required.
   - Architecture, boundary, migration, or API issue → Architecture note and plan, then implementation and verification.
   - Missing or weak coverage → Tests first, then implementation and verification.
   - Implementation defect within the understood scope → Implementation, then verification.
   - Verification or release-process gap → Verification, then review.
   - Documentation-only issue → Documentation after the fix.
4. Re-run the canonical validation command and any affected tests after fixes, then start the next fresh review round.
5. Record the round number, reviewer context, findings, fixes, and evidence.

Never exceed three rounds. If actionable disagreement or findings remain after round three, stop and ask the user to decide rather than continuing an unbounded loop.

If a finding shows the change was **not** actually well-scoped (substantial product decision, cross-cutting architecture, migration risk, or unclear user-visible behavior), **hard stop**: do not continue bypassing formal stages — recommend switching to `sdd` and wait for the user.

## Stage 7 — Documentation updates

After behavior and review findings are stable, have the documentation model (role `docs`) update the files this change actually touches. Use `clear-markdown` audience modes. Update at minimum:

- `docs/architecture.md` (**audience:** `hybrid`) when the change alters components, boundaries, data/control flow, or decisions.
- `README.md` (**audience:** `human`) when the change alters setup, usage, or examples visible to users.
- `AGENTS.md` (**audience:** `agent`) orientation line when the change shifts what an agent working in the repo needs to know first.

Then update the rest of the documentation set as needed (**audience:** `human` unless the file is agent-facing): user guides, CLI/API references, examples, configuration, migration, release, and troubleshooting docs; changelog or release notes when the repository uses them.

Document supported platforms, limitations, security behavior, and upgrade steps when relevant. Keep examples consistent with the implementation and run available documentation checks or generated-doc builds. Record final release/status changes in the established workflow documentation.

## Stage 8 — Commit, push, PR, merge, and cleanup

Before release actions, present a release gate packet:

```
=== Human gate: Release ===

## What this changes (plain language)
<non-jargon explanation of what landed in the application>

## Release summary
- Changed-file list (paths)
- Verification evidence
- Review-round result
- Known limitations

## Open questions
<none | Qn / Why / Recommendation / Alternatives>

=== end gate ===
```

Confirm the worktree contains only intended changes. Surface any remaining ambiguity with recommendations before asking for release authorization.

With explicit user approval for the defined release-action set (an existing authorization remains valid unless it is absent, ambiguous, or the scope changes):

1. Verify the active repository root, branch, worktree list, status, and recent commit-message conventions.
2. Review staged, unstaged, tracked, and untracked files and diffs; exclude secrets, local settings, generated noise, and unrelated user work.
3. Create a concise conventional commit when the repository uses conventional commits, describing why the change was made.
4. Push the feature branch to the expected remote. Never force-push or push directly to a protected default branch.
5. Open or update a pull request using the repository's supported tooling. Include the problem, solution, scope, tests/verification, review-round summary, documentation changes, migrations, and known risks.
6. When merge is in scope and authorized, wait for required checks and merge without bypassing branch protections.
7. After merge, reconcile release/status documentation and verify the default branch, worktrees, local branches, and remote refs. Remove worktrees, local branches, or merged remote branches only when cleanup is in scope; prompt immediately before deleting files/directories or removing worktrees.
8. Report the commit, branch, PR, merge result, cleanup result, verification evidence, and any remaining action required from the user.

If approval for any release action is absent or ambiguous, stop after preparing the exact proposed command or PR content. Do not infer permission to commit, push, merge, deploy, or delete.

## Completion checklist

- [ ] Work happened in the intended feature worktree.
- [ ] Primary and adversarial brainstorm passes were completed ephemerally (or the skip was recorded with reason); only the focused architecture decision is retained (architecture in `docs/architecture.md` when applicable).
- [ ] Each role's model was selected via fit / complexity / constraints; fallbacks were recorded, not silently substituted.
- [ ] A lightweight, ordered plan with a focused architecture note is recorded (in `docs/decisions/<feature>/plan.md` or the task/PR description).
- [ ] Behavioral notes live in the task/PR description, or in `notes.md` when the work spans sessions or the plan has ≥5 tasks.
- [ ] No unresolved requirement or architecture ambiguity was guessed through.
- [ ] Tests were written first or the exception was documented.
- [ ] Relevant formatting, linting, type, unit, integration, E2E, and build checks pass.
- [ ] The canonical validation command was rerun after implementation and after later fixes; CI runs the same authoritative validation.
- [ ] Fresh-context review passed within three rounds, or unresolved findings were escalated; mis-scope findings triggered a hard stop and `sdd` recommendation.
- [ ] Documentation this change touches is updated (architecture, README, AGENTS as applicable).
- [ ] On release, move any `docs/decisions/<feature>/{plan,notes,workflow}.md` that exist to the frozen paths the host uses (`docs/plans/`, etc.) and remove the decisions folder when empty of active drafts.
- [ ] The user approved commit/push/PR actions before they were performed.
- [ ] The final release audit covered staged, unstaged, tracked, and untracked files; the commit and PR contain only intended changes and include verification evidence.
- [ ] After merge, release/status documentation, the default branch, worktrees, local branches, and remote refs were reconciled and verified.

## Related skills

- **`sdd`** — heavier: formal specification, single human review gate before implementation.
- **`rpi`** — middle ground: PRD + research/plan gates, specialized reviewers, freeze into the feature PR.
- **`clear-markdown`** — audience modes (`human` / `agent` / `hybrid`) for Markdown this workflow writes.
