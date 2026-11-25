# Briefs

The lead writes one `brief.md` that every cold agent receives whole, then a short assignment per agent. A brief is the only context its reader has: point at files and records, and state the rules of the read in full.

## `brief.md`

1. **Why this pass exists**: the trigger, and the user's own words when they asked for it.
2. **Scope, window, pinned commit**, and the size table.
3. **What you may read**: the snapshot's path; the record (issues, pull requests, comments) and how to query it read-only; the PRDs and decision records by name. Then what stays closed, with the project's confidentiality rules stated in full.
4. **The rules of the read**: you change nothing; you build nothing into the snapshot; you run the test suite only if the brief says it is cheap; you start no agent of your own; you search nothing outside the project unless the brief allows it.
5. **The yardstick**: the goal, then each principle with its source, the lead's own marked as such.
6. **What to look for**: the lenses, by pointer to `lenses.md` or copied in.
7. **What you write**: the notes file below.
8. **What you return**: at most 15 lines: the path of your file, a one-paragraph judgement, your five most valuable findings by id. A separate reader will check your findings against the code, so give exact paths and lines and state no more than you saw.

## A finding

Every finding, from any role, has this shape:

- **id**: the reader's letter and a number (`C4`).
- **what**: the thing, with `path:line`, and the lens.
- **cause**: why it exists, with the issue or pull request when found; else "cause not found".
- **verdict**: one of KEEP, SIMPLIFY, MERGE (with what), MOVE (where), REMOVE.
- **evidence**, and how sure: sure, likely, or a guess.
- **loss**: what is lost or risked by the change.
- **saving**: a rough size, in lines or files.
- **bin**: `before the next freeze` (it touches something about to run unchanged, and would be frozen wrong), `any time` (safe and independent), or `after <a named event>` (a coming decision or trial may reshape it).

## A reader's notes file

1. **Summary**, ten lines at most: coherent, or grown past its purpose, and where.
2. **Sizes** measured in the area.
3. **Findings**, most valuable first.
4. **What works and must stay.**
5. **Doubts about past decisions**, in the words you would say them.
6. **What you did not read.**

## Assignments

- **Area reader**: the paths of its area, its letter, its notes file name.
- **Product reader**: the user-facing surface and docs of the whole scope and the PRDs. It reads code only to settle what the surface does.
- **History reader**: the record across the window. For each sizeable addition: what asked for it, who ruled, whether the reason still holds. It also reports the trend: what kinds of change made the scope grow.
- **Builder**: asked, not briefed: "List what you would simplify, merge or remove in what you built, and what you doubt, in the finding shape." Its answer is saved as a notes file.

## The synthesiser

Receives `brief.md` and every notes file. Writes `report.md`: the overall judgement; the size table; findings merged across readers (keeping every source id), ranked by value, grouped by bin; what works; doubts about past decisions; what nobody read. It adds no finding of its own and softens none. Two readers who disagree are reported as disagreeing.

## The checker

Receives `brief.md`, `report.md` and the list of claims to test. It is adversarial: for each claim it goes to the code and the record and tries to show it wrong. It returns one line per claim: `confirmed`, `partly` with the correction, or `refuted` with the evidence. The usual corrections are overclaims: "redundant" where one case is still covered only here, "unused" where one caller remains, a count that is off. It reads; it changes nothing.
