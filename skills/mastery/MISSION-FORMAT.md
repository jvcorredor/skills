# MISSION.md Format

`MISSION.md` lives at the workspace root. It captures the reason the user is learning. In a `/mastery` workspace, it can hold a primary mission plus up to two semi-focuses — this is how skill stacking is implemented.

Every teaching decision should trace back to this document and to `SKILL-TREE.md`.

## Template

```md
# Mission

## Primary mission

### Why
{1-3 sentences. The concrete real-world goal the user is chasing. What changes in their life or work when they have this skill? Push for the underlying outcome, not abstract framings like "to understand X".}

### Success looks like
- {A specific, observable thing the user will be able to do}
- {Another specific thing}

### Constraints
- {Time, budget, prior commitments, learning preferences}

### Out of scope
- {Adjacent topics the user explicitly does not want to chase right now}

## Semi-focus: {Topic 1}

### Why
{1-2 sentences. Why this is a staging area for the primary mission, or why it's worth developing to serious expertise in parallel.}

### Success looks like
- {Specific observable thing}

### Merge plan
{What would it look like to merge this into the primary mission? What needs to be true first?}

## Semi-focus: {Topic 2} (optional)

{Same structure as above. Omit entirely if not used.}

## Stack rationale

{1-3 sentences on why this particular stack compounds. For technically inclined users, the ideal stack per the book is domain expertise + math + coding + communication. Note which of these the user is already strong in and which they are building.}
```

## Rules

- **Concrete over abstract.** "Ship a Rust CLI to my team by Q3" beats "learn Rust." "Run a half marathon by October" beats "get fitter." Push back on vagueness until you have something observable.
- **Push back on vagueness.** If the user cannot articulate why, interview them before writing anything. A bad mission is worse than no mission.
- **At most one primary + two semi-focuses.** More than this and the user is spreading themselves too thin. The book: "You don't want to spread yourself too thin. You need to be moving at a competitive speed in at least one direction."
- **Semi-focuses are serious, not hobbies.** A semi-focus is a staging area for something the user wants to eventually merge into the primary mission. It must be developed to serious expertise, not just a light dabble. If it's just for fun, it's a hobby, not a semi-focus — don't list it here.
- **Every semi-focus has a merge plan.** If you can't articulate what merging it into the primary mission would look like, it's not a semi-focus — it's a hobby.
- **Revise when reality shifts.** Missions change. When the user's goal moves, update this file — don't leave a stale mission steering future sessions. Confirm with the user before changing. Record the change in a learning record.
- **Keep it short.** If `MISSION.md` runs past a screen, it has stopped being a compass and started being a plan. The plan lives in `SKILL-TREE.md`.

## Interviewing for the mission

If the user invokes `/mastery` without a clear mission, do not produce lessons. Interview them first. Useful questions:

- What do you want to be able to do that you can't do now?
- What changes in your life or work when you get there?
- What's the timeframe? Is there a deadline, or is this open-ended?
- What can you not afford to give up while pursuing this? (Sleep, relationships, job, etc.)
- What's already in place? (Prior skills, prior knowledge, resources, time budget)
- Are there other skills you want to build in parallel? Why those?
- What's explicitly out of scope?

If the user says "I want to learn X" without a concrete outcome, push harder. The book: "You have to work really damn hard to figure out what fulfills you. The solution to 'I don't know what I want to do' is NOT 'I guess I just won't do anything because I don't know what to do.'"

The mission does not have to be perfect. It has to be concrete enough to steer teaching. It can be revised as the user learns more.
