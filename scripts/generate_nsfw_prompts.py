#!/usr/bin/env python3
from __future__ import annotations

import random

IDENTITY = (
    "alina23, aidmaNSFWunlock, photorealistic erotic photograph of one 23 year old european woman, "
    "dirty blonde hair darker roots honey ends, hazel green-brown eyes, warm fair skin, slim legs"
)

EXPLICIT = {
    "soft": "provocative outfit, cleavage, short hem, stockings and heels",
    "nude": "topless, bare breasts and nipples, bottom still on or pulled aside",
    "explicit": (
        "nude breasts and visible vulva, no panties, stockings and stiletto pumps stay on"
    ),
}

OUTFITS = {
    "soft": [
        "tiny black mini skirt and unbuttoned white blouse, bra showing",
        "red bodycon mini dress cut very short, zipper down the front",
        "black leather mini and a cropped tank, midriff bare",
        "school-style but adult: short grey pleated mini, white shirt knotted under the bust",
        "satin slip dress riding up, thin straps falling",
        "tight beige knit mini, no underwear line, nipples under the knit",
        "open silk robe over a black thong and hold-ups",
        "secretary look: white blouse half open, black pencil skirt hiked to the welt",
        "wet-look black mini and a tiny bikini top",
        "gold sequin micro mini, no bra, hard nipples under the fabric",
    ],
    "nude": [
        "mini skirt only, no top, breasts bare",
        "open robe, nothing under it except stockings",
        "skirt around the waist, chest nude",
        "tied shirt off the shoulders, breasts out, mini still on",
    ],
    "explicit": [
        "nothing on the torso or groin except garter or hold-ups and pumps",
        "robe open and off the shoulders, fully nude front",
        "mini skirt lifted and no panties",
        "only a garter belt, stockings and heels",
    ],
}

STOCKINGS = [
    "nude 20-den hold-ups, wide welt, silicone dots inside",
    "black 15-den hold-ups, deep lace band, silicone strip",
    "seamed stockings on a garter belt, clips on the welt, back seam",
    "champagne hold-ups, reinforced heel and toe",
    "wine-red stay-ups, baroque lace top",
    "plain matte black opaques with a simple welt",
    "fishnet hold-ups with a solid lace band",
]

GARTERS = [
    "black satin garter belt, four straps",
    "nude garter belt under the hem",
    "red garter, gold clips",
    "hold-ups only, no belt",
]

HEELS = [
    "black patent pointed stilettos, 10cm needle heel, no platform",
    "nude patent pumps, sharp toe",
    "black suede courts, slim heel",
    "red patent pointed pumps",
    "ankle-strap stilettos, thin strap, still a pump toe",
]

POSES = {
    "soft": [
        "standing in a doorway, hip out, one knee bent",
        "sitting on the chair arm, skirt riding up",
        "leaning on the dresser, looking back over the shoulder",
        "walking toward camera, short steps in the pumps",
        "perched on the bed edge, knees together",
    ],
    "nude": [
        "sitting, blouse off, chest to camera",
        "standing at the window side-on, topless",
        "on all fours on the bed, looking at camera, breasts hanging",
        "kneeling on the chair, topless",
    ],
    "explicit": [
        "sitting, knees open, vulva visible, heels on the floor",
        "on the bed, knees up, nude plus stockings",
        "standing with one foot on the chair, nude front",
        "lying back, legs apart, pumps on",
        "bent forward on the dresser, looking back, groin readable",
    ],
}

PLACES = [
    "hotel bedroom, lamp, wood floor",
    "hotel suite living room, low sofa",
    "bathroom doorway, warm light",
    "bed with rumpled white sheets",
]

NEGATIVE = (
    "child, teen, underage, different woman, plastic skin, cgi, anime, "
    "platform sole, block heel, sneakers, barefoot, sagging stockings, "
    "cropped head, cropped feet, extra legs, watermark, mosaic censor"
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
        "photorealistic, 35mm, full body, both shoes in frame",
    ]
    return ", ".join(parts), NEGATIVE
