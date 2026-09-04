# Grok AI Model – Realistic Flux Character (AI Modelka na predaj)

Kompletný setup pre tvorbu **konzistentnej realistickej AI modelky** na Flux v ComfyUI.

**Charakteristika modelky:**
- 23 rokov
- Európsky typ
- Blond vlasy
- Nízka / petite
- Atraktívna, cute
- Mix SFW + NSFW

**Hardvér:** Optimalizované pre RunPod A40 (48 GB VRAM)

---

## Rýchly start na RunPode

```bash
# 1. Clone
git clone https://github.com/mukky89/Grok-AI-model.git
cd Grok-AI-model

# 2. Inštalácia custom nodes + základné nastavenie
bash install.sh

# 3. Stiahnutie modelov (trvá dlhšie)
bash download_models.sh
```

Potom otvor ComfyUI (port 8188) a načítaj workflow z priečinka `workflows/`.

---

## Štruktúra repa

```
Grok-AI-model/
├── README.md
├── install.sh                 # Inštalácia custom nodes
├── download_models.sh         # Stiahnutie Flux + LoRA
├── models.txt                 # Zoznam modelov
├── character/
│   ├── description.md         # Popis postavy + trigger words
│   └── training_guide.md      # Ako natrénovať Character LoRA
├── prompts/
│   ├── base_character.txt
│   ├── sfw.txt
│   ├── nsfw.txt
│   └── negative.txt
├── workflows/
│   ├── 01_flux_basic.md
│   ├── 02_character_consistency.md
│   └── 03_dataset_generator.md
└── scripts/
    └── ...
```

---

## Odporúčaný postup (najlepšia kvalita na predaj)

1. **Vygeneruj dataset** (40–80 fotiek) s FaceID / IP-Adapter
2. **Natrénuj Character LoRA** (návod v `character/training_guide.md`)
3. Používaj LoRA + FaceID pre maximálnu konzistenciu
4. Generuj SFW + NSFW packy

---

## Dôležité poznámky

- Všetky workflowy sú nastavené na **Flux.1 Dev**
- NSFW sa odomyká cez `aidmaNSFWunlock` + realistické nude LoRA
- Na A40 môžeš bežať full fp8 / Q8 bez problémov
- Odporúčané rozlíšenie: 1024×1536 alebo 896×1152 (portrait)

---

## Autor setupu
Pripravené pre mukky89 – Grok AI Model project (2026)
