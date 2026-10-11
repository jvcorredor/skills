---
name: guided-implementation
description: Pair-programming mode that builds a task in small approved units, explains each design decision, and gates every unit on the user's approval. Use when the user says "implement this with me", "guided implementation", "pair with me on this issue", "teach me while implementing", or invokes /guided-implementation. Plain "implement X" requests and explaining an existing diff belong elsewhere.
---

# Guided implementation

You are pairing with an experienced platform/software engineer who may be new to this repository or stack. The deliverable is the change **and** their grasp of its architecture, interfaces, tests, and operational tradeoffs. Spend interaction on that. Keep prose concise and technically rigorous; label uncertain claims as uncertain.

## Vocabulary

- **Unit**: one small change, independently explainable and verifiable, landing as one commit.
- **Card**: the pitch for a unit, shown before it is built.
- **Gate**: a stop where you wait for the user's reply.

## Permission boundary

| Free | Granted by approval | Always ask |
|---|---|---|
| Read, search, `git log/diff/status/blame/show`, `gh issue/pr view` | Plan approval: create the branch or worktree the user's instructions call for | Dependency changes, generators, migrations, codegen not named on an approved card |
| Existing tests, lint, typecheck as already configured, when they need no install step or external services | Unit approval: that unit's edits, any dependency change named on its card, its verification runs, and its one commit | Push, PR, any remote or live-cluster action |
| | | A baseline run needing an install, Docker, or credentials: propose it as unit 0, carded like any other |

You make every edit, test run, and commit yourself, so each explanation comes from the code you wrote. The session's record lives in commit bodies and the wrap-up; the repo gains only the agreed changes.

## 1. Kickoff

Inspect the task or issue text, repo instructions (`AGENTS.md`, `CLAUDE.md`), the modules the task touches, the tests and how they run, CI config, and dependency manifests. On a large repo an `Explore` subagent may map it; confirm its findings before relying on them. Run the baseline tests when the boundary allows.

Send one message, then gate. When open questions exist, that message carries the orientation and the first question only; each later message carries one question; the decomposition follows once all are settled.

1. **Orientation**: only what touches this task: relevant paths and entry points, how tests run and the baseline result, what CI enforces, constraints from repo instructions. Offer `show-me` when a diagram would help.
2. **Open questions**: ambiguities or design forks that would change the plan. When any exist, ask them one at a time with your recommendation, and hold the decomposition until all are settled.
3. **Decomposition**: numbered units, one line each: goal plus the check that proves it. Order interfaces before implementations, and the shortest path to something runnable first. Aim for 3–8 units; past ~10, say so and suggest splitting the work (e.g. `to-issues`).

Kickoff is done when the user approves or edits the plan. Then create the branch or worktree; your next message carries the unit 1 card.

## 2. Unit loop

### Card

```
Unit N/M: <title>
Goal:          what this unit achieves
Why now:       how it connects to existing code and earlier units
Files:         expected to change
Interface:     public API / CLI / config / schema implications
Alternatives:  the real options, and the recommended one with its reason
Supply chain:  see SUPPLY-CHAIN.md
Verification:  the test that goes red first, or the check that proves it
Ask:           an approval request, or one focused question
```

Goal, Files, Verification, and Ask always appear. Every other field collapses to one line or vanishes when it does not apply: Alternatives only when there is a real choice; Supply chain only when the unit touches dependencies, CI, container images, or infrastructure-as-code, and then read [SUPPLY-CHAIN.md](SUPPLY-CHAIN.md) before writing the card.

### Build

On approval, build exactly that unit:

- **Behaviour change with a test harness**: write the test, run it, capture the red (the failing assertion). Implement, run it, capture the green. Place tests at the seams `tdd` describes, through public interfaces; the gates here stay in charge of the loop.
- **Everything else** (config, docs, CI, refactor under existing tests): run the check that fits: the existing suite stays green, a lint, a dry-run, a `plan`.
- **Commit**: one Conventional Commit. The body states the decision made and the main alternative rejected, in one or two lines.

Prefer the repo's conventions over new abstractions; keep the change small, idiomatic, and production-appropriate. When the work surfaces anything outside the approved unit (a new unit, an unsettled design fork that materially affects the codebase, an ambiguity, a verification failure whose fix needs wider scope), stop and ask, with your recommendation.

### Report, next card

Send one message, then gate:

```
Unit N done
  diff summary (git show --stat), excerpts or explanation of non-obvious code,
  commands run with results (the red's failing assertion, then the green),
  new risks / assumptions / follow-ups
Next: unit N+1
  the card
```

After the last unit, the wrap-up (below) takes the place of the next card.

### Handling the reply

The user reviews the diff and brings their own questions. Answer every question first, rigorously, with pointers into the diff. Questions alone leave the gate closed; build only on an explicit approval, which may share the reply. Then act on the rest:

- **approve**: build the unit.
- **revise** on an unbuilt card: re-present the card with the change, building nothing.
- **revise unit K: …** on a finished unit: a new card for the fix, landing as its own commit; existing history stays as it is. The fix card goes next; the pending card follows it.

## Autopilot

"autopilot" covers all remaining units; "autopilot through unit N" covers a range. Either reply also approves the pending card. Build approved units back to back without gates, still committing each one and posting a short per-unit summary (diff summary, commands with results, new risks).

Autopilot still stops for: a unit absent from the approved plan, an unsettled design fork, a verification failure unfixable within the unit's scope, and anything in the always-ask column. After a bounded run, send the next card and resume gating. "guided" or "pause" restores the gates once the unit in progress finishes.

## 3. Wrap-up

After the last unit, run the full verification once and send:

- units with commit SHAs
- decisions made
- deferred items and follow-ups
- the final verification result

Then one ask: hand off to `pr-cleanup` (push, PR, CI, prune), with a **Design decisions** section in the PR body drawn from this wrap-up.
