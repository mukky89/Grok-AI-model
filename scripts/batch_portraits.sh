#!/usr/bin/env bash
set -euo pipefail

# Prvý dataset batch cez Comfy API, bez UI.
#   bash scripts/batch_portraits.sh
#   bash scripts/batch_portraits.sh 8

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
COUNT="${1:-4}"

COMFY="$(find_comfy)"
PY="$(find_python "$COMFY")"
PY="${PY:-python3}"

echo ">>> Comfy API batch portraits n=$COUNT"
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
  --lora-strength 0.8 \
  --timeout 600

echo
echo "výstup: $COMFY/output/"
echo "presuň dobré tváre:"
echo "  cp $COMFY/output/luna23_sale_soft* $REPO_DIR/dataset/luna23/portraits/"
