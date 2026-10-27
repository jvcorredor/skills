---
name: drive-prd
description: Drive a PRD's tickets one at a time through implementer, independent review, fixes, CI, and merge, parking human-only work, until no agent-ready ticket remains.
argument-hint: "[PRD issue number or URL; defaults to the session's PRD]"
---

# Drive PRD

You are the **orchestrator** of one PRD workstream. Subagents build, review, and verify; you pick tickets, adjudicate findings, and merge. Every ticket you claim ends **merged** or **parked**, and the loop runs until the frontier is empty.

The issue tracker and triage label vocabulary should have been provided to you (`docs/agents/` or the repo's `AGENTS.md`/`CLAUDE.md`). If not, tell the user to run `/setup-matt-pocock-skills`. Label names below are the canonical roles; use the repo's mapping.

## Vocabulary

- **Workstream**: the PRD issue plus every ticket linked to it: its sub-issues, or issues whose `## Parent` section names the PRD.
- **Blocker**: an issue in the ticket's native blocked-by relationship (`gh api repos/{owner}/{repo}/issues/<n>/dependencies/blocked_by`), else one listed in its `## Blocked by` section.
- **Frontier**: workstream tickets that are open, labelled `ready-for-agent`, unassigned, with every blocker closed.
- **Claim**: assign the ticket to yourself (`gh issue edit <n> --add-assignee @me`) before any work on it.
- **Park**: hand a ticket to the human. Swap `ready-for-agent` for `ready-for-human`, unassign, and comment the exact question with your recommendation. If it has a PR, convert it to draft (`gh pr ready <n> --undo`) and keep its worktree. A parked ticket stays open, so its dependents leave the frontier with it.
- **HITL block**: any of these parks the ticket:
  - the implementer stops with a question or design decision;
  - a finding adjudicates to **decide**;
  - fixes still fail verification or CI after two fix rounds;
  - CI is red for a cause outside the ticket, twice;
  - a rebase conflict whose resolution needs judgement;
  - branch protection or a required human review blocks the merge;
  - the work touches secrets or a live cluster.

## Authority

Invoking this skill authorizes, for workstream tickets only: worktrees and branches, pushes, PRs, PR and issue comments, label and assignee edits, follow-up issues, and merges once a PR passes every gate below. Merge through `gh pr merge` alone, so branch protection and required checks stay in force. Leave the PRD issue open; closing it is the user's call.

## State lives in GitHub

Assignment, labels, PR state, and comments are the record. After each ticket merges or parks, comment one line on the PRD issue (`Merged #<pr> for #<ticket>` or `Parked #<ticket>: <question>`). A fresh session reading the PRD, its tickets, and their PRs can resume the loop. Subagents write long output to a file in your scratchpad and return the path; your own context holds verdicts and pointers.

## 1. Start

1. **Find the PRD.** An argument names it. Without one, take the PRD this session has been working on: the one it wrote with `to-prd`, broke into tickets, or discussed. Name it in the kickoff so a wrong guess is visible. Ask only when the session holds no PRD or more than one.
2. Read the PRD (`gh issue view <n> --comments`) and every workstream ticket. Read the repo's `AGENTS.md`/`CLAUDE.md` and note its default branch and the merge method its history uses (merge commit or squash).
3. **Resume in-flight work.** A workstream ticket assigned to you with an open PR re-enters the loop at Review; one assigned to you without a PR is unclaimed and returns to the frontier.
4. **Triage gate.** If workstream tickets carry `needs-triage` or no state label (`to-issues` publishes them that way), list them and ask the user once which are agent-ready. Relabel per the answer. This is the loop's only up-front question.
5. Post the kickoff: the PRD, the frontier in pick order, tickets already parked or human-owned, and what blocks the rest. Then begin the loop without waiting.

## 2. Loop

One ticket in flight at a time. Each step ends on its completion criterion before the next starts.

### Pick

Re-fetch the frontier: merges unblock tickets, and the user may edit the tracker between iterations. Pick the ticket that unblocks the most open workstream tickets; break ties by lowest number. Claim it. An empty frontier sends you to **Stop**.

*Done when:* one ticket is claimed.

### Build

1. `git fetch origin`, then branch the worktree from the freshly merged default branch, never from local HEAD:
   `git worktree add -b <slug> ~/.claude/worktrees/<slug> origin/<default>`, slug `<repo>-<ticket#>-<short-kebab-description>`.
2. Launch the `implementer` agent in the background with pointers only: ticket number, PRD number, worktree path. Add to its brief: finish by pushing the branch and opening a PR whose body follows the `pr` skill and carries `Closes: #<ticket>` on its own line; report the PR number with its usual report; write anything long to a file and return the path.

*Done when:* the implementer returns a PR number, or a question, which is a HITL block.

### Review

Launch three reviewer subagents in parallel, read-only, each on one **angle**. Brief each with the PR number, ticket number, PRD number, its angle, and an output file path. Keep the implementer's report out of their briefs, so each reviewer meets the diff cold.

| Angle | Looks for |
|---|---|
| Correctness | each acceptance criterion met; bugs, edge cases, error paths |
| Tests | each new test fails without the change; behaviour tested through public interfaces; acceptance criteria with no test |
| Fit | PRD intent, ADRs, `CONTEXT.md` vocabulary, repo conventions, scope creep; supply chain when dependencies, CI, images, or IaC change |

Each finding carries `path:line`, the claim, a concrete failure scenario, and a severity.

*Done when:* all three files exist.

### Adjudicate

Read every finding and give it one verdict:

- **fix**: real and inside the ticket's scope.
- **follow-up**: real but outside it. Open an issue with `## Parent` naming the PRD, label `needs-triage`, and wire a blocking edge if it gates another ticket.
- **reject**: wrong, duplicated, or not worth the change; give a one-line reason.
- **decide**: needs a product or design decision. This is a HITL block.

Route any finding you doubt through the `verifier` agent before ruling; its evidence decides. Post the full verdict table as one PR comment.

*Done when:* every finding has a verdict on the PR. No **fix** verdicts: go to **Merge**.

### Fix

Resume the same implementer with `SendMessage`, pointing at the verdict comment; it pushes fix commits to the PR branch. If it cannot be resumed, launch a fresh `implementer` pointed at the PR, the worktree, and the comment. Then the `verifier` agent checks the new commits against each **fix** verdict. Each fix gets one verdict: confirmed or refuted. A refuted fix starts the next round.

*Done when:* every fix is confirmed. Two rounds without that is a HITL block.

### Merge

1. Watch CI with `gh pr checks <pr> --watch` as a background command; its exit wakes you.
2. Red, caused by the ticket's code: a fix round (counts toward the two). Red for any other cause: `gh run rerun <run-id> --failed` once; red again is a HITL block.
3. Green: if `origin/<default>` moved since the branch was cut, have the implementer rebase and push, then wait for CI again. Merge with the repo's method and `--delete-branch`.
4. Confirm the ticket closed; if the closing keyword missed, close it with a comment linking the PR.
5. `git worktree remove ~/.claude/worktrees/<slug>`, delete the local branch, and comment on the PRD.

*Done when:* the PR is merged, the ticket closed, the worktree gone. Return to **Pick**.

### On a HITL block

Park the ticket, comment on the PRD, and return to **Pick**. The loop keeps working everything a parked ticket does not block.

## Budget

Above 70% of the 5-hour limit, keep looping, but route read-only recon that touches no secrets to Flash, per the global routing rule. When the user says they are near the limit, or a call fails on the limit, finish the step in flight, merge or park the ticket, and go to **Stop**.

## 3. Stop

The loop stops when the frontier is empty or the budget runs out. Send one report:

- **Merged**: ticket → PR, one line each.
- **Parked**: ticket, its question, your recommendation.
- **Still blocked**: ticket → the open blocker holding it.
- **Follow-ups opened**: issue numbers and titles.
- **Next**: what unblocks the most work once the user answers.

Then send a push notification with a one-line summary, since the user is likely away.
