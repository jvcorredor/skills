# guided-implementation

A pair-programming mode for Claude Code. Claude splits a task into small units, pitches each one, builds it only after you approve, then shows you the diff and the reasoning so you can question it. Use it when you want to understand a repo or stack while the change gets made.

## Invoking

Say one of:

- `implement this with me`
- `guided implementation`
- `pair with me on this issue`
- `teach me while implementing`

or type `/guided-implementation <task or issue>`.

Claude first sends an orientation, any open questions, and a numbered plan. Nothing is edited until you approve the plan, and then each unit's card.

## Replies

| You say | Effect |
|---|---|
| `approve` | Build the unit on the current card: edits, red → green test run, one commit |
| `revise: …` | Re-pitch the current card with your change; nothing is built |
| `revise unit 2: …` | A new card that fixes a finished unit, as a new commit |
| `autopilot` / `autopilot through unit 4` | Approve the current card and build approved units without stopping; still commits and summarises each, and still stops on surprises |
| `guided` / `pause` | Turn the stops back on once the current unit finishes |

Ask about the diff and approve the next unit in the same reply, or ask first and approve once satisfied: questions alone never start the next unit.

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
claude: Unit 1 done: 2 files, +38/-4; red: "expected 0 writes, got 3"; green.
        Next: unit 2/3 ...
you:    why does Apply still open the DB connection in dry-run?
claude: It reads current state to compute the diff; only writes are skipped
        (syncer.go:88). Approve unit 2?
you:    approve
```
