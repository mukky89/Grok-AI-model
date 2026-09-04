# Workflows

## flux_nsfw_basic.json

Hotový Flux workflow pre tvoju AI modelku.

### Čo obsahuje:
- Flux.1 Dev FP8
- CLIP + T5 (fp8)
- VAE
- aidmaNSFWunlock LoRA (strength 0.85)
- Prompt nastavený na 23yo blond petite European
- Resolution 896×1152 (portrait)
- Steps 25, Euler, Guidance 3.5

### Ako použiť na RunPode:

```bash
cd /workspace/Grok-AI-model
git pull

# Skopíruj workflow do ComfyUI
cp workflows/flux_nsfw_basic.json /workspace/runpod-slim/ComfyUI/user/default/workflows/
```

Potom v ComfyUI:
1. Load → flux_nsfw_basic.json
2. Queue Prompt

Alebo drag & drop JSON priamo do ComfyUI okna.
