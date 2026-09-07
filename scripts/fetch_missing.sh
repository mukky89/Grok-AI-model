#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

COMFY="$(find_comfy)"
if [ -z "$COMFY" ]; then
  echo "CHYBA: ComfyUI nenájdený"
  exit 1
fi

MODELS="$COMFY/models"
mkdir -p "$MODELS/unet" "$MODELS/clip" "$MODELS/vae" "$MODELS/loras"

PY="$(find_python "$COMFY")"
PY="${PY:-python3}"

file_ok() {
  local f="$1" min="$2"
  [ -f "$f" ] && [ "$(stat -c%s "$f" 2>/dev/null || echo 0)" -ge "$min" ]
}

TARGET_UNET="$MODELS/unet/flux1-dev-fp8.safetensors"
LORA_DEST="$MODELS/loras/aidmaNSFWunlock-FLUX-V0.2.safetensors"

if file_ok "$TARGET_UNET" 1000000000; then
  echo "OK Flux UNET: $TARGET_UNET ($(du -h "$TARGET_UNET" | cut -f1))"
else
  echo ">>> sťahujem Flux FP8 z HuggingFace"
  SRC="$("$PY" - <<'PY'
import os
from huggingface_hub import hf_hub_download
token = os.environ.get("HF_TOKEN") or os.environ.get("HUGGING_FACE_HUB_TOKEN")
print(hf_hub_download(repo_id="Kijai/flux-fp8", filename="flux1-dev-fp8.safetensors", token=token))
PY
)"
  ln -sfn "$SRC" "$TARGET_UNET"
  echo "OK $TARGET_UNET"
fi

if file_ok "$LORA_DEST" 1000000; then
  echo "OK LoRA: $LORA_DEST ($(du -h "$LORA_DEST" | cut -f1))"
else
  rm -f "$LORA_DEST"
  echo "=== disk ==="
  df -h /workspace /tmp /root 2>/dev/null || df -h
  if [ -z "${CIVITAI_TOKEN:-}" ]; then
    echo "CHYBA: nastav CIVITAI_TOKEN a spusti znova: bash scripts/runpod.sh models"
  else
    TMP="/tmp/aidmaNSFWunlock.safetensors"
    rm -f "$TMP"
    echo ">>> Civitai → $TMP"
    if curl -L --fail --retry 3 --retry-all-errors \
      -H "Authorization: Bearer ${CIVITAI_TOKEN}" \
      -o "$TMP" \
      "https://civitai.com/api/download/models/754348"; then
      if file_ok "$TMP" 1000000; then
        cp -f "$TMP" "$LORA_DEST"
        echo "OK $LORA_DEST ($(du -h "$LORA_DEST" | cut -f1))"
      else
        echo "CHYBA: stiahnutý súbor je prázdny/HTML"
        head -c 200 "$TMP" || true
      fi
    else
      echo "Civitai download zlyhal"
    fi
  fi
fi

echo
bash "$SCRIPT_DIR/verify_setup.sh" || true
