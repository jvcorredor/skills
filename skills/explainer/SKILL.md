---
name: explainer
description: Generates a self-contained interactive HTML explainer for complex topics in a dark GitHub-inspired theme with Mermaid diagrams, before/after toggles, pipeline cards, timelines, risk tables, and decision checklists. Picks from four variant templates — PRs (code changes), issues/stories/epics (work items), concepts/frameworks/ADRs (ideas to evaluate), research/claims (evidence to evaluate) — each with its own narrative spine ending in an actionable decision checklist. Use when the user asks for a visual explainer, asks to "help me understand" something complex, wants an HTML write-up of a PR/issue/paper, asks for an interactive walkthrough, or invokes /explainer. Saves to /tmp/ by default.
---

# Explainer

Produce a self-contained HTML document that walks a reader from confusion to a confident decision. Output is one `.html` file (Mermaid is the only CDN dep).

## The principle

An explainer is a **guided tour**, not an index card. It moves the reader along this arc:

> what was → what changed and why → how the new shape works → what changed in code → tradeoffs → (rollout) → what to verify before acting

Every section earns its place by advancing that arc. If a section just *describes* without advancing understanding, cut it.

## When to use

Trigger phrases: "explain this PR", "make me an explainer", "help me understand X", "visualize this", "walkthrough of Y", "rich documentation for Z", `/explainer`.

## Workflow

### 1. Frame the decision (don't skip)

Pin down — by asking briefly OR inferring from context:

- **Audience**: who's reading? Calibrate jargon to them.
- **Decision**: what action follows? (merge / reject / refactor / adopt / cite / just learning)
- **Stakes**: cost of getting it wrong.

If genuinely unclear and would materially change the doc, ask one short question. Otherwise infer and state your inference in the hero so the reader can correct you.

### 2. Gather material thoroughly

Read the source in full — the diff hunks lie about context, the abstract hides the assumptions.

- **PR**: `gh pr view <N> --json title,body,author,additions,deletions,changedFiles,files,baseRefName,headRefName,closingIssuesReferences`, `gh pr diff <N>`, `git log <base>..<head>`, then read every changed file in full. Read referenced issues too.
- **Issue**: `gh issue view <N> --comments`, linked PRs, the code being discussed.
- **Concept / research**: the source paper / doc. Cite section + line numbers.
- **Architecture / ADR**: the ADR, neighboring ADRs, CONTEXT.md, the code that implements (or fails to implement) it.

### 3. Pick the right template, then fork it

Four templates, same dark GitHub theme, same components, different spines:

| Template | Use for | Spine |
|---|---|---|
| [TEMPLATE-pr.html](TEMPLATE-pr.html) | Pull requests (code changes) | current shape → new shape → mechanics → file-by-file → tradeoffs → rollout → risks → decide |
| [TEMPLATE-issue.html](TEMPLATE-issue.html) | Issues, bugs, stories, epics | observed/requested → known vs. unknown → model → hypotheses/criteria/scope → affected surface → sequencing → risks → decide |
| [TEMPLATE-concept.html](TEMPLATE-concept.html) | Concepts, frameworks, ADRs | why it matters → prerequisites → mental model → worked example → what it's NOT → when to use → risks of misuse → decide |
| [TEMPLATE-research.html](TEMPLATE-research.html) | Papers, claims, studies | claim → methodology → evidence → limitations → where it generalises → related work → risks → decide |

Pick by **what the reader is examining and what decision they're making**:
- Examining a **change** with code → PR template
- Examining a **work item** (bug to fix, story to grab, epic to plan) → issue template
- Examining an **idea** to adopt/agree with → concept template
- Examining a **claim** to trust/apply → research template

If borderline, pick the one whose decision verb in §8 matches the user's actual decision. An ADR with no code goes in concept; an ADR delivered as a PR goes in PR.

The CSS block is identical across all four templates. If you change the palette or a component, change it in all four.

**The components** (in [REFERENCE.md](REFERENCE.md) — read it):

| Component | Use for |
|---|---|
| Hero (pills + lede + topnav) | Always. The lede is the TL;DR. |
| Pipeline cards (numbered steps, danger/good variants) | Sequential systems, especially before/after |
| Before/After toggle | Anytime there's a "what changed" — almost every PR |
| Two-column compare | Conceptual deltas: "trust anchor before vs. after" |
| Mermaid (sequence / state / flowchart / gitGraph) | Mechanics that span actors or time |
| File-by-file accordion | PR walkthrough. Group by **concern**, not by file. |
| Selective diff snippet | A 3–10 line change whose shape carries the explanation |
| Version / option table | "Why X specifically?" decisions |
| Timeline w/ actor badges | Rollouts, multi-step ops, ordered procedures |
| Risk table (risk / likelihood / mitigation) | Always |
| Decision checklist (with "why this matters" subtitles) | Always — replaces "open questions" |
| `<p class="small">` clarifying footnotes | After diagrams/tables, prevent misreadings |

Each template has its own §1–§8 spine pre-numbered with placeholders. Fill them in; don't reorder or skip without reason. Sections present in a template are load-bearing for that variant — the spine is the variant's whole point.

**Constant across all four templates:**
1. **Hero** — title, pills (refs / scope / freshness / status), lede (1–3 sentences that are the TL;DR), topnav.
2. **Risks** — risk table.
3. **Decision checklist** — interactive checkboxes, each with a "why this matters" subtitle.
4. **Footer** — provenance ("Generated for X on a session focused on Y").

### 4. Selective diff rule

**Do not paste the full PR diff.** The reader can see that in GitHub.

A diff snippet earns its place only when the *shape of the change* carries the explanation — when reading the hunk itself gives the reader something prose can't. A one-line flag flip can be load-bearing; a fifty-line method body rewrite can be too. A two-hundred-line file rename, by contrast, has no explanatory value and goes in the file accordion as a prose summary.

Heuristic: if a reader who reads only the snippet (no surrounding prose) gets a real "oh, that's what's happening" — include it. If the snippet is just textual evidence that something changed, summarise instead. **High explanatory value is the test, not line count.**

### 5. Specific titles, not generic ones

- "1 · The shortcut we're removing" not "Background"
- "2 · The new architecture at a glance" not "Solution overview"
- "5 · About the ESO chart bump" not "Dependencies"

Title each section with what it *says*, not what kind of section it is.

### 6. Save & report

Default path: `/tmp/explainer-<slug>-<YYYY-MM-DD>.html` where slug is the PR number, issue number, or kebab-case topic. Print the absolute path. Don't auto-open unless asked.

## Variants

Per-variant guidance (PR, issue, concept, research, ADR — what to put in each section, which components fit) lives in [REFERENCE.md](REFERENCE.md). Read it before generating any explainer that isn't a plain PR.

## Anti-patterns

- **Dumping the full diff.** The reader has GitHub. Include a hunk only when it has **high explanatory value** — the shape of the change itself teaches something the prose can't. Size is not the test; one line can be load-bearing and fifty can be cosmetic.
- **Generic section titles** ("Background", "Overview", "Summary"). Title with the content.
- **Skipping the before-side.** Every "what changed" needs a clear "what was". The Before/After toggle is two equal panes.
- **A doc with no Before/After and no Mermaid and no Pipeline cards.** Then you wrote a README, not an explainer.
- **Burying tradeoffs in a final paragraph.** They go in a section with their own header, and a risk table.
- **"Could have bugs."** Not a risk. A risk names the failure mode, the trigger, and the blast radius.
- **A bullet list of open questions.** Convert each to a decision-checklist item with a "why this matters" subtitle.
- **Light theme by default.** Dark is the default in TEMPLATE.html. Switch only on request.
