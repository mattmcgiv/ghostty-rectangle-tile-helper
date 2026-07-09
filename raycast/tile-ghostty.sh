#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Tile Ghostty Windows
# @raycast.mode silent
# @raycast.packageName Ghostty

# Optional parameters:
# @raycast.icon 🖥️
# @raycast.description Tile open Ghostty windows (2×2 / 1×3 / 2×3) and bring Ghostty to the front

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TILER="${SCRIPT_DIR}/../bin/tile-ghostty"

if [[ ! -x "$TILER" ]]; then
  chmod +x "$TILER" 2>/dev/null || true
fi

if [[ ! -e "$TILER" ]]; then
  echo "tile-ghostty not found at $TILER" >&2
  exit 1
fi

exec "$TILER"
