#!/usr/bin/env python3
"""Generuje Flux prompt packy pre glamour Luna23 (NSFW, stockings, heels)."""

from __future__ import annotations

import argparse
import random
from pathlib import Path

IDENTITY = (
    "aidmaNSFWunlock, glamour photograph of one petite 23 year old northern european woman, "
    "long straight honey-blonde hair, light blue irises, round matching pupils, "
    "sharp catchlights in both eyes, long eyelashes, small cute face, pointed chin, "
    "slim petite body, fair skin"
)

EYES = (
    "both eyes sharp and symmetrical, same eye color, no crossed eyes, "
    "detailed iris texture, wet highlight on the cornea"
)

SKIN = (
    "believable skin texture, fine pores, soft glam makeup, glossy lips, "
    "subtle contour, dewy highlights on cheekbones, not plastic, not airbrushed"
)

EXPLICIT = {
    "soft": "black lace lingerie, nipples faintly visible through lace, boudoir glamour",
    "nude": "topless glamour, bare breasts, tasteful nude with garter and stockings still on",
    "explicit": (
        "nude glamour, bare breasts, nipples, shaved vulva visible between stocking tops, "
        "intimate but editorial, not medical"
    ),
}

OUTFITS = [
    "black lace garter belt with four neat straps, sheer black seamed stockings, straps clipped, black stiletto heels",
    "champagne lace garter, nude sheer stockings, nude patent stilettos",
    "burgundy satin garter belt, black stockings with back seam, pointed black heels",
    "white couture garter set, ivory stockings, white stiletto sandals",
    "black waist cincher and garter, glossy hold-ups, ankle-strap stilettos",
]

POSES = [
    "three-quarter body from mid-thigh up, face large in frame, looking at camera",
    "boudoir three-quarter, sitting on a velvet chaise, knees together, heels visible, eye contact",
    "standing three-quarter, hand on hip, chin slightly down, looking through lashes",
    "leaning on a vanity, face close enough to read the eyes, stockings and heels in frame",
    "editorial standing pose, one heel kicked back, torso turned, sharp eyes to camera",
    "on the bed but framed as magazine cover, head to knees, both eyes crisp",
]

PLACES = [
    "luxury hotel suite, warm practical lamps and a large softbox",
    "glamour studio, large octabox camera left, gentle rim light in hair",
    "penthouse at dusk, city bokeh, beauty dish on the face",
    "marble bathroom vanity, soft Hollywood lighting",
    "velvet boudoir set, gold accents, controlled studio light",
]

CAMERAS = [
    "shot on 85mm, f/2.8, focus on the eyes, editorial glamour photo",
    "Vogue-style studio photo, tack sharp eyes, creamy background",
    "high-end boudoir photograph, 85mm, face in focus first",
]

NEGATIVE = (
    "broken eyes, dead eyes, crossed eyes, lazy eye, different sized eyes, extra pupils, "
    "melted eyelids, looking two directions, empty sclera, white eyes, deformed iris, "
    "illustration, cgi, 3d render, plastic skin, airbrushed, beauty filter, instagram face, "
    "doll face, poreless, wax figure, different woman, brown hair, dark eyes, tall, wide hips, "
    "child, teen, underage, deformed feet, extra toes, fused toes, broken heels, missing shoes, "
    "cropped head, extra legs, twisted garter, floating straps, extra fingers, "
    "watermark, text, logo, medical photo, amateur flash, dirty room"
)


def build_prompt(explicit: str, seed: int | None = None) -> tuple[str, str]:
    rng = random.Random(seed)
    parts = [
        IDENTITY,
        EYES,
        rng.choice(POSES),
        EXPLICIT[explicit],
        rng.choice(OUTFITS),
        "slim legs, heels fully visible, garter straps connected straight",
        SKIN,
        rng.choice(PLACES),
        rng.choice(CAMERAS),
    ]
    return ", ".join(parts), NEGATIVE


def main() -> None:
    parser = argparse.ArgumentParser(description="Luna23 glamour NSFW prompt generator")
    parser.add_argument("-n", "--count", type=int, default=10)
    parser.add_argument(
        "--explicit",
        choices=sorted(EXPLICIT),
        default="nude",
    )
    parser.add_argument("--seed", type=int, default=None)
    parser.add_argument("-o", "--out", type=Path, default=None)
    args = parser.parse_args()

    rng = random.Random(args.seed)
    lines: list[str] = []
    for i in range(args.count):
        s = rng.randint(1, 10_000_000)
        pos, neg = build_prompt(args.explicit, seed=s)
        block = (
            f"# {i + 1}  seed_hint={s}  explicit={args.explicit}\n"
            f"POSITIVE:\n{pos}\n\n"
            f"NEGATIVE:\n{neg}\n"
            f"{'-' * 72}\n"
        )
        lines.append(block)

    text = "\n".join(lines)
    print(text)

    out = args.out
    if out is None:
        cand = Path("/workspace/Grok-AI-model/dataset/luna23/captions")
        if cand.is_dir():
            out = cand / f"prompts_{args.explicit}.txt"
    if out is not None:
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(text, encoding="utf-8")
        print(f"\nULOZENE: {out}")


if __name__ == "__main__":
    main()
