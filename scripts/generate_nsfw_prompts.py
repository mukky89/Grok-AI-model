#!/usr/bin/env python3
from __future__ import annotations

import argparse
import random

IDENTITY = (
    "aidmaNSFWunlock, candid raw photograph of one ordinary 24 year old slavic woman, "
    "not a model, slightly long oval face, soft jaw, small natural nose with a tiny bump, "
    "light brown hair with grown-out roots, loose messy waves to the chest, "
    "hazel eyes a bit close together, faint undereye, sparse brows, "
    "thin upper lip, uneven real teeth when she smiles, "
    "warm skin with pores, a few freckles on the nose, no glam makeup"
)

EXPLICIT = {
    "soft": "short provocative clothes, cleavage, stockings and heels",
    "nude": (
        "topless, both breasts fully bare, natural round areolas, "
        "two intact nipples not melted, no bra, no hands covering chest"
    ),
    "explicit": (
        "completely nude except hold-up stockings and stiletto pumps, "
        "no panties, no skirt covering the groin, "
        "camera pointed at the pelvis from slightly below, "
        "knees open toward the lens, vulva and labia in the center of the frame, "
        "bare breasts with natural hang and two clear nipples"
    ),
}

OUTFITS = {
    "soft": [
        "cheap black mini from a night out, hem riding up",
        "washed-out red bodycon, stretched at the bust",
        "white shirt half unbuttoned, black mini, office after hours",
        "satin slip that clings and shows the welt",
        "open hotel robe, thong, hold-ups",
        "leather-look mini and a thin tank, nipples under the tank",
    ],
    "nude": [
        "no top, only a pulled-up mini",
        "robe off the shoulders, chest bare",
        "skirt around the waist, breasts free",
    ],
    "explicit": [
        "no clothing on torso or groin",
        "garter belt only plus stockings and pumps",
        "hold-ups and heels only",
    ],
}

STOCKINGS = [
    "real nylon hold-ups: knit visible, wide opaque welt, silicone gripper dots on the inner band",
    "15-den black sheers, lace welt tight mid-thigh, no wrinkles at the knee",
    "seamed stockings, back seam straight, metal garter clips on the welt",
    "nude stay-ups, matte thigh, sheen only on the shin, reinforced toe in the pump",
]

GARTERS = [
    "thin black garter belt, four straps hanging straight, clips closed",
    "hold-ups only, welt doing the work, no belt",
    "narrow nude belt under nothing else",
]

HEELS = [
    "scuffed black pointed stilettos, thin 9cm heel, no platform, both shoes fully in frame",
    "nude patent pumps, sharp toe, needle heel under the ankle",
    "worn black suede courts, slim heel, heel cap visible",
]

POSES = {
    "soft": [
        "standing in a hotel room, phone-photo awkward stance",
        "sitting on the bed edge, skirt short, feet in pumps",
        "leaning on a dresser, looking back",
    ],
    "nude": [
        "sitting topless, shoulders relaxed, not posing like a catalog",
        "standing side-on by a window, breasts natural",
    ],
    "explicit": [
        "sitting on the bed facing camera, knees pulled apart, pelvis forward, heels on the floor",
        "lying back, camera between the knees, vulva sharp in the foreground, face still visible",
        "on the chair, feet on the seat posts, groin open to camera",
        "low angle from the foot of the bed, legs spread, stockings and pumps framing the vulva",
    ],
}

PLACES = [
    "messy hotel room, cheap lamp, wrinkled sheets, afternoon window",
    "small bedroom, radiator, curtain half drawn",
]

NEGATIVE = (
    "instagram model, beauty filter, plastic skin, doll face, perfect symmetry, "
    "catalog lighting, octabox, glued-on makeup, ice-blue eyes, platinum hair, "
    "deformed nipples, extra nipples, melted nipples, blob areolas, misplaced nipples, "
    "panties covering the groin, thong covering the vulva, censored, mosaic, "
    "closed legs hiding the groin, standing pose that hides genitals, "
    "platform shoes, block heel, sneakers, barefoot, sagging stockings, "
    "cgi, 3d, anime, child, teen, watermark, cropped head, cropped feet"
)


def build_prompt(explicit: str, seed: int | None = None) -> tuple[str, str]:
    rng = random.Random(seed)
    lvl = explicit if explicit in EXPLICIT else "soft"
    parts = [
        IDENTITY,
        EXPLICIT[lvl],
        rng.choice(OUTFITS[lvl]),
        rng.choice(POSES[lvl]),
        rng.choice(STOCKINGS),
        rng.choice(GARTERS),
        rng.choice(HEELS),
        rng.choice(PLACES),
        "shot on a 35mm lens, slight grain, imperfect framing, photoreal",
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
        print(f"# {i+1} seed={s}\n{pos}\n")


if __name__ == "__main__":
    main()
