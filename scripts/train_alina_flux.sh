#!/usr/bin/env bash
set -euo pipefail

# Plnohodnotný Flux LoRA tréning Aliny.
#   export HF_TOKEN=...
#   bash scripts/train_alina_flux.sh

REPO=/workspace/Grok-AI-model
SRC=/workspace/ai-studio-tools/lora_dataset/alina_v2/img
TOOLKIT=/workspace/ai-toolkit
CFG="$REPO/scripts/alina_flux_lora.yaml"
LOG="$REPO/training_output/train_alina_flux.log"
PY=/workspace/runpod-slim/ComfyUI/.venv-cu128/bin/python
[ -x "$PY" ] || PY=python3

mkdir -p "$REPO/training_output"

if [ ! -d "$SRC" ]; then
  echo "CHYBA dataset: $SRC"
  exit 1
fi

N=$(ls "$SRC"/*.png 2>/dev/null | wc -l)
echo "dataset: $N png v $SRC"
if [ "$N" -lt 20 ]; then
  echo "CHYBA: málo fotiek"
  exit 1
fi

echo ">>> captions: dopln trigger alina23 ak chýba"
for t in "$SRC"/*.txt; do
  [ -f "$t" ] || continue
  if ! grep -q 'alina23' "$t"; then
    sed -i '1s/^/alina23, /' "$t"
  fi
done

if [ -z "${HF_TOKEN:-}${HUGGING_FACE_HUB_TOKEN:-}" ]; then
  echo "VAROVANIE: HF_TOKEN nie je set. FLUX.1-dev sa nemusí stiahnuť."
  echo "  export HF_TOKEN=hf_..."
fi

if [ ! -d "$TOOLKIT/.git" ]; then
  echo ">>> git clone ostris/ai-toolkit"
  git clone --depth 1 https://github.com/ostris/ai-toolkit.git "$TOOLKIT"
fi
cd "$TOOLKIT"
git submodule update --init --recursive || true

echo ">>> deps"
"$PY" -m pip install -q -r requirements.txt || "$PY" -m pip install -r requirements.txt

echo ">>> start training 2500 steps dim32 → log $LOG"
echo "    GPU by nemala bežať nina-make ani Comfy sample naraz."
nohup "$PY" run.py "$CFG" >> "$LOG" 2>&1 &
echo "PID $!"
echo "tail -f $LOG"
