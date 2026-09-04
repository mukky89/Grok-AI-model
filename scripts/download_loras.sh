#!/usr/bin/env bash
set -euo pipefail

# Stiahne Flux LoRA, ktoré vieme ťahať z Hugging Face bez Civitai tokenu.
# Civitai anatomy/nylon LoRA stiahni ručne (pozri workflows/06_sales_quality.md).

if [ -d "/workspace/runpod-slim/ComfyUI/models/loras" ]; then
  LORAS="/workspace/runpod-slim/ComfyUI/models/loras"
elif [ -d "/workspace/ComfyUI/models/loras" ]; then
  LORAS="/workspace/ComfyUI/models/loras"
else
  echo "CHYBA: models/loras nenájdené"
  exit 1
fi

PY=""
for c in \
  /workspace/runpod-slim/ComfyUI/.venv-cu128/bin/python \
  /workspace/ComfyUI/.venv-cu128/bin/python
do
  if [ -x "$c" ]; then PY="$c"; break; fi
done
PY="${PY:-$(command -v python3 || true)}"
HF="${PY} -m huggingface_hub.commands.huggingface_cli download"
if command -v hf >/dev/null 2>&1; then
  HF="hf download"
fi

echo "LoRA dir: $LORAS"
mkdir -p "$LORAS"
cd "$LORAS"

download_as() {
  local repo="$1" file="$2" dest="$3"
  if [ -f "$dest" ]; then
    echo "OK uz je $dest"
    return 0
  fi
  echo ">>> $repo / $file -> $dest"
  if command -v hf >/dev/null 2>&1; then
    hf download "$repo" "$file" --local-dir . || return 1
  else
    "$PY" - <<PY
from huggingface_hub import hf_hub_download
import shutil, os
p = hf_hub_download(repo_id="$repo", filename="$file")
shutil.copy2(p, "$dest")
print("saved", "$dest")
PY
  fi
  if [ -f "$file" ] && [ "$file" != "$dest" ]; then
    mv -f "$file" "$dest"
  fi
}

# 1) Realism — XLabs (oficiálny HF, Flux Dev)
download_as "XLabs-AI/flux-RealismLora" "lora.safetensors" "flux_RealismLora.safetensors" || true

# 2) Extra uncensored (Flux Dev) — ak repo existuje
download_as "enhanceaiteam/Flux-uncensored-v2" "lora.safetensors" "flux_uncensored_v2.safetensors" || true

echo
echo "Hotovo. Teraz máš:"
ls -lh "$LORAS"/flux_RealismLora.safetensors "$LORAS"/flux_uncensored_v2.safetensors "$LORAS"/aidmaNSFWunlock-FLUX-V0.2.safetensors 2>/dev/null || true
echo
echo "Civitai ručne (odporúčané ďalšie):"
echo "  Nude Style FLUX / Photorealistic nude -> $LORAS"
echo "  Silk Satin Nylon -> $LORAS"
echo "  Hyper Realism aidma: https://civitai.com/models/730373"
