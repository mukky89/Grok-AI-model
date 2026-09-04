#!/usr/bin/env python3
"""Generuje Flux prompt packy pre realistickú Luna23 (NSFW, stockings, heels)."""

from __future__ import annotations

import argparse
import random
from pathlib import Path

IDENTITY = (
    "aidmaNSFWunlock, raw photo of one petite 23 year old northern european woman, "
    "long straight honey-blonde hair, light blue eyes, small cute face, pointed chin, "
    "slim petite body, fair skin"
)

SKIN = (
    "real skin pores, peach fuzz, subsurface scattering, slight redness on knees and elbows, "
    "natural breasts, visible veins under pale skin, unretouched, film grain, 35mm kodak portra"
)

EXPLICIT = {
    "soft": "nude torso, nipples visible, black lace lingerie set",
    "nude": "nude, exposed breasts, erect nipples, shaved vulva, labia visible",
    "explicit": (
        "nude, exposed breasts, erect nipples, shaved vulva, detailed labia, "
        "natural pubic mound, intimate anatomy in frame"
    ),
}

OUTFITS = [
    "black lace garter belt with four straps, sheer black stockings, straps clipped to stockings, black stiletto high heels",
    "white lace garter belt, nude sheer stockings with reinforced heel, red patent stiletto heels",
    "dark red satin garter belt, black seamed stockings, pointed black stilettos",
    "black harness garter, fishnet thigh highs, platform high heels",
    "champagne lace garter, sheer nude stockings, beige pointed heels",
    "black waist cincher and garter, glossy hold-ups, ankle-strap stilettos",
]

POSES = [
    "full body head-to-toe, both feet visible, standing, weight on one leg, one hand on hip, looking at camera",
    "full body, walking toward camera, hips slightly turned, heels fully in frame",
    "full body, leaning against a wall, one knee bent, arched back, looking over shoulder",
    "full body, sitting on the edge of a hotel bed, knees apart, heels on the floor",
    "full body from behind, looking back, stockings and heel profile visible",
    "three-quarter full body, low camera angle so heels and face stay in frame",
    "standing with feet together, toes pointed, hands at sides, straight posture",
]

PLACES = [
    "hotel room, warm lamp light, beige carpet",
    "luxury bathroom, marble floor, soft vanity light",
    "bedroom at night, practical lamp, rumpled sheets behind her",
    "penthouse window, city bokeh, cool rim light",
    "fitting room mirror, overhead fluorescent mixed with warm bulb",
    "studio seamless backdrop, single large softbox from camera left",
]

CAMERAS = [
    "shot on 35mm, f/2.2, shallow depth of field, unedited photograph",
    "flash snapshot, hard shadow behind her, candid",
    "available light photo, slight motion in hair, documentary",
    "editorial fashion photo, sharp focus on face and feet",
]

NEGATIVE = (
    "illustration, cgi, 3d render, plastic skin, airbrushed, beauty filter, instagram face, "
    "doll face, poreless, wax figure, different woman, brown hair, dark eyes, tall, wide hips, "
    "child, teen, underage, deformed feet, extra toes, fused toes, broken heels, missing shoes, "
    "cropped feet, cropped head, extra legs, twisted garter, floating straps, extra fingers, "
    "watermark, text, logo"
)


def build_prompt(explicit: str, seed: int | None = None) -> tuple[str, str]:
    rng = random.Random(seed)
    parts = [
        IDENTITY,
        rng.choice(POSES),
        EXPLICIT[explicit],
        rng.choice(OUTFITS),
        "slim legs, complete shoes on both feet, garter straps connected",
        SKIN,
        rng.choice(PLACES),
        rng.choice(CAMERAS),
    ]
    return ", ".join(parts), NEGATIVE


def main() -> None:
    parser = argparse.ArgumentParser(description="Luna23 NSFW prompt generator")
    parser.add_argument("-n", "--count", type=int, default=10)
    parser.add_argument(
        "--explicit",
        choices=sorted(EXPLICIT),
        default="nude",
        help="soft = lingerie, nude = default, explicit = silnejšia anatómia",
    )
    parser.add_argument("--seed", type=int, default=None)
    parser.add_argument(
        "-o",
        "--out",
        type=Path,
        default=None,
        help="uloží txt (default: stdout + dataset/luna23/captions ak existuje)",
    )
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
