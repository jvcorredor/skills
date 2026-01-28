#!/usr/bin/env bash
# Package a skill for Claude.ai upload
# Usage: ./scripts/package-skill.sh <skill-name>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
SKILLS_DIR="$REPO_ROOT/skills"
DIST_DIR="$REPO_ROOT/dist"

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 <skill-name>"
    echo "Available skills:"
    ls -1 "$SKILLS_DIR" 2>/dev/null | grep -v '\.gitkeep' || echo "  (none yet)"
    exit 1
fi

SKILL_NAME="$1"
SKILL_PATH="$SKILLS_DIR/$SKILL_NAME"

if [[ ! -d "$SKILL_PATH" ]]; then
    echo "Error: Skill '$SKILL_NAME' not found at $SKILL_PATH"
    exit 1
fi

if [[ ! -f "$SKILL_PATH/SKILL.md" ]]; then
    echo "Error: SKILL.md not found in $SKILL_PATH"
    exit 1
fi

# Create dist directory
mkdir -p "$DIST_DIR"

# Create temp directory for packaging
TEMP_DIR=$(mktemp -d)
trap 'rm -rf "$TEMP_DIR"' EXIT

# Copy skill to temp
cp -r "$SKILL_PATH" "$TEMP_DIR/$SKILL_NAME"

# Rename SKILL.md to Skill.md (Claude.ai expects mixed case)
mv "$TEMP_DIR/$SKILL_NAME/SKILL.md" "$TEMP_DIR/$SKILL_NAME/Skill.md"

# Create ZIP with proper structure (skill folder at root)
OUTPUT_ZIP="$DIST_DIR/$SKILL_NAME.zip"
(cd "$TEMP_DIR" && zip -r "$OUTPUT_ZIP" "$SKILL_NAME")

echo "Created: $OUTPUT_ZIP"
echo "Upload to Claude.ai via Settings > Capabilities > Custom Skills"
