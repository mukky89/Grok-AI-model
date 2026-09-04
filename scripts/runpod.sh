#!/usr/bin/env bash
set -euo pipefail

# Grok AI Model – jeden vstupný skript pre RunPod A40
# Použitie (vždy cez bash, nie sh):
#   bash /workspace/Grok-AI-model/scripts/runpod.sh
#   bash /workspace/Grok-AI-model/scripts/runpod.sh start
#   bash /workspace/Grok-AI-model/scripts/runpod.sh status
#   bash /workspace/Grok-AI-model/scripts/runpod.sh stop
#   bash /workspace/Grok-AI-model/scripts/runpod.sh pull
#   bash /workspace/Grok-AI-model/scripts/runpod.sh setup

REPO_URL="https://github.com/mukky89/Grok-AI-model.git"
REPO_DIR="/workspace/Grok-AI-model"
CMD="${1:-setup}"

find_comfy() {
  if [ -d "/workspace/runpod-slim/ComfyUI" ]; then
    echo "/workspace/runpod-slim/ComfyUI"
  elif [ -d "/workspace/ComfyUI" ]; then
    echo "/workspace/ComfyUI"
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

ensure_repo() {
  if [ ! -d "$REPO_DIR/.git" ]; then
    echo ">>> Clone $REPO_URL"
    git clone "$REPO_URL" "$REPO_DIR"
  fi
}

pull_repo() {
  ensure_repo
  echo ">>> git pull"
  git -C "$REPO_DIR" pull --ff-only || git -C "$REPO_DIR" pull
}

ensure_tmux() {
  if ! command -v tmux >/dev/null 2>&1; then
    echo ">>> instalujem tmux"
    apt-get update -y && apt-get install -y tmux
  fi
}

comfy_status() {
  echo "=== port 8188 ==="
  if command -v netstat >/dev/null 2>&1; then
    netstat -lptn 2>/dev/null | grep -E ':8188' || echo "nepočúva"
  else
    echo "netstat nie je k dispozícii"
  fi
  echo
  echo "=== curl /system_stats ==="
  curl -sS -m 8 http://127.0.0.1:8188/system_stats && echo || echo "ComfyUI neodpovedá"
  echo
  echo "=== tmux ==="
  tmux ls 2>/dev/null || echo "žiadna tmux session"
}

start_comfy() {
  local comfy py
  comfy="$(find_comfy)"
  if [ -z "$comfy" ]; then
    echo "CHYBA: ComfyUI priečinok nenájdený."
    exit 1
  fi
  py="$(find_python "$comfy")"
  if [ -z "$py" ]; then
    echo "CHYBA: python nenájdený."
    exit 1
  fi

  ensure_tmux

  if curl -sS -m 3 http://127.0.0.1:8188/system_stats >/dev/null 2>&1; then
    echo "ComfyUI už beží na 8188."
    return 0
  fi

  if tmux has-session -t comfy 2>/dev/null; then
    echo "Session comfy existuje, ale port neodpovedá — restart."
    tmux kill-session -t comfy || true
    sleep 1
  fi

  echo ">>> štart ComfyUI"
  echo "    dir: $comfy"
  echo "    py:  $py"
  tmux new-session -d -s comfy "cd '$comfy' && '$py' main.py --listen 0.0.0.0 --port 8188; echo EXIT:$?; sleep 30"

  echo "čakám na port 8188..."
  local i
  for i in $(seq 1 30); do
    if curl -sS -m 2 http://127.0.0.1:8188/system_stats >/dev/null 2>&1; then
      echo "OK ComfyUI žije."
      echo "UI: https://POD_ID-8188.proxy.runpod.net"
      echo "log: tmux attach -t comfy"
      return 0
    fi
    sleep 2
  done

  echo "VAROVANIE: port 8188 po 60s neodpovedá. Pozri log:"
  echo "  tmux attach -t comfy"
  return 1
}

stop_comfy() {
  if tmux has-session -t comfy 2>/dev/null; then
    tmux kill-session -t comfy
    echo "tmux session comfy zastavená."
  else
    echo "tmux session comfy nebeží."
  fi
  pkill -f "main.py --listen" 2>/dev/null || true
}

run_setup() {
  pull_repo
  cd "$REPO_DIR"

  echo ">>> install.sh"
  bash "$REPO_DIR/install.sh" || true

  echo ">>> download_models.sh"
  bash "$REPO_DIR/download_models.sh" || true

  echo ">>> verify_setup.sh"
  bash "$REPO_DIR/scripts/verify_setup.sh" || true

  echo ">>> prepare_dataset.sh"
  bash "$REPO_DIR/scripts/prepare_dataset.sh"

  echo ">>> apply_fullbody_workflow.sh"
  bash "$REPO_DIR/scripts/apply_fullbody_workflow.sh" || true

  start_comfy

  echo
  echo "=============================================="
  echo "  Setup hotový"
  echo "  Load v ComfyUI: workflows/flux_nsfw_basic.json"
  echo "  Portréty najprv, full body až po referenčnej tvári."
  echo "  Dataset: $REPO_DIR/dataset/luna23"
  echo "=============================================="
}

case "$CMD" in
  setup)  run_setup ;;
  start)  start_comfy ;;
  stop)   stop_comfy ;;
  status) comfy_status ;;
  pull)   pull_repo ;;
  *)
    echo "Použitie: bash scripts/runpod.sh [setup|start|stop|status|pull]"
    exit 1
    ;;
esac
