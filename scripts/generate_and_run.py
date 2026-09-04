#!/usr/bin/env python3
"""Vygeneruje NSFW prompt a rovno ho spustí v ComfyUI."""

from __future__ import annotations

import argparse
import copy
import json
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT / "scripts") not in sys.path:
    sys.path.insert(0, str(ROOT / "scripts"))

from generate_nsfw_prompts import build_prompt  # noqa: E402


def http_json(url: str, payload: dict | None = None, timeout: int = 60) -> dict:
    data = None
    headers = {"Content-Type": "application/json"}
    if payload is not None:
        data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(url, data=data, headers=headers)
    with urllib.request.urlopen(req, timeout=timeout) as resp:
        raw = resp.read()
        if not raw:
            return {}
        return json.loads(raw.decode("utf-8"))


def wait_alive(base: str) -> None:
    try:
        http_json(f"{base}/system_stats", timeout=8)
    except Exception as exc:
        raise SystemExit(
            f"ComfyUI nebeží na {base}\n"
            f"spusti: bash scripts/runpod.sh start\n{exc}"
        )


def queue_job(base: str, workflow: dict) -> str:
    res = http_json(f"{base}/prompt", {"prompt": workflow})
    pid = res.get("prompt_id")
    if not pid:
        raise SystemExit(f"ComfyUI neodovzdal prompt_id: {res}")
    return pid


def wait_done(base: str, prompt_id: str, timeout: int) -> dict:
    t0 = time.time()
    while time.time() - t0 < timeout:
        hist = http_json(f"{base}/history/{prompt_id}", timeout=30)
        if prompt_id in hist:
            return hist[prompt_id]
        time.sleep(2)
    raise SystemExit(f"timeout {timeout}s pri čakaní na {prompt_id}")


def saved_names(history_item: dict) -> list[str]:
    names = []
    for node_out in history_item.get("outputs", {}).values():
        for img in node_out.get("images", []):
            names.append(img.get("filename", ""))
    return [n for n in names if n]


def main() -> None:
    p = argparse.ArgumentParser()
    p.add_argument("-n", "--count", type=int, default=4)
    p.add_argument("--explicit", choices=["soft", "nude", "explicit"], default="nude")
    p.add_argument("--seed", type=int, default=None)
    p.add_argument("--host", default="http://127.0.0.1:8188")
    p.add_argument("--lora", default="aidmaNSFWunlock-FLUX-V0.2.safetensors")
    p.add_argument("--guidance", type=float, default=2.6)
    p.add_argument("--steps", type=int, default=32)
    p.add_argument("--width", type=int, default=768)
    p.add_argument("--height", type=int, default=1344)
    p.add_argument("--timeout", type=int, default=300)
    p.add_argument("--dry-run", action="store_true")
    args = p.parse_args()

    wf_path = ROOT / "workflows" / "flux_nsfw_fullbody_api.json"
    template = json.loads(wf_path.read_text(encoding="utf-8"))
    base = args.host.rstrip("/")

    if not args.dry_run:
        wait_alive(base)

    cap_dir = Path("/workspace/Grok-AI-model/dataset/luna23/captions")
    cap_dir.mkdir(parents=True, exist_ok=True)

    rng_seed = args.seed if args.seed is not None else int(time.time())
    print(f"base={base}  count={args.count}  explicit={args.explicit}  seed0={rng_seed}")

    for i in range(args.count):
        seed = rng_seed + i
        pos, neg = build_prompt(args.explicit, seed=seed)
        wf = copy.deepcopy(template)
        wf["4"]["inputs"]["lora_name"] = args.lora
        wf["5"]["inputs"]["text"] = pos
        wf["6"]["inputs"]["text"] = neg
        wf["7"]["inputs"]["guidance"] = args.guidance
        wf["8"]["inputs"]["width"] = args.width
        wf["8"]["inputs"]["height"] = args.height
        wf["9"]["inputs"]["seed"] = seed
        wf["9"]["inputs"]["steps"] = args.steps
        wf["11"]["inputs"]["filename_prefix"] = f"luna23_{args.explicit}"

        note = cap_dir / f"{args.explicit}_{seed}.txt"
        note.write_text(f"POSITIVE:\n{pos}\n\nNEGATIVE:\n{neg}\n", encoding="utf-8")
        print(f"\n[{i+1}/{args.count}] seed={seed}")
        print(pos[:220] + "...")

        if args.dry_run:
            continue

        pid = queue_job(base, wf)
        print(f"queued {pid}")
        item = wait_done(base, pid, args.timeout)
        status = item.get("status", {})
        if status.get("status_str") == "error" or item.get("status_str") == "error":
            print("CHYBA ComfyUI:", json.dumps(status, ensure_ascii=False)[:800])
            continue
        files = saved_names(item)
        print("OK", ", ".join(files) if files else "hotovo (skontroluj ComfyUI/output)")

    print("\noutput: /workspace/runpod-slim/ComfyUI/output/")
    print(f"captions: {cap_dir}")


if __name__ == "__main__":
    main()
