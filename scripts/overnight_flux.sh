#!/usr/bin/env bash
set -uo pipefail
# Beží do 06:00 miestneho času poda.
#   bash scripts/overnight_flux.sh

END=$(date -d "06:00" +%s)
NOW=$(date +%s)
if [ "$NOW" -ge "$END" ]; then
  END=$(date -d "tomorrow 06:00" +%s)
fi
LOG=/workspace/Grok-AI-model/training_output/overnight.log
mkdir -p /workspace/Grok-AI-model/training_output
echo "deadline $(date -d @$END)" | tee -a "$LOG"

wait_train() {
  while pgrep -f "run.py .*alina_flux_lora.yaml" >/dev/null 2>&1; do
    echo "$(date -Iseconds) training still running" | tee -a "$LOG"
    sleep 120
    if [ "$(date +%s)" -ge "$END" ]; then
      echo "deadline počas tréningu — nechávam job dobehnúť" | tee -a "$LOG"
      return 0
    fi
  done
}

wait_train

LATEST=$(ls -t /workspace/Grok-AI-model/training_output/alina_flux_v1/*.safetensors 2>/dev/null | head -n 1 || true)
if [ -n "$LATEST" ]; then
  cp -f "$LATEST" /workspace/runpod-slim/ComfyUI/models/loras/alina_flux_v1.safetensors
  echo "LoRA → models/loras/alina_flux_v1.safetensors ($LATEST)" | tee -a "$LOG"
fi

while [ "$(date +%s)" -lt "$END" ]; do
  echo "$(date -Iseconds) flux batch 4" | tee -a "$LOG"
  bash /workspace/Grok-AI-model/scripts/batch_portraits.sh 4 >> "$LOG" 2>&1 || true
  sleep 5
done
echo "STOP $(date -Iseconds)" | tee -a "$LOG"
