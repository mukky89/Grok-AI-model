#!/usr/bin/env bash
set -euo pipefail
# Stiahne Qwen-Image NSFW LoRA vedľa Aliny.
#   export HF_TOKEN=hf_...
#   bash scripts/fetch_qwen_nsfw.sh

DEST=/workspace/runpod-slim/ComfyUI/models/loras
mkdir -p "$DEST"
OUT="$DEST/qwen_image_nsfw.safetensors"

if [ -f "$OUT" ] && [ "$(stat -c%s "$OUT" 2>/dev/null || echo 0)" -gt 10000000 ]; then
  echo "OK uz je $OUT ($(du -h "$OUT" | awk '{print $1}'))"
  exit 0
fi

if [ -z "${HF_TOKEN:-}${HUGGING_FACE_HUB_TOKEN:-}" ]; then
  echo "export HF_TOKEN=hf_..." >&2
  exit 1
fi

PY=/workspace/ai-toolkit/.venv/bin/hf
if [ ! -x "$PY" ]; then
  PY=hf
fi

echo ">>> HF starsfriday/Qwen-Image-NSFW"
"$PY" download starsfriday/Qwen-Image-NSFW --include "*.safetensors" --local-dir /tmp/qwen-nsfw
FOUND=$(ls /tmp/qwen-nsfw/*.safetensors /tmp/qwen-nsfw/**/*.safetensors 2>/dev/null | head -n 1 || true)
if [ -z "$FOUND" ]; then
  echo "CHYBA: v repo nie je safetensors" >&2
  ls -la /tmp/qwen-nsfw >&2 || true
  exit 1
fi
cp -f "$FOUND" "$OUT"
ls -lh "$OUT"
