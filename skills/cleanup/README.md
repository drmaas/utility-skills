# cleanup

Watch a PR until checks pass, squash-merge it (deleting the remote branch), then remove the matching git worktree if present and delete the local branch.

```bash
npx skills add drmaas/utility-skills --skill cleanup
```

Trigger phrases: "cleanup PR", "merge when green", "watch checks and merge", "land this PR", "tear down the worktree after merge".

Distinct from `autopilot` (fixes CI/comments; never merges).
