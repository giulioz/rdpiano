#!/usr/bin/env python3
"""Summarize lifted fallback coverage from suite stats files."""

import argparse
import json
import pathlib
import sys


def parse_pc(value: str) -> int:
    v = value.strip()
    return int(v, 16) if v.lower().startswith("0x") else int(v, 16)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--stats-dir", required=True)
    ap.add_argument("--fail-on-fallback", action="store_true")
    ap.add_argument(
        "--allow-fallback-pc",
        action="append",
        default=[],
        help="Allow fallback at this PC (hex, e.g. E156 or 0xE156). Repeatable.",
    )
    ap.add_argument("--dump-pcs-out")
    args = ap.parse_args()

    stats_dir = pathlib.Path(args.stats_dir)
    files = sorted(stats_dir.glob("*.stats.json"))
    if not files:
        print(f"no stats files found in {stats_dir}", file=sys.stderr)
        return 2

    total_step_attempts = 0
    total_lifted_steps = 0
    total_fallback_steps = 0
    total_unlifted_hits = 0
    total_unique_unlifted_pcs = 0
    union_unlifted_pcs: set[int] = set()
    union_unlifted_pc_hits: dict[int, int] = {}

    for f in files:
        with f.open("r", encoding="utf-8") as fh:
            data = json.load(fh)
        total_step_attempts += int(data.get("step_attempts", 0))
        total_lifted_steps += int(data.get("lifted_steps", 0))
        total_fallback_steps += int(data.get("fallback_steps", 0))
        total_unlifted_hits += int(data.get("unlifted_hits", 0))
        total_unique_unlifted_pcs += int(data.get("unique_unlifted_pcs", 0))
        pcs = data.get("unlifted_pcs", [])
        if isinstance(pcs, list):
            for pc in pcs:
                union_unlifted_pcs.add(int(pc))
        pc_hits = data.get("unlifted_pc_hits", [])
        if isinstance(pc_hits, list):
            for item in pc_hits:
                if isinstance(item, dict):
                    pc = int(item.get("pc", 0))
                    hits = int(item.get("hits", 0))
                    union_unlifted_pc_hits[pc] = union_unlifted_pc_hits.get(pc, 0) + hits

    print("lift_coverage_summary")
    print(f"  files={len(files)}")
    print(f"  step_attempts={total_step_attempts}")
    print(f"  lifted_steps={total_lifted_steps}")
    print(f"  fallback_steps={total_fallback_steps}")
    print(f"  unlifted_hits={total_unlifted_hits}")
    print(f"  unique_unlifted_pcs_sum={total_unique_unlifted_pcs}")
    print(f"  unique_unlifted_pcs_union={len(union_unlifted_pcs)}")

    top = sorted(union_unlifted_pc_hits.items(), key=lambda kv: (-kv[1], kv[0]))[:10]
    if top:
        print("  top_unlifted_pcs:")
        for pc, hits in top:
            print(f"    {pc:04X} hits={hits}")

    if args.dump_pcs_out:
        out_path = pathlib.Path(args.dump_pcs_out)
        with out_path.open("w", encoding="utf-8") as f:
            for pc, hits in sorted(union_unlifted_pc_hits.items(), key=lambda kv: (-kv[1], kv[0])):
                f.write(f"{pc:04X} {hits}\n")
        print(f"  dumped_unlifted_pcs={out_path}")

    allowlist = {parse_pc(v) for v in args.allow_fallback_pc}
    unexpected = sorted(pc for pc in union_unlifted_pcs if pc not in allowlist)
    if unexpected:
        print(
            "unexpected_unlifted_pcs="
            + ",".join(f"{pc:04X}" for pc in unexpected),
            file=sys.stderr,
        )
        return 1

    if args.fail_on_fallback and total_fallback_steps != 0 and not allowlist:
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
