# Model stack – čo vyzerá ako reálna fotka

Ak má zákazník uveriť, že ide o reálnu fotografiu:

1. **Flux NSFW fine-tune** (Fluxed Up / CHROMA / Persephone) — víťaz na kožu, svetlo, tvár, ruky.
2. **SDXL Juggernaut / RealVis** — záloha, rýchlejšie, častejšie plast.
3. **Pony / Illustrious / NoobAI** — nie na photoreal predaj. Anime / stylized.

Base Flux Dev je cenzurovaný. Použi fine-tune alebo `aidmaNSFWunlock` @ 0.7–0.9.

## Minimálny stack

- 1 checkpoint
- max 2 LoRA (+ character až po tréningu)
- CFG 3.0–3.5
- amateur / 35mm / pores / film grain
- žiadny masterpiece 8k spam

## Prečo nie 5 LoRA

Každý ďalší LoRA zabíja fotorealizmus a láme identitu.
