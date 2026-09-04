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
echo ">>> Checking huggingface-cli..."
if ! command -v huggingface-cli &> /dev/null; then
    echo "Installing huggingface_hub..."
    pip install -U huggingface_hub[hf_transfer] -q
fi

export HF_HUB_ENABLE_HF_TRANSFER=1

echo ""
echo "=== 1/4  Downloading Flux.1 Dev (FP8 recommended for A40) ==="
# Official FP8 or community FP8
if [ ! -f "unet/flux1-dev-fp8.safetensors" ] && [ ! -f "unet/flux1-dev.safetensors" ]; then
    echo "Downloading flux1-dev-fp8 (or full)..."
    # Try Kijai / community FP8 first (smaller)
    huggingface-cli download Kijai/flux-fp8 flux1-dev-fp8.safetensors --local-dir unet/ --local-dir-use-symlinks False 2>/dev/null || \
    huggingface-cli download black-forest-labs/FLUX.1-dev flux1-dev.safetensors --local-dir unet/ --local-dir-use-symlinks False || true
else
    echo "Flux UNET already present."
fi

echo ""
echo "=== 2/4  Downloading Text Encoders (CLIP + T5) ==="
if [ ! -f "clip/clip_l.safetensors" ]; then
    huggingface-cli download comfyanonymous/flux_text_encoders clip_l.safetensors --local-dir clip/ --local-dir-use-symlinks False
fi
if [ ! -f "clip/t5xxl_fp8_e4m3fn.safetensors" ] && [ ! -f "clip/t5xxl_fp16.safetensors" ]; then
    # FP8 T5 is enough and faster on A40
    huggingface-cli download comfyanonymous/flux_text_encoders t5xxl_fp8_e4m3fn.safetensors --local-dir clip/ --local-dir-use-symlinks False || \
    huggingface-cli download comfyanonymous/flux_text_encoders t5xxl_fp16.safetensors --local-dir clip/ --local-dir-use-symlinks False
fi

echo ""
echo "=== 3/4  Downloading VAE ==="
if [ ! -f "vae/ae.safetensors" ]; then
    huggingface-cli download black-forest-labs/FLUX.1-schnell ae.safetensors --local-dir vae/ --local-dir-use-symlinks False || \
    huggingface-cli download black-forest-labs/FLUX.1-dev ae.safetensors --local-dir vae/ --local-dir-use-symlinks False
fi

echo ""
echo "=== 4/4  NSFW LoRAs (manual from Civitai) ==="
echo ""
echo "These must be downloaded manually from Civitai (login required for some):"
echo ""
echo "1. aidmaNSFWunlock (most important - unlock NSFW on Flux)"
echo "   https://civitai.com/models/674027"
echo "   → put into: $MODELS/loras/"
echo "   Trigger: aidmaNSFWunlock   Strength: 0.7-0.9"
echo ""
echo "2. Photorealistic nude / Nude Style for FLUX (skin + anatomy)"
echo "   Search on Civitai: 'Photorealistic nude Flux' or 'Nude Style for FLUX V2'"
echo "   → put into: $MODELS/loras/"
echo ""
echo "3. (Optional) Detail / skin pores LoRA"
echo ""
echo "After downloading LoRAs, restart ComfyUI."
echo ""
echo "=============================================="
echo "  Base models download finished."
echo "  Now download the 1-2 NSFW LoRAs from Civitai."
echo "=============================================="
