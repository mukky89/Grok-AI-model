#!/usr/bin/env bash
set -euo pipefail

# Spustí existujúci Alina production stack, nie Grok Flux test.
#   bash scripts/run_alina.sh
#   bash scripts/run_alina.sh 50

PROD=/workspace/ai-studio-tools/alina_production.sh
FIFTY=/workspace/ai-studio-tools/run_alina_50.sh
N="${1:-}"

echo "=== Alina production ==="
ls -lh /workspace/runpod-slim/ComfyUI/models/loras/alina_v6.safetensors
ls /workspace/runpod-slim/ComfyUI/input/alina_v3_reference_001.png

if [ "$N" = "50" ] && [ -x "$FIFTY" ] || [ "$N" = "50" ] && [ -f "$FIFTY" ]; then
  echo ">>> $FIFTY"
  bash "$FIFTY"
  exit $?
fi

if [ -f "$PROD" ]; then
  echo ">>> $PROD"
  head -n 30 "$PROD"
  echo "-----"
  bash "$PROD"
  exit $?
fi

echo "CHYBA: nenašiel som alina_production.sh"
exit 1
