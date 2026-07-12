# LESSON-FORMAT.md

Lessons live in `./lessons/` as `0001-slug.html`, `0002-slug.html`, etc. Each lesson is a self-contained HTML file. Lessons are the primary unit of teaching in a `/mastery` workspace.

In `/teach`, a lesson is optimized for **one tangible win** within the user's working memory. In `/mastery`, a lesson is optimized for **a high volume of action-feedback-adjustment cycles** on a tightly-scoped skill. The lesson should leave the user winded — brain feeling like mush, or at least significantly taxed.

## What a lesson must contain

1. **A prerequisite audit summary at the top.** What node on the skill tree is this lesson drilling? What prerequisites were verified at automaticity before this lesson was designed? If the audit found a gap, the lesson should be fortifying the gap, not advancing. This is visible to the user, not hidden — they should know what tree node they're on and why.

2. **Many reps, not one win.** The lesson must produce a high volume of action-feedback-adjustment cycles on the target skill. A 30-minute session should produce a high double- or triple-digit rep count. This rules out:
   - Single worked example followed by one practice problem
   - Long think-pair-share type activities
   - Over-long single problems that take the whole session to solve once
   - Any activity that throttles the volume of cycles
   
   **From-blank-page re-implementation.** After tests pass, the user deletes the function bodies and re-implements from memory. This is the rep that builds automaticity. Tests passing is understanding; reproduction from a blank page is automaticity. **The agent deletes the bodies, not the user.** If the user deletes them, they get a last glance at the implementation immediately before re-implementing, which taints the recall assessment — it becomes recognition, not reproduction.

3. **Concrete before abstract.** Always start with concrete examples. Layer abstractions only after the user has built a zoo of concrete examples to compress. Never open with a theorem, a definition, or an abstract framework. Open with a concrete problem, a concrete instance, a concrete example.

4. **Recall before reason.** When the lesson requires the user to apply a result, they must recall the result from memory first, then justify or derive it afterwards. Never display the result alongside the prompt. Never have the user derive first and refer during practice.

5. **Spotter protocol for reference.** Any reference material, hints, or worked solutions must follow the spotter protocol:
   - The user attempts the rep unaided.
   - If they fail despite trying their hardest, a minimal hint is revealed (progressive disclosure — one small cue at a time).
   - The user attempts again.
   - Only as a last resort is the full answer revealed.
   - The user must recall the full answer from memory after seeing it before proceeding.
   - Never display the answer alongside the prompt.

6. **Calibrated difficulty.** Tasks must be just beyond the edge of capability, but achievable in a timely manner. If the user can't make measurable progress in the session, the calibration is wrong — the lesson should drop back. Include a calibration check early in the lesson: if the user can't complete the first few reps, they should stop and the agent should redesign.

7. **Measurable progress.** The lesson must have a way for the user to measure their progress within the session. Rep count, accuracy rate, time-to-solve, silly-mistake rate. Without measurement, neither the user nor the agent can tell whether the calibration is right.

8. **Spaced repetition schedule.** Each lesson specifies when the user should revisit the skill:
   - If the skill was just learned to understanding: review tomorrow.
   - If the skill was drilled to automaticity in this session: review in 3 days.
   - If the skill is being fortified after prior automaticity: review in 1 week.
   - If the skill is being reviewed after a successful prior review: double the interval.
   - If the user fails the review (can't recall, makes multiple silly mistakes): halve the interval and mark the tree node `[^]` for fortification.
   - **Provisional pass:** tests pass but not clean first try (bugs fixed via test/agent feedback). Don't double the interval; hold steady or shorten slightly. The user understands the contract but hasn't reproduced it from memory — the distinction matters.
   - **Fortifying nodes take priority.** A node marked `[^]` uses a 1-day interval and takes priority over new lessons. Clear all due reviews before advancing to new material. A fortifying node that's overdue is the highest-priority work in the session.
   - **Record reviews in the review queue.** The next review date, interval, and protocol live in the review queue section of `HABIT-LOG.md`, not only in the lesson HTML. The lesson HTML is the plan; the review queue is the execution.

9. **A primary source recommendation.** The most high-quality, high-trust resource on the topic. The user should read or watch this alongside the lesson. Lessons are not a substitute for primary sources — they are the practice arena.

10. **A reminder to ask follow-up questions.** The agent is the user's teacher. Anything unclear should be raised.

11. **Links to other lessons and reference docs** via HTML anchors.

12. **Beautiful, self-contained, printable.** GitHub-dark theme via [`assets/theme.css`](./assets/theme.css) — copy the skill's bundled `theme.css` into the workspace's `./assets/` as the baseline, then extend via `lesson.css`; don't rewrite from scratch. The user will return to these. Link a shared stylesheet from `./assets/` so the course looks like one course, not a pile of one-offs.

## Lesson template

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>{Skill name} — Mastery Lesson {NNNN}</title>
  <link rel="stylesheet" href="../assets/theme.css">
  <link rel="stylesheet" href="../assets/lesson.css">
</head>
<body>
  <header>
    <p class="breadcrumb"><a href="../SKILL-TREE.md">Tree</a> › {Branch} › {Node}</p>
    <h1>{Skill name}</h1>
    <p class="meta">Lesson {NNNN} · {date} · Target: {rep count} reps in {minutes} min</p>
  </header>

  <section class="audit">
    <h2>Prerequisite audit</h2>
    <ul>
      <li>{Prerequisite 1}: verified at automaticity ({LR-NNNN}, {date})</li>
      <li>{Prerequisite 2}: verified at automaticity ({LR-NNNN}, {date})</li>
    </ul>
    <p>Advancing to: {node name}</p>
  </section>

  <section class="concrete">
    <h2>Concrete examples</h2>
    <!-- A worked concrete example. No abstractions yet. -->
  </section>

  <section class="practice">
    <h2>Reps</h2>
    <!-- Many, many reps. Progressive difficulty. Spotter protocol on hints. -->
    <!-- Rep count target visible. Accuracy feedback immediate. -->
  </section>

  <section class="abstract">
    <h2>Compression</h2>
    <!-- Only now, after the zoo of examples, introduce the abstraction. -->
    <!-- The user should feel the compression as an "aha", not as a definition to memorize. -->
  </section>

  <section class="recall">
    <h2>Recall check</h2>
    <!-- Close the lesson with a recall check: can the user reproduce the key results from memory? -->
    <!-- This is the bar for the lesson. If they can't, they need another session on this node. -->
  </section>

  <section class="schedule">
    <h2>Spacing</h2>
    <p>Review this skill on: {date}</p>
    <p>If review is easy, double the interval next time. If review fails, halve the interval and re-fortify.</p>
  </section>

  <section class="source">
    <h2>Primary source</h2>
    <p><a href="{url}">{Title}</a> — {one line on why this source and what to focus on}</p>
  </section>

  <section class="questions">
    <h2>Stuck?</h2>
    <p>Ask the agent. Anything unclear, anything that feels like it shouldn't be this hard, any silly mistake you keep making — raise it. The agent is your teacher.</p>
  </section>

  <nav class="links">
    <a href="../lessons/{prev}.html">← Previous</a>
    <a href="../lessons/{next}.html">Next →</a>
    <a href="../reference/{ref}.html">Reference</a>
  </nav>
</body>
</html>
```

## Assets

Lessons are built from reusable **components**, stored in `./assets/`: stylesheets, quiz widgets, simulators, diagram helpers — anything a second lesson could reuse.

Reuse is the default, not the exception. Before authoring a lesson, read `./assets/` and build from the components already there. When a lesson needs something new and reusable, write it as a component in `./assets/` and link to it — never inline code a future lesson would duplicate.

A shared stylesheet is the first component every workspace earns: every lesson links it, so the lessons look like one consistent course rather than a pile of one-offs. The skill ships a starter [`assets/theme.css`](./assets/theme.css) — copy it into the workspace's `./assets/` as the baseline before adding `lesson.css`. As the workspace grows, so should the component library.

## Common failure modes

- **One big problem instead of many reps.** A 30-minute session spent on one problem is one rep. This is not deliberate practice. Break the problem into many small reps.
- **Worked example alongside practice.** Displaying the worked example while the user practices is the spotter lifting the weight for them. Hide it. Reveal only as a last resort.
- **Abstract first.** Opening with a definition or theorem. The user will nod along and learn nothing. Always start concrete.
- **No calibration check.** If the first rep is too hard, the whole session is wasted. Include an early easy rep to confirm calibration.
- **No measurement.** If the user can't tell whether they're making progress, they will either coast (too easy) or drown (too hard) without knowing which.
- **Too long.** A lesson that takes more than 30-45 minutes is too long. The user's focus will degrade. Split it.
- **Too short on reps.** A lesson that takes 10 minutes and has 5 reps is too short on volume. Either add more reps or combine with another node.
- **Tests pass after iteration is not automaticity.** The user must pass tests on the FIRST run from a blank page. If they run tests, see failures, fix, and run again — those fixes are debugging, not recall. The next attempt should be from a blank page again. "Learned a lot" + "had to run tests throughout" is the tell: that's iterating against the test set, not reproducing from memory.
- **Tests are necessarily incomplete.** The test set can't probe every contract edge. The agent should verify contract correctness beyond the test set — construct probes for edge cases the tests don't cover (e.g., a reader that returns a non-EOF error, a writer that receives an empty buffer). Bugs the test set doesn't catch are where understanding and automaticity diverge.

## Drill patterns

### Predict-then-verify

The user predicts each output from memory, runs the code once, compares, and writes one sentence per miss explaining why the actual differs from the prediction. Re-predict misses from memory and repeat until clean. Each prediction is a rep.

This format directly serves "recall before reason" and produces high rep count in short time. It is especially effective for:
- Distinguishing similar concepts (e.g., `io.EOF` vs `io.ErrUnexpectedEOF`)
- Learning the behavior of stdlib functions across edge cases
- Fortifying a distinction that has decayed after a gap

Implementation: a single `main.go` with 10-20 cases, each printing a labeled line. The user writes predictions as comments before running. The code is the answer key — but the user sees output only after predicting, not before.

### From-blank-page re-implementation

After tests pass on an initial implementation, the agent deletes the function bodies and the user re-implements from memory. Run tests once at the end. Clean first try = automaticity. Bugs fixed via test feedback = understanding, not automaticity — re-do from blank page.

## The paradox of serious training

The user will often feel weak during a well-designed lesson. This is the feeling of adaptation. Do not back off. The book: "The way you get stronger is by continually lifting weights heavy enough to make you feel weak. You never stop feeling humbled by your training, and the primary feeling you experience day to day is weakness, not strength."

If the user reports the lesson was easy, the calibration is wrong — it should be challenging. Adjust the next lesson up.

If the user reports the lesson was hard but they made measurable progress, the calibration is right. Tell them so.

If the user reports the lesson was hard and they made no measurable progress, the calibration is wrong — drop back. Do not interpret this as "push harder."
