#!/usr/bin/env bash
# Link every skill in this repo into the agents' skill directories:
#
#   ~/.claude/skills            Claude Code
#   ~/.config/opencode/skills   opencode (skipped when ~/.config/opencode is absent)
#
# Safe to re-run. It replaces symlinks and never a real file or directory:
# a real entry that has a skill's name is reported and the run exits 1. It
# also removes links into this repo whose skill no longer exists.
#
# Run it from the main checkout: the links point at the checkout the script
# lives in, so a run from a worktree links to that worktree.
#
# SKILLS_LINK_DESTS (colon-separated directories) overrides the destinations.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
SRC="$REPO/skills"

if [ -n "${SKILLS_LINK_DESTS:-}" ]; then
  IFS=: read -r -a dests <<<"$SKILLS_LINK_DESTS"
else
  dests=("$HOME/.claude/skills")
  if [ -d "$HOME/.config/opencode" ]; then
    dests+=("$HOME/.config/opencode/skills")
  fi
fi

conflicts=0
for dest in "${dests[@]}"; do
  mkdir -p "$dest"

  for skill_md in "$SRC"/*/SKILL.md; do
    src="$(dirname "$skill_md")"
    target="$dest/$(basename "$src")"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      echo "conflict: $target is not a symlink; left alone" >&2
      conflicts=$((conflicts + 1))
      continue
    fi
    if [ "$(readlink "$target" 2>/dev/null || true)" = "$src" ]; then
      continue
    fi
    ln -sfn "$src" "$target"
    echo "linked $target"
  done

  for link in "$dest"/*; do
    [ -L "$link" ] || continue
    to="$(readlink "$link")"
    case "$to" in
      "$SRC"/*)
        if [ ! -e "$to" ]; then
          rm "$link"
          echo "pruned $link"
        fi
        ;;
    esac
  done
done

if [ "$conflicts" -ne 0 ]; then
  echo "$conflicts conflict(s): move or delete those entries, then re-run" >&2
  exit 1
fi
