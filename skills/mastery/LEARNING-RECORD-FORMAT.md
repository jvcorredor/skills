# LEARNING-RECORD-FORMAT.md

Learning records live in `./learning-records/` and use sequential numbering: `0001-slug.md`, `0002-slug.md`, etc. Create the directory lazily — only when the first record is written.

They are the teaching equivalent of ADRs: they capture non-obvious lessons, key insights, and stated prior knowledge that will steer future sessions. They are the primary input to the prerequisite audit before each lesson.

In a `/mastery` workspace, the bar for what counts as "learned" is **higher** than in `/teach`. Understanding is necessary but not sufficient. The bar is automatic, low-error execution under load.

## Template

```md
# {Short title of what was learned or established}

{1-3 sentences: what was learned (or what prior knowledge was established), and why it matters for future sessions.}
```

That is the whole format. A learning record can be a single paragraph. The value is recording _that_ this is now known and _why_ it changes what to teach next — not in filling out sections.

## Optional sections

Only include these when they add genuine value. Most records won't need them.

- **Status** frontmatter (`active | superseded by LR-NNNN`) — useful when an earlier understanding turns out to be wrong and is replaced.
- **Bar** — what bar was met: `understanding` | `automaticity` | `fortified`. The default is `understanding`; most records will want a higher bar. See below.
- **Evidence** — how the user demonstrated the understanding or automaticity. A quiz score, a rep count under time pressure, a problem solved without reference, a silly-mistake rate. Useful when the claim might be revisited.
- **Implications** — what this unlocks or rules out for future sessions. Worth recording when non-obvious.
- **Prerequisite audit result** — if this record was produced by a prerequisite audit, name the node audited and the verdict (advance / fortify X first / drop back to Y).

## The bar

In `/teach`, a learning record is written when the user "demonstrated genuine understanding of something non-trivial." In `/mastery`, that bar is too low.

Understanding is what allows the user to follow along. Automaticity is what allows the user to execute without using working memory. The book is explicit:

- "If you're making silly mistakes, then you need more practice, simple as that."
- "To have enough mental bandwidth to think deeply about a complex situation, you need total fluency in the fundamentals. They must lie well beneath your edge of ability."
- "You can operate at that edge – but not comfortably – and that makes all the difference."

The three bars:

1. **Understanding** — the user can explain the concept, can follow along when someone else executes it, can recognise correct and incorrect executions. This is the floor, not the goal.
2. **Automaticity** — the user can execute the skill correctly, quickly, and with low error rate under load (time pressure, distraction, interleaving with other skills, no reference material). This is the bar for advancing in `/mastery`.
3. **Fortified** — the user can execute the skill correctly while performing a higher-level skill on top of it. This is the bar for marking a node `[x]` and leaving it alone for a while.

When writing a learning record, name the bar. When the bar is `automaticity` or `fortified`, name the evidence.

## Numbering

Scan `./learning-records/` for the highest existing number and increment by one.

## When to write a learning record

Write one when any of these is true:

1. **The user demonstrated automaticity on something non-trivial** — not just understanding, but automatic, low-error execution under load. This is the signal to advance on the skill tree. Name the evidence.
2. **The user disclosed prior knowledge** — "I already know X." Record it, and record the _depth_ claimed. Then verify with a quick calibration task before marking it `[x]` on the tree. Self-report is not evidence.
3. **A misconception was corrected** — the user previously believed something wrong and now sees why. These are high-value: they predict future stumbling blocks for related topics.
4. **A prerequisite audit was performed** — record the verdict, the evidence, and the implication for the next lesson.
5. **The mission shifted in response to learning** — the user discovered they cared about something different than they thought. Cross-link to `MISSION.md` and update it.
6. **A silly mistake pattern was observed** — record the pattern and the prerequisite it points to. This drives the next prerequisite audit.

### What does _not_ qualify

- Material that was merely covered. Coverage is not learning. Wait for evidence.
- Material the user only understands but cannot execute automatically. Record this as a `[~]` on the tree, not as a learning record — unless you want to capture _why_ it's not yet automatic and what would get it there.
- Anything already captured tersely in `GLOSSARY.md` as a term definition. Don't duplicate.
- Session-by-session activity logs. That's what `HABIT-LOG.md` is for. Learning records are decision-grade insights.

## Supersession

When a later record contradicts an earlier one (the user's understanding deepened, or automaticity decayed and needs re-fortification), mark the old record `Status: superseded by LR-NNNN` rather than deleting it. The history of how understanding evolved is itself useful signal.

Automaticity decay is normal and expected. If a skill that was `[x]` six months ago is now shaky, that's not a failure — it's a signal to schedule fortification. Record it.
