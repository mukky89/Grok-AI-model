# 04 – Full body quality (heels / stockings / garter)

Ak je výstup slabý, nepridávaj slová do promptu. Zmeň render.

## Workflow
`workflows/flux_nsfw_fullbody.json`

Načítaj v ComfyUI alebo:
```bash
cd /workspace/Grok-AI-model
git pull
bash scripts/apply_fullbody_workflow.sh
```

## Nastavenia
- 768 × 1344 (nohy a topánky ostanú v zábere)
- steps 30
- sampler euler, scheduler simple
- FluxGuidance 3.0
- KSampler CFG 1
- aidmaNSFWunlock strength 0.7
- prefix výstupu: luna23_fullbody

## Po vygenerovaní
1. Vyber 1 seed s dobrými nohami a tvárou
2. FaceDetailer denoise 0.25–0.35
3. 2× upscale (UltimateSDUpscale)

Unlock LoRA odomkne nahotu, neurobí fotorealitu. Pridaj samostatnú Flux realism LoRA 0.55–0.7 keď ju máš v models/loras/.
