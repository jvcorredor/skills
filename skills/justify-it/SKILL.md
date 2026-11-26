---
name: justify-it
description: Re-examine a claim or proposal you made, hard: tradeoffs, worth, fit with goals and principles, and the dimensions the user missed. Defaults to your last claim.
disable-model-invocation: true
argument-hint: "[pasted claim + commentary | \"your proposal\" | empty = your last claim]"
---

# Justify it

The user is challenging something you said. Their argument: `$ARGUMENTS`

This is a **pre-mortem** of your own claim, run as if a skeptical peer wrote it. Holding the claim and changing it are both good outcomes; the evidence picks between them.

## 1. Pin the target

- **Empty argument:** the target is the last substantive claim, proposal or recommendation you made in this conversation.
- **A pointer** ("your proposal", "the caching idea"): find that passage in the conversation.
- **Pasted text plus commentary:** the pasted text is the target. The commentary is the user's lead: a suspicion to investigate, carrying exactly the weight of the reasons it gives.

Restate the target in one sentence, in its strongest form (**steelman** it). When two passages fit, name both and take the more consequential one.

Done when: one sentence the user would recognise as what you claimed.

## 2. Gather the yardstick

- **Goals and principles come from sources.** Read the ones that bear on the claim: the conversation, `AGENTS.md` / `CLAUDE.md`, ADRs, the PRD or issue, memory. Each principle you cite later names its source.
- **Premises get checked by looking.** List the facts the claim rests on. For each, read the code, run the read-only command, or check the docs, then mark it **verified** or **assumed**.

Done when: every premise is marked and every cited principle has a source.

## 3. Pre-mortem

Assume it is six months later and this turned out to be a mistake. Walk every dimension; give each one line, or mark it n/a with the reason.

- **Problem:** is it real, and is it the problem that matters now?
- **Alternatives:** at least two, including doing nothing and the simplest thing that could work. How does the claim compare?
- **Cost:** build, maintenance, complexity, operational load, money, attention. Who pays it.
- **Opportunity cost:** what this displaces.
- **Reversibility:** one-way or two-way door; blast radius if wrong.
- **Fit:** each relevant goal and principle: served, neutral, or strained (cite it).
- **Second-order effects:** what it makes easier or harder later; the precedent it sets.
- **Missing dimensions:** the angles this particular claim raises that the list above does not (security, people, timing, legal, a stakeholder nobody named). Name at least one, or state why none applies.

Done when: every dimension has a line, and the missing-dimensions line is filled.

## 4. Rule

Pick one verdict:

- **Stands:** the claim survives as stated.
- **Revise:** the core holds; part of it changes.
- **Withdraw:** something else is better, including doing nothing.

## Output

Lead with the verdict and the single reason that decides it, so the first two lines answer the challenge. Then:

1. **Strongest case for / strongest case against**, two or three lines each.
2. **Dimensions** that moved the verdict, one line each; collapse the n/a ones into one line.
3. **Premises:** verified vs assumed. Each assumed premise names what would verify it.
4. **What would flip it:** the evidence or change that would reverse the verdict.
5. On **Revise**, the revised proposal in full. On **Withdraw**, what you recommend instead.
