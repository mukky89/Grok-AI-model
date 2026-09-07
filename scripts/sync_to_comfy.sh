#!/usr/bin/env bash
set -euo pipefail

# Skopíruje workflow JSON, prompty a predajné priečinky do ComfyUI.
#   bash scripts/sync_to_comfy.sh

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"
REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

COMFY="$(find_comfy)"
if [ -z "$COMFY" ]; then
  echo "CHYBA: ComfyUI priečinok nenájdený."
  exit 1
fi

WF_DEST="$COMFY/user/default/workflows"
mkdir -p "$WF_DEST" \
  "$COMFY/user/default" \
  "$REPO_DIR/drafts" \
  "$REPO_DIR/final/set_01" \
  "$REPO_DIR/video" \
  "$REPO_DIR/dataset_keep"

echo ">>> sync workflows → $WF_DEST"
shopt -s nullglob
for f in "$REPO_DIR/workflows"/*.json; do
  cp -f "$f" "$WF_DEST/"
  echo "  $(basename "$f")"
done

# extra_model_paths — LoRA/character z repa bez kopírovania váh
EXTRA="$COMFY/extra_model_paths.yaml"
if [ ! -f "$EXTRA" ]; then
  cat > "$EXTRA" << EOF
grok_ai_model:
  base_path: $REPO_DIR
  loras: loras
  checkpoints: checkpoints
  output: drafts
EOF
  echo ">>> created $EXTRA"
fi

echo ">>> dataset dirs"
bash "$SCRIPT_DIR/prepare_dataset.sh" "$REPO_DIR/dataset/luna23"

echo
echo "OK sync"
echo "  Comfy: $COMFY"
echo "  Workflows: $WF_DEST"
ls -1 "$WF_DEST"/*.json 2>/dev/null || true
