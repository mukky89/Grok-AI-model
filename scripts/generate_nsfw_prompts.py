#!/usr/bin/env python3
from __future__ import annotations

import argparse
import random
from pathlib import Path

IDENTITY = (
    "alina23, aidmaNSFWunlock, candid photograph of one 23 year old european woman, "
    "the same woman every time, dirty blonde hair with darker roots and honey ends, "
    "long mostly straight hair, hazel green-brown eyes, warm fair skin, oval face, "
    "soft natural smile, slim body, natural proportions"
)

EYES = (
    "hazel green-brown irises, both eyes same color, sharp nearest eye, no ice blue eyes"
)

SKIN = (
    "visible pores, faint natural flush, tiny imperfections, not airbrushed, not plastic"
)

EXPLICIT = {
    "soft": (
        "champagne satin slip dress and black fishnet tights, relaxed sitting pose, "
        "intimate but not catalog lingerie ad"
    ),
    "nude": (
        "same woman, topless, natural breasts, warm lamp light, tasteful not clinical"
    ),
    "explicit": (
        "same woman, nude, natural body, warm bedroom light, intimate photograph"
    ),
}

OUTFITS = [
    "champagne silk slip on a cream upholstered wooden chair",
    "oversized white shirt, same bedroom lamp",
    "beige satin slip, black fishnets, barefoot",
    "simple nude-toned lingerie, no heavy lace catalog set",
]

POSES = [
    "sitting on the cream chair, body angled, looking off camera with a small smile",
    "sitting on the chair, hands on thighs, soft eye contact",
    "perched on the chair edge, relaxed shoulders, 35mm crop mid-thigh to hair",
    "same chair, leaning forward slightly, natural unposed hands",
]

PLACES = [
    "the same warm hotel bedroom, dark wood four-poster bed, cream chair, "
    "tungsten bedside lamp, cream walls, patterned rug, quiet evening light"
]

CAMERAS = [
    "35mm photograph, f/2.2, window plus lamp mix, subtle film grain, shallow depth of field",
    "candid still, focus on the nearest eye, background lamp bokeh",
]

NEGATIVE = (
    "ice blue eyes, platinum blonde, different woman, instagram face, doll face, "
    "plastic skin, airbrushed, beauty filter, cgi, 3d, anime, studio octabox, "
    "black lace catalog, city penthouse, marble bathroom, red velvet set, "
    "child, teen, underage, extra fingers, extra limbs, watermark, text"
)


def build_prompt(explicit: str, seed: int | None = None) -> tuple[str, str]:
    rng = random.Random(seed)
    parts = [
        IDENTITY,
        EYES,
        rng.choice(POSES),
        EXPLICIT[explicit],
        rng.choice(OUTFITS),
        SKIN,
        PLACES[0],
        rng.choice(CAMERAS),
    ]
    return ", ".join(parts), NEGATIVE


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("-n", "--count", type=int, default=10)
    parser.add_argument("--explicit", choices=sorted(EXPLICIT), default="soft")
    parser.add_argument("--seed", type=int, default=None)
    parser.add_argument("-o", "--out", type=Path, default=None)
    args = parser.parse_args()
    rng = random.Random(args.seed)
    lines = []
    for i in range(args.count):
        s = rng.randint(1, 10_000_000)
        pos, neg = build_prompt(args.explicit, seed=s)
        lines.append(f"# {i+1} seed={s}\nPOSITIVE:\n{pos}\n\nNEGATIVE:\n{neg}\n" + "-" * 72 + "\n")
    text = "\n".join(lines)
    print(text)
    if args.out:
        args.out.parent.mkdir(parents=True, exist_ok=True)
        args.out.write_text(text, encoding="utf-8")


if __name__ == "__main__":
    main()
