# Human review gates

After every agent review phase, pause and surface (1) a **plain-language change explanation**, (2) a **phase content summary**, (3) the agent's review findings, and (4) any **open questions with recommendations**. The user decides only after the agent has self-revised.

## Where the gates fire

- After PRD review (`phases/01-prd.md`).
- After research review (`phases/02-research-review.md`).
- After plan review (`phases/04-plan-review.md`). Also surface implementation strategy from `plan.md`. User may override by editing `plan.md` before Approved, or Revise naming the strategy.
- After each implementation review (`phases/07-implement-review.md`).
- After final review (`phases/09-final-review.md`).
- After refactor candidate write-up when opted in (`phases/10-refactor.md`).
- Freeze + PR (`phases/11-freeze.md`) — different question set (commit / PR), still a mandatory stop.

Commit mid-feature (`phases/08-commit.md`) is also a gate with its own options. Commit and freeze gates still include the plain-language change explanation and open-questions block.

## Gate behavior

1. Print a structured gate packet:

   ```
   === Human gate: <phase name> ===

   ## What this changes (plain language)
   <short non-jargon explanation of what is proposed or already done to the application —
    who is affected, what behaves differently, what stays the same>

   ## Phase summary
   <gate-specific content summary — see below; composed in the main thread from artifacts / git, not invented>

   ## Agent review
   Agent summary: <one-paragraph or numbered findings from the review subagent>
   Agent-edited files: <list, with line counts>
   Self-revisions applied: <list of changes the agent already made>
   Implementation strategy: <TDD or Code first — only on the plan-review gate>

   ## Open questions
   <none | numbered list — see below>

   === end gate ===
   ```

2. **What this changes (plain language)** is mandatory at every gate (including commit and freeze). Write for a non-specialist: say what the app will do differently, for whom, and any notable risk or side effect. Avoid file lists, API jargon, and artifact dumps here — those belong in Phase summary or Diff on demand.

3. **Phase summary** is mandatory and gate-specific. Short digest (about half to one screen). Do not paste the full artifact unless asked. Brief language.

4. **Open questions** are mandatory whenever the agent was unclear, hit ambiguity, or made a provisional assumption. Never bury ambiguity or guess past it. For each item use:

   ```
   Q<n>: <decision the user must make>
   Why it matters: <one sentence>
   Recommendation: <preferred option + one-line reason>
   Alternatives: <other viable options, brief>
   ```

   If there are no open questions, write `Open questions: none`. Do not proceed on silent assumptions about behavior, scope, compatibility, security, or UX.

### PRD gate

Compose from `docs/decisions/<feature>/prd.md`:

- Status.
- Problem / user / outcome (one line each).
- Scope vs non-goals (short).
- Requirement count and any missing outcome traces.
- Metrics only if present (flag unsourced if critic left any).
- Open questions or `none`.
- Artifact path.

### Research-review gate

Compose from `research.md`:

- Problem restatement (1–2 sentences).
- Top codebase findings (bullets; paths when useful).
- Constraints / invariants.
- Open questions left for planning.
- Artifact path.

### Plan-review gate

Compose from `plan.md` + `checklist.md` (+ contracts/ADRs if touched):

- Chosen approach (1–2 sentences).
- Implementation strategy (TDD / Code first + reason if Code first).
- Phase list with one-line intent each.
- Acceptance criteria overview.
- Risks / deferred items.
- Contracts sections touched or `skipped`.
- ADRs written (paths).
- Artifact paths.

### Implementation-review gate (per checklist phase)

Compose from implementer + verify summaries, checklist progress, and `git`:

- Checklist phase id / title and what was marked done.
- What was built (behavior, not file laundry list).
- Tests added/updated and whether strategy matched `plan.md`.
- Verify result.
- Files touched (paths only).
- Contract/ADR drift notes if any.
- Anything skipped or deferred.

### Final-review gate

Compose from plan + checklist + branch diff vs base:

- Outcome vs plan.
- Checklist completion state.
- High-level change set.
- Remaining risks or follow-ups.
- Contracts/ADRs status.
- Do not paste the full diff by default.

### Refactor gate (opt-in)

Compose from `refactor.md`:

- Numbered candidate list (title + one-line why each).
- In-scope vs stretch.
- Artifact path.

5. By default, do not dump the full artifact or full diff. Detail on demand: [Diff on demand](#diff-on-demand).

6. Call `question` with options:

   - **Approved** — proceed (only when open questions are resolved or explicitly deferred by the user).
   - **Revise** — user notes; return to the same review subagent.
   - **Ignore points** — user lists findings to disregard; return with notes + ignore list.
   - **Abort** — stop; record reason in conversation state.

   When open questions exist, prefer presenting them in the same `question` turn (or immediately before) so the user can pick recommendations or override them before choosing Approved.

7. Record the reply in conversation state. Optional log: `docs/decisions/<feature>/workflow.md` only if the user wants one (frozen later).

## Diff on demand

When the user requests detail:

- Markdown artifacts: unified diff since last approval of that artifact, or full file if shorter.
- Implementation / final: `git diff <base-branch>..HEAD` for files in scope, capped at 1000 lines.

Never edit an artifact at a human gate. Edits go to the next subagent invocation.

## Termination

Review loops end only on **Approved**. Freeze ends only after commit/PR choices or Abort per `phases/11-freeze.md`. Do not auto-advance on agent “no issues found.”
