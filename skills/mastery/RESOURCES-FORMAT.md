# RESOURCES-FORMAT.md

`RESOURCES.md` is the curated set of trusted sources for this workspace. Knowledge for lessons should be drawn from here, not from parametric guesses. Wisdom comes from the communities listed here.

In a `/mastery` workspace, the bar for inclusion is higher than in `/teach`. The book is explicit: "Never trust your parametric knowledge." A resource that is marketing dressed as education does not belong. A community with weak moderation does not belong.

## Structure

```md
# {Topic} Resources

## Knowledge

- [Book: _{Title}_ — {Author}]({url})
  Foundational text on {what it covers}. Use for: {when to reach for it}.
- [Course: {Title} — {Author/institution}]({url})
  Well-sequenced curriculum on {what it covers}. Use for: {when}.
  Skill tree mapping source: {if this is the source for SKILL-TREE.md, say so here}

## Wisdom (Communities)

- [{Community name}]({url})
  {What kind of community, moderation quality, signal-to-noise.} Use for: {what the user can test here}.

## Gaps

- {Area the mission needs but no good resource was found.} Drives future search.
```

## Rules

- **High-trust only.** Prefer primary sources, recognised experts, peer-reviewed work, and communities with strong moderation. If a resource is marketing dressed as education, leave it out.
- **Annotate every entry.** A bare link is useless in three months. Add one line: what it covers and when to reach for it.
- **Group by Knowledge / Wisdom.** Mirrors the philosophy. It is fine for a resource to appear in only one group.
- **Mark the skill tree source.** If `SKILL-TREE.md` was mapped from a particular curriculum or textbook, name it here. This is the anchor for the tree's integrity.
- **Surface gaps explicitly.** If no good resource exists for an area the mission needs, write a `## Gaps` section listing what is missing. This drives future search.
- **Prune ruthlessly.** A resource that turned out to be wrong, shallow, or off-mission should be removed, not buried. Better five sharp sources than thirty mediocre ones.
- **Record community preferences.** If the user has opted out of communities, note it here so future sessions don't keep proposing them.

## On consumption vs production

Every resource in `RESOURCES.md` should be pressed into production immediately. The book:

> "Consuming is only helpful insofar as it enables you to produce. If you feel personally attacked by this then please understand that the whole reason I'm saying this is because I want to see you achieve your goals. Passive consumption is not the way to do that."

When you add a resource, also note (in the annotation) what the user should **produce** after consuming it. A book on linear algebra? Produce: work all the problems in chapter 1. A documentary on machine learning? Produce: implement the simplest model discussed, from memory, in code.

Resources without a production plan are a risk. They become passive consumption. They feed the state of "blah."

## On finding high-trust resources

Before `RESOURCES.md` is well-populated, your focus should be to find high-quality resources which will help the user acquire knowledge. Do this actively — search, read, evaluate. Do not trust your parametric knowledge of the topic.

For hierarchical skill domains (math, coding, music, etc.), the highest-trust resource is usually a **well-sequenced curriculum** written by a domain expert who has taught the subject for years. This is almost always better than a self-derived roadmap. The book:

> "Only those who have extremely outsized perseverance and generalization ability have any chance of fighting through and making it to the other side. And even then, it will take longer (and they'll likely end up with more holes in their knowledge) than if they just sucked it up and worked through a well-sequenced calculus course."

Prefer:
- Curricula and textbooks with problem sets and solutions
- Courses with structured progressions and exercises
- Primary sources (papers, original texts) for advanced topics
- Recognised experts with teaching experience, not just practitioners

Avoid:
- Blog posts that summarise without depth
- Videos that explain without exercises
- Resources that promise shortcuts
- Anything that markets "fun" or "easy" as a primary feature — the book is clear that effective training is effortful and not inherently enjoyable
