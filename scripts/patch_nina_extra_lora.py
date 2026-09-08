#!/usr/bin/env python3
"""Idempotent: nina_generate.py získa --extra-lora / EXTRA_LORA."""
from __future__ import annotations

from pathlib import Path

TARGETS = [
    Path("/workspace/ai-studio-tools/bin/nina_generate.py"),
    Path("/workspace/AI-influencerka/scripts/nina_generate.py"),
]

OLD = '''        model_node = character_node

    clip_node'''

NEW = '''        model_node = character_node

    extra_lora = extra_lora or __import__("os").environ.get("EXTRA_LORA", "").strip() or None
    extra_strength = extra_lora_strength
    if extra_lora:
        extra_node = str(next_id); next_id += 1
        nodes[extra_node] = {
            "class_type": "LoraLoaderModelOnly",
            "inputs": {
                "model": [model_node, 0],
                "lora_name": extra_lora,
                "strength_model": extra_strength,
            },
        }
        model_node = extra_node
        print(f"extra LoRA {extra_lora} @ {extra_strength}", flush=True)

    clip_node'''

SIG_OLD = '''def build_workflow(scene: str, mode: str, quality: str, seed: int, prefix: str,
                   detail: bool = True, negative_extra: str = "", denoise: float = 1.0,
                   lora: str | None = None, lora_strength: float = 1.0,'''

SIG_NEW = '''def build_workflow(scene: str, mode: str, quality: str, seed: int, prefix: str,
                   detail: bool = True, negative_extra: str = "", denoise: float = 1.0,
                   lora: str | None = None, lora_strength: float = 1.0,
                   extra_lora: str | None = None, extra_lora_strength: float = 0.75,'''

ARG_OLD = '''    parser.add_argument(
        "--lora-strength", type=float, default=1.0,
        help="LoRA strength (default 1.0). Lower it if output overfits to the training scenes.",
    )'''

ARG_NEW = '''    parser.add_argument(
        "--lora-strength", type=float, default=1.0,
        help="LoRA strength (default 1.0). Lower it if output overfits to the training scenes.",
    )
    parser.add_argument(
        "--extra-lora", default=None,
        help="Second LoRA stacked after the character LoRA (e.g. qwen_image_nsfw.safetensors).",
    )
    parser.add_argument(
        "--extra-lora-strength", type=float, default=0.75,
        help="Strength of --extra-lora (default 0.75).",
    )'''


def patch(path: Path) -> str:
    if not path.is_file():
        return f"SKIP missing {path}"
    text = path.read_text(encoding="utf-8")
    if "--extra-lora" in text and "extra_lora_strength" in text and "extra LoRA" in text:
        return f"OK already {path}"
    orig = text
    if SIG_OLD in text:
        text = text.replace(SIG_OLD, SIG_NEW, 1)
    if OLD in text:
        text = text.replace(OLD, NEW, 1)
    if ARG_OLD in text:
        text = text.replace(ARG_OLD, ARG_NEW, 1)
    # Forward new kwargs at the build_workflow(...) call site if present.
    needle = "lora_strength=args.lora_strength,"
    inject = (
        "lora_strength=args.lora_strength,\n"
        "                    extra_lora=getattr(args, \"extra_lora\", None) or __import__(\"os\").environ.get(\"EXTRA_LORA\"),\n"
        "                    extra_lora_strength=getattr(args, \"extra_lora_strength\", 0.75),"
    )
    if needle in text and "extra_lora=getattr" not in text:
        text = text.replace(needle, inject, 1)
    if text == orig:
        return f"FAIL no match {path}"
    path.write_text(text, encoding="utf-8")
    return f"PATCHED {path}"


def main() -> None:
    for path in TARGETS:
        print(patch(path))


if __name__ == "__main__":
    main()
