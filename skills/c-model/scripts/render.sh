#!/usr/bin/env bash
# Render views of a Structurizr workspace to C4-PlantUML, SVG and PNG.
#
# Generalized from homelab's scripts/build-diagrams.sh: same pinned
# Structurizr CLI and PlantUML, plus SHA-256 checks. Tools are cached once
# per machine (not per repo) so the skill works in any repository.
#
# Usage:
#   render.sh --check
#   render.sh <workspace.dsl> <out-dir> [KEY[:name] ...]
#   render.sh --puml <file.puml> <out-dir>
#
#   --check        Only verify prerequisites. Exit 3 (and print the brew
#                  line) when Java 17+ or Graphviz is missing.
#   KEY            A view key from the workspace. KEY:name writes
#                  <out-dir>/name.{puml,svg,png}; plain KEY writes KEY.*.
#                  No keys renders every view in the workspace.
#   --puml         Render a plain PlantUML file (L4 class diagram, or a
#                  sequence diagram finer-grained than the model).
#
# Env:
#   C_MODEL_TOOLS    tool cache (default ${XDG_CACHE_HOME:-~/.cache}/c-model/tools)
#   C_MODEL_FORMATS  space-separated, default "svg png"
#
# macOS: every JVM runs headless (no Dock icon, no focus theft); see below.
#
# Exit codes: 0 ok, 2 usage, 3 missing prerequisite, 4 validation/export
# failure, 5 a requested view key does not exist.

set -euo pipefail

STRUCTURIZR_CLI_VERSION="v2025.11.09"
STRUCTURIZR_CLI_SHA256="f5365a463fc44d539ed19bec00c48ba1e1ecda0ccfd1ba40d2e7472d264eb79a"
PLANTUML_VERSION="1.2026.8"
PLANTUML_SHA256="5e1ecfa8ecd32c90b03bbf3b1eb6f020943f98ab0fcf4032be31a0002ee2c462"

tools_dir="${C_MODEL_TOOLS:-${XDG_CACHE_HOME:-$HOME/.cache}/c-model/tools}"
formats="${C_MODEL_FORMATS:-svg png}"

fail() { echo "render: $1" >&2; exit "${2:-1}"; }

# --- Prerequisites -----------------------------------------------------------

java_major() { "$1" -version 2>&1 | awk -F'"' '/version/ {split($2, v, "."); print (v[1] == "1" ? v[2] : v[1]); exit}'; }

find_java() {
  local c
  for c in "${JAVA_HOME:+$JAVA_HOME/bin/java}" "$(command -v java 2>/dev/null || true)" \
           /opt/homebrew/opt/openjdk/bin/java /usr/local/opt/openjdk/bin/java; do
    [[ -n "$c" && -x "$c" ]] || continue
    local m; m="$(java_major "$c" 2>/dev/null || true)"   # macOS /usr/bin/java stub prints no version
    [[ "$m" =~ ^[0-9]+$ && "$m" -ge 17 ]] && { echo "$c"; return 0; }
  done
  return 1
}

missing=()
JAVA_BIN="$(find_java || true)"
[[ -n "$JAVA_BIN" ]] || missing+=("Java 17+")
command -v dot   >/dev/null 2>&1 || missing+=("Graphviz")
command -v curl  >/dev/null 2>&1 || missing+=("curl")
command -v unzip >/dev/null 2>&1 || missing+=("unzip")
if (( ${#missing[@]} )); then
  echo "render: missing: ${missing[*]}" >&2
  echo "render: install with:  brew install openjdk graphviz" >&2
  echo "render: (Linux: apt-get install -y openjdk-17-jre-headless graphviz unzip)" >&2
  exit 3
fi
JAVA_HOME="$(cd "$(dirname "$JAVA_BIN")/.." && pwd)"
export JAVA_HOME
export PATH="$JAVA_HOME/bin:$PATH"

[[ "${1:-}" == "--check" ]] && { echo "render: ok (java $(java_major "$JAVA_BIN"), $(dot -V 2>&1 | head -1))"; exit 0; }

# --- Arguments ---------------------------------------------------------------

mode=workspace
[[ "${1:-}" == "--puml" ]] && { mode=puml; shift; }
(( $# >= 2 )) || { sed -n '2,30p' "$0" >&2; exit 2; }
workspace="$1"; out_dir="$2"; shift 2
[[ -f "$workspace" ]] || fail "no file at $workspace" 2

# --- Pinned tools, verified and cached ---------------------------------------

sha256() { if command -v sha256sum >/dev/null; then sha256sum "$1"; else shasum -a 256 "$1"; fi | awk '{print $1}'; }

fetch() { # url dest sha
  local tmp; tmp="$(mktemp)"
  curl -fsSL -o "$tmp" "$1"
  [[ "$(sha256 "$tmp")" == "$3" ]] || { rm -f "$tmp"; fail "checksum mismatch for $1" 4; }
  mv "$tmp" "$2"
}

mkdir -p "$tools_dir"
cli_dir="$tools_dir/structurizr-cli-$STRUCTURIZR_CLI_VERSION"
if [[ ! -f "$cli_dir/structurizr.sh" ]]; then
  echo "render: downloading structurizr-cli $STRUCTURIZR_CLI_VERSION" >&2
  zip="$tools_dir/structurizr-cli-$STRUCTURIZR_CLI_VERSION.zip"
  [[ -f "$zip" && "$(sha256 "$zip")" == "$STRUCTURIZR_CLI_SHA256" ]] || \
    fetch "https://github.com/structurizr/cli/releases/download/$STRUCTURIZR_CLI_VERSION/structurizr-cli.zip" "$zip" "$STRUCTURIZR_CLI_SHA256"
  rm -rf "$cli_dir"; mkdir -p "$cli_dir"
  unzip -q "$zip" -d "$cli_dir"
  chmod +x "$cli_dir/structurizr.sh"
fi

plantuml_jar="$tools_dir/plantuml-$PLANTUML_VERSION.jar"
if [[ ! -f "$plantuml_jar" || "$(sha256 "$plantuml_jar")" != "$PLANTUML_SHA256" ]]; then
  echo "render: downloading PlantUML $PLANTUML_VERSION" >&2
  fetch "https://github.com/plantuml/plantuml/releases/download/v$PLANTUML_VERSION/plantuml-$PLANTUML_VERSION.jar" "$plantuml_jar" "$PLANTUML_SHA256"
fi

# Headless JVMs, a hard requirement on macOS: without these flags every java
# launch puts a Dock icon up and steals focus from the user's terminal.
# The explicit -D flags cover the JVMs started here; JAVA_TOOL_OPTIONS covers
# the one structurizr.sh starts.
JAVA_HEADLESS=(-Djava.awt.headless=true -Dapple.awt.UIElement=true)
export JAVA_TOOL_OPTIONS="${JAVA_TOOL_OPTIONS:+$JAVA_TOOL_OPTIONS }-Djava.awt.headless=true -Dapple.awt.UIElement=true"

# One PlantUML JVM per format for all files, never one per view.
render_all() { # file.puml ...
  local fmt
  for fmt in $formats; do
    java "${JAVA_HEADLESS[@]}" -DPLANTUML_LIMIT_SIZE=16384 -jar "$plantuml_jar" \
      -charset UTF-8 "-t$fmt" "$@" >/dev/null 2>&1 || fail "PlantUML failed ($fmt) on: $*" 4
  done
  local f; for f in "$@"; do echo "${f%.puml}.svg"; done
}

mkdir -p "$out_dir"
if [[ "$mode" == puml ]]; then
  name="$(basename "$workspace" .puml)"
  [[ "$workspace" -ef "$out_dir/$name.puml" ]] || cp "$workspace" "$out_dir/$name.puml"
  render_all "$out_dir/$name.puml"
  exit 0
fi

# --- Export (the export parses and fails on an invalid workspace) ----------

puml_dir="$(mktemp -d)"
trap 'rm -rf "$puml_dir"' EXIT

"$cli_dir/structurizr.sh" export -workspace "$workspace" -format plantuml/c4plantuml \
  -output "$puml_dir" >"$puml_dir/export.log" 2>&1 \
  || { grep -v '^Picked up JAVA_TOOL_OPTIONS' "$puml_dir/export.log" >&2; fail "workspace failed to parse or export" 4; }
ls "$puml_dir"/structurizr-*.puml >/dev/null 2>&1 \
  || { grep -v '^Picked up JAVA_TOOL_OPTIONS' "$puml_dir/export.log" >&2; fail "export wrote no views" 4; }

# Exported files are named structurizr-<KEY>.puml (plus -key.puml legends).
if (( $# == 0 )); then
  for f in "$puml_dir"/structurizr-*.puml; do
    k="${f##*/structurizr-}"; k="${k%.puml}"
    [[ "$k" == *-key ]] && continue
    set -- "$@" "$k"
  done
fi

files=()
for pair in "$@"; do
  key="${pair%%:*}"; name="${pair#*:}"
  puml="$puml_dir/structurizr-$key.puml"
  [[ -f "$puml" ]] || fail "no view with key '$key' in $workspace (keys: $(find "$puml_dir" -name 'structurizr-*.puml' ! -name '*-key.puml' -exec basename {} .puml \; | sed 's/^structurizr-//' | sort | tr '\n' ' '))" 5
  cp "$puml" "$out_dir/$name.puml"
  files+=("$out_dir/$name.puml")
done
render_all "${files[@]}"
