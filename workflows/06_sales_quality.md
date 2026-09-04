# 06 – Predajová kvalita (nie draft)

Unlock LoRA nestačí. Predajový pack = 3 vrstvy + 2 passy.

## Stack (poradie)
1. Flux.1 Dev (ideálne full / T5 fp16, nie len FP8)
2. aidmaNSFWunlock **0.65–0.75**
3. Anatomy / photoreal nude LoRA **0.65–0.75**
4. Nylon / stockings LoRA **0.7** (len keď sú v zábere punčochy)
5. FaceDetailer denoise **0.28–0.35**
6. UltimateSDUpscale 2× denoise **0.2**

Max 3 LoRA naraz. Štvrtá rozbije tvár.

## Súbory na Civitai (ručne do models/loras/)
- https://civitai.com/models/674027  aidmaNSFWunlock
- Photorealistic nude / Nude Style for FLUX V2 / Realistic_Nudes Flux
- Silk Satin and Nylon (alebo RealBlackFFStockings)

Po stiahnutí pomenuj súbory tak, ako ich číta skript, alebo použi flagy:

```bash
bash scripts/generate_and_run.sh -n 4 --explicit soft \
  --lora aidmaNSFWunlock-FLUX-V0.2.safetensors \
  --lora2 photorealistic_nude.safetensors \
  --lora2-strength 0.7 \
  --guidance 3.2 --steps 32 --width 832 --height 1216
```

## Crop pre predaj
- cover / feed: 832×1216 (tvár + lingerie, oči čitateľné)
- full body: až keď máš character LoRA + FaceDetailer
- neskôr FaceID z 1 referencie

## Sampler
- draft: euler + simple, 28 steps
- predaj: dpmpp_2m + beta, 32–40 steps, FluxGuidance 3.2, CFG 1

## QC pred nahratím
Vyhoď fotku ak:
- oči nesedia / sú mŕtve
- nylon je plocha, nie pletivo
- iná žena ako referencia
- extra prsty, zlomený podpätok
- plastová pleť
