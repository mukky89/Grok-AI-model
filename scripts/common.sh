#!/usr/bin/env bash
# Spoločné cesty. Source: source "$(dirname "$0")/common.sh"

REPO_URL="https://github.com/mukky89/Grok-AI-model.git"
REPO_DIR="${REPO_DIR:-/workspace/Grok-AI-model}"

find_comfy() {
  if [ -n "${COMFYUI_DIR:-}" ] && [ -d "$COMFYUI_DIR" ]; then
    echo "$COMFYUI_DIR"
  elif [ -d "/workspace/runpod-slim/ComfyUI" ]; then
    echo "/workspace/runpod-slim/ComfyUI"
  elif [ -d "/workspace/ComfyUI" ]; then
    echo "/workspace/ComfyUI"
  elif [ -d "$HOME/ComfyUI" ]; then
    echo "$HOME/ComfyUI"
  else
    echo ""
  fi
}

find_python() {
  local comfy="$1"
  if [ -x "$comfy/.venv-cu128/bin/python" ]; then
    echo "$comfy/.venv-cu128/bin/python"
  elif [ -x "$comfy/venv/bin/python" ]; then
    echo "$comfy/venv/bin/python"
  elif command -v python3 >/dev/null 2>&1; then
    command -v python3
  else
    echo ""
  fi
}
