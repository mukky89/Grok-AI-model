# 05 – Prečo je výstup slabý a čo s tým

Máš všetky typické Flux full-body chyby naraz. Riešia sa **oddene**, nie ďalším slovom v prompte.

## 1. Málo explicitné
Unlock LoRA 0.7 + priame slová: `exposed breasts, erect nipples, shaved vulva, labia visible`.
Ak stále cenzuruje, unlock hore na 0.8 — nie na 1.0 (rozbije anatómiu).

## 2. Plastová pleť / falošná tvár
- FluxGuidance **2.5–2.8**, nie 3.5+
- v prompte: `raw photo, film grain, pores, unretouched`
- vyhoď: beautiful, photorealistic, 8k, ultra detailed
- pridaj Flux **realism / skin** LoRA 0.55–0.7 (Civitai), nie len unlock
- FaceDetailer denoise **0.28** na hotový obrázok

## 3. Zlé nohy, topánky, podväzky
- latent **768×1344** alebo **832×1472** (násobok 16)
- v prompte: `head-to-toe, both feet visible, straps connected to stockings`
- negative: `cropped feet, broken heels, floating straps, extra toes`
- ak nohy padajú 8 z 10, rob **half body** a nohy dorieš img2img outpaintom — full body v jednom passe Flux často kazí

## 4. Iná žena ako Luna
Prompt to **nespraví**. Kým nie je Character LoRA:
1. Vyber 1 referenčnú tvár (najlepší close-up)
2. InstantID alebo IP-Adapter FaceID (nody z install.sh)
3. weight 0.65–0.8
4. ten istý ref obrázok na celý dataset
Potom trénuj `luna23` podľa character/training_guide.md.

## 5. Rozmazané / málo ostré
- steps **32**
- neber preview ako finál
- 2× UltimateSDUpscale, denoise 0.2–0.3
- výstup z `output/luna23_fullbody_*.png`

## Poradie práce
1. `git pull && bash scripts/apply_fullbody_workflow.sh`
2. Load `flux_nsfw_fullbody.json`
3. 10 seedov, vyhoď 9
4. FaceDetailer + upscale na 1 víťaza
5. z víťaznej tváre FaceID dataset 40–80 fotiek
