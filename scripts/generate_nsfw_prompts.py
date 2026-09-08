#!/usr/bin/env python3
from __future__ import annotations

import argparse
import random
from pathlib import Path

IDENTITY = (
    "alina23, aidmaNSFWunlock, photorealistic photograph of one 23 year old european woman, "
    "dirty blonde hair with darker roots and honey ends, hazel green-brown eyes, "
    "warm fair skin with visible pores, slim legs, same woman"
)

SKIN = (
    "natural skin texture on thighs where the stocking welt presses, "
    "faint fabric imprint, no plastic skin, no beauty filter"
)

EXPLICIT = {
    "soft": "mini skirt and lingerie, erotic but clothed",
    "nude": "topless, skirt hiked, stockings stay on",
    "explicit": "nude except stockings and heels, intimate photograph",
}

STOCKINGS = [
    "matte 20-denier nude hold-ups with a wide opaque welt and silicone inner grip dots clearly visible on the inner welt",
    "sheer black hold-ups, 15 denier, deep lace band, silicone gripper strip along the inside of the band",
    "seamed black stockings attached to a thin satin garter belt, metal clips and rubber grips on the welt, back seam straight down the calf",
    "champagne hold-ups, reinforced heel and toe, lace top sitting mid-thigh, no sagging",
    "dark navy hold-ups with a decorative baroque lace band and visible silicone nubs",
    "plain nude stay-ups, wide comfort welt, slight shine only on the shin, matte on the thigh",
]

GARTERS = [
    "black satin garter belt with four straps hanging straight, clips fastened on the stocking welt",
    "narrow nude garter belt under a mini skirt, straps peeking below the hem",
    "no garter belt, hold-ups only, welt doing all the work",
    "red satin garter belt, gold hardware, two straps per thigh",
]

HEELS = [
    "black pointed-toe stiletto pumps, 10cm heel, thin stiletto, glossy patent, closed back, thin sole, heel sitting under the ankle not a block",
    "nude patent pointed pumps, stiletto heel, almond-pointed toe, ankle strap off",
    "black suede pointed courts, slim heel, no platform, no chunky sole",
    "burgundy leather pumps, needle heel, sharp toe, visible heel cap and outsole edge",
]

OUTFITS = [
    "very short black mini skirt, hem at upper thigh, stockings showing below the hem",
    "tight grey mini skirt riding up when she sits, hold-up welt visible",
    "black mini skirt and a fitted blouse, skirt just covering the garter clips",
    "micro mini, sitting so the lace tops show",
]

POSES = [
    "standing three-quarter, one knee soft, feet in the pumps planted, skirt hem and stocking tops in frame",
    "sitting on a chair edge, knees together then slightly apart, heels on the floor, welt and clips sharp",
    "leaning on a dresser, one foot on tiptoe in the pump, seam or welt in focus",
    "walking pose, weight on the back heel, front pump pointed, stockings taut",
]

PLACES = [
    "the same warm hotel bedroom, wood floor, lamp light, full length in frame",
    "hotel corridor carpet, warm practicals, full legs visible",
]

CAMERAS = [
    "50mm photograph, f/2.8, focus on the stocking welt and the nearest pump, sharp fabric knit and heel silhouette",
    "35mm full-body, both shoes complete in frame, no cropped toes, no cropped head",
]

NEGATIVE = (
    "ice blue eyes, platinum blonde, different woman, plastic skin, cgi, 3d, anime, "
    "platform shoes, chunky heel, block heel, wedge, sneakers, barefoot, no shoes, "
    "sagging stockings, wrinkled nylon puddle, missing welt, floating straps, "
    "deformed shoes, melted heels, extra heels, two left feet, cropped feet, cropped toes, "
    "cropped head, extra legs, child, teen, watermark"
)


def build_prompt(explicit: str, seed: int | None = None) -> tuple[str, str]:
    rng = random.Random(seed)
    parts = [
        IDENTITY,
        rng.choice(POSES),
        EXPLICIT.get(explicit, EXPLICIT["soft"]),
        rng.choice(OUTFITS),
        rng.choice(STOCKINGS),
        rng.choice(GARTERS),
        rng.choice(HEELS),
        "nylon knit visible, welt edge sharp, stiletto is a thin rod not a wedge",
        SKIN,
        rng.choice(PLACES),
        rng.choice(CAMERAS),
    ]
    return ", ".join(parts), NEGATIVE


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("-n", "--count", type=int, default=8)
    p.add_argument("--explicit", choices=sorted(EXPLICIT), default="soft")
    p.add_argument("--seed", type=int, default=None)
    args = p.parse_args()
    rng = random.Random(args.seed)
    for i in range(args.count):
        s = rng.randint(1, 10_000_000)
        pos, neg = build_prompt(args.explicit, seed=s)
        print(f"# {i+1} seed={s}\nPOSITIVE:\n{pos}\n\nNEGATIVE:\n{neg}\n" + "-" * 72)


if __name__ == "__main__":
    main()
