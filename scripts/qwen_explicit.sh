#!/usr/bin/env bash
set -euo pipefail
COUNT="${1:-4}"
REPO=/workspace/Grok-AI-model
SET=/workspace/ai-studio-tools/prompt_set_explicit.json
RUN="ALINA_EXPLICIT_$(date +%m%d_%H%M)"

python3 "$REPO/scripts/patch_nina_extra_lora.py"
python3 "$REPO/scripts/explicit_qwen_prompts.py" -n "$COUNT" -o "$SET"

export LORA="${LORA:-alina_v6.safetensors}"
export CHARACTER="${CHARACTER:-alina}"
export EXTRA_LORA="${EXTRA_LORA:-qwen_image_nsfw.safetensors}"
export EXTRA_LORA_STRENGTH="${EXTRA_LORA_STRENGTH:-0.75}"
export WORKFLOW=qwen
export QUALITY=premium
export STEPS="${STEPS:-30}"
export SKIN=--no-skin-detail
export PRESET=standard
export NEG="${NEG:-platform shoes, chunky heel, sneakers, barefoot, panties covering the groin, thong covering the vulva, censored, mosaic, closed legs hiding the groin, deformed nipples, child, teen, cropped feet, cropped head}"

echo ">>> Qwen explicit n=$COUNT lora=$LORA extra=$EXTRA_LORA @$EXTRA_LORA_STRENGTH"
bash /workspace/AI-influencerka/scripts/run_prompt_set.sh "$SET" "$RUN"
echo "hotovo: /workspace/runpod-slim/ComfyUI/output/AI_Influencer/Production/$RUN"
