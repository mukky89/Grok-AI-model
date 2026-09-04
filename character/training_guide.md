# Character LoRA Training Guide (Flux)

Cieľ: Natrénovať silnú Character LoRA, aby modelka vyzerala vždy rovnako.

## 1. Dataset (najdôležitejšie)

**Odporúčaný počet obrázkov:** 40–80

**Rozdelenie:**
- 25–30 SFW (portréty, polovičné, full body, rôzne outfity)
- 15–25 NSFW (nahé, lingerie, explicit)
- Rôzne uhly: front, 3/4, side, slightly from above
- Rôzne výrazy: smile, neutral, seductive, surprised
- Rôzne osvetlenie

**Kvalita:**
- Minimálne 1024×1024, lepšie 1024×1536
- Žiadne rozmazané, žiadne zlé ruky, žiadne deformácie
- Tvár musí byť vždy jasne viditeľná

## 2. Captioning

Každý obrázok by mal mať `.txt` s popisom.

**Príklad dobrého captionu:**
```
luna23, 23 year old european woman, long blonde hair, cute face, light blue eyes, petite, slim, wearing white lingerie, looking at viewer, soft lighting, realistic photo
```

**Nástroje na captioning:**
- JoyCaption / WD14 Tagger v ComfyUI
- Alebo manuálne + LLM (Gemma / Qwen uncensored)

## 3. Training nastavenia (Flux LoRA)

Odporúčané (kohya_ss alebo ComfyUI training nodes):

- **Network Dim:** 16–32
- **Network Alpha:** 16–32
- **Learning Rate:** 1e-4 až 5e-5
- **Steps:** 1500–3000 (podľa veľkosti datasetu)
- **Batch size:** 1–2 (A40 zvládne viac)
- **Resolution:** 1024
- **Optimizer:** AdamW8bit
- **Scheduler:** cosine

**Trigger word:** `luna23` (alebo tvoj zvolený)

## 4. Po natrénovaní

1. Daj LoRA do `models/loras/`
2. Testuj silu 0.7 – 0.95
3. Kombinuj s FaceID / IP-Adapter pre ešte lepšiu stabilitu
4. Ulož najlepšiu verziu ako `luna23_v1.safetensors`

## 5. Tip na predaj

- Maj 2–3 verzie LoRA (v1, v2, v3)
- Generuj character sheet (front, side, back, expressions)
- Urob konzistentný pack (20 SFW + 20 NSFW) ako ukážku
