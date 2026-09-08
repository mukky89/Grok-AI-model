#!/usr/bin/env python3
"""Prompt set pre nina run_prompt_set.sh — explicit Qwen + Alina."""
from __future__ import annotations

import argparse
import json
import random
from pathlib import Path

ADULT = (
    "A clearly adult woman in her mid-twenties, the same established fictional "
    "influencer identity, photographed as a real person not a catalog model"
)

SCENES = [
    (
        "sitting on the hotel bed facing the camera, knees open toward the lens, "
        "completely nude except sheer black hold-up stockings with a wide lace welt "
        "and black pointed stiletto pumps, bare breasts with natural hang and two "
        "clear nipples, vulva and labia visible in the lower center of the frame"
    ),
    (
        "lying back on rumpled sheets, camera between the knees at a low angle, "
        "nude torso, hold-ups and pumps on, groin sharp in the foreground, face still visible"
    ),
    (
        "seated on a wooden chair, feet on the floor in stilettos, knees apart, "
        "no panties, garter belt with four straps clipped to seamed stockings, "
        "bare breasts, vulva visible"
    ),
    (
        "standing with one foot on the chair, three-quarter nude front, "
        "champagne hold-ups, silicone gripper dots on the inner welt readable, "
        "breasts and vulva both in frame"
    ),
    (
        "on the bed edge, robe off the shoulders and pooled, only nude stay-ups "
        "and nude patent pumps remain, legs open, explicit adult photograph"
    ),
    (
        "bathroom doorway, warm lamp, full-length nude plus black seamed stockings "
        "and pumps, weight on one hip, no hands covering breasts or groin"
    ),
]

FINISH = (
    "photorealistic 35mm photograph, visible pores, natural asymmetry, "
    "nylon knit and welt detail sharp, thin stiletto not a platform, "
    "exactly one adult woman, no text, no watermark"
)


def build(rng: random.Random) -> str:
    return ". ".join([ADULT, rng.choice(SCENES), FINISH]) + "."


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("-n", "--count", type=int, default=6)
    p.add_argument("--seed", type=int, default=None)
    p.add_argument("-o", "--out", default="/workspace/ai-studio-tools/prompt_set_explicit.json")
    args = p.parse_args()
    rng = random.Random(args.seed if args.seed is not None else random.randrange(1, 10**9))
    entries = []
    for i in range(args.count):
        prompt = build(rng)
        entries.append({"index": i + 1, "category": "explicit", "version": "explicit_qwen", "prompt": prompt})
        print(f"[{i+1}/{args.count}] {prompt[:90]}...")
    Path(args.out).parent.mkdir(parents=True, exist_ok=True)
    Path(args.out).write_text(json.dumps(entries, indent=2), encoding="utf-8")
    print(f"ULOZENE {args.out}")


if __name__ == "__main__":
    main()
