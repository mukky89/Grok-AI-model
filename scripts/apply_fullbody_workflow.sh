#!/usr/bin/env bash
set -euo pipefail

# Skopíruje full-body workflow do ComfyUI user folderu.
# Použitie na RunPode:
#   cd /workspace/Grok-AI-model && git pull && bash scripts/apply_fullbody_workflow.sh

REPO_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$REPO_DIR/workflows/flux_nsfw_fullbody.json"

find_comfy() {
  if [ -d "/workspace/runpod-slim/ComfyUI" ]; then
    echo "/workspace/runpod-slim/ComfyUI"
  elif [ -d "/workspace/ComfyUI" ]; then
    echo "/workspace/ComfyUI"
  elif [ -d "$HOME/ComfyUI" ]; then
    echo "$HOME/ComfyUI"
  else
    echo ""
  fi
}

COMFY="$(find_comfy)"
if [ -z "$COMFY" ]; then
  echo "CHYBA: ComfyUI priečinok nenájdený."
  exit 1
fi

if [ ! -f "$SRC" ]; then
  echo "CHYBA: chýba $SRC — daj git pull."
  exit 1
fi

DEST_DIR="$COMFY/user/default/workflows"
mkdir -p "$DEST_DIR" "$COMFY/user/default" 
cp -f "$SRC" "$DEST_DIR/flux_nsfw_fullbody.json"
cp -f "$REPO_DIR/workflows/flux_nsfw_basic.json" "$DEST_DIR/flux_nsfw_basic.json" 2>/dev/null || true

echo "OK workflow:"
echo "  $DEST_DIR/flux_nsfw_fullbody.json"
echo
echo "V ComfyUI: Workflow → Browse templates / Load"
echo "alebo drag & drop ten JSON."
echo
echo "Odporúčané:"
echo "  768x1344  steps 30  euler/simple  FluxGuidance 3.0  unlock LoRA 0.7"
echo "  potom FaceDetailer denoise 0.3 + 2x upscale"
