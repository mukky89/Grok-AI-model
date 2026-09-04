# Grok AI Model – Realistic Flux Character (AI Modelka na predaj)

Kompletný setup pre tvorbu **konzistentnej realistickej AI modelky** na **Flux.1 Dev** v ComfyUI.

**Charakteristika modelky:**
- 23 rokov
- Európsky typ
- Blond vlasy, cute, atraktívna
- Nízka / petite
- Mix SFW + NSFW

**Hardvér:** Optimalizované pre **RunPod A40 (48 GB VRAM)**

---

## Rýchly start na RunPode

```bash
# 1. Clone
cd /workspace
git clone https://github.com/mukky89/Grok-AI-model.git
cd Grok-AI-model

# 2. Inštalácia custom nodes
bash install.sh

# 3. Stiahnutie Flux + text encoders + VAE
bash download_models.sh

# 4. Over súbory + štart ComfyUI
bash scripts/verify_setup.sh
bash scripts/start_comfyui.sh --tmux
```

Potom stiahni **aidmaNSFWunlock** z Civitai (link v `models.txt`) do `models/loras/`.

Načítaj `workflows/flux_nsfw_basic.json` v ComfyUI (port 8188).

---

## Helper skripty

Všetko spúšťaj cez `bash` (na RunPode je `/bin/sh` = dash).

| Skript | Čo robí |
|---|---|
| `scripts/verify_setup.sh` | Skontroluje Flux UNET, CLIP, VAE, unlock LoRA, port 8188 |
| `scripts/start_comfyui.sh` | Štart `0.0.0.0:8188` cez `.venv-cu128` |
| `scripts/start_comfyui.sh --tmux` | To isté v tmux session `comfy` |
| `scripts/prepare_dataset.sh` | Vytvorí `dataset/luna23/{portraits,half_body,full_body,nsfw}` |

---

## Štruktúra

```
Grok-AI-model/
├── README.md
├── install.sh
├── download_models.sh
├── models.txt
├── scripts/
│   ├── verify_setup.sh
│   ├── start_comfyui.sh
│   └── prepare_dataset.sh
├── character/
│   ├── description.md
│   └── training_guide.md
├── prompts/
├── workflows/
│   ├── flux_nsfw_basic.json
│   ├── 01_flux_basic.md
│   ├── 02_character_consistency.md
│   └── 03_dataset_generator.md
└── dataset/luna23/          ← vznikne po prepare_dataset.sh
```

---

## Odporúčaný postup (najlepšia kvalita na predaj)

1. Vygeneruj **dataset 40–80 fotiek** (FaceID + base prompt)
2. Natrénuj **Character LoRA** (návod v `character/training_guide.md`)
3. Používaj **Character LoRA + FaceID + aidmaNSFWunlock**
4. Generuj SFW + NSFW packy

---

## Dôležité nastavenia Flux

- Steps: 20–28
- Sampler: euler
- Guidance: 2.5–3.5
- Resolution: 896×1152 alebo 1024×1536
- NSFW unlock strength: 0.7–0.9
- Character LoRA strength: 0.8–0.95

---

## Autor
Pripravené pre mukky89 – Grok AI Model project (September 2026)
