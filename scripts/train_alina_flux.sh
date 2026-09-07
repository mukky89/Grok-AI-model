#!/usr/bin/env bash
set -euo pipefail

REPO=/workspace/Grok-AI-model
SRC=/workspace/ai-studio-tools/lora_dataset/alina_v2/img
TOOLKIT=/workspace/ai-toolkit
VENV="$TOOLKIT/.venv"
CFG="$REPO/scripts/alina_flux_lora.yaml"
LOG="$REPO/training_output/train_alina_flux.log"

# Comfy constraint by rozbil lycoris
unset PIP_CONSTRAINT PIP_CONSTRAINTS || true
export PIP_CONSTRAINT=/dev/null
export PIP_CONSTRAINTS=/dev/null

mkdir -p "$REPO/training_output"
N=$(ls "$SRC"/*.png 2>/dev/null | wc -l)
echo "dataset: $N png"

for t in "$SRC"/*.txt; do
  [ -f "$t" ] || continue
  grep -q 'alina23' "$t" || sed -i '1s/^/alina23, /' "$t"
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
  python3 -m venv "$VENV"
fi
PY="$VENV/bin/python"
"$PY" -m pip install -U pip setuptools wheel

echo ">>> torch do isolovaného venv"
"$PY" -m pip install torch torchvision --index-url https://download.pytorch.org/whl/cu128 \
  || "$PY" -m pip install torch torchvision --index-url https://download.pytorch.org/whl/cu124

echo ">>> toolkit requirements bez Comfy constraintu"
"$PY" -m pip install --no-cache-dir -r requirements.txt

echo ">>> start 2500 steps → $LOG"
nohup "$PY" run.py "$CFG" >> "$LOG" 2>&1 &
echo "PID $!"
sleep 3
tail -n 40 "$LOG" || true
