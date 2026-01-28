#!/usr/bin/env bash
# Install this skills plugin for Claude Code
# Usage: ./scripts/install.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
PLUGIN_NAME="skills"
CLAUDE_DIR="${HOME}/.claude"
PLUGINS_DIR="${CLAUDE_DIR}/plugins"
REPOS_DIR="${PLUGINS_DIR}/repos"
INSTALLED_FILE="${PLUGINS_DIR}/installed_plugins.json"

# Get version from plugin.json
VERSION=$(grep '"version"' "${REPO_ROOT}/.claude-plugin/plugin.json" | sed 's/.*: *"\([^"]*\)".*/\1/')

echo "Installing ${PLUGIN_NAME} plugin v${VERSION}..."

# Create repos directory if needed
mkdir -p "${REPOS_DIR}"

# Create symlink (force overwrite if exists)
ln -sf "${REPO_ROOT}" "${REPOS_DIR}/${PLUGIN_NAME}"
echo "  Symlinked: ${REPOS_DIR}/${PLUGIN_NAME} -> ${REPO_ROOT}"

# Register in installed_plugins.json
if [[ ! -f "${INSTALLED_FILE}" ]]; then
    echo '{"version": 2, "plugins": {}}' > "${INSTALLED_FILE}"
fi

TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
PLUGIN_KEY="${PLUGIN_NAME}@local"

# Use jq if available, otherwise use python
if command -v jq &> /dev/null; then
    jq --arg key "$PLUGIN_KEY" \
       --arg path "${REPOS_DIR}/${PLUGIN_NAME}" \
       --arg version "$VERSION" \
       --arg timestamp "$TIMESTAMP" \
       '.plugins[$key] = [{
         "scope": "user",
         "installPath": $path,
         "version": $version,
         "installedAt": $timestamp,
         "lastUpdated": $timestamp,
         "isLocal": true
       }]' "${INSTALLED_FILE}" > "${INSTALLED_FILE}.tmp" && mv "${INSTALLED_FILE}.tmp" "${INSTALLED_FILE}"
elif command -v python3 &> /dev/null; then
    python3 << EOF
import json
with open("${INSTALLED_FILE}", "r") as f:
    data = json.load(f)
data["plugins"]["${PLUGIN_KEY}"] = [{
    "scope": "user",
    "installPath": "${REPOS_DIR}/${PLUGIN_NAME}",
    "version": "${VERSION}",
    "installedAt": "${TIMESTAMP}",
    "lastUpdated": "${TIMESTAMP}",
    "isLocal": True
}]
with open("${INSTALLED_FILE}", "w") as f:
    json.dump(data, f, indent=2)
EOF
else
    echo "Error: jq or python3 required for registration"
    exit 1
fi

echo "  Registered in: ${INSTALLED_FILE}"
echo ""
echo "Done! Restart Claude Code to use the plugin."
