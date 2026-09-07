# Grok AI Model – Realistic Flux Character (AI Modelka na predaj)

Kompletný setup pre tvorbu **konzistentnej realistickej AI modelky** na **Flux** v ComfyUI.

**Charakteristika modelky:**
- 23 rokov
- Európsky typ
- Blond vlasy, cute, atraktívna
- Nízka / petite
- Mix SFW + NSFW
- Trigger: `luna23`

**Hardvér:** RunPod A40 (48 GB VRAM) alebo RTX 4090 fp8

---

## Rýchly start na RunPode

```bash
cd /workspace
git clone https://github.com/mukky89/Grok-AI-model.git
cd Grok-AI-model
bash scripts/runpod.sh setup
```

Ak už repo existuje:

```bash
cd /workspace/Grok-AI-model
git pull
bash scripts/runpod.sh start     # ComfyUI v tmux na 8188
bash scripts/runpod.sh status    # žije?
```

SSH a denné príkazy: [`docs/runpod-ssh.md`](docs/runpod-ssh.md)

Potom stiahni **aidmaNSFWunlock** z Civitai (link v `models.txt`) do `models/loras/`.

Načítaj `workflows/flux_nsfw_basic.json`. Najprv portréty, až potom full body.

UI: `https://POD_ID-8188.proxy.runpod.net`

---

## Dokumentácia z tohto setupu

| Súbor | Čo |
|---|---|
| [`docs/stack.md`](docs/stack.md) | Flux vs Pony vs SDXL — čo vyzerá ako reálna fotka |
| [`docs/sales-workflow.md`](docs/sales-workflow.md) | Denný predajný pipeline, Set 01, quality gate |
| [`docs/runpod-ssh.md`](docs/runpod-ssh.md) | SSH, volume, start/stop |
| [`workflows/07_sales_pipeline.md`](workflows/07_sales_pipeline.md) | Krátky predajný postup |
| [`character/description.md`](character/description.md) | Char sheet |
| [`character/training_guide.md`](character/training_guide.md) | Character LoRA |

---

## Helper skripty

Všetko spúšťaj cez `bash` (na RunPode je `/bin/sh` = dash).

| Skript | Čo robí |
|---|---|
| `scripts/runpod.sh setup` | pull + nodes + models + dataset + start |
| `scripts/runpod.sh start` | ComfyUI v tmux `0.0.0.0:8188` |
| `scripts/runpod.sh status` | port + /system_stats |
| `scripts/runpod.sh stop` | zastaví tmux comfy |
| `scripts/verify_setup.sh` | skontroluje Flux súbory |
| `scripts/prepare_dataset.sh` | `dataset/luna23/{portraits,half_body,full_body,nsfw}` |

---

## Odporúčaný postup (najlepšia kvalita na predaj)

1. Vygeneruj **dataset 40–80 fotiek** (najprv tvár)
2. Natrénuj **Character LoRA** (`character/training_guide.md`)
3. Používaj **Character LoRA + aidmaNSFWunlock** (max 2 extra LoRA)
4. Generuj SFW + NSFW packy podľa `docs/sales-workflow.md`
5. Video len I2V z vybranej fotky, nie text-to-video

---

## Dôležité nastavenia Flux

- Draft: 28 steps, CFG 3.2, 768×1152
- Finále: 32–36 steps, 896×1152
- Sampler na predaj: DPM++ 2M + beta (staré workflow môže mať euler — na look skús oba)
- Guidance: 2.5–3.5
- NSFW unlock: 0.7–0.9
- Character LoRA: 0.8–0.95

---

## Autor
Pripravené pre mukky89 – Grok AI Model project (September 2026)
