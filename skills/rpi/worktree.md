# Worktree setup

RPI always runs in a dedicated feature worktree. Never edit in the main checkout.

## Procedure

Run after fit + PRD (or when the orchestrator is ready to edit), once `<feature>` slug, model-selection constraints, and base branch are known.

1. Verify the active root:

   ```bash
   git rev-parse --show-toplevel
   git branch --show-current
   git worktree list
   git status --short
   ```

2. If the shell is in the main checkout, **enter a feature worktree** before any edits. Do not invent a path: use the host agent’s usual worktree location, the path the user gives, or whatever `git worktree list` already shows for this feature.

3. If no suitable worktree exists yet, create one with `git worktree add` (branch `feature/<feature-slug>` unless the user specifies otherwise), using that agent’s or repo’s normal worktree directory. Follow host `AGENTS.md` / contributor docs when they define a layout.

4. Confirm the shell is inside the worktree (`git rev-parse --show-toplevel` matches it). Run repo setup there if needed (e.g. `pnpm install`).

5. If uncommitted changes block setup in the main checkout, stop and ask. Do not stash, commit, or mix changes without authorization.

6. Reject reuse of an existing worktree on a different branch unless the user explicitly authorizes it.

## Conventions

- Branch names: `feature/<slug>` unless the user says otherwise.
- Paths vary by coding agent — never hardcode a vendor-specific worktree directory in this skill.
- Prefer the agent’s native worktree tooling when it already entered one; otherwise `git worktree add` is fine.

## Cleanup

- Never remove a worktree without explicit user authorization.
- After the feature is merged, ask before `git worktree remove`.
