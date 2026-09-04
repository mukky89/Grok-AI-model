# Scripts

Spúšťaj cez `bash`, nie `sh` (na RunPode je `/bin/sh` = dash).

```bash
cd /workspace/Grok-AI-model

bash scripts/verify_setup.sh
bash scripts/start_comfyui.sh          # popredie, port 8188
bash scripts/start_comfyui.sh --tmux   # prežije odpojenie SSH
bash scripts/prepare_dataset.sh
```

`start_comfyui.sh` hľadá:
- `/workspace/runpod-slim/ComfyUI`
- `/workspace/ComfyUI`
- `~/ComfyUI`

a python v `.venv-cu128` alebo `venv`.
