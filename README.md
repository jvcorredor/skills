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
│   ├── install.sh        # Install plugin for Claude Code
│   └── uninstall.sh      # Remove plugin
└── README.md
```

## Installation

```bash
./scripts/install.sh
```

This will:
1. Symlink the repo to `~/.claude/plugins/repos/skills`
2. Register the plugin in `~/.claude/plugins/installed_plugins.json`

Restart Claude Code to use the plugin. New skills added to `skills/` will be available after restarting.

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
