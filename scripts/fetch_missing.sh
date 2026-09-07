#!/usr/bin/env bash
set -euo pipefail

# Doplní chýbajúci Flux UNET a aidmaNSFWunlock.
#   bash scripts/fetch_missing.sh
# Voliteľné env:
#   HF_TOKEN / HUGGING_FACE_HUB_TOKEN
#   CIVITAI_TOKEN

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

COMFY="$(find_comfy)"
if [ -z "$COMFY" ]; then
  echo "CHYBA: ComfyUI nenájdený"
  exit 1
fi

MODELS="$COMFY/models"
mkdir -p "$MODELS"/{unet,clip,vae,loras,diffusion_models}

PY="$(find_python "$COMFY")"
PY="${PY:-python3}"

find_existing_flux() {
  find /workspace -type f \(
    -iname 'flux1-dev-fp8.safetensors' -o
    -iname 'flux1-dev.safetensors' -o
    -iname 'flux1-dev-fp8*.safetensors'
  \) 2>/dev/null | head -n 1
}

TARGET_UNET="$MODELS/unet/flux1-dev-fp8.safetensors"

if [ -f "$TARGET_UNET" ]; then
  echo "OK Flux UNET už je: $TARGET_UNET"
else
  EXISTING="$(find_existing_flux || true)"
  if [ -n "$EXISTING" ]; then
    echo ">>> našiel som Flux: $EXISTING"
    ln -sfn "$EXISTING" "$TARGET_UNET"
    # ak má iný názov ako fp8, stále linkni očakávanú cestu
    echo "OK symlink → $TARGET_UNET"
  else
    echo ">>> sťahujem Flux FP8 z HuggingFace (Kijai/flux-fp8)"
    if ! "$PY" - <<'PY'
import os, shutil
from huggingface_hub import hf_hub_download
token = os.environ.get("HF_TOKEN") or os.environ.get("HUGGING_FACE_HUB_TOKEN")
p = hf_hub_download(repo_id="Kijai/flux-fp8", filename="flux1-dev-fp8.safetensors", token=token)
print(p)
PY
    then
      echo "HF download zlyhal. Nastav HF_TOKEN a spusti znova."
    else
      SRC="$("$PY" - <<'PY'
import os
from huggingface_hub import hf_hub_download
token = os.environ.get("HF_TOKEN") or os.environ.get("HUGGING_FACE_HUB_TOKEN")
print(hf_hub_download(repo_id="Kijai/flux-fp8", filename="flux1-dev-fp8.safetensors", token=token))
PY
)"
      cp -n "$SRC" "$TARGET_UNET" 2>/dev/null || ln -sfn "$SRC" "$TARGET_UNET"
      echo "OK $TARGET_UNET"
    fi
  fi
fi

LORA_DEST="$MODELS/loras/aidmaNSFWunlock-FLUX-V0.2.safetensors"
if ls "$MODELS/loras/"*aidma*NSFW* >/dev/null 2>&1 || [ -f "$LORA_DEST" ]; then
  echo "OK aidmaNSFWunlock už je"
  ls -1 "$MODELS/loras/"*aidma* 2>/dev/null || true
else
  if [ -z "${CIVITAI_TOKEN:-}" ]; then
    echo "CHYBA: chýba aidmaNSFWunlock a nie je CIVITAI_TOKEN"
    echo "  export CIVITAI_TOKEN=xxx"
    echo "  bash scripts/fetch_missing.sh"
    echo "  token: https://civitai.com/user/account (API Keys)"
  else
    echo ">>> sťahujem aidmaNSFWunlock z Civitai"
    # model 674027 — current version download endpoint
    curl -L --fail --retry 3 \
      -H "Authorization: Bearer $CIVITAI_TOKEN" \
      -o "$LORA_DEST" \
      "https://civitai.com/api/download/models/754348" \
    || curl -L --fail --retry 3 \
      -H "Authorization: Bearer $CIVITAI_TOKEN" \
      -o "$LORA_DEST" \
      "https://civitai.com/api/download/models/674027" \
    || echo "Civitai download zlyhal — skontroluj token / version id"
    if [ -f "$LORA_DEST" ]; then
      echo "OK $LORA_DEST ($(du -h "$LORA_DEST" | cut -f1))"
    fi
  fi
fi

echo
bash "$SCRIPT_DIR/verify_setup.sh" || true
