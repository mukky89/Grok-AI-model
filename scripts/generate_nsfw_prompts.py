#!/usr/bin/env python3
"""Glamour / explicit Flux prompty — materiály, svetlo, prostredie."""

from __future__ import annotations

import argparse
import random
from pathlib import Path

IDENTITY = (
    "aidmaNSFWunlock, editorial glamour photograph of one petite 23 year old "
    "northern european woman, long straight honey-blonde hair with a few flyaways, "
    "light blue irises with visible iris texture, matching round pupils, "
    "sharp white catchlights in both eyes, long dark lashes, small cute face, "
    "pointed chin, slim collarbones, petite frame, fair skin"
)

EYES = (
    "both eyes sharp and level, same color, wet cornea highlight, no crossed eyes"
)

SKIN = (
    "visible pores on cheeks and chest, faint peach fuzz on arms, "
    "soft blush on knees and knuckles, dewy cheekbones, glossy lips, "
    "subtle glam makeup, not plastic, not airbrushed"
)

EXPLICIT = {
    "soft": (
        "black lace balconette bra and matching thong, nipples faintly showing "
        "through thin lace, boudoir not medical"
    ),
    "nude": (
        "topless, bare breasts with natural hang and textured areolas, "
        "garter and stockings stay on, tasteful nude editorial"
    ),
    "explicit": (
        "nude from the waist up and between the stocking tops, bare breasts, "
        "erect nipples, shaved vulva and labia visible, intimate editorial, not clinical"
    ),
}

OUTFITS = [
    (
        "black Leavers lace garter belt sitting on the waist, four satin elastic "
        "straps clipped to the welt of sheer 15-denier black stockings, "
        "back seam down each calf, pointed black patent stiletto heels"
    ),
    (
        "champagne Chantilly lace garter, nude sheer stockings with reinforced heel "
        "and toe, straps hanging straight, nude patent slingback stilettos"
    ),
    (
        "burgundy satin garter belt over pale skin, black seamed stockings, "
        "metal clips catching the light, glossy black pointed heels"
    ),
    (
        "white couture garter set, ivory stockings with lace tops, "
        "thin straps aligned, white leather stiletto sandals"
    ),
]

POSES = [
    (
        "three-quarter crop from mid-thigh to hair, face large in frame, "
        "weight on the back hip, one hand on the garter, looking at camera through lashes"
    ),
    (
        "sitting on the edge of a velvet chaise, knees together then slightly parted, "
        "heels on the carpet, torso turned to the key light, eye contact"
    ),
    (
        "standing at a marble vanity, one palm on the stone, body in three-quarter, "
        "stockings and heels still in frame, chin slightly down"
    ),
    (
        "leaning a shoulder into a padded headboard, one knee up on the mattress, "
        "editorial pose, eyes sharp to lens"
    ),
]

PLACES = [
    (
        "luxury hotel suite at dusk, king bed with rumpled ivory linen, "
        "warm tungsten lamps, gold curtain catching city light, beige wool carpet"
    ),
    (
        "glamour studio, dark charcoal seamless, large octabox camera-left, "
        "soft rim in the hair, controlled black negative fill"
    ),
    (
        "penthouse living room, low sofa in cognac leather, floor-to-ceiling glass, "
        "city bokeh, beauty dish on the face, warm practicals in the back"
    ),
    (
        "marble bathroom with a freestanding tub, fogged mirror, vanity bulbs, "
        "cool stone and warm skin contrast"
    ),
    (
        "velvet boudoir set, oxblood drapes, antique gold mirror, "
        "Hollywood lighting from above-left"
    ),
]

CAMERAS = [
    "shot on 85mm, f/2.8, focus locked on the nearest eye, shallow falloff on the far shoulder",
    "medium format look, fine grain, editorial retouch kept minimal",
    "85mm glamour still, catchlights from a beauty dish, creamy background",
]

NEGATIVE = (
    "broken eyes, dead eyes, crossed eyes, lazy eye, different sized eyes, extra pupils, "
    "melted eyelids, empty sclera, deformed iris, illustration, cgi, 3d render, "
    "plastic skin, airbrushed, beauty filter, instagram face, doll face, poreless, "
    "wax figure, different woman, brown hair, dark eyes, tall, wide hips, child, teen, "
    "underage, deformed feet, extra toes, fused toes, broken heels, missing shoes, "
    "cropped head, extra legs, twisted garter, floating straps, extra fingers, "
    "watermark, text, logo, medical photo, dirty room, cheap motel, harsh on-camera flash"
)


def build_prompt(explicit: str, seed: int | None = None) -> tuple[str, str]:
    rng = random.Random(seed)
    parts = [
        IDENTITY,
        EYES,
        rng.choice(POSES),
        EXPLICIT[explicit],
        rng.choice(OUTFITS),
        "nylon has a faint sheen, lace has an open floral pattern, metal clips are small and sharp",
        SKIN,
        rng.choice(PLACES),
        rng.choice(CAMERAS),
    ]
    return ", ".join(parts), NEGATIVE


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("-n", "--count", type=int, default=10)
    parser.add_argument("--explicit", choices=sorted(EXPLICIT), default="nude")
    parser.add_argument("--seed", type=int, default=None)
    parser.add_argument("-o", "--out", type=Path, default=None)
    args = parser.parse_args()

    rng = random.Random(args.seed)
    lines: list[str] = []
    for i in range(args.count):
        s = rng.randint(1, 10_000_000)
        pos, neg = build_prompt(args.explicit, seed=s)
        lines.append(
            f"# {i + 1}  seed_hint={s}  explicit={args.explicit}\n"
            f"POSITIVE:\n{pos}\n\nNEGATIVE:\n{neg}\n" + ("-" * 72) + "\n"
        )
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
