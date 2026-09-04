#!/usr/bin/env bash
set -euo pipefail

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

echo "LoRA dir: $LORAS"
mkdir -p "$LORAS"

download_as() {
  local repo="$1" file="$2" dest="$3"
  if [ -f "$LORAS/$dest" ]; then
    echo "OK uz je $dest"
    return 0
  fi
  echo ">>> $repo / $file -> $dest"
  "$PY" - "$repo" "$file" "$LORAS/$dest" <<'PY' || return 0
import sys, shutil
from huggingface_hub import hf_hub_download
repo, name, dest = sys.argv[1], sys.argv[2], sys.argv[3]
try:
    p = hf_hub_download(repo_id=repo, filename=name)
    shutil.copy2(p, dest)
    print("saved", dest)
except Exception as e:
    print("SKIP", repo, e)
    sys.exit(0)
PY
}

# uz mame / skusime znova
download_as "XLabs-AI/flux-RealismLora" "lora.safetensors" "flux_RealismLora.safetensors"
download_as "DavidBaloches/Hyper_Realism_Lora_by_aidma" "aidmaHyperrealism-FLUX-v0.3.safetensors" "aidmaHyperrealism-FLUX-v0.3.safetensors"
download_as "salomonsky/flux-lora-uncensored" "flux-lora-uncensored.safetensors" "flux-lora-uncensored.safetensors"
download_as "Heartsync/Flux-NSFW-uncensored" "lora.safetensors" "flux_NSFW_uncensored.safetensors"
download_as "the1ian/Flux-uncensored" "lora.safetensors" "flux_uncensored_mirror.safetensors"
download_as "Ryouko65777/Flux-Uncensored-V2" "lora.safetensors" "flux_uncensored_v2.safetensors"

echo
echo "=== Flux LoRA na disku ==="
ls -lh "$LORAS"/{aidmaNSFWunlock-FLUX-V0.2.safetensors,flux_RealismLora.safetensors,aidmaHyperrealism-FLUX-v0.3.safetensors,flux-lora-uncensored.safetensors,flux_NSFW_uncensored.safetensors,flux_uncensored_v2.safetensors,flux_uncensored_mirror.safetensors} 2>/dev/null || true
