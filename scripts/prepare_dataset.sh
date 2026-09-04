#!/usr/bin/env bash
set -euo pipefail

# Pripraví priečinky pre Luna23 dataset podľa workflows/03_dataset_generator.md

ROOT="${1:-/workspace/Grok-AI-model/dataset/luna23}"

mkdir -p \
  "$ROOT/portraits" \
  "$ROOT/half_body" \
  "$ROOT/full_body" \
  "$ROOT/nsfw" \
  "$ROOT/rejected" \
  "$ROOT/captions"

cat > "$ROOT/README.md" << 'EOF'
# Luna23 dataset

Cieľ: 40–80 fotiek jednej tváre pred Character LoRA.

Rozdelenie:
- portraits/   15× close-up, rôzne výrazy
- half_body/   15× polopostava, rôzne outfity
- full_body/   15× celá postava
- nsfw/        15–20× lingerie / nude
- rejected/    zlé ruky, iná tvár, blur
- captions/    .txt k obrázkom (alebo vedľa png ako rovnaký názov)

Pravidlá:
- minimálne 1024×1024, lepšie 1024×1536
- tvár vždy viditeľná
- jeden look: long straight blonde, light blue eyes, petite
- caption formát: luna23, 23 year old european woman, long blonde hair, ...

Po výbere fotiek pokračuj v character/training_guide.md
EOF

echo "Dataset dirs:"
find "$ROOT" -maxdepth 1 -type d | sort
echo
echo "Hotovo. Kopíruj vybrané výstupy z ComfyUI/output/ sem."
