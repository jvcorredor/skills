# SKILL-TREE.md Format

`SKILL-TREE.md` lives at the workspace root. It is the map of the skill tree(s) for the mission(s). Every teaching decision — what to drill next, what to audit as a prerequisite, when to advance, when to drop back — traces back to this map.

This is the structural difference from `/teach`. Without the tree, you cannot audit prerequisites. Without prerequisite audits, the user will eventually drown in the deep end and call it a lack of talent when it's actually a missing foundation.

## Template

```md
# Skill Tree: {Topic}

## Legend

- [ ] not started
- [~] in progress (understanding demonstrated, not yet automatic)
- [x] automatic (low-error execution under load demonstrated)
- [^] fortifying (was automatic, being re-strengthened via layering)

## Tree

### Trunk: {Foundational skill group}

- [x] {Prerequisite skill 1}
  - Evidence: {LR-NNNN or session date}
  - Last verified: {date}
- [~] {Prerequisite skill 2}
  - Evidence: {LR-NNNN}
  - Gaps: {what's keeping it from automaticity}
- [ ] {Prerequisite skill 3}

### Branch: {Higher-level skill group}

- [ ] {Advanced skill 1}
  - Prerequisites: {links to trunk nodes}
  - Status: blocked — waiting on {prerequisite skill 2}
- [ ] {Advanced skill 2}
  - Prerequisites: {links}
  - Status: ready — all prerequisites at [x]

## Current position

The user is currently working on: {node name}

Next node to reach for: {node name}
- Prerequisites for next node: {list}
- Prerequisite audit status: {verified / needs fortification on X}

## Layering plan

Advanced skills that will be layered on top of trunk nodes to fortify them:
- {Advanced skill} → fortifies {trunk node}
- {Advanced skill} → fortifies {trunk node}

## Notes

- Any cross-cutting observations, e.g. "user's arithmetic is solid but fractions are shaky; expect friction in algebra nodes that depend on fraction operations."
```

## Rules

- **One tree per mission.** If the workspace has a primary mission and a semi-focus, the file has two top-level trees (`## Tree: Primary` and `## Tree: Semi-focus`). Keep them in one file so you can see intersectional opportunities.
- **Map before teaching.** Do not produce lessons until the tree for the relevant area is mapped. A lesson without a tree is a guess.
- **Every node has a status.** No bare bullet points. The status tells you whether to advance, drill, or drop back.
- **Every `[x]` node has evidence.** Link to the learning record that demonstrates automaticity. No evidence, no `[x]`.
- **Every blocked node names what it's waiting on.** This is what makes the prerequisite audit mechanical, not a judgement call.
- **Update after every session.** The tree is a living document. If a node moved from `[~]` to `[x]`, update it. If a node regressed (was `[x]`, now shaky), mark it `[^]` and schedule fortification.
- **Layering plan is not optional.** The book is explicit: advanced skills force robustness in underlying skills. If you don't plan the layering, you don't get the fortification.
- **Be honest about gaps.** If you don't know enough to map a subtree, say so. That's a signal to research (`RESOURCES.md`) before teaching.

## Mapping a tree you don't fully know

You will often be asked to teach a topic whose skill tree you don't know in detail. Do not fake it. The book is explicit: "The granular steps of the journey, the actual learning, needs to be carried out bottom-up." A tree you guessed at is worse than no tree.

When you don't know the tree:

1. Find a high-quality, well-sequenced curriculum or textbook on the topic. Use it as the skeleton.
2. Map the tree from that curriculum.
3. Note in `RESOURCES.md` where the tree came from.
4. Refine the tree as the user progresses and you discover missing or unnecessary nodes.

A well-sequenced curriculum written by a domain expert is almost always better than a self-derived roadmap. The book: "Only those who have extremely outsized perseverance and generalization ability have any chance of fighting through and making it to the other side. And even then, it will take longer (and they'll likely end up with more holes in their knowledge) than if they just sucked it up and worked through a well-sequenced calculus course."
