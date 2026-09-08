#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
COUNT="${1:-6}"
EXPLICIT="${2:-soft}"
COMFY="$(find_comfy)"
PY="$(find_python "$COMFY")"
PY="${PY:-python3}"

echo ">>> Flux heels/holdups n=$COUNT explicit=$EXPLICIT"
"$PY" "$REPO_DIR/scripts/generate_and_run.py" \
  -n "$COUNT" \
  --explicit "$EXPLICIT" \
  --width 768 \
  --height 1152 \
  --steps 28 \
  --guidance 3.2 \
  --sampler dpmpp_2m \
  --scheduler beta \
  --lora aidmaNSFWunlock-FLUX-V0.2.safetensors \
  --lora-strength 0.8 \
  --timeout 600
