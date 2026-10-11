# guided-implementation

A pair-programming mode for Claude Code. Claude splits a task into small units, pitches each one, builds it only after you approve, then stops so you can review the diff and accept it before the next unit is pitched. Use it when you want to understand a repo or stack while the change gets made.

## Invoking

Say one of:

- `implement this with me`
- `guided implementation`
- `pair with me on this issue`
- `teach me while implementing`

or type `/guided-implementation <task or issue>`.

Claude first sends an orientation, any open questions, and a numbered plan. Nothing is edited until you approve the plan, and then each unit's card.

## Replies

Every unit stops twice: at its **card** (approve the work) and at its **review** (accept the result). The commit happens on acceptance.

| You say | At the card | At the review |
|---|---|---|
| `approve` / `accept` | Build the unit: edits, red → green test run, left uncommitted | Commit the unit, then show the next card |
| `revise: …` | Re-pitch the card; nothing is built | Change the uncommitted unit, re-verify, re-report |
| `revise unit 2: …` | A new card fixing committed unit 2, as its own commit; it goes next | same |
| `autopilot` / `autopilot through unit 4` | Approve, then build and commit units without stopping; still summarises each and stops on surprises | Accept, then the same |
| `guided` / `pause` | Turn the stops back on once the current unit finishes | same |

Ask whatever you like at either stop. Questions alone never move past it.

Claude may read, search and run the existing tests at any time, as long as they need no install, Docker or credentials. Edits, commits, dependency installs, pushes and PRs need approval.

## Example

```
you:    pair with me on this issue: #41 add --dry-run to the sync command
claude: Orientation: sync lives in cmd/sync.go, calls internal/syncer.Apply;
        tests: go test ./... (green, 42 pass); CI runs lint + test.
        Plan:
          1. Add DryRun to syncer.Options; Apply skips writes  (verify: unit test)
          2. Wire --dry-run flag in cmd/sync.go                (verify: CLI test)
          3. Document the flag in README                       (verify: lint)
        Approve the plan?
you:    approve
claude: Unit 1/3: DryRun option
        Goal: Apply reports planned writes without performing them
        Files: internal/syncer/syncer.go, internal/syncer/syncer_test.go
        Alternatives: separate Plan() method vs an option flag; recommend the
          flag, since callers already build Options
        Verification: TestApplyDryRun goes red (writes happen), then green
        Approve?
you:    approve
claude: Unit 1 built (uncommitted): 2 files, +38/-4;
        red: "expected 0 writes, got 3"; green. Accept unit 1?
you:    why does Apply still open the DB connection in dry-run?
claude: It reads current state to compute the diff; only writes are skipped
        (syncer.go:88). Accept unit 1?
you:    accept
claude: Unit 1 committed: 3f2a9c1 feat(syncer): add DryRun option
        Unit 2/3: --dry-run flag ...
        Approve?
```
