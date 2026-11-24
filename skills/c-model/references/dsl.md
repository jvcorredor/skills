# Structurizr DSL cheat sheet (pinned toolchain)

Pinned: structurizr-cli v2025.11.09 (DSL library 5.0.2; the CLI is archived,
this is its last release) -> `export -format plantuml/c4plantuml` -> PlantUML
1.2026.8. The online docs (https://docs.structurizr.com/dsl/language) describe
the newer 6.x tool: `plantuml.skinparams` and the `perspective "x" { }` block
do NOT exist on this pin. Statements are line based: one per line, `{` ends
its line.

## Skeleton

```
workspace "Name" "Description" {
    !identifiers hierarchical      // new workspaces only; keep an existing file's mode
    model {
        user = person "User" "desc"
        sys = softwareSystem "Sys" "desc" {
            group "Edge" {
                api = container "API" "desc" "Go"
            }
            db = container "DB" "desc" "PostgreSQL" "Database"
            api -> db "Reads and writes" "SQL"   // inside sys: short ids
        }
        ext = softwareSystem "Stripe" "desc" "External"
        user -> sys.api "Uses" "HTTPS"           // outside: dotted path
        sys.api -> ext "Charges cards" "HTTPS" "Unverified"
    }
    views {
        systemContext sys "L1" "desc" {
            include *
            autolayout lr
        }
        styles { ... }        // paste references/styles.dsl
        properties {
            "c4plantuml.tags" "true"
        }
    }
}
```

- Identifiers: flat (default) = all ids global and unique; hierarchical =
  `sys.api`, `sys.api.comp`. Never switch an existing file's mode: it
  rewrites every reference. Forward references are not allowed.
- Elements: `person|softwareSystem <name> [description] [tags]`,
  `container|component <name> [description] [technology] [tags]`.
- Relationship: `a -> b [description] [technology] [tags]`. Tags are one
  comma-separated string: `"Planned,Async"`.
- Implied relationships: `user -> sys.api` also creates `user -> sys`
  (unless one already exists). Define explicit system-level relationships
  to control L1 labels.
- `url https://...` on an element becomes a `$link` in the render.
- Perspectives, `!docs`, `!adrs` never reach the C4-PlantUML output.

## Deployment

```
live = deploymentEnvironment "Live" {
    deploymentNode "Region" "desc" "GCP" {
        deploymentNode "Cluster" "desc" "GKE" "" 3 {   // [tags] then instances
            lb = infrastructureNode "LB" "desc" "nginx" "Unverified"
            apiInst = containerInstance api            // hierarchical: sys.api
        }
    }
    lb -> apiInst "Routes to"
}
```

- Instance-to-instance relationships are copied from the static model.
- Instances `> 1` render as `Name (xN)`.

## Views

| View | Form | Key convention |
|---|---|---|
| system context | `systemContext <system> "L1" "desc" { ... }` | `L1` |
| landscape | `systemLandscape "L1" "desc" { ... }` | `L1` |
| container | `container <system> "L2" "desc" { ... }` | `L2`, `L2-<slice>` |
| component | `component <container> "L3-<Container>" "desc" { ... }` | `L3-<Container>` |
| deployment | `deployment <system\|*> <env> "Deployment" "desc" { ... }` | `Deployment[-<env>]` |
| dynamic | `dynamic <*\|system\|container> "Dynamic-<Flow>" "desc" { ... }` | `Dynamic-<Flow>` |

Always set an explicit key: generated keys (`SystemContext-001`) are not
stable, and the key is the exported file name (`structurizr-<KEY>.puml`).

Inside static and deployment views:

- `include *` = the scope plus directly connected elements; `include a b c`
  lists ids explicitly (best for keeping a view under ~20 elements).
- Element expressions (quote when spaced): `"element.tag==Planned"`,
  `"element.type==Container"`, `"element.parent==sys"`, `->x->`.
- Relationship exclusion: `exclude "* -> *"`, `exclude "a -> *"`,
  `exclude "* -> b"`, `exclude "a -> b"`. In deployment views these match
  the instances of the named elements.
- `autolayout lr|tb`: only `lr` changes the C4 output; separations ignored.
- `title "x"` and `description "x"` override the generated title.

Dynamic views:

```
dynamic sys "Dynamic-SignIn" "Sign-in through the API" {
    1: user -> sys.api "Submits credentials"
    2: sys.api -> sys.db "Looks up the session"
    properties {
        "plantuml.sequenceDiagram" "true"    // sequence diagram, not collaboration
    }
}
```

- No `include`/`exclude` here. Each step needs a static relationship
  between the two elements (either direction); the step text overrides it.
- Parallel steps: repeat a number (`2: ...`, `2: ...`), not nested `{ }`.
- To mark a step Unverified, tag its static relationship.

## C4-PlantUML export: what survives (verified on this pin)

- `"c4plantuml.tags" "true"` is REQUIRED; without it the exporter emits no
  `AddElementTag`/`AddRelTag`, so no style and no tag legend appears.
- Element styles that survive: `background`, `color`, `stroke`,
  `strokeWidth`, `border solid|dashed` (`dotted` does not show in the
  render). Ignored: `opacity`, `fontSize`, `width`, most shapes. Only
  `shape Cylinder` (-> Db) and `shape Pipe` (-> Queue) change containers
  and components.
- Relationship styles: `color`, `style solid|dashed|dotted`. Default is
  dashed: set `relationship "Relationship" { style solid }`.
- No `_Ext` macros: mark externals with an `External` tag and style.
- `SHOW_LEGEND(true)` is always written; `c4plantuml.legend "false"` does
  not remove it.
- Do NOT use `theme default`: it is fetched from static.structurizr.com at
  export time and breaks offline runs. Use the local styles block.
- Filtered and image views export nothing; use a normal view with
  `include`/`exclude`.
- An unknown `-format` exits 0 with no files; render.sh checks the files.
