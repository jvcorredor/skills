# REFERENCE-FORMAT.md

Reference documents live in `./reference/` as `*.html`. They are the compressed essence of a lesson or a group of lessons — cheat sheets, syntax tables, algorithms, glossaries, pose sequences. They are designed for quick reference and for printing.

In `/teach`, reference docs are framed as helpful compressed reference. In `/mastery`, reference docs come with an explicit usage protocol: **they are spotters, not crutches.**

## The spotter protocol

This is the single most important rule for reference docs in a `/mastery` workspace. If you do not enforce this, the reference docs will undermine everything else.

From the book:

> "When you take notes, you know what you're NOT doing? Retrieving from memory. When you take great notes and constantly refer back to them, you know what you're STILL not doing? Retrieving from memory."

> "If you load information into working memory by looking at reference material instead of pulling from long-term memory, then you're not strengthening your retention. It's like you're going to the gym to lift weights, but you're just going through the motions and letting your spotter lift the weight for you. No strength is being developed."

The protocol, to be printed at the top of every reference doc:

1. **Recall first.** Before consulting this document, try to recall the answer from memory.
2. **Peek only as a last resort.** Only if you cannot recall despite trying your hardest.
3. **Peek the minimum.** Reveal only the specific piece you were trying to recall, not the whole section.
4. **Close the document and recall again.** After peeking, close the reference and reproduce the full answer from memory before proceeding.
5. **Never transcribe.** Never copy from the reference into your working output. Always reproduce from memory.
6. **If you keep needing to peek, you need more reps.** The reference is not the solution — more practice is.

## Template

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>{Topic} — Reference</title>
  <link rel="stylesheet" href="../assets/theme.css">
  <link rel="stylesheet" href="../assets/reference.css">
</head>
<body>
  <header class="spotter-protocol">
    <h2>Spotter protocol</h2>
    <ol>
      <li>Recall first.</li>
      <li>Peek only as a last resort.</li>
      <li>Peek the minimum — one piece, not the whole section.</li>
      <li>Close the document and recall again.</li>
      <li>Never transcribe. Reproduce from memory.</li>
      <li>If you keep peeking, you need more reps, not this reference.</li>
    </ol>
  </header>

  <main>
    <h1>{Topic}</h1>
    <!-- Compressed reference content. Tables, syntax, algorithms, definitions. -->
    <!-- Designed for quick lookup. Not a lesson. Not a tutorial. -->
  </main>
</body>
</html>
```

## What goes in reference docs

- Syntax and code snippets for programming
- Algorithms and flowcharts for processes
- Pose sequences for yoga
- Exercises and routines for fitness
- Glossaries for any topic with its own nomenclature
- Formulas, theorems, and identities for math
- Decision trees for diagnosis/troubleshooting

## What does NOT go in reference docs

- Lessons. Those live in `./lessons/`.
- Long explanations. Reference is compressed, not explanatory.
- Anything the user has not yet drilled to at least understanding. A reference doc for a skill the user hasn't encountered is a cheat sheet for a course they haven't taken — useless and demotivating.

## Rules

- **Print the spotter protocol at the top of every reference doc.** Not in a footnote. Not in a separate page. At the top, where the user sees it every time they open the doc.
- **Compress aggressively.** A reference doc that runs past a few pages has stopped being a reference and started being a textbook. Split it or cut it.
- **Cross-link to lessons.** A reference doc should link to the lesson(s) that drill the skill it references. If the user keeps peeking, they should know which lesson to re-run.
- **Promote to reference only at automaticity.** A reference doc is not a learning aid — it is a maintenance aid for skills the user has already drilled. Do not create a reference doc for a skill the user has only just encountered. Wait until they have drilled it to at least understanding, ideally automaticity.
- **Update as understanding deepens.** A reference doc written in week one may be wrong by week six. Update in place; do not leave stale entries.
- **Revisit rarely; recall often.** The user should be recalling from memory far more often than they consult the reference. If they consult the reference more than once per week for a given skill, that skill needs more reps, not better reference material.

## The vicious cycle of forgetting

If the user is constantly referring to a reference doc, they are in the vicious cycle of forgetting:

1. They keep looking back at the reference because they can't remember.
2. They can't remember because they're not transferring to long-term memory.
3. They're not transferring to memory because they're not practicing retrieving from memory.
4. They're not retrieving from memory because they're always looking back at the reference.

The only way out is retrieval practice. The reference doc is the spotter, not the weight. If the user is using the reference as the weight, the reference is doing harm — close it and schedule more reps.
