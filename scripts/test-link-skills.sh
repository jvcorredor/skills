#!/usr/bin/env bash
# Tests scripts/link-skills.sh against temporary destinations.
# Usage: bash scripts/test-link-skills.sh
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
link="$REPO/scripts/link-skills.sh"
tmp="$(mktemp -d)"
a="$tmp/a"
b="$tmp/b"
fails=0

check() { # check <description> <command...>
  local what="$1"
  shift
  if "$@"; then echo "ok   $what"; else echo "FAIL $what"; fails=$((fails + 1)); fi
}

skill="$(basename "$(dirname "$(find "$REPO/skills" -maxdepth 2 -name SKILL.md | sort | head -1)")")"
count="$(find "$REPO/skills" -maxdepth 2 -name SKILL.md | wc -l | tr -d ' ')"

# A fresh run links every skill into every destination.
SKILLS_LINK_DESTS="$a:$b" bash "$link" >/dev/null
check "links every skill into the first destination" [ "$(find "$a" -type l | wc -l | tr -d ' ')" = "$count" ]
check "links every skill into the second destination" [ "$(find "$b" -type l | wc -l | tr -d ' ')" = "$count" ]
check "a link points at the repo's skill" [ "$(readlink "$a/$skill")" = "$REPO/skills/$skill" ]

# A second run changes nothing.
check "a re-run prints nothing" [ -z "$(SKILLS_LINK_DESTS="$a:$b" bash "$link")" ]

# A symlink that points elsewhere is replaced.
ln -sfn "$tmp" "$a/$skill"
SKILLS_LINK_DESTS="$a" bash "$link" >/dev/null
check "replaces a symlink that points elsewhere" [ "$(readlink "$a/$skill")" = "$REPO/skills/$skill" ]

# A link into this repo whose skill is gone is pruned; other links are kept.
ln -s "$REPO/skills/no-such-skill" "$a/no-such-skill"
ln -s "$tmp/elsewhere" "$a/foreign"
SKILLS_LINK_DESTS="$a" bash "$link" >/dev/null
check "prunes a dead link into this repo" [ ! -L "$a/no-such-skill" ]
check "keeps a dead link that points elsewhere" [ -L "$a/foreign" ]

# A real directory is left alone and the run fails.
rm "$b/$skill"
mkdir "$b/$skill"
touch "$b/$skill/keep"
status=0
SKILLS_LINK_DESTS="$b" bash "$link" >/dev/null 2>&1 || status=$?
check "exits 1 on a real directory" [ "$status" = 1 ]
check "leaves the real directory alone" [ -f "$b/$skill/keep" ]

echo "scratch left in $tmp"
[ "$fails" -eq 0 ] || exit 1
