#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
COUNT="${1:-6}"
EXPLICIT="${2:-explicit}"
COMFY="$(find_comfy)"
PY="$(find_python "$COMFY")"
PY="${PY:-python3}"

echo ">>> Flux n=$COUNT explicit=$EXPLICIT  unlock=0.9 euler/simple"
"$PY" "$REPO_DIR/scripts/generate_and_run.py" \
  -n "$COUNT" \
  --explicit "$EXPLICIT" \
  --width 768 \
  --height 1152 \
  --steps 32 \
  --guidance 2.8 \
  --sampler euler \
  --scheduler simple \
  --lora aidmaNSFWunlock-FLUX-V0.2.safetensors \
  --lora-strength 0.9 \
  --timeout 600
