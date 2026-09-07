#!/usr/bin/env bash
set -euo pipefail

#   bash scripts/runpod.sh setup|start|stop|status|pull|sync|models|batch [N]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
# shellcheck source=common.sh
source "$SCRIPT_DIR/common.sh"

REPO_DIR="/workspace/Grok-AI-model"
CMD="${1:-setup}"
ARG2="${2:-}"

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
  echo
  echo "=== workflows v Comfy user ==="
  local comfy
  comfy="$(find_comfy)"
  if [ -n "$comfy" ]; then
    ls -1 "$comfy/user/default/workflows"/*.json 2>/dev/null || echo "žiadne JSON"
  fi
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
    tmux kill-session -t comfy || true
    sleep 1
  fi

  echo ">>> štart ComfyUI"
  tmux new-session -d -s comfy "cd '$comfy' && '$py' main.py --listen 0.0.0.0 --port 8188; echo EXIT:$?; sleep 30"

  local i
  for i in $(seq 1 30); do
    if curl -sS -m 2 http://127.0.0.1:8188/system_stats >/dev/null 2>&1; then
      echo "OK ComfyUI žije."
      return 0
    fi
    sleep 2
  done
  echo "VAROVANIE: port 8188 neodpovedá. tmux attach -t comfy"
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

sync_all() {
  bash "$REPO_DIR/scripts/sync_to_comfy.sh"
}

fetch_models() {
  bash "$REPO_DIR/scripts/fetch_missing.sh"
}

run_batch() {
  local n="${ARG2:-4}"
  bash "$REPO_DIR/scripts/batch_portraits.sh" "$n"
}

run_setup() {
  pull_repo
  cd "$REPO_DIR"
  bash "$REPO_DIR/install.sh" || true
  bash "$REPO_DIR/download_models.sh" || true
  fetch_models || true
  bash "$REPO_DIR/scripts/verify_setup.sh" || true
  sync_all
  start_comfy
}

case "$CMD" in
  setup)  run_setup ;;
  start)  start_comfy ;;
  stop)   stop_comfy ;;
  status) comfy_status ;;
  pull)   pull_repo ;;
  sync)   pull_repo; sync_all; comfy_status ;;
  models) pull_repo; fetch_models ;;
  batch)  pull_repo; run_batch ;;
  *)
    echo "Použitie: bash scripts/runpod.sh [setup|start|stop|status|pull|sync|models|batch]"
    echo "  batch [N]  N portrétov cez API (default 4)"
    exit 1
    ;;
esac
