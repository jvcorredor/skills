# Lenses

Every reader looks through all of these; the product reader leans on 1 and 2, the history reader on 3 and 7, the area readers on 3 to 5. A finding names the lens it came from.

## 1. Product coherence

Read from the seat of the person who uses the thing, with the docs and the surface in front of you (commands, flags, screens, settings, messages).

- Two things that do one job. Which one would a new user be told to use?
- Two features that make no sense given each other: one makes the other unreachable, pointless or contradictory.
- An area overbuilt until it confuses: more modes, options, states or messages than the job has cases.
- A setting nobody chose: it exists because a default was once in doubt.
- One concept under two names, or one name for two concepts.
- What a newcomer must learn that the goal does not need them to know.

## 2. Requirements drift

Read the PRDs and decision records beside what was built.

- Built, and never asked for.
- Asked for, later superseded, and still there.
- Decisions taken during build or review that contradict or shadow one another.
- An exception to a rule that has grown as large as the rule.
- A requirement that is met twice, by two mechanisms.

## 3. Reactive additions

- What was added to answer one finding? Name the cause (issue, pull request, review comment); write "cause not found" when you did not find it.
- Is the cause still live, or did a later decision remove it, so the mechanism now guards nothing?
- A backstop behind another guard that has always caught the case first.

## 4. Structure

Use the project's design vocabulary where it has one (the `codebase-design` skill's **module**, **interface**, **depth**, **seam** where present).

- Shallow modules: a caller must know nearly as much as the implementation.
- The **deletion test**: would deleting it concentrate complexity, or only move it?
- The same logic in two places; one piece that would replace several scattered ones.
- Behaviour held somewhere odd for it (a document that a test cuts out and runs, a script inside prose, a rule enforced only by convention).

## 5. Proportion

- Size (lines, files, test time, a reader's attention) against what the thing protects. What breaks for the user, and how badly, if it is removed?
- Instruments and their policing: checks of checks, tests of wording, rules about rules, docs that describe docs. Each must name the fault it has caught or would catch.
- Ceremony out of scale with the risk: a release checklist for a personal tool, a full review loop for a reversible one-line change.

## 6. What works

Say plainly what serves the goal well and must not be touched. A pass that only lists faults invites breaking what works.

## 7. Past decisions

The decisions of whoever steered the work (the user, a lead, reviewers) are in scope like any code. Which additions did a ruling cause? Which ruling do you doubt, and is there a simpler way to get what it was for? Does any text claim more than its evidence shows? Say it bluntly.
