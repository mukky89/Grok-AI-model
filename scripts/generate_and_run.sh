#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PY=""
for c in \
  /workspace/runpod-slim/ComfyUI/.venv-cu128/bin/python \
  /workspace/ComfyUI/.venv-cu128/bin/python \
  /workspace/runpod-slim/ComfyUI/venv/bin/python
do
  if [ -x "$c" ]; then PY="$c"; break; fi
done
PY="${PY:-$(command -v python3 || true)}"
if [ -z "$PY" ]; then echo "CHYBA: python3 chyba"; exit 1; fi
"$PY" "$ROOT/scripts/generate_and_run.py" "$@"
