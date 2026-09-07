#!/usr/bin/env bash
set -euo pipefail

# Zmaže Wan video váhy a cache, aby bolo miesto na Flux LoRA.
#   bash scripts/cleanup_wan.sh

echo "=== disk pred ==="
df -h /workspace /tmp 2>/dev/null || df -h
echo

echo "=== kandidáti Wan ==="
find /workspace -iname '*wan*' \(
  -iname '*.safetensors' -o -iname '*.ckpt' -o -iname '*.pt' -o -iname '*.pth' -o -iname '*.bin' -o -iname '*.gguf'
\) 2>/dev/null | head -n 80 || true

# find na niektorých podech neznáša zalomené \( \) — druhý prechod jednoducho
find /workspace -type f \( -iname '*wan2*' -o -iname '*wan_2*' -o -iname '*Wan2*' -o -iname '*wan-ai*' -o -iname '*wan_t2v*' -o -iname '*wan_i2v*' \) 2>/dev/null | head -n 80 || true

echo
echo ">>> mažem typické Wan priečinky a váhy"

# Comfy model dirs
for d in \
  /workspace/runpod-slim/ComfyUI/models \
  /workspace/ComfyUI/models
do
  [ -d "$d" ] || continue
  find "$d" -type f \( \
    -iname '*wan2*' -o -iname '*Wan2*' -o -iname '*wan_2*' -o \
    -iname '*wan_t2v*' -o -iname '*wan_i2v*' -o -iname '*wan-ai*' -o \
    -iname '*Wan-AI*' -o -iname '*wanx*' \
  \) -print -delete 2>/dev/null || true
done

# HF cache Wan
find /root/.cache/huggingface /workspace/.cache /workspace/huggingface -type d -iname '*wan*' 2>/dev/null | while read -r p; do
  echo "rm -rf $p"
  rm -rf "$p"
done || true

# časté one-click názvy
rm -rf \
  /workspace/Wan* \
  /workspace/wan* \
  /workspace/models/wan* \
  /workspace/runpod-slim/ComfyUI/models/diffusion_models/*wan* \
  /workspace/runpod-slim/ComfyUI/models/unet/*wan* \
  /workspace/runpod-slim/ComfyUI/models/checkpoints/*wan* \
  2>/dev/null || true

echo
echo "=== disk po ==="
df -h /workspace /tmp 2>/dev/null || df -h
echo
echo "Hotovo. Potom: bash scripts/runpod.sh models"
