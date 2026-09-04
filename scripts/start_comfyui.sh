#!/usr/bin/env bash
set -euo pipefail

# Štart ComfyUI na RunPode: 0.0.0.0:8188
# Použitie: bash scripts/start_comfyui.sh
# Voliteľne: bash scripts/start_comfyui.sh --tmux

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
if [ -z "$COMFY" ]; then
  echo "CHYBA: ComfyUI priečinok nenájdený."
  exit 1
fi

if [ -x "$COMFY/.venv-cu128/bin/python" ]; then
  PY="$COMFY/.venv-cu128/bin/python"
elif [ -x "$COMFY/venv/bin/python" ]; then
  PY="$COMFY/venv/bin/python"
elif command -v python3 >/dev/null 2>&1; then
  PY="$(command -v python3)"
else
  echo "CHYBA: python nenájdený."
  exit 1
fi

CMD=("$PY" main.py --listen 0.0.0.0 --port 8188)

echo "ComfyUI: $COMFY"
echo "Python:  $PY"
echo "Command: ${CMD[*]}"
echo

cd "$COMFY"

if [ "${1:-}" = "--tmux" ]; then
  if ! command -v tmux >/dev/null 2>&1; then
    apt-get update -y && apt-get install -y tmux
  fi
  if tmux has-session -t comfy 2>/dev/null; then
    echo "Session 'comfy' už existuje. Attach: tmux attach -t comfy"
    exit 0
  fi
  tmux new -s comfy "${CMD[*]}"
else
  exec "${CMD[@]}"
fi
