# 03 – Dataset Generator (pre Character LoRA)

## Cieľ
Vygenerovať 40–80 kvalitných fotiek jednej modelky na tréning LoRA.

## Odporúčaný postup
1. Použi FaceID + silný base prompt
2. Generuj v dávkach podľa kategórií:
   - 15× Close-up portrait (rôzne výrazy)
   - 15× Half body (rôzne outfity)
   - 15× Full body
   - 15–20× NSFW / nude
3. Vyber iba najlepšie (bez zlých rúk, deformácií, zlých tvárí)
4. Captionuj (JoyCaption alebo manuálne)
5. Trénuj LoRA podľa character/training_guide.md

## Batch tipy
- Seed fixni na začiatku a potom varíruj
- Používaj rovnaký base prompt + meníš len oblečenie / pózu / výraz
- Rozlíšenie drž konzistentné (1024×1536)

## Po vygenerovaní
Ulož všetko do priečinka `dataset/luna23/` s captions.
