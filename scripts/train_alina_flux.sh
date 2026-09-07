#!/usr/bin/env bash
set -euo pipefail

# Plnohodnotný Flux LoRA tréning — VLASTNÝ venv, nie Comfy.
#   export HF_TOKEN=hf_...
#   bash scripts/train_alina_flux.sh

REPO=/workspace/Grok-AI-model
SRC=/workspace/ai-studio-tools/lora_dataset/alina_v2/img
TOOLKIT=/workspace/ai-toolkit
VENV="$TOOLKIT/.venv"
CFG="$REPO/scripts/alina_flux_lora.yaml"
LOG="$REPO/training_output/train_alina_flux.log"

mkdir -p "$REPO/training_output"

if [ ! -d "$SRC" ]; then
  echo "CHYBA dataset: $SRC"
  exit 1
fi

N=$(ls "$SRC"/*.png 2>/dev/null | wc -l)
echo "dataset: $N png"

echo ">>> captions trigger alina23"
for t in "$SRC"/*.txt; do
  [ -f "$t" ] || continue
  if ! grep -q 'alina23' "$t"; then
    sed -i '1s/^/alina23, /' "$t"
  fi
done

if [ -z "${HF_TOKEN:-}${HUGGING_FACE_HUB_TOKEN:-}" ]; then
  echo "CHYBA: export HF_TOKEN=hf_..."
  exit 1
fi

if [ ! -d "$TOOLKIT/.git" ]; then
  git clone --depth 1 https://github.com/ostris/ai-toolkit.git "$TOOLKIT"
fi
cd "$TOOLKIT"
git submodule update --init --recursive || true

if [ ! -x "$VENV/bin/python" ]; then
  echo ">>> nový venv $VENV"
  python3 -m venv "$VENV"
fi
PY="$VENV/bin/python"
"$PY" -m pip install -U pip setuptools wheel
# izolovaný install — žiadny Comfy constraint
echo ">>> pip toolkit deps"
"$PY" -m pip install -r requirements.txt

echo ">>> start 2500 steps"
echo "log: $LOG"
nohup "$PY" run.py "$CFG" >> "$LOG" 2>&1 &
echo "PID $!"
sleep 2
tail -n 30 "$LOG" || true
