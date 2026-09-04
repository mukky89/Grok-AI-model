# Prompty

Statické súbory + generátor.

```bash
cd /workspace/Grok-AI-model
bash scripts/generate_nsfw_prompts.sh -n 12 --explicit nude
bash scripts/generate_nsfw_prompts.sh -n 8 --explicit explicit --seed 23
bash scripts/generate_nsfw_prompts.sh -n 8 --explicit soft
```

Výstup ide na stdout a do `dataset/luna23/captions/prompts_*.txt`.

Kopíruj POSITIVE / NEGATIVE do ComfyUI. Nastavenia full body: 768×1344, steps 32, FluxGuidance 2.6, unlock LoRA 0.7–0.75.
