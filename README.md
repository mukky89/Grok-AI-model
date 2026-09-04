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
```

Potom stiahni **aidmaNSFWunlock** z Civitai (link v `models.txt`) do `models/loras/`.

Reštartuj ComfyUI a môžeš generovať.

---

## Štruktúra

```
Grok-AI-model/
├── README.md
├── install.sh              ← custom nodes
├── download_models.sh      ← Flux + CLIP + VAE
├── models.txt              ← zoznam + linky
├── character/
│   ├── description.md      ← popis modelky + trigger
│   └── training_guide.md   ← ako natrénovať Character LoRA
├── prompts/
│   ├── base_character.txt
│   ├── sfw.txt
│   ├── nsfw.txt
│   └── negative.txt
└── workflows/
    ├── 01_flux_basic.md
    ├── 02_character_consistency.md
    └── 03_dataset_generator.md
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
