# drive-prd

An orchestrator loop for Claude Code. Once a PRD and its tickets are on GitHub, Claude works through them one at a time: an implementer agent builds each ticket to a PR, three independent reviewers read it cold, Claude adjudicates their findings and gets the fixes made, then merges on green CI. Tickets that need you are parked with a question, and the loop moves on to everything they don't block.

## Invoking

```
/drive-prd #42
/drive-prd            # the PRD this session has been working on
```

Claude names the PRD it picked in its kickoff message, so a wrong guess is easy to catch.

## What it asks you

- **Once, up front**: which tickets are agent-ready, if any are still `needs-triage` or unlabelled.
- **At the end**: one report listing what merged, what's parked (each with its question and Claude's recommendation), what's still blocked, and any follow-up issues opened. You also get a push notification.

Nothing else waits on you. Invoking the skill authorizes pushes, PRs, comments, labels, follow-up issues and merges for the PRD's tickets. Merges go through `gh pr merge` with branch protection intact. The PRD issue itself is left open.

## What parks a ticket

The implementer asks a design question; a review finding needs a product decision; fixes fail twice; CI is red for an outside cause twice; a rebase conflict needs judgement; branch protection wants a human; or the work touches secrets or a live cluster.

To unpark one, answer on the ticket and relabel it `ready-for-agent`. The next `/drive-prd` run picks it up.

## Resuming

The state lives in GitHub: assignment, labels, PRs and a one-line comment on the PRD per merged or parked ticket. A new session running `/drive-prd #42` picks up any open PR it left behind at review.
