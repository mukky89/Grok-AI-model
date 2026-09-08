#!/usr/bin/env bash
set -euo pipefail
unset PIP_CONSTRAINT PIP_CONSTRAINTS || true
export PIP_CONSTRAINT=/dev/null

VENV=/workspace/ai-toolkit/.venv
PY="$VENV/bin/python"
CFG=/workspace/Grok-AI-model/scripts/alina_flux_lora_smoke.yaml
LOG=/workspace/Grok-AI-model/training_output/smoke.log
mkdir -p /workspace/Grok-AI-model/training_output

if [ ! -x "$PY" ]; then
  echo "CHYBA: najprv raz zlyhal venv. bash scripts/train_alina_flux.sh"
  exit 1
fi

echo ">>> torchaudio"
"$VENV/bin/pip" install torchaudio --index-url https://download.pytorch.org/whl/cu128 || \
"$VENV/bin/pip" install torchaudio

if [ -z "${HF_TOKEN:-}${HUGGING_FACE_HUB_TOKEN:-}" ]; then
  echo "CHYBA: export HF_TOKEN=..."
  exit 1
fi

echo ">>> smoke 2 steps (stiahne FLUX.1-dev, potrvá)"
cd /workspace/ai-toolkit
"$PY" run.py "$CFG" 2>&1 | tee "$LOG"
echo "=== koniec smoke ==="
tail -n 20 "$LOG"
