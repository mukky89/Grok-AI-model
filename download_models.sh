#!/bin/bash
set -e

echo "=============================================="
echo "  Grok AI Model - Download Models (A40 / Flux)"
echo "=============================================="

# Detect ComfyUI models path
if [ -d "/workspace/ComfyUI/models" ]; then
    MODELS="/workspace/ComfyUI/models"
elif [ -d "/workspace/runpod-slim/ComfyUI/models" ]; then
    MODELS="/workspace/runpod-slim/ComfyUI/models"
elif [ -d "$HOME/ComfyUI/models" ]; then
    MODELS="$HOME/ComfyUI/models"
else
    echo "ComfyUI models folder not found. Creating ./models"
    MODELS="./models"
fi

echo "Models directory: $MODELS"
mkdir -p "$MODELS"/{unet,clip,vae,loras,checkpoints,controlnet,ipadapter,upscale_models}
cd "$MODELS"

echo ""
echo ">>> Using new 'hf' CLI"

echo ""
echo "=== 1/4  Downloading Flux.1 Dev FP8 ==="
if [ ! -f "unet/flux1-dev-fp8.safetensors" ] && [ ! -f "unet/flux1-dev.safetensors" ]; then
    echo "Downloading flux1-dev-fp8..."
    hf download Kijai/flux-fp8 flux1-dev-fp8.safetensors --local-dir unet/ || \
    hf download black-forest-labs/FLUX.1-dev flux1-dev.safetensors --local-dir unet/ || true
else
    echo "Flux UNET already present."
fi

echo ""
echo "=== 2/4  Downloading Text Encoders (CLIP + T5) ==="
if [ ! -f "clip/clip_l.safetensors" ]; then
    hf download comfyanonymous/flux_text_encoders clip_l.safetensors --local-dir clip/
fi
if [ ! -f "clip/t5xxl_fp8_e4m3fn.safetensors" ] && [ ! -f "clip/t5xxl_fp16.safetensors" ]; then
    echo "Downloading T5 XXL FP8..."
    hf download comfyanonymous/flux_text_encoders t5xxl_fp8_e4m3fn.safetensors --local-dir clip/ || \
    hf download comfyanonymous/flux_text_encoders t5xxl_fp16.safetensors --local-dir clip/
fi

echo ""
echo "=== 3/4  Downloading VAE ==="
if [ ! -f "vae/ae.safetensors" ]; then
    hf download black-forest-labs/FLUX.1-schnell ae.safetensors --local-dir vae/ || \
    hf download black-forest-labs/FLUX.1-dev ae.safetensors --local-dir vae/
fi

echo ""
echo "=== 4/4  NSFW LoRAs (manual from Civitai) ==="
echo ""
echo "These must be downloaded manually from Civitai:"
echo ""
echo "1. aidmaNSFWunlock (REQUIRED)"
echo "   https://civitai.com/models/674027"
echo "   Put into: $MODELS/loras/"
echo "   Trigger: aidmaNSFWunlock   Strength: 0.7-0.9"
echo ""
echo "2. Photorealistic nude / Nude Style for FLUX (recommended)"
echo "   Search on Civitai"
echo ""
echo "After downloading LoRAs, restart ComfyUI."
echo ""
echo "=============================================="
echo "  Base models download finished."
echo "=============================================="
