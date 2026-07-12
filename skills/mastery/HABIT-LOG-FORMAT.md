# HABIT-LOG-FORMAT.md

`HABIT-LOG.md` lives at the workspace root. It is the consistency and session log. It serves two purposes:

1. **Habit protection.** The single most important thing in the early weeks is showing up. The log makes showing up visible.
2. **Calibration signal.** Session length, rep count, and what was hard are the raw data for the next prerequisite audit.

From the book:

> "If I've learned anything about habit formation and maintenance, it's that you've absolutely got to stay consistent, even (and especially) during those times when you need to dial back the total volume. Obviously you'll move slower when you throttle the volume, but at least you'll protect the habit."

> "When someone gets derailed from their journey to get better at writing, math, coding, an instrument, a sport, or whatever it may be, it's almost always the same story: at some point they fell off the wagon entirely and never managed to get back on."

## Template

```md
# Habit Log

## Streak

Current streak: {N} days
Longest streak: {N} days
Last session: {date}
Next session: {date or "tomorrow morning"}

## Rule

{The user's daily minimum. E.g. "At least 10 minutes, first thing in the morning, before shower." Set in the first session. Never zero.}

## Review queue

Single source of truth for spaced reviews. Checked at the start of every session. A review is due = run it BEFORE advancing to new material. The spaced review IS the test of automaticity; without it, `[x]` marks are provisional.

| Node | Last drilled | Next review | Interval | Protocol | Status |
|------|-------------|-------------|----------|----------|--------|
| {node name} | {date} | {date} | {Nd} | {what to re-implement, what test to run} | {due/clean/failed} |

**Rule:** if a review is due and the user fails (can't reproduce clean from memory), halve the interval to 1 day and mark the tree node `[^]` for fortification. If the user passes, double the interval. This is the spaced repetition engine — it only works if we run it.

## Sessions

### {YYYY-MM-DD}
- Duration: {minutes}
- Node drilled: {skill tree node}
- Rep count: {N}
- What was hard: {1 sentence}
- What was easy: {1 sentence}
- Silly mistakes: {count or pattern}
- Bar met: understanding / automaticity / fortified
- Next session target: {node or "review {node}"}

### {YYYY-MM-DD}
{...}
```

## Rules

- **Record every session.** No exceptions. If the user did 5 minutes, record 5 minutes. If they skipped, record skipped — and schedule a make-up.
- **The daily minimum is sacred.** Work with the user to set it in the first session. Default: 10 minutes, first thing in the morning, before shower. The book is explicit on morning training: it shields the schedule from unexpected events, gives no time to consider skipping, and provides a clear trigger and reward via operant conditioning.
- **Never zero.** If the user needs to dial back volume, dial back to the daily minimum, never to zero. "Once you've got a good habit going, do everything you can to protect it."
- **Record the rep count, not just the duration.** Duration measures time; rep count measures volume. Volume is what compounds.
- **Record silly mistakes.** Patterns of silly mistakes are the signal that a prerequisite needs fortification. This is calibration gold for the next prerequisite audit.
- **Record the bar met.** This is what tells you whether to advance on the skill tree, drill more, or fortify.
- **Record what was hard and what was easy.** "Hard but made progress" = right calibration. "Easy" = calibration too low, add weight. "Hard and no progress" = calibration too high, drop back.
- **Don't moralise skips.** Record them, schedule a make-up, move on. The book: "Don't overreact to bad days. Even if you're making the right decisions, you can still have bad days."

## Streak mechanics

- **Current streak** counts consecutive days with at least the daily minimum.
- **Longest streak** is the high-water mark. Visible for motivation.
- **A skip resets the current streak.** This is intentional. The cost of a skip should be visible.
- **But a skip is not a failure.** It's a data point. The book: "It always becomes a battle of willpower by the end." Skips happen. The goal is not zero skips; the goal is that skips don't become the pattern.
- **If the user skips twice in a week, flag it.** Gently. Ask what's getting in the way. Usually it's not lack of motivation — it's a calibration issue (lesson too hard, too long, too boring) or an environment issue (wrong time of day, no quiet space). Treat it as an engineering problem.

## Irregular schedules

The skill assumes daily practice. Reality: users with jobs, university, or caregiving responsibilities may not be able to practice daily. Acknowledge this without moralizing. Adapt spacing relative to actual session frequency, not calendar days. At lower frequency, more of each session goes to re-learning — name the consequence and move on.

- **Do not moralize gaps.** The book: "Don't overreact to bad days." A 6-day gap is a data point, not a character flaw. Record it, adapt spacing, move on.
- **Name the consequence.** At lower frequency, decay outpaces consolidation. More of each session goes to re-learning instead of advancing. This is the math, not a judgment.
- **The review queue is how you detect decay.** If a node was `[x]` but the spaced review fails, it decays to `[^]` and the interval halves. This is the system working as designed — the review caught the decay before a new lesson built on sand.
- **Set realistic intervals.** If the user can only practice 2-3 times per week, a "3-day" interval is effectively "next session." Calibrate intervals to session frequency, not calendar days.

## What this is not

- **Not a journal.** Don't record feelings, reflections, or narrative. Record data.
- **Not a lesson plan.** The next session target is one line, not a plan. The plan is in `SKILL-TREE.md` and the next lesson.
- **Not a substitute for learning records.** Learning records are decision-grade insights. The habit log is raw calibration data.

## Using the log in the prerequisite audit

Before each lesson, read the recent sessions in `HABIT-LOG.md`:

- If silly mistakes are trending up on a prerequisite, fortify it before advancing.
- If the user has been skipping or shortening sessions, address the habit before pushing content.
- If the bar met has been "understanding" for several sessions on the same node, the user is stuck — they need more reps or a different angle, not a new node.
- If the bar met has been "automaticity" on the current node for 2-3 sessions, it's time to advance or layer.
