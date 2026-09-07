#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
COUNT="${1:-4}"

COMFY="$(find_comfy)"
PY="$(find_python "$COMFY")"
PY="${PY:-python3}"

REF="$COMFY/input/alina_v3_reference_001.png"
KEEP="$REPO_DIR/dataset_keep/alina_ref.png"
mkdir -p "$REPO_DIR/dataset_keep"
if [ -f "$REF" ] && [ ! -f "$KEEP" ]; then
  cp -f "$REF" "$KEEP"
  echo "ref: $KEEP"
fi

echo ">>> Alina batch n=$COUNT  lora=alina_v6 + unlock"
"$PY" "$REPO_DIR/scripts/generate_and_run.py" \
  -n "$COUNT" \
  --explicit soft \
  --width 768 \
  --height 1152 \
  --steps 28 \
  --guidance 3.2 \
  --sampler dpmpp_2m \
  --scheduler beta \
  --lora aidmaNSFWunlock-FLUX-V0.2.safetensors \
  --lora-strength 0.75 \
  --lora2 alina_v6.safetensors \
  --lora2-strength 0.9 \
  --timeout 600
