#!/usr/bin/env bash
set -euo pipefail
# Wrapper pre RunPod (dash nemá python alias).

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PY=""
for c in \
  /workspace/runpod-slim/ComfyUI/.venv-cu128/bin/python \
  /workspace/ComfyUI/.venv-cu128/bin/python \
  /workspace/runpod-slim/ComfyUI/venv/bin/python
do
  if [ -x "$c" ]; then PY="$c"; break; fi
done
if [ -z "$PY" ]; then
  PY="$(command -v python3 || true)"
fi
if [ -z "$PY" ]; then
  echo "CHYBA: python3 nenájdený"
  exit 1
fi

mkdir -p "$ROOT/dataset/luna23/captions"
"$PY" "$ROOT/scripts/generate_nsfw_prompts.py" "$@"
