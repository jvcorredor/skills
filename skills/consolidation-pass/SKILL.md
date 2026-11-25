---
name: consolidation-pass
description: Audit recent work in a repo or feature set for coherence, duplication and growth past its purpose, from both the product's and the code's side, then turn the adjudicated findings into a workstream. Use at a checkpoint (a workstream PRD closes, a freeze is near, the same question returns a third time) or when the user asks for a consolidation, coherence or refinement pass.
argument-hint: "[repo, area or feature set; and the window, e.g. since a date, a tag or the last pass]"
---

# Consolidation pass

Work that lands as a run of reactive changes is each time reasonable alone. A **consolidation pass** asks the question nobody asked along the way: do the pieces still fit one another and the project's goal, or would a simpler thing now do the work of several?

You are the **lead** of the pass. **Cold** agents read and judge; you set the scope and the **yardstick**, adjudicate with the user, and hand the result to a workstream. The pass itself changes nothing in the repo: every change waits for that workstream.

## Roles

| Role | Does | Count |
|---|---|---|
| **Lead** (you) | Scope, yardstick, sizes, briefs, adjudication with the user | 1 |
| **Area reader** | Reads one area of the scope through every lens | one per area, 3 to 6 |
| **Product reader** | Reads the whole scope from the user's seat: the PRDs, the docs, the command line or screens | 1 |
| **History reader** | Reads the record (issues, pull requests, review and decision comments) for what drove each addition | 1 |
| **Builder** | The session or person that built the work lists its own doubts | 0 or 1 |
| **Synthesiser** | Merges every notes file into one report | 1 |
| **Checker** | Tests the report's claims against the code and the record | 1 |

Every reader, the synthesiser and the checker is **cold**: a fresh agent that did not build the work, briefed in writing, read-only. A finder never grades its own findings, so the checker is none of the readers. All of them judge, so give them the model tier you would trust with a judgement, per the user's model routing.

The lenses are in [references/lenses.md](references/lenses.md). The brief each role receives, and the shape of a **finding**, are in [references/briefs.md](references/briefs.md). Read both before step 4.

## 1. Scope

1. Name the **scope** (a repo, an area, a feature set) and the **window** (since the last pass, a tag, a date, or the start of a named workstream). An argument gives them; else propose them from the recent history and say so.
2. Pin a commit. Give the readers a read-only snapshot of it (a worktree nobody edits) and the paths of the record they may read.
3. Make a working folder outside the repo: `brief.md`, `notes/`, `report.md`. Nothing of the pass lands in the tree.
4. If the window holds less than about one workstream of change, say so and stop: there is nothing yet to consolidate.

*Done when:* scope, window, commit and folder are written at the top of `brief.md`.

## 2. Yardstick

The readers judge against the project's own goal and principles, never their taste.

1. Collect the goal the scope serves and the principles it is held to, **in the user's words**, each with its source (a PRD, an ADR, a README, something the user said).
2. Add the general ones every pass carries: small over large; one way to do one thing; build what the current goal needs and defer the rest with a trigger.
3. Mark any principle that is your own inference as yours.
4. If the project states no goal or principles for the scope, ask the user for them once, before any reader starts.

*Done when:* every line of the yardstick has a source or is marked as the lead's.

## 3. Sizes

Measure the scope at the pinned commit and at the start of the window: files and lines by kind (code, tests, docs, rules and config), and the running time of the test suite when it is known. Put both columns and the difference in `brief.md`. This table is how growth is tracked from one pass to the next.

*Done when:* the table has both columns for every kind.

## 4. Read

1. Split the scope into areas so that every file belongs to exactly one area reader.
2. Launch all readers in parallel, in the background, each with `brief.md` and its own assignment and notes file name.
3. Ask the builder, when there is one, for its own list of doubts. Its list is a set of claims like any other and goes through the checker.

*Done when:* every notes file exists and has every section the brief requires.

## 5. Synthesise

One synthesiser reads every notes file and writes `report.md`: an overall judgement, the size table, the findings merged and ranked, what works and must stay, doubts about past decisions, and what nobody read. Readers that disagree stay visible as a disagreement.

*Done when:* every finding in every notes file is in the report, or is named as merged into another.

## 6. Check

The checker tests claims against the code and the record: every finding whose verdict is REMOVE or MERGE, every finding you mean to put to the user, and a sample of the rest. Each gets `confirmed`, `partly` (with the correction) or `refuted`. Correct the report from its results; a refuted finding is struck, visibly.

*Done when:* every finding that will reach the user carries a check result.

## 7. Adjudicate

1. Write your own judgement at the top of the report, in a few paragraphs: where the scope is coherent, where it grew past its purpose, and what drove the growth. Include your own past decisions where the readers doubted them.
2. Pick the decisions that are the **user's**: anything that changes what the product does, removes something the user asked for, or reverses a decision the user made. Keep this list short. Put them to the user **one per turn**, each with your recommendation and what is lost.
3. Rule on the rest yourself, and give every finding a **fate**: do, with a bin (`before the next freeze`, `any time`, `after <a named event>`); or drop, with the reason.
4. Record the decisions where the project keeps decisions, and show the user the report.

*Done when:* every finding has a fate and every user decision has an answer.

## 8. Hand off

1. Turn the findings marked *do* into a workstream: a PRD whose goal is a smaller, more coherent scope with behaviour unchanged except where a decision says so, then its tickets (the `to-prd` and `to-issues` skills where present), driven like any other workstream.
2. Ask each of its pull requests to report net lines by kind.
3. When the workstream closes, measure again and add the column to the size table: the pass is finished when the table shows its effect.

Until that workstream lands, weigh size in every new change to the scope: an addition names the existing thing that could have taken it, and why it could not.

*Done when:* the PRD and its tickets exist, or the user has declined them.
