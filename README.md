# Skills

Personal agent skills for Kubernetes, infrastructure, and cloud engineering workflows.

## Structure

```
skills/
├── .claude-plugin/
│   └── plugin.json       # Plugin metadata for Claude Code
├── skills/               # Individual skills
│   └── <skill-name>/
│       ├── SKILL.md      # Main skill definition (required)
│       ├── references/   # Additional documentation (optional)
│       └── scripts/      # Helper scripts (optional)
├── scripts/
│   ├── link-skills.sh       # Link every skill into Claude Code and opencode
│   └── test-link-skills.sh  # Tests for link-skills.sh
└── README.md
```

## Installation

```bash
./scripts/link-skills.sh
```

This symlinks each directory under `skills/` into `~/.claude/skills` (Claude Code) and, when `~/.config/opencode` exists, into `~/.config/opencode/skills` (opencode). Run it from the main checkout, and again after adding or removing a skill. It replaces symlinks, never a real file or directory, and removes its own links to skills that no longer exist in this repo. The dotfiles repo runs it when a machine is set up.

Test: `bash scripts/test-link-skills.sh`.

## Third-party skills

Matt Pocock's skills are not copied here. In Claude Code they come from the `mattpocock-skills` plugin (`claude plugin install mattpocock-skills@claude-plugins-official`), which updates itself.

Two skills in this repo are derived from [mattpocock/skills](https://github.com/mattpocock/skills) (MIT, © Matt Pocock):

- `implement` is upstream's skill without `disable-model-invocation: true`. An agent cannot preload a skill that carries that flag, and the `implementer` agent preloads `implement`. A skill in `~/.claude/skills` is listed under its bare name, so this copy is the one that name loads.
- `resolving-merge-conflicts` was removed upstream and is kept here.

## Creating a New Skill

1. Create a directory under `skills/`:
   ```bash
   mkdir -p skills/my-skill
   ```

2. Create `SKILL.md` with required frontmatter:
   ```yaml
   ---
   name: my-skill
   description: Use when [specific trigger conditions]
   tools: Bash, Read, Write
   ---

   # My Skill

   ## When to Use
   - Trigger condition 1
   - Trigger condition 2

   ## Procedure
   1. Step one
   2. Step two

   ## Examples
   ...
   ```

3. Add optional supporting files in `references/` or `scripts/` subdirectories.

## SKILL.md Format

The `description` field is critical - Claude uses it to determine when to invoke the skill.

**Required frontmatter:**
- `name`: Unique identifier (lowercase, hyphens)
- `description`: When to use this skill (max 200 chars)

**Optional frontmatter:**
- `tools`: Comma-separated list of allowed tools
- `dependencies`: Required packages (e.g., `python>=3.8`)
