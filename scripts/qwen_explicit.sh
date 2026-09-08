#!/usr/bin/env bash
set -euo pipefail
# Explicit set cez existujuci Qwen/nina stack + Alina LoRA.
# NSFW LoRA sa nalozi ak existuje qwen_image_nsfw.safetensors
# (nina berie zatial jednu LoRA — Alina ostava primarna).
#   bash scripts/qwen_explicit.sh
#   bash scripts/qwen_explicit.sh 8

COUNT="${1:-6}"
REPO=/workspace/Grok-AI-model
SET=/workspace/ai-studio-tools/prompt_set_explicit.json
RUN="ALINA_EXPLICIT_$(date +%m%d_%H%M)"

python3 "$REPO/scripts/explicit_qwen_prompts.py" -n "$COUNT" -o "$SET"

export LORA="${LORA:-alina_v6.safetensors}"
export CHARACTER="${CHARACTER:-alina}"
export WORKFLOW=qwen
export QUALITY=premium
export STEPS="${STEPS:-30}"
export SKIN=--no-skin-detail
export PRESET=standard
export NEG="${NEG:-platform shoes, chunky heel, sneakers, barefoot, panties covering the groin, thong covering the vulva, censored, mosaic, closed legs hiding the groin, deformed nipples, child, teen, cropped feet, cropped head}"

echo ">>> Qwen explicit n=$COUNT lora=$LORA"
bash /workspace/AI-influencerka/scripts/run_prompt_set.sh "$SET" "$RUN"
echo "hotovo: /workspace/runpod-slim/ComfyUI/output/AI_Influencer/Production/$RUN"
