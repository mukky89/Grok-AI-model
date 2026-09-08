#!/usr/bin/env bash
set -euo pipefail
# Veľký mix: soft + nude + explicit
#   bash scripts/batch_mix.sh
#   bash scripts/batch_mix.sh 8 6 6

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOFT="${1:-8}"
NUDE="${2:-6}"
EXPL="${3:-6}"

bash "$SCRIPT_DIR/batch_heels.sh" "$SOFT" soft
bash "$SCRIPT_DIR/batch_heels.sh" "$NUDE" nude
bash "$SCRIPT_DIR/batch_heels.sh" "$EXPL" explicit
echo "hotovo mix soft=$SOFT nude=$NUDE explicit=$EXPL"
