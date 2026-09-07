#!/usr/bin/env bash
set -euo pipefail

# Nájde Alina referenčné fotky na pode.
#   bash scripts/find_alina.sh

echo "=== hľadám Alina / LLM ref ==="
find /workspace /root /home -type f \(
  -iname '*alina*' -o -iname '*ALINA*' -o -iname '*llm_0825*' -o -iname '*0825_final*'
\) 2>/dev/null | grep -Ei '\.(png|jpg|jpeg|webp)$' || true

echo
echo "=== najväčšie png/jpg v typických priečinkoch ==="
for d in \
  /workspace \
  /workspace/Grok-AI-model \
  /workspace/Grok-AI-model/dataset_keep \
  /workspace/runpod-slim/ComfyUI/input \
  /workspace/runpod-slim/ComfyUI/output \
  /workspace/ComfyUI/input \
  /workspace/ComfyUI/output
do
  [ -d "$d" ] || continue
  echo "-- $d"
  find "$d" -maxdepth 3 -type f \( -iname '*.png' -o -iname '*.jpg' \) -printf '%s %p\n' 2>/dev/null \
    | sort -nr | head -n 15 || true
done
