# Sales workflow – realistická AI modelka

Cieľ: stála tvár + telo, amateur fotky na predaj, video len z fotky.

Trigger: `luna23` (alebo iný locknutý token z character/description.md).

## Priečinky na pode

```
/workspace/Grok-AI-model/
  dataset/luna23/{portraits,half_body,full_body,nsfw}
  dataset_keep/          # len schválené na LoRA
  drafts/
  final/set_01/
  video/
```

## Stack

Checkpoint: Flux NSFW fine-tune (Fluxed Up / CHROMA / Persephone) alebo Flux.1 Dev + unlock LoRA.

LoRA:
- aidmaNSFWunlock @ 0.8
- skin/amateur LoRA @ 0.65–0.8 (voliteľné)
- character LoRA `luna23` @ 0.8–1.0 až po natrénovaní

Sampler (predajný look):
- DPM++ 2M, scheduler beta (ak umelé svetlo → sgm_uniform)
- draft: 28 steps, CFG 3.2, 768×1152
- finále: 32–36 steps, 832×1216 alebo 896×1152
- face detailer vždy; hands len keď sú v zábere
- upscale 1.4× až po schválení

Existujúce JSON: `workflows/flux_nsfw_basic.json` (portrét), `workflows/flux_nsfw_fullbody.json`.

## Prompt skeleton

Positive:
```
luna23, candid amateur photograph, 35mm film,
soft natural window light, real skin pores,
tiny imperfections, subtle film grain,
shallow depth of field, same bedroom,
[CLOTHES], [POSE], [SHOT]
```

Negative: `prompts/negative.txt`

Meníš len CLOTHES / POSE / SHOT.

## Denný cyklus

1. Brief → 3 premenné
2. Batch 4 drafty
3. Výber 1 seed
4. Finále + face detailer
5. Video len I2V 3–5 s z finálnej fotky

## Set 01 — Sunday morning

1. close-up face, oversize white tee, sitting on bed
2. mid shot, same tee, looking out the window
3. full body, same tee, standing barefoot
4. mirror selfie, underwear
5. mid shot on bed, underwear, from above
6. sitting at window, underwear
7. nude, covered by sheet, mid shot
8. nude, standing by window, side light
9. close-up collarbone / neck / face
10. lying on bed, unposed full body

Z každého 4 seedov, necháš 1. Cieľ: 20–25 fotiek + 2 I2V.

## Quality gate

Vyhoď: iná tvár, plastová koža, extra prsty, iná izba, beauty filter.
Nechaj: póry, window light, malé nedokonalosti, rovnaká tvár.
