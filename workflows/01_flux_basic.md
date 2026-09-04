# 01 – Základný Flux Realistic Workflow

## Cieľ
Jednoduchý text-to-image s realistickou blond modelkou.

## Potrebné nodes
- UNETLoader (Flux)
- DualCLIPLoader
- VAELoader
- CLIPTextEncode
- EmptyLatentImage
- KSampler
- VAEDecode
- SaveImage
- LoraLoader (pre unlock + character LoRA)

## Odporúčané nastavenia
- Resolution: 896 × 1152
- Steps: 25
- CFG: 2.5 – 3.5
- Sampler: euler
- Scheduler: simple / beta

## Prompt štruktúra
Positive:
```
luna23, 23 year old European woman, long straight blonde hair, cute face, light blue eyes, petite, slim, [scéna], realistic photo, detailed skin, natural lighting
```

Negative: skopíruj z prompts/negative.txt

## Tip
Najprv vygeneruj bez Character LoRA, až keď máš dobrú tvár, pridaj FaceID.
