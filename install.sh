#!/bin/bash
set -e

echo "=============================================="
echo "  Grok AI Model - Install Script (A40 / Flux)"
echo "=============================================="

# Prejdi do ComfyUI priečinka (uprav podľa tvojho setupu)
if [ -d "/workspace/ComfyUI" ]; then
    COMFYUI_DIR="/workspace/ComfyUI"
elif [ -d "/workspace/runpod-slim/ComfyUI" ]; then
    COMFYUI_DIR="/workspace/runpod-slim/ComfyUI"
elif [ -d "$HOME/ComfyUI" ]; then
    COMFYUI_DIR="$HOME/ComfyUI"
else
    echo "ComfyUI priečinok nenájdený. Nastav COMFYUI_DIR manuálne."
    exit 1
fi

echo "ComfyUI directory: $COMFYUI_DIR"
cd "$COMFYUI_DIR/custom_nodes"

echo ""
echo ">>> Inštalujem dôležité custom nodes..."

# Základné node packs
git clone https://github.com/ltdrdata/ComfyUI-Manager.git 2>/dev/null || true
git clone https://github.com/ltdrdata/ComfyUI-Impact-Pack.git 2>/dev/null || true
git clone https://github.com/Fannovel16/comfyui_controlnet_aux.git 2>/dev/null || true
git clone https://github.com/cubiq/ComfyUI_IPAdapter_plus.git 2>/dev/null || true
git clone https://github.com/cubiq/ComfyUI_InstantID.git 2>/dev/null || true
git clone https://github.com/rgthree/rgthree-comfy.git 2>/dev/null || true
git clone https://github.com/ssitu/ComfyUI_UltimateSDUpscale.git 2>/dev/null || true
git clone https://github.com/kijai/ComfyUI-KJNodes.git 2>/dev/null || true
git clone https://github.com/WASasquatch/was-node-suite-comfyui.git 2>/dev/null || true

echo ""
echo ">>> Hotovo. Reštartuj ComfyUI."
echo "Potom spusti: bash download_models.sh"
echo "=============================================="
