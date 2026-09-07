#!/usr/bin/env bash
set -euo pipefail
# Späťne kompatibilné — všetky JSON ide cez sync_to_comfy.sh
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec bash "$SCRIPT_DIR/sync_to_comfy.sh"
