---
name: sdd
description: Run a disciplined spec-driven development workflow for non-trivial software changes. Use this skill whenever a user asks for TDD, SDD, a brainstorm-to-implementation plan, architecture or requirements work, a human review gate, independent code review, or a commit/push/PR workflow. It takes the change through an isolated worktree, model-assisted brainstorming, architecture, specification, approval, implementation planning, tests-first development, model-assisted coding and verification, fresh-context review, documentation, and a final freeze that commits durable decision docs into the feature PR. Distinct from rpi (multi-gate research loop) and doit (no formal spec or pre-impl gate).
compatibility: Requires Git with worktree support, the repository's existing development tools, and an independent review context (fresh Task/generalPurpose or harness equivalent). Optional graphify for cheaper codebase orientation.
metadata:
  repository: https://github.com/drmaas/utility-skills
---

# Spec-Driven Development Workflow

Follow this workflow for non-trivial changes. The goal is to make the intended behavior explicit before implementation, make tests traceable to the approved behavior, and use independent review to catch problems the implementer is too close to see.

Do not silently skip stages. If a stage is not applicable, record why in the workflow log. Keep a short status checklist and update it after each stage.

## Operating rules

- Match the repository's conventions, tooling, architecture, and naming before introducing anything new.
- Keep the work isolated in a feature worktree. Do not develop a feature in the main checkout.
- Before editing with multiple worktrees, verify `git rev-parse --show-toplevel`, the current branch, `git worktree list`, and repository status; use the confirmed root for absolute paths.
- Separate discovery from commitment: brainstorming may contain alternatives; the approved specification must contain a clear decision.
- Treat the human review gate as a real stop. Do not write the implementation plan, tests, or production code until the user approves the specification.
- Every human gate (spec approval and release) must include a plain-language explanation of what is changing in the application, plus any open questions with a recommended answer. Never leave ambiguity as a silent assumption.
- Write tests from approved acceptance criteria before implementation. A test may be intentionally red at first, but it must become meaningful and pass after implementation.
- Keep the specification, architecture, plan, tests, implementation, and documentation consistent. When one changes, inspect the downstream artifacts.
- Use the project's package manager and existing scripts. Do not install a new dependency merely to satisfy this workflow without approval.
- Treat untrusted values and unusual object behavior defensively, including inherited properties, accessors, proxies, cycles, sparse collections, malformed encodings, and mutable shared state when relevant.
- Keep public diagnostics and serialized output deterministic and independent of third-party wording or incidental iteration order.
- After implementation or review fixes, rerun the repository's canonical validation command; CI should run that same authoritative command rather than a weaker duplicate.
- Before release operations, audit staged, unstaged, tracked, and untracked files for secrets, local settings, generated artifacts, unrelated changes, and accidental edits outside the worktree.
- Keep state-inspection commands clearly scoped so branch, path, and status output cannot be confused; a failed or malformed tool call is a no-op, not a reason to guess.
- Commit, push, PR creation, merge, and cleanup are separate release actions for audit purposes, but one explicit authorization for a clearly defined set remains valid for that set. Ask again only when authorization is absent, ambiguous, or the scope changes; never force-push or push directly to a protected default branch. Prompt immediately before deleting files/directories or removing worktrees.
- Before release commit: freeze durable drafts out of `docs/decisions/<feature>/` onto final paths, stage those moves with the feature changes, and include them in the feature PR. Do not leave dangling decision drafts for a later docs-only commit. Skip freeze only when no durable decision files exist (content lived in the task/PR description); record that reason.
- Prefer structured decision docs over dumping chat into the repository. Subagents receive a stage brief and artifact paths — not this full skill text.

## Model selection

Canonical definitions (identical across `rpi`, `sdd`, `doit`): [`models.md`](models.md).

Select models by **role** and task **fit / complexity / constraints** against the harness allowlist. Never hardcode vendor or model IDs. Prefer a different model family for `adversarial` / `review` than for the authoring role. Lock choices per role for the workflow unless the user changes constraints. Record rationale and chosen ids in the workflow log. A model report is not verification evidence.

Use the **sdd** stage→role map in `models.md`.

| Stage | Phase | Role |
| --- | --- | --- |
| 1 | Brainstorm / adversarial | `reasoning` / `adversarial` |
| 2–3 | Architecture, specification | `reasoning` |
| 5 | Implementation plan | `plan` |
| 6–7 | Tests, implementation | `coding` |
| 8 | Verification | `verify` |
| 9 | Independent review | `review` |
| 10 | Documentation | `docs` |

## Graphify (token reduction)

Before broad repository reads in Stage 1 (and again when architecture needs deep orientation), check the worktree (and repo root if different) for `graphify-out/graph.json`.

- **Present:** prefer `graphify query`, `graphify path`, `graphify explain`, and `graphify-out/GRAPH_REPORT.md` over blind multi-file exploration. Still open source files to verify citations (path + line).
- **Absent:** recommend once that the user install and run [graphify](https://github.com/Graphify-Labs/graphify) so later stages and re-runs can query a persistent graph. Do not block the workflow; do not install graphify inside a subagent. One short recommendation is enough.

## Determinism

- Stable `REQ-*` and `AC-*` IDs; map tests to them where practical.
- Canonical validation command is the source of truth; capture exact commands and exit codes in the workflow log.
- Fixed review finding → stage routing (Stage 9); max three rounds, then ask the user.
- Update the stage checklist after every stage; skipped stages need a recorded reason.
- Model choice locked per role unless constraints change.
- Failed or malformed tool calls are no-ops — never guess from partial output.

## Workflow state and artifacts

Use the repository's established locations when they exist. Otherwise use these defaults.

Write each Markdown file for its **audience mode** (`human` | `agent` | `hybrid`) per the `clear-markdown` skill. Frozen copies keep the same mode as the draft.

| Path / artifact | Purpose | Audience |
| --- | --- | --- |
| *(ephemeral brainstorm — do not write `docs/decisions/<feature>/brainstorm.md`)* | Working context only | — |
| `docs/architecture.md` | Living architecture / boundary decisions | `hybrid` |
| `docs/decisions/<feature>/spec.md` → `docs/specs/<feature>.md` | Testable specification (`REQ-*` / `AC-*`) | `hybrid` |
| `docs/decisions/<feature>/spec-NN-<topic>.md` | Post-approval spec correction (append-only sibling) | `hybrid` |
| `docs/decisions/<feature>/plan.md` → `docs/plans/<feature>.md` | Ordered implementation plan mapped to ACs | `hybrid` |
| Plan addendum (or amend workflow log) | Post-approval plan corrections | `agent` |
| `docs/decisions/<feature>/workflow.md` → `docs/workflows/<feature>-workflow.md` | Stage status, reviews, verify cmds, model rationale | `agent` |
| `docs/decisions/<feature>/research.md` → `docs/research/` | Carry-over from prior RPI only; freeze on release | `hybrid` |
| Spec / release gate packets (chat) | Plain-language human decision | `human` |
| Task / PR description (small-change alternate) | Spec/plan content when not large enough for durable files | `hybrid` |
| Host `README.md` (Stage 10) | Setup, usage, user-visible examples | `human` |
| Host `AGENTS.md` (Stage 10) | Agent orientation | `agent` |
| User guides, CLI/API refs, changelog / release notes | As touched in Stage 10 | `human` |
| Subagent stage brief (chat / Task prompt) | Fresh review context | `agent` |

- Brainstorm notes: ephemeral working context only. Do not create or retain `docs/decisions/<feature>/brainstorm.md` files. Preserve only the decisions that survive synthesis in the architecture, specification, plan, and workflow record.
- Architecture decision: `docs/architecture.md` (**audience:** `hybrid`), updated as boundaries change.
- Specification: `docs/decisions/<feature>/spec.md` (**audience:** `hybrid`) while in draft or approved status. On release or supersession the file is moved (not copied, not edited) to `docs/specs/<feature>.md` and gains a `> Status: frozen <date>` header. Post-approval siblings `spec-NN-<topic>.md` move beside it under `docs/specs/` with the same freeze header.
- Implementation plan: `docs/decisions/<feature>/plan.md` (**audience:** `hybrid`) while in draft or approved status. On release or supersession the file is moved to `docs/plans/<feature>.md` and frozen (`> Status: frozen <date>`).
- Workflow log: `docs/decisions/<feature>/workflow.md` (**audience:** `agent`) — running record of stage status, review rounds, findings, verification results, and model-selection rationale. On feature completion the file is moved to `docs/workflows/<feature>-workflow.md` and frozen.
- Research carry-over (prior RPI only): `docs/decisions/<feature>/research.md` → `docs/research/<feature>.md`, frozen the same way.
- Tests: mapped to acceptance-criterion IDs where practical.

Decision records under `docs/specs/`, `docs/plans/`, `docs/workflows/`, and `docs/research/` are **frozen decision history**: do not edit them. If a record goes stale, write a new one with a `> Superseded by:` footer pointing to the replacement. The code is the source of truth for current behavior; decision records describe the decision, not the system. Prefer code → tests → architecture docs → decision records when the host does not define priority.

Freeze is part of the feature release, not a follow-up: moved paths must be committed on the feature branch and present in the feature PR. No dangling `docs/decisions/<feature>/` drafts after a successful release commit.

Prefer durable documents for the architecture, specification, and plan when the change is large enough that another engineer will need to implement or review it. For a small change, the same information may be kept in the task or PR description, but still pass through every gate. If old brainstorm files exist, treat them as disposable working artifacts and prompt before deleting them.

### Skill-bundle Markdown (this package)

| Path | Audience |
| --- | --- |
| `README.md` | `human` |
| `SKILL.md`, `models.md` | `agent` |

## Stage 0 — Enter an isolated worktree

1. Verify the repository root with `git rev-parse --show-toplevel`, then inspect the current branch, worktrees, status, and available package/test scripts. If the checkout has uncommitted work, do not mix it in — ask how to proceed or branch from a clean known base.
2. Create or enter the dedicated feature worktree and branch. Prefer the host repo’s naming convention when documented; otherwise use branch `feature/<feature-slug>` and a worktree path from the host agent’s usual layout, a path the user supplies, or `git worktree add` adjacent to the main checkout. Never hardcode a vendor-specific worktree directory in this skill. Confirm the shell is operating in that worktree before editing.
3. Record base commit, branch, worktree path, intended change, model-selection constraints, and which models will serve each role. If the user supplied a worktree, verify it is the intended feature worktree before editing.

## Stage 1 — Brainstorm

Understand the problem before choosing a solution. Keep both raw outputs ephemeral; do not save brainstorm documents in the repository.

Apply the Graphify rules above before broad reads.

Ask the primary model (role `reasoning`) to produce the brainstorm: user problem and desired outcome; affected users, callers, and systems; current behavior and limitations; constraints, invariants, security/privacy concerns, and compatibility requirements; at least two plausible approaches when the design is not obvious; trade-offs, risks, unknowns, and questions requiring user input; a provisional success definition and likely acceptance criteria.

Run an adversarial pass with a different model (role `adversarial`, different family when possible). Give it the primary result plus repository context and ask it to attack for omissions, false assumptions, boundary failures, platform issues, supply-chain risks, and false-green verification. The adversarial pass should challenge the primary proposal, not restate it.

Skip the adversarial pass only when the change is a pure documentation or config edit with no behavior, security, persistence, migration, public-API, or compatibility surface; record the skip reason.

Ask focused questions for decisions that materially affect behavior, compatibility, cost, security, or architecture. For each question, include a recommendation (preferred option + one-line reason) and brief alternatives. Do not turn unresolved assumptions into requirements. Carry forward useful material as synthesized decisions, not retained brainstorm files.

## Stage 2 — Architecture

Have the architecture-synthesis model (role `reasoning`) resolve the two brainstorm inputs, repository evidence, and user constraints into the chosen approach. Prefer graphify orientation when present. Describe:

- Components/modules affected and their responsibilities.
- Public APIs, data models, schemas, state transitions, and error paths.
- Control flow and important sequence/interaction behavior.
- Persistence, migrations, caching, concurrency, and rollback behavior when relevant.
- Security boundaries, permissions, secrets, input validation, and observability.
- Extension points and how future implementations can be added without coupling core behavior.
- Testing seams and which behavior belongs in unit, integration, or end-to-end tests.
- Alternatives considered and why they were rejected.

Keep architecture decisions proportional to the change. Write durable boundary and decision updates to `docs/architecture.md` when required by the repository. Flag anything that would require a specification change or a human decision.

## Stage 3 — Write the specification

Have the specification model (role `reasoning`) write the specification to `docs/decisions/<feature>/spec.md` using the synthesized architecture and the ephemeral brainstorm findings. It must be a testable specification in user and system terms. Include:

1. Problem statement and goals.
2. Scope and explicit non-goals.
3. Actors, entry points, and supported environments.
4. Functional requirements with stable IDs such as `REQ-001`.
5. Acceptance criteria with stable IDs such as `AC-001`, including happy paths, edge cases, and failure behavior.
6. API, CLI, UI, file-format, or compatibility changes.
7. Security, privacy, performance, accessibility, and operational requirements.
8. Migration, rollout, and backward-compatibility behavior.
9. Open questions and assumptions.

Every acceptance criterion should be observable and specific enough to become a test or a documented manual check. State what the system must not do when that boundary matters. Once the user approves this specification (Stage 4), the file is append-only: corrections after approval are made by writing a new `spec-NN-<topic>.md` or by amending the workflow log, not by editing the approved spec.

## Stage 4 — Human review gate

Present the proposed architecture and specification to the user in a concise review packet:

```
=== Human gate: Specification approval ===

## What this changes (plain language)
<non-jargon explanation of how the application will behave differently,
 who is affected, and what stays the same>

## Review summary
- Decisions made and alternatives rejected
- Requirements and acceptance criteria (short)
- User-visible changes and compatibility impact
- Risks

## Open questions
<none | numbered list — see format below>

=== end gate ===
```

For every point of unclarity or ambiguity, list an open question. Never bury it or guess past it. Format each item as:

```
Q<n>: <decision the user must make>
Why it matters: <one sentence>
Recommendation: <preferred option + one-line reason>
Alternatives: <other viable options, brief>
```

Stop and wait for explicit approval. Resolve or explicitly defer open questions before treating the gate as approved. Do not write the implementation plan or tests before approval. If the user requests changes, rerun the relevant ephemeral model pass and update the architecture or specification as appropriate, then repeat this gate. Record the approval, resolved questions, and any conditions.

## Stage 5 — Write the implementation plan

After approval, have the plan model (role `plan`) write the ordered plan to `docs/decisions/<feature>/plan.md`. It must be concrete enough for another engineer to execute. For each task include:

- The relevant file, module, package, or configuration area.
- The behavior or invariant being added/changed.
- Dependencies and ordering constraints.
- The acceptance-criterion IDs covered.
- The test or verification that proves completion.

Separate foundational changes from integration and cleanup. Identify generated files, migrations, feature flags, rollback steps, and documentation updates. Keep the plan aligned with the approved scope; if it is no longer aligned, return to the appropriate earlier stage instead of quietly expanding scope. Once the plan is written after approval, it is append-only: post-approval edits go in a new plan addendum or in the workflow log.

## Stage 6 — Write tests first

Have the tests-and-coding model (role `coding`) implement the tests before production code whenever the repository permits it.

- Map tests to acceptance criteria and requirements.
- Cover normal behavior, boundaries, invalid input, failures, security constraints, and compatibility behavior.
- Use the narrowest appropriate test level: unit tests for deterministic logic, integration tests for component boundaries, and end-to-end tests for real user journeys.
- Prefer real serializers, schemas, parsers, and boundaries over excessive mocks.
- Follow the repository's existing test framework and naming conventions.
- Run the new tests before implementation when useful and record the expected red state; do not weaken assertions just to obtain green.

If tests cannot be written first for a particular integration or UI constraint, document the reason and write the closest executable contract before coding.

## Stage 7 — Write the implementation

Have the tests-and-coding model (role `coding`) implement only the approved behavior and the plan's tasks.

- Make the smallest coherent change that satisfies the tests.
- Preserve existing behavior outside the approved scope.
- Validate untrusted input at the correct boundary and return stable, actionable errors.
- Avoid speculative abstractions and unrelated refactors.
- Keep public names, schemas, migrations, and generated artifacts synchronized.
- Update tests when implementation reveals an approved edge case that was not expressible initially; if behavior changes, return to the specification gate.

## Stage 8 — Verification and tests

Have the verification model (role `verify`) drive the project's complete relevant verification suite, not only the new tests. The workflow must still execute real commands and capture their output; a model report alone is not evidence. At minimum, use the repository's equivalents of:

- Formatting and linting.
- Type checking or static analysis.
- Unit tests.
- Relevant integration tests.
- End-to-end browser or system tests.
- Build/package checks and migration checks when applicable.

Review the diff and test output together. Check that each acceptance criterion has evidence, no test relies on accidental implementation details, and no unrelated files or secrets are included. Fix failures before advancing. Record exact commands and results in the workflow log.

## Stage 9 — Independent fresh-context review loop

Spawn a fresh Task/`generalPurpose` subagent (or harness equivalent) for review (role `review`). The reviewer must not rely on prior chat or the implementer's unstated reasoning. Give it **only**: the relevant request, approved specification, architecture, implementation plan, final diff, and verification results.

Use a maximum of **three review rounds**:

1. Round 1 is mandatory. Request findings ordered by severity: missing requirements, incorrect assumptions, security/privacy issues, regressions, test gaps, maintainability concerns, and documentation gaps.
2. If round 1 has no actionable findings, mark the review passed and continue.
3. Rounds 2 and 3 run only when round 1 produced findings. Classify each finding and loop back to the earliest appropriate stage:
   - Requirement or user-visible behavior issue → Brainstorm or Specification, then repeat the human review gate.
   - Architecture, boundary, migration, or API issue → Architecture and Implementation Plan; repeat the human gate if behavior or scope changes.
   - Missing or weak coverage → Tests first, then implementation and verification.
   - Implementation defect within approved behavior → Implementation, then verification.
   - Verification or release-process gap → Verification, then review.
   - Documentation-only issue → Documentation after the fix.
4. Re-run the canonical validation command and any affected tests after fixes, then start the next fresh review round.
5. Record the round number, reviewer context, findings, fixes, and evidence.

Never exceed three rounds. If actionable disagreement or findings remain after round three, stop and ask the user to decide rather than continuing an unbounded loop.

## Stage 10 — Documentation updates

Once behavior and review findings are stable, have the documentation model (role `docs`) update the files this change actually touches. Use `clear-markdown` audience modes. Update at minimum:

- `docs/architecture.md` (**audience:** `hybrid`) when the change alters components, boundaries, data/control flow, or decisions.
- `README.md` (**audience:** `human`) when the change alters setup, usage, or examples visible to users.
- `AGENTS.md` (**audience:** `agent`) orientation line when the change shifts what an agent working in the repo needs to know first.

Then update the rest of the documentation set as needed (**audience:** `human` unless the file is agent-facing): user guides, CLI/API references, examples, configuration, migration, release, and troubleshooting docs; changelog or release notes when the repository uses them.

Document supported platforms, limitations, security behavior, and the upgrade path. Keep examples executable or consistent with the implementation. Run documentation checks, links, generated-doc builds, or package checks that the repository provides. Record final release/status changes in the established workflow documentation.

## Stage 11 — Freeze docs, then commit / push / PR / merge / cleanup

### Freeze (before the release gate)

If durable files exist under `docs/decisions/<feature>/`, move them (not copy) to final paths and add `> Status: frozen <YYYY-MM-DD>` at the top of each moved file. Skip missing files.

| Draft | Final path |
| --- | --- |
| `spec.md` | `docs/specs/<feature>.md` |
| `spec-NN-<topic>.md` | `docs/specs/<feature>-NN-<topic>.md` (or host-equivalent under `docs/specs/`) |
| `plan.md` | `docs/plans/<feature>.md` |
| `workflow.md` | `docs/workflows/<feature>-workflow.md` |
| `research.md` (prior RPI carry-over) | `docs/research/<feature>.md` |

Then remove the empty `docs/decisions/<feature>/` directory. Do not leave unfrozen durable drafts there.

If the change never wrote durable decision files (spec/plan lived only in the task/PR description), skip freeze and record that reason in the release packet.

Also stage any living docs touched earlier (`docs/architecture.md`, README, AGENTS, guides) with the same release commit — they are already on final paths.

### Release gate

Before release actions, present a release gate packet:

```
=== Human gate: Release ===

## What this changes (plain language)
<non-jargon explanation of what landed in the application>

## Freeze summary
- Paths moved (or "none — no durable decision files")
- Living docs touched (architecture / README / AGENTS / …)

## Release summary
- Changed-file list (paths), including frozen decision docs
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
2. Review staged, unstaged, tracked, and untracked files and diffs; never include secrets, local settings, generated noise, or unrelated user work. Confirm freeze moves (or the recorded skip) are part of the pending change set.
3. Create a concise conventional commit when the repository uses conventional commits, describing why the change was made. The commit **must** include frozen decision-doc paths (and deletions under `docs/decisions/<feature>/`) whenever those files existed — same commit as the feature code when practical, or an immediate follow-up commit on the same branch before opening/updating the PR. Never defer freeze to a separate docs-only PR by default.
4. Push the feature branch to the expected remote. Never force-push or push directly to a protected default branch.
5. Open or update a pull request using the repository's supported tooling. Include the problem, solution, scope, tests/verification, review-round summary, **frozen decision-doc paths**, documentation changes, migrations, and known risks. The PR must contain the frozen artifacts when they exist.
6. When merge is in scope and authorized, wait for required checks and merge without bypassing branch protections.
7. After merge, reconcile release/status documentation and verify the default branch, worktrees, local branches, and remote refs. Remove worktrees, local branches, or merged remote branches only when cleanup is in scope; prompt immediately before deleting files/directories or removing worktrees.
8. Report the commit, branch, PR, merge result, cleanup result, verification evidence, freeze paths (or skip reason), and any remaining action required from the user.

Do not claim the workflow complete while `docs/decisions/<feature>/` still holds unfrozen durable drafts, or while freeze moves exist only as uncommitted local edits after the user authorized a release commit.

If approval for any release action is absent or ambiguous, stop after preparing the exact proposed command or PR content. Do not infer permission to commit, push, merge, deploy, or delete.

## Completion checklist

A change is complete only when:

- [ ] Work happened in the intended feature worktree.
- [ ] Primary and adversarial brainstorm passes were completed ephemerally (or the skip was recorded with reason); only synthesized architecture decisions are retained (architecture in `docs/architecture.md`).
- [ ] The specification at `docs/decisions/<feature>/spec.md` was explicitly approved by the user.
- [ ] The implementation plan at `docs/decisions/<feature>/plan.md` maps tasks to acceptance criteria.
- [ ] Each role's model was selected via fit / complexity / constraints; fallbacks were recorded, not silently substituted.
- [ ] Tests were written first or the exception was documented.
- [ ] Relevant formatting, linting, type, unit, integration, E2E, and build checks pass.
- [ ] The canonical validation command was rerun after implementation and after later fixes; CI runs the same authoritative validation.
- [ ] Fresh-context review passed within three rounds, or unresolved findings were escalated.
- [ ] Documentation this change touches is updated (architecture, README, AGENTS as applicable).
- [ ] Durable decision drafts were frozen onto final paths (`docs/specs/`, `docs/plans/`, `docs/workflows/`, `docs/research/` as applicable), the decisions folder removed, and those paths committed on the feature branch so the feature PR contains them — or freeze was skipped with a recorded reason (no durable decision files).
- [ ] The user approved commit/push/PR actions before they were performed.
- [ ] The final release audit covered staged, unstaged, tracked, and untracked files; the commit and PR contain only intended changes, include frozen decision docs when they exist, and include verification evidence.
- [ ] After merge, release/status documentation, the default branch, worktrees, local branches, and remote refs were reconciled and verified.

## Related skills

- **`rpi`** — middle ground: PRD + research/plan gates, specialized reviewers, freeze into the feature PR.
- **`doit`** — lighter: no formal spec, no human approval gate before implementation; still freezes decision docs into the feature PR when files exist.
- **`clear-markdown`** — audience modes (`human` / `agent` / `hybrid`) for Markdown this workflow writes.
