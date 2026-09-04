# Scripts

Na RunPode vždy `bash`, nie `sh`.

## Hlavný vstup

```bash
cd /workspace/Grok-AI-model
git pull
bash scripts/runpod.sh setup    # pull + nodes + models + dataset + start tmux
bash scripts/runpod.sh start    # len ComfyUI v tmux na 0.0.0.0:8188
bash scripts/runpod.sh status   # port + /system_stats + tmux
bash scripts/runpod.sh stop
bash scripts/runpod.sh pull
```

Log ComfyUI: `tmux attach -t comfy`  (odpojiť: Ctrl+B, D)

## Ďalšie

| Skript | Čo robí |
|---|---|
| `verify_setup.sh` | Flux UNET, CLIP, VAE, unlock LoRA |
| `start_comfyui.sh` | priamy štart / `--tmux` |
| `prepare_dataset.sh` | `dataset/luna23/...` |
| `apply_fullbody_workflow.sh` | skopíruje JSON do ComfyUI user/workflows |
