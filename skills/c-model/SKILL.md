---
name: c-model
description: C4 architecture model and diagrams (context, container, component, code, deployment, sequence/dynamic) for any repo or named system, kept as one Structurizr workspace grounded in the code and rendered to SVG via C4-PlantUML. Use when the user asks for a model, a diagram, the architecture, a C1/C2/C3/C4 or L1-L4 level diagram of something (including "holistically"), a C4 view, a sequence diagram of a flow, how something works end to end, or what X looks like; or types /c-model.
argument-hint: "<1|2|3|4|deployment|dynamic <flow>> <system> [container|package]"
---

# c-model

`$ARGUMENTS` is `<level> <system> [container|package]`. Without a slash command,
map the request: "C3/L3/components" -> `3`, "containers" -> `2`, "context" ->
`1`, "sequence/flow/how X reaches Y" -> `dynamic <flow>`, "where it runs" ->
`deployment`. "Holistically" with a level -> every significant element at that
level (holistic C3 is defined in [references/levels.md](references/levels.md)).

Read [references/levels.md](references/levels.md) for what belongs at the
level asked; read [references/dsl.md](references/dsl.md) before editing DSL.

## Rules

- **One model, many views.** One `workspace.dsl` per repo or system; every
  level is a view of it. Extend an existing workspace; keep its identifiers,
  view keys and comments. Never redraw a level as a separate picture.
- **Code is the ground truth, not memory.** Every element and relationship
  you add or change carries a `// source: <repo-relative path>` comment. What
  you cannot find in files gets the `Unverified` tag (and stays in the
  report). Never invent elements to fill a level.
- **Never read secrets**: no Secret data, kubeconfigs, `talos/_out`, tfvars
  values, `.env` values, tokens, 1Password. Names of secrets are fine.
- **Live reads only when the user asks for a live snapshot**, and only
  read-only metadata (`kubectl get -o name`/`-o wide`, `pvesh get` without
  tokens). Default source is the repo at `origin/main`.
- **Readable views**: at most ~20 elements each. Split views or use
  `include`/`exclude`; never cram.
- **Render only through `scripts/render.sh`.** On macOS a bare `java` or
  `plantuml` call puts a Dock icon up and steals the user's focus on every
  view; render.sh runs every JVM headless and batches all views into one
  PlantUML JVM per format. Never loop renders view by view.
- **Edits only in a git worktree on a branch**, never on the default branch.
  Draft the PR; never merge.

## Steps

1. **Resolve the target.** The system names a repo (look in the cwd, then
   `~/workspace/github.com/*/<name>`) or a system inside one. `git fetch`;
   create a worktree from `origin/<default>` per the user's worktree rule.
   Done when you are in the worktree at the fetched head.
2. **Preflight.** Run `scripts/render.sh --check`. Exit 3 means Java 17+ or
   Graphviz is missing: print the `brew install openjdk graphviz` line it
   shows and ask once whether to install. On no, stop here.
3. **Find the workspace.** `git ls-files '*.dsl'`; a `workspace` file wins.
   None: create `docs/diagrams/workspace.dsl` with `!identifiers
   hierarchical` and the styles from [references/styles.dsl](references/styles.dsl).
   Read the whole existing file and note its last commit date.
4. **Gather evidence** for the requested level only, per
   [references/levels.md](references/levels.md). For more than a few
   directories, fan out read-only recon subagents (one per area) that return
   facts with file paths and write long output to a file. Record drift: model
   elements the code no longer shows, and code the model lacks.
5. **Edit the model, then the view(s).** Add or correct elements and
   relationships with source comments, then add or update the view with its
   key. Sequence diagrams: choose a Structurizr `dynamic` view or a plain
   PlantUML file per levels.md, and note why. If the repo has its own diagram
   build script or docs pages that list view keys, register new keys there.
6. **Render.** `scripts/render.sh <workspace.dsl> <out-dir> KEY[:name] ...`
   (`--puml <file> <out-dir>` for L4 and plain sequence files). Out-dir: the
   repo's existing diagram assets dir if one is gitignored, else
   `.c-model/out/` (add it to `.gitignore`). Fix validation errors and re-run
   until it exits 0. Read each PNG and split any view that is unreadable.
   Then `open` each SVG.
7. **Ship.** Run the repo's pre-PR checks if it has them. Conventional
   Commit, push the branch, open a **draft** PR with the report as its body.
8. **Report** (in this order):
   - views produced: key, title, SVG path;
   - elements and relationships added or changed, each with its source;
   - every `Unverified` item and why it could not be verified;
   - drift between the old workspace and the code;
   - the PR link;
   - one line: "Want these views published as a private Artifact page?"
