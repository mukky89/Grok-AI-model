#!/usr/bin/env bash
set -euo pipefail

ok=0
fail=0

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
MODELS="${COMFY}/models"

echo "=============================================="
echo "  Grok AI Model – verify_setup"
echo "=============================================="

if [ -z "$COMFY" ]; then
  echo "CHYBA: ComfyUI priečinok nenájdený."
  exit 1
fi

echo "ComfyUI: $COMFY"
echo

bytes_of() { stat -c%s "$1" 2>/dev/null || echo 0; }

check_file() {
  local path="$1"
  local label="$2"
  local min="${3:-1}"
  if [ -f "$path" ] && [ "$(bytes_of "$path")" -ge "$min" ]; then
    echo "OK   $label  ($(du -h "$path" | cut -f1))"
    echo "     $path"
    ok=$((ok + 1))
  else
    echo "CHYBA $label"
    echo "     $path  size=$(bytes_of "$path")"
    fail=$((fail + 1))
  fi
}

check_file "$MODELS/unet/flux1-dev-fp8.safetensors" "Flux UNET FP8" 1000000000
check_file "$MODELS/clip/t5xxl_fp8_e4m3fn.safetensors" "T5 XXL FP8" 1000000
check_file "$MODELS/clip/clip_l.safetensors" "CLIP-L" 1000000
check_file "$MODELS/vae/ae.safetensors" "Flux VAE" 1000000

LORA_UNLOCK="$MODELS/loras/aidmaNSFWunlock-FLUX-V0.2.safetensors"
check_file "$LORA_UNLOCK" "aidmaNSFWunlock LoRA" 1000000

CHAR_LORA="$MODELS/loras/luna23_v1.safetensors"
if [ -f "$CHAR_LORA" ] && [ "$(bytes_of "$CHAR_LORA")" -ge 1000000 ]; then
  echo "OK   Character LoRA luna23_v1"
  ok=$((ok + 1))
else
  echo "INFO Character LoRA luna23_v1 ešte nie je (normálne pred tréningom)"
fi

echo
echo "Port 8188:"
if command -v netstat >/dev/null 2>&1; then
  netstat -lptn 2>/dev/null | grep -E ':8188' || echo "  nepočúva (ComfyUI asi nebeží)"
else
  echo "  netstat nie je k dispozícii"
fi

echo
echo "Venv python:"
if [ -x "$COMFY/.venv-cu128/bin/python" ]; then
  echo "OK   $COMFY/.venv-cu128/bin/python"
  ok=$((ok + 1))
elif [ -x "$COMFY/venv/bin/python" ]; then
  echo "OK   $COMFY/venv/bin/python"
  ok=$((ok + 1))
else
  echo "INFO venv python nenašiel som na očakávanej ceste"
fi

echo
echo "=============================================="
echo "  OK: $ok    CHYBY: $fail"
echo "=============================================="

if [ "$fail" -gt 0 ]; then
  exit 1
fi
