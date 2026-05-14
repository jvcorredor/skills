# Components catalogue + variant guidance

SKILL.md is the workflow and principle. This file is the catalogue of components and per-variant guidance.

---

## Components catalogue

How to recognise when each component fits, and how to use it well.

### Hero (always)

Pills (refs / scope / freshness) + title + **lede** + topnav.

The lede IS the TL;DR. 1–3 sentences. State the thing being changed, the why, and the headline tradeoff. A reader who stops here should still be able to act. Don't add a separate "TL;DR" section — strengthen the lede instead.

Topnav links to every numbered section so the reader can jump.

### Before/After toggle (almost every PR / refactor / migration)

Same pipeline visualised twice, with a CSS-driven toggle to flip between panes. The two panes must have **the same shape** so the reader's eye lands on the same step number in each and immediately sees what changed.

Use `.step.danger` on the old-shape steps that are being removed; `.step.good` on the new-shape steps that are key wins.

Inline `<span class="tag danger">` / `<span class="tag good">` qualifiers on the step title (e.g. "long-lived", "short-lived", "no credentials", "deprecated") let the reader scan the security/freshness properties of each step at a glance.

End each pane with a `<p class="small">` summarising "what's bounded" vs. "what's not" (before) / "what's structurally different" (after). This is where the reader learns to *see* the delta.

### Pipeline / step cards

Numbered steps with badges. Use for any sequential system: data flows, auth flows, request paths, deploy chains, build pipelines. Each card has a one-line title and a 1–2-sentence description in `<div class="desc">`.

Don't use for trees, parallel processes, or anything non-linear — Mermaid handles those.

### Two-column conceptual comparison

Use for **conceptual deltas**, not implementation deltas. E.g. "trust anchor: a static key blob" vs. "trust anchor: a signing key that mints fresh JWTs". The two columns answer the same question at the same level of abstraction.

Apply `.col.before` (red left border) and `.col.after` (green left border).

### Mermaid (sequence / state / flowchart / gitGraph)

| Topic shape | Mermaid type |
|---|---|
| Data / control flow between components | `flowchart` |
| Interaction across time / actors | `sequenceDiagram` |
| Lifecycle, modes, transitions | `stateDiagram-v2` |
| Branching strategy, release flow | `gitGraph` |
| Hierarchy / decomposition | `flowchart TD` with subgraphs |
| Class / type relationships | `classDiagram` |
| ER / schema | `erDiagram` |

For sequence diagrams: use `autonumber`, use `<br/>` in labels to keep critical detail on the diagram (audiences, token lifetimes, header values).

Always follow a Mermaid diagram with a `<p class="small">` footnote that heads off the most likely misreading. Example: "Cached fetches: STS caches the discovery doc + JWKS by Cache-Control. After warmup, STS doesn't talk to GCS on every exchange."

### File-by-file accordion

For PRs. **Group by concern, not by file.** A PR that touches `migration.sql`, `models.py`, `api.py`, and `tests/` is one accordion called "Add archived_at column end-to-end" — not four.

Inside each accordion, choose **one** of:
- A **resource table** (column 1: name, column 2: change with new/deleted/modified pill + why) — for groups with many files where the diffs don't individually teach.
- A **selective diff snippet** — for groups where the change shape itself is the lesson (see next).
- **Prose + a small code block** of the salient bit (e.g. a 4-line YAML excerpt showing the new flags).

Put the group's **role** in the summary line via `<span class="role">…</span>` (right-aligned, muted) so the accordion is scannable.

### Selective diff snippets

The reader has GitHub. They do not need the full diff dumped here.

A diff snippet earns its place only when it has **high explanatory value** — when the shape of the change itself teaches something the prose can't. **Line count is not the test.** A one-line flag flip can be load-bearing. A fifty-line function-body rewrite can be load-bearing. A two-hundred-line file rename isn't.

Test: would a reader who reads only the snippet (no surrounding prose) get a real "oh, that's what's happening"? If yes — include, at whatever size it takes. If the snippet is just textual evidence that the file changed — summarise instead.

Examples that earn their place (any size):
- A one-line swap of `verify=False` → `verify=True` that closes a security hole.
- A 5-line swap of one auth shape for another (`secretRef` → `workloadIdentityFederation`).
- A 30-line state-machine rewrite where the new branching shape is the whole point.
- A whole function being deleted, when the deletion itself is the argument.
- A schema column added with its constraints, indexes, and FK in one go.

Examples that don't (any size):
- Full renames across N files.
- Mechanical apiVersion bumps.
- Large refactors with no shape-change (extract-method, file split, formatter).
- Cosmetic diffs that "show the change happened" but don't teach what changed.

Use `<pre class="diff"><code><span class="del">- old</span><span class="add">+ new</span></code></pre>`. Follow the snippet with a `<p class="small">` explaining *what* the shape change means, not what the textual diff says.

### Version / option tables

Surface "why this specific choice" decisions. Columns are the dimensions that actually matter for the decision (e.g. for a chart pin: Released, WIF support, Serves v1beta1). Use pills (`good`/`bad`/`warn`) for yes/no/partial cells.

Always pair with a `<h3>Why X specifically?</h3>` bullet list that resolves the table into a decision.

### Timeline with actor badges

For rollouts, hands-on procedures, multi-step ops. Each `.tl-item` has:
- An auto-incremented step number (via CSS counter).
- An **actor**: `data-actor="operator|CI|ArgoCD|..."` + class `actor-op|actor-ci|actor-bot`.
- Optional `.risk` modifier for hard cutovers — adds a left border and turns the meta line yellow.
- Optional embedded `<pre>` block for the command to run.
- Optional `<div class="meta">` for "watch out for X" notes.

The point of the actor badge is to make it obvious **who has to do this step** — there's a big difference between "CI does this on merge" and "operator runs this by hand at the right moment".

### Risk table

`<table>` with columns: Risk / Likelihood / Mitigation.

Risk column: name the failure mode + trigger + blast radius. "Could have bugs" is not a risk. "ESO chart bump surfaces an unrelated regression (e.g. cert-manager DNS-01 ES stops syncing)" *is*.

Likelihood: pill — `good` (low), `warn` (medium/expected), `bad` (high/likely).

Mitigation: how to detect it, what the recovery is. If the answer is "no clean recovery", say so explicitly.

### Decision checklist (always)

This replaces a generic "open questions" list. The format is `<label>` + `<input type=checkbox>` + `<span class="q">Question</span>` + `<span class="why">Why this matters</span>`.

Each item is a real question the reader should answer **before acting**. The "why" subtitle explains the stakes of getting it wrong — so the reader isn't just ticking boxes but actually pausing to consider.

Examples that work:
- "Do I have a quiet window for the {{hard cutover}}?" — why: "In-cluster controllers will log auth errors for up to ~1h post-apply."
- "Is the project number `594695390705` correct?" — why: "Hardcoded in `gcr-access-token.yaml`. Verify with `gcloud projects describe ...`."

Examples that don't:
- "Have I reviewed the code?" — too vague to be actionable.
- "Are there any bugs?" — not a question, a wish.

### Small `<p class="small">` clarifying footnotes

After diagrams, tables, and dense sections. Use them to:
- Head off the most likely misreading.
- Add a non-obvious caveat.
- Cite the source of a number/claim.

Treat them as a writer's tool, not a styling choice. If you don't have a clarification to make, don't add an empty footnote.

---

## Variant guidance

Each variant has its own template. The template's §1–§8 spine is the canonical structure — fill in placeholders, don't reshape.

### PR variant — `TEMPLATE-pr.html`

**Decision the reader is making:** merge / request changes / reject.

**Spine:** current shape → new shape → mechanics → file-by-file → tradeoffs → rollout → risks → decide.

**Risks must cover:**
- Rollback story (forward-only migration? one-way data transform?)
- Performance impact (new N+1? new index? hot-path allocation?)
- Security surface (new endpoint? new permission? deserialization of user input?)
- Breaking changes (API shape, env vars, config keys, DB schema)
- Test coverage gaps

### Issue variant — `TEMPLATE-issue.html`

Covers bugs, stories, and epics. Pick the shape of §1 and §4 based on type:

| Type | §1 shape | §4 shape | §8 verbs |
|---|---|---|---|
| Bug | Before/After toggle: expected vs. observed | Ranked hypotheses with falsification tests | fix-now / next-sprint / need-info / wontfix |
| Story | Pipeline of proposed user flow | Numbered acceptance criteria as checklist | grab / refine / estimate-and-shelve |
| Epic | Outcome statement + scope summary | Scope table of sub-stories with status | commit / re-scope / defer |

**Spine:** observed/requested → known vs. unknown → model → hypotheses/criteria/scope → affected surface → sequencing → risks → decide.

**For bugs specifically:**
- §3 (model) = a sequence diagram of how the bug manifests, with the divergence point annotated in the footnote.
- §7 risks are **risks of NOT fixing** — name the failure mode the user experiences, frequency, and cost. "Bug" is not a risk; "users can't reset password, ~40 tickets/week" is.

**For stories:**
- §3 = the proposed user flow as a sequenceDiagram or pipeline.
- §6 sequencing is for dependency ordering, not rollout — "which sub-tasks block which".

**For epics:**
- §3 = `flowchart TD` with subgraphs showing the decomposition.
- §6 timeline is the milestone sequence.

### Concept / framework / ADR variant — `TEMPLATE-concept.html`

**Decision the reader is making:** adopt / learn deeper / skip / cite (concepts); agree / revisit / extend (ADRs).

**Spine:** why it matters → prerequisites → mental model → worked example → what it's NOT → when to use → risks of misuse → decide.

**For ADRs specifically:** retitle §1 as "Context and forces", §5 ("what it's NOT") as "Alternatives considered" with a flowchart highlighting the chosen path, and §7 risks as "Consequences and what this locks in". §8 checklist questions become "what would trigger me to revisit this decision?"

### Research / claim variant — `TEMPLATE-research.html`

**Decision the reader is making:** trust / apply / investigate further / dismiss.

**Spine:** claim → methodology → evidence → limitations → where it holds → related work → risks → decide.

**Header pills are not optional** — date and replication status calibrate the reader's trust before they read a word of body text. Conflict-of-interest / funding-source belongs in the hero too if relevant.

**The unacknowledged-limitations column in §4 is the most valuable thing in the doc.** Authors won't write down their own blind spots; you have to.

---

## How to choose a section title

Titles state **what the section says**, not **what kind of section it is**.

| Generic (bad) | Specific (good) |
|---|---|
| Background | The shortcut we're removing |
| Overview | The new architecture at a glance |
| Implementation | Token exchange — step by step |
| Files | File-by-file: what changed |
| Dependencies | About the ESO chart bump |
| Deployment | Operator-side rollout |
| Conclusion | Decide |

If you can't write a specific title, the section probably doesn't have a clear enough job. Fix the section, not the title.
