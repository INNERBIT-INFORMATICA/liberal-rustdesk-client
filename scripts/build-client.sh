#!/usr/bin/env bash
# Dispatches a branded RustDesk client build using a preset from
# branding/<preset>/ (preset.env + optional icon.png / logo.png).
# Extra args are passed through to rdgen_cli.py as-is.
#
# Usage:
#   ./scripts/build-client.sh --list
#   ./scripts/build-client.sh innerbit --platform windows
#   ./scripts/build-client.sh liberalcontabilidade --platform linux --dry-run
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BRANDING_DIR="$SCRIPT_DIR/../branding"

list_presets() {
  for f in "$BRANDING_DIR"/*/preset.env; do
    basename "$(dirname "$f")"
  done
}

if [[ $# -lt 1 || "$1" == "-h" || "$1" == "--help" ]]; then
  sed -n '2,9p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
  exit 1
fi
if [[ "$1" == "--list" ]]; then
  list_presets
  exit 0
fi

PRESET="$1"; shift
PRESET_DIR="$BRANDING_DIR/$PRESET"
if [[ ! -f "$PRESET_DIR/preset.env" ]]; then
  echo "error: preset '$PRESET' not found. Available:" >&2
  list_presets >&2
  exit 1
fi

REPO="INNERBIT-INFORMATICA/rustdesk-client"
VERSION="1.5.0"
SERVER="" KEY="" FILENAME="" APPNAME="" COMPNAME="" ACCENT_COLOR=""
EXTRA_ARGS=()
# shellcheck source=/dev/null
source "$PRESET_DIR/preset.env"

missing=()
for var in SERVER KEY FILENAME APPNAME; do
  val="${!var}"
  if [[ -z "$val" || "$val" == "TODO" ]]; then missing+=("$var"); fi
done
if [[ ${#missing[@]} -gt 0 ]]; then
  echo "error: preset '$PRESET' is incomplete, fill in: ${missing[*]} ($PRESET_DIR/preset.env)" >&2
  exit 1
fi

args=(
  --repo "$REPO"
  --server "$SERVER"
  --key "$KEY"
  --filename "$FILENAME"
  --version "$VERSION"
  --appname "$APPNAME"
)
[[ -n "$COMPNAME" ]] && args+=(--compname "$COMPNAME")
[[ -n "$ACCENT_COLOR" ]] && args+=(--accent-color "$ACCENT_COLOR")
[[ -f "$PRESET_DIR/icon.png" ]] && args+=(--icon "$PRESET_DIR/icon.png")
[[ -f "$PRESET_DIR/logo.png" ]] && args+=(--logo "$PRESET_DIR/logo.png")

exec python3 "$SCRIPT_DIR/../rdgen_cli.py" "${args[@]}" ${EXTRA_ARGS[@]+"${EXTRA_ARGS[@]}"} "$@"
