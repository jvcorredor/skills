---
name: drive-prd
description: Drive a PRD's tickets under a WIP cap through implementer, independent review, fixes, a head-pinned verdict, CI, and merge, parking human-only work, until no agent-ready ticket remains.
argument-hint: "[PRD issue number or URL; defaults to the session's PRD]"
---

# Drive PRD

You are the **orchestrator** of one PRD workstream. Subagents build, review, and verify; you pick tickets, adjudicate findings, and merge. Every ticket you claim ends **merged** or **parked**, and the loop runs until **Stop** holds.

The issue tracker and triage label vocabulary should have been provided to you (`docs/agents/` or the repo's `AGENTS.md`/`CLAUDE.md`). If not, tell the user to run `/setup-matt-pocock-skills`. Label names below are the canonical roles; use the repo's mapping.

## Vocabulary

- **Workstream**: the PRD issue plus every ticket linked to it: its sub-issues, or issues whose `## Parent` section names the PRD.
- **Blocking issue**: an issue in the ticket's native blocked-by relationship (`gh api repos/{owner}/{repo}/issues/<n>/dependencies/blocked_by`), else one listed in its `## Blocked by` section.
- **Frontier**: workstream tickets that are open, labelled `ready-for-agent`, unassigned, with every blocking issue closed.
- **Claim**: assign the ticket to yourself (`gh issue edit <n> --add-assignee @me`) before any work on it.
- **Park**: hand a ticket to the human. Swap `ready-for-agent` for `ready-for-human`, unassign, and comment the exact question with your recommendation. If it has a PR, convert it to draft (`gh pr ready <n> --undo`) and keep its worktree. A parked ticket stays open, so its dependents leave the frontier with it.
- **HITL block**: any of these parks the ticket:
  - the implementer stops with a question or design decision;
  - a finding adjudicates to **decide**;
  - the fix budget (see Fix) runs out, or a check gets no answer: neither is approval;
  - CI is red for a cause outside the ticket, twice;
  - a rebase conflict whose resolution needs judgement;
  - branch protection or a required human review blocks the merge;
  - the work touches secrets or a live cluster.
- **Severity**: *blocker* = the intended case is wrong; *should* = a real bug callers will hit; *nit* = everything else. Only a blocker or should that can be **shown** (a failing run or test, or a line the PR made wrong) blocks.
- **Head verdict**: one PR comment whose text a cold `verifier` writes to a file and you post verbatim, never writing or editing a `VERDICT:` yourself. First line `VERDICT: PASS|PASS+NOTES|FAIL @ <full 40-char head sha>`, then a ledger with one line per finding: `S<n> [blocker|should|nit] path:line claim → fixed|declined(<reason>)|open`. Your own read and the implementer's never count. A head verdict covers a later head only when `git patch-id --verbatim` of the PR diff is unchanged (a pure rebase); any other push needs a fresh one. Only comments whose author association is OWNER, MEMBER, or COLLABORATOR count. A PASS or PASS+NOTES whose ledger has a `[blocker]` or `[should]` line ending `→ open` counts as FAIL.

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

**WIP cap**, per orchestrator session: a ticket is *active* when claimed and not HITL-parked (a PR waiting only on someone else's merge stays active). At most 1 active ticket in Build and at most 3 active in total; a ticket in Build counts as its future PR. A full cap means wait, not start more. Each step ends on its completion criterion before the next starts.

### Pick

Re-fetch the frontier: merges unblock tickets, and the user may edit the tracker between iterations. Pick the ticket that unblocks the most open workstream tickets; break ties by lowest number. A ticket that touches the same files, modules, or ADR as an active ticket waits: such tickets run one after another. Claim it. A frontier ticket that already has a PR (unparked) re-enters at **Verify**: re-claim it and keep its PR and worktree; its round count restarts. Cap full, or only waiting tickets left: wait for an active ticket to merge or park. When **Stop** holds, go there.

*Done when:* one ticket is claimed, or the cap or an overlap holds you.

### Build

1. `git fetch origin`, then branch the worktree from the freshly merged default branch, never from local HEAD:
   `git worktree add -b <slug> ~/.claude/worktrees/<slug> origin/<default>`, slug `<repo>-<ticket#>-<short-kebab-description>`.
2. Launch the `implementer` agent in the background with pointers only: ticket number, PRD number, worktree path. Add to its brief: finish by pushing the branch and opening a PR whose body follows the `pr` skill and carries `Closes: #<ticket>` on its own line; report the PR number with its usual report; write anything long to a file and return the path.

*Done when:* the implementer returns a PR number, or a question, which is a HITL block.

### Review

Launch three reviewer subagents in parallel, read-only, each on one **angle**. Brief each with the PR number, ticket number, PRD number, its angle, and an output file path. Keep the implementer's report out of their briefs, so each reviewer meets the diff cold. Brief them: correctness gaps only, skip style.

| Angle | Looks for |
|---|---|
| Correctness | each acceptance criterion met; bugs, edge cases, error paths |
| Tests | each new test fails without the change; behaviour tested through public interfaces; acceptance criteria with no test. For IaC, CI and config files, plan or validate output, or one negative case, is proof enough: never ask for a check that pins the repo's own text, config values or upstream shapes |
| Fit | PRD intent, ADRs, `CONTEXT.md` vocabulary, repo conventions, scope creep; supply chain when dependencies, CI, images, or IaC change; any growth in CI wall time or check code, which must be justified |

Each finding carries `path:line`, the claim, a concrete failure scenario, and a severity (blocker, should, or nit).

*Done when:* all three files exist.

### Adjudicate

Read every finding and give it one verdict:

- **fix**: a blocker or should that can be shown, inside the ticket's scope. A nit never blocks, and a blocker or should that cannot be shown is downgraded to a nit: collect nits in ONE follow-up issue per PRD (append to it if it exists).
- **follow-up**: real but outside it. Open an issue with `## Parent` naming the PRD, label `needs-triage`, and wire a blocking edge if it gates another ticket.
- **reject**: wrong, duplicated, or not worth the change; give a one-line reason. Reject a finding whose only fix is another guard arm or regression test, unless it names a costly failure the existing checks miss. A finding about a check is fixed in that check.
- **decide**: needs a product or design decision. This is a HITL block.

Route any finding you doubt through the `verifier` agent before ruling; its evidence decides. Post the full verdict table as one PR comment.

*Done when:* every finding has a verdict on the PR. Then go to **Fix**, or to **Verify** when no finding is **fix**.

### Fix

Resume the same implementer with `SendMessage`, pointing at the verdict comment; it pushes fix commits to the PR branch. If it cannot be resumed, launch a fresh `implementer` pointed at the PR, the worktree, and the comment. Add to the brief:

- The verdict table and every ruling you have made on this PRD (quote them, or link the comments) bind the fix. Change only what a **fix** verdict asks for.
- For a fix to code, first write a test that fails without the fix, then fix, then run the full test suite and linters, not just the new test. IaC, CI and config fixes follow the Tests angle's proof rule instead.
- Report each fix commit against the verdict it answers, and list any other change with its reason.

**Fix budget:** 3 rounds, or 5 when the PR touches live-safety code (guards, applies, secrets, destroys, release scripts). Running out, or getting no answer, is a HITL block: the PR is parked.

*Done when:* the fix commits are pushed. Go to **Verify**.

### Verify

After every push, a rebase included, `merge-gate` decides whether the last head verdict carries over. If not, launch one fresh `verifier`, briefed without the implementer's report: PR number, head sha, the adjudication comment, the rulings, and the head verdict format. It checks the PR at the new head, each **fix** verdict and ruling included. A change no verdict or ruling asks for, or one that contradicts a ruling, is an open ledger line. FAIL needs an open blocker or should that can be shown.

*Done when:* the latest head verdict names the current head. PASS or PASS+NOTES: put each open `[nit]` line in the PRD's single nit issue, then go to **Merge**. FAIL: its open blocker and should lines become **fix** verdicts; another **Fix** round.

### Merge

1. Watch CI with `gh pr checks <pr> --watch` as a background command; its exit wakes you.
2. Red, caused by the ticket's code: a fix round (counts toward the budget), then **Verify**. Red for any other cause: `gh run rerun <run-id> --failed` once; red again is a HITL block.
3. Green: if `origin/<default>` moved since the branch was cut, have the implementer rebase and push, then return to **Verify** and wait for CI again.
4. Merge only when CI is green and the latest head verdict (a `VERDICT:` comment from a counted author) is not FAIL and names the current head sha in full (`gh pr view <pr> --json headRefOid`), or carries over (`merge-gate` reports `carried`). Merge with the repo's method and `--delete-branch`.
5. Confirm the ticket closed; if the closing keyword missed, close it with a comment linking the PR.
6. `git worktree remove ~/.claude/worktrees/<slug>`, delete the local branch, and comment on the PRD.

*Done when:* the PR is merged, the ticket closed, the worktree gone. Return to **Pick**.

### On a HITL block

Park the ticket, comment on the PRD, and return to **Pick**. The loop keeps working everything a parked ticket does not block.

## Budget

Above 70% of the 5-hour limit, keep looping, but route read-only recon that touches no secrets to Flash, per the global routing rule. When the user says they are near the limit, or a call fails on the limit, finish the step in flight, merge or park the ticket, and go to **Stop**.

## 3. Stop

The loop stops when no active ticket can progress without the user and no frontier ticket can start (the frontier is empty, the cap is full, or every pick overlaps an active ticket), or the budget runs out. Send one report:

- **Merged**: ticket → PR, one line each.
- **Parked**: ticket, its question, your recommendation.
- **Still blocked**: ticket → the open blocking issue holding it.
- **Follow-ups opened**: issue numbers and titles.
- **Next**: what unblocks the most work once the user answers.

Then send a push notification with a one-line summary, since the user is likely away.
