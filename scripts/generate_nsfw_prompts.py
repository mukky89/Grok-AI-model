#!/usr/bin/env python3
from __future__ import annotations

import argparse
import random

IDENTITY = (
    "alina23, aidmaNSFWunlock, photorealistic erotic photograph of one 23 year old european woman, "
    "dirty blonde hair with darker roots and honey ends, hazel green-brown eyes, "
    "warm fair skin with visible pores, slim legs, same adult woman"
)

EXPLICIT = {
    "soft": "short mini skirt, cleavage, stockings and heels",
    "nude": (
        "completely topless, bare breasts and nipples visible, no bra, no shirt, "
        "mini skirt pulled up to the waist"
    ),
    "explicit": (
        "fully nude, no skirt, no panties, no bra, bare breasts with natural hang and visible nipples, "
        "shaved vulva and labia visible, legs slightly apart so the groin is in frame, "
        "only hold-ups or garter stockings and stiletto pumps remain on"
    ),
}

STOCKINGS = [
    "matte 20-denier nude hold-ups, wide welt, silicone gripper dots inside the band",
    "sheer black hold-ups, lace top, silicone strip on the inner welt",
    "seamed black stockings on a thin satin garter belt, metal clips on the welt, back seam down the calf",
    "champagne hold-ups, reinforced heel and toe, lace band mid-thigh",
]

GARTERS = [
    "black satin garter belt, four straps, clips on the welt",
    "no garter belt, hold-ups only",
    "narrow nude garter belt, straps on the stocking tops",
]

HEELS = [
    "black pointed stiletto pumps, thin 10cm heel, patent, no platform",
    "nude patent pointed pumps, needle heel, closed back",
    "black suede court pumps, slim heel, toes complete in frame",
]

OUTFITS_SOFT = [
    "very short black mini skirt, hem at upper thigh",
    "tight grey mini skirt sitting, welt showing",
]

POSES_SOFT = [
    "standing three-quarter, pumps planted, legs and shoes in frame",
    "sitting on a chair edge, heels on the floor",
]

POSES_EXPLICIT = [
    "sitting on the chair, knees open enough to show the vulva, heels on the floor, breasts bare",
    "lying back on the bed, knees up, stockings and pumps on, breasts and groin visible",
    "standing with one foot on the chair, torso nude, camera at three-quarter so breasts and vulva read clearly",
    "on the bed edge, legs apart, looking at camera, full nude plus stockings and heels",
]

PLACES = [
    "warm hotel bedroom, lamp light, full body in frame",
    "hotel bed, rumpled sheets, tungsten lamp",
]

NEGATIVE = (
    "clothes on the torso, bra, panties covering the groin, censored, mosaic, "
    "ice blue eyes, different woman, plastic skin, cgi, 3d, anime, "
    "platform shoes, chunky heel, sneakers, barefoot, "
    "sagging stockings, deformed shoes, cropped feet, cropped head, "
    "child, teen, underage, watermark"
)


def build_prompt(explicit: str, seed: int | None = None) -> tuple[str, str]:
    rng = random.Random(seed)
    lvl = explicit if explicit in EXPLICIT else "explicit"
    parts = [IDENTITY, EXPLICIT[lvl]]
    if lvl == "soft":
        parts += [rng.choice(POSES_SOFT), rng.choice(OUTFITS_SOFT)]
    else:
        parts.append(rng.choice(POSES_EXPLICIT))
    parts += [
        rng.choice(STOCKINGS),
        rng.choice(GARTERS),
        rng.choice(HEELS),
        "nylon knit visible, thin stiletto not a wedge",
        rng.choice(PLACES),
        "35mm full body, breasts and feet both in frame, photorealistic",
    ]
    return ", ".join(parts), NEGATIVE


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("-n", type=int, default=8)
    p.add_argument("--explicit", choices=sorted(EXPLICIT), default="explicit")
    p.add_argument("--seed", type=int, default=None)
    args = p.parse_args()
    rng = random.Random(args.seed)
    for i in range(args.n):
        s = rng.randint(1, 10_000_000)
        pos, neg = build_prompt(args.explicit, seed=s)
        print(f"# {i+1}\n{pos}\n")


if __name__ == "__main__":
    main()
