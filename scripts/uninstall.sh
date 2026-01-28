#!/usr/bin/env bash
# Uninstall this skills plugin from Claude Code
# Usage: ./scripts/uninstall.sh

set -euo pipefail

PLUGIN_NAME="skills"
CLAUDE_DIR="${HOME}/.claude"
PLUGINS_DIR="${CLAUDE_DIR}/plugins"
REPOS_DIR="${PLUGINS_DIR}/repos"
INSTALLED_FILE="${PLUGINS_DIR}/installed_plugins.json"
PLUGIN_KEY="${PLUGIN_NAME}@local"

echo "Uninstalling ${PLUGIN_NAME} plugin..."

# Remove symlink
if [[ -L "${REPOS_DIR}/${PLUGIN_NAME}" ]]; then
    rm "${REPOS_DIR}/${PLUGIN_NAME}"
    echo "  Removed symlink: ${REPOS_DIR}/${PLUGIN_NAME}"
fi

# Remove from installed_plugins.json
if [[ -f "${INSTALLED_FILE}" ]]; then
    if command -v jq &> /dev/null; then
        jq --arg key "$PLUGIN_KEY" 'del(.plugins[$key])' "${INSTALLED_FILE}" > "${INSTALLED_FILE}.tmp" && mv "${INSTALLED_FILE}.tmp" "${INSTALLED_FILE}"
    elif command -v python3 &> /dev/null; then
        python3 << EOF
import json
with open("${INSTALLED_FILE}", "r") as f:
    data = json.load(f)
data["plugins"].pop("${PLUGIN_KEY}", None)
with open("${INSTALLED_FILE}", "w") as f:
    json.dump(data, f, indent=2)
EOF
    fi
    echo "  Removed from: ${INSTALLED_FILE}"
fi

echo ""
echo "Done! Restart Claude Code to complete uninstallation."
