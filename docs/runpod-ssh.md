# RunPod – SSH a dennodenné použitie

Nepoužívaj volume disk ako jediné úložisko modelov. Network Volume v tom istom regióne = modely prežijú stop poda.

GPU: A40 48 GB (aktuálny target repo) alebo RTX 4090 24 GB fp8.

## Pripojenie

Z RunPod UI skopíruj SSH príkaz (IP, port, kľúč). Príklad tvaru:

```bash
ssh root@POD_IP -p PORT -i ~/.ssh/id_ed25519
```

IP a port nedávaj do gitu.

Overenie:

```bash
nvidia-smi
df -h
ls /workspace
```

## Prvý setup

```bash
cd /workspace
git clone https://github.com/mukky89/Grok-AI-model.git
cd Grok-AI-model
bash scripts/runpod.sh setup
```

Ak už repo je:

```bash
cd /workspace/Grok-AI-model
git pull
bash scripts/runpod.sh start
bash scripts/runpod.sh status
```

Comfy hľadá v `/workspace/runpod-slim/ComfyUI` alebo `/workspace/ComfyUI`.

UI: `https://POD_ID-8188.proxy.runpod.net`

## Čo setup spraví

- git pull
- install.sh
- download_models.sh
- verify_setup.sh
- prepare_dataset.sh (dataset/luna23)
- apply_fullbody_workflow.sh
- ComfyUI v tmux na 0.0.0.0:8188

Potom ručne stiahni `aidmaNSFWunlock` do `models/loras/` — link v `models.txt`, treba Civitai token.

## Denné príkazy

```bash
bash scripts/runpod.sh start
bash scripts/runpod.sh status
bash scripts/runpod.sh stop
bash scripts/runpod.sh pull
tmux attach -t comfy    # log
```

Po práci **stop pod**, Network Volume nechaj. Nenechávaj Comfy 24 h naprázdno.

## Load v ComfyUI

1. `workflows/flux_nsfw_basic.json` — portréty / lock tváre
2. až potom `workflows/flux_nsfw_fullbody.json`
3. predajný postup: `docs/sales-workflow.md`
