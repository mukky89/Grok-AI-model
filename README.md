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

Potom stiahni **aidmaNSFWunlock** z Civitai (link v `models.txt`) do `models/loras/`.

Načítaj `workflows/flux_nsfw_basic.json`. Najprv portréty, až potom full body.

UI: `https://POD_ID-8188.proxy.runpod.net`

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
