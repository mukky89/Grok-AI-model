#!/usr/bin/env bash
set -euo pipefail

# Natrénuje Flux LoRA z existujúceho Alina datasetu.
#   bash scripts/train_alina_flux.sh

SRC=/workspace/ai-studio-tools/lora_dataset/alina_v2/img
DST=/workspace/Grok-AI-model/dataset/alina_flux
OUT=/workspace/runpod-slim/ComfyUI/models/loras
TOOLKIT=/workspace/ai-toolkit

echo "=== Flux Alina LoRA ==="
if [ ! -d "$SRC" ]; then
  echo "CHYBA: dataset nie je $SRC"
  exit 1
fi
mkdir -p "$DST" "$OUT"
# nespamuj kópiami — symlink
ln -sfn "$SRC" "$DST/img"
echo "fotky: $(ls "$SRC"/*.png 2>/dev/null | wc -l)"

if [ ! -d "$TOOLKIT" ]; then
  echo ">>> clone ostris/ai-toolkit"
  git clone https://github.com/ostris/ai-toolkit.git "$TOOLKIT"
fi

CFG=/workspace/Grok-AI-model/scripts/alina_flux_lora.yaml
echo "config: $CFG"
echo "Po tréningu daj LoRA do $OUT/alina_flux_v1.safetensors"
echo
echo "Spusti ručne ak toolkit žiada venv:"
echo "  cd $TOOLKIT && python run.py $CFG"

if [ -x /workspace/runpod-slim/ComfyUI/.venv-cu128/bin/python ]; then
  PY=/workspace/runpod-slim/ComfyUI/.venv-cu128/bin/python
else
  PY=python3
fi

if [ -f "$TOOLKIT/run.py" ]; then
  cd "$TOOLKIT"
  "$PY" run.py "$CFG" || echo "ak run.py padlo, doinštaluj: pip install -r requirements.txt"
fi
