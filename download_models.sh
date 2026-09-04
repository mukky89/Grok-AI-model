#!/bin/bash
set -e

echo "=============================================="
echo "  Downloading Flux + NSFW models for A40"
echo "=============================================="

# Uprav cestu podľa tvojho ComfyUI
if [ -d "/workspace/ComfyUI" ]; then
    MODELS="/workspace/ComfyUI/models"
elif [ -d "/workspace/runpod-slim/ComfyUI" ]; then
    MODELS="/workspace/runpod-slim/ComfyUI/models"
else
    MODELS="./models"
    mkdir -p "$MODELS"/{checkpoints,loras,clip,vae,unet,controlnet,ipadapter}
fi

echo "Models directory: $MODELS"
cd "$MODELS"

# Vytvor priečinky
mkdir -p checkpoints loras clip vae unet controlnet ipadapter

echo ""
echo ">>> Stiahnutie modelov vyžaduje huggingface-cli alebo manuálne linky."
echo "Odporúčané príkazy (spusti jeden po druhom):"
echo ""

cat << 'EOF'
# === FLUX BASE (vyber jednu) ===
# FP8 (odporúčané na A40 – rýchle + kvalitné)
# huggingface-cli download black-forest-labs/FLUX.1-dev --include "flux1-dev.safetensors" --local-dir checkpoints/

# Alebo GGUF Q8 (ešte úspornejšie)
# https://huggingface.co/city96/FLUX.1-dev-gguf

# === CLIP + VAE ===
# huggingface-cli download comfyanonymous/flux_text_encoders --local-dir clip/
# huggingface-cli download black-forest-labs/FLUX.1-dev --include "ae.safetensors" --local-dir vae/

# === NSFW UNLOCK + REALISTIC LORAs ===
# Tieto stiahni manuálne z Civitai a daj do loras/:
# 1. aidmaNSFWunlock (alebo podobný Flux unlock)
# 2. Photorealistic nude / Realistic_Nudes Flux
# 3. Detail skin / pores LoRA
# 4. Anatomy LoRA (pre lepšie genitálie)

echo "Po stiahnutí modelov reštartuj ComfyUI."
EOF

echo ""
echo "=============================================="
echo "Pozri models.txt pre presné linky a odporúčania."
echo "=============================================="
