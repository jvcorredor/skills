---
name: pr-cleanup
description: Push the current branch, open a PR that closes its issue, wait for CI, then prune the worktree after merge. Use when finishing a worktree branch.
---

# pr-cleanup
Push current branch, open PR with `Closes #<issue>` in the body, wait for CI, then on merge prune the worktree.

Steps:
1. Confirm branch is not main
2. `gh pr create --body "Closes #<n>\n\n<summary>"`
3. Watch CI; report failures
4. After merge: `git worktree remove <path>` and prune
