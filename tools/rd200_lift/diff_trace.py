#!/usr/bin/env python3
"""Exact JSONL trace comparator for rd200 traces."""

import argparse
import json
import pathlib
import sys
from typing import Any


def load_jsonl(path: pathlib.Path) -> list[dict[str, Any]]:
    out: list[dict[str, Any]] = []
    with path.open("r", encoding="utf-8") as f:
        for i, line in enumerate(f, start=1):
            s = line.strip()
            if not s:
                continue
            try:
                obj = json.loads(s)
            except json.JSONDecodeError as exc:
                raise ValueError(f"{path}:{i}: invalid json: {exc}") from exc
            out.append(obj)
    return out


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--baseline", required=True)
    ap.add_argument("--candidate", required=True)
    args = ap.parse_args()

    baseline_path = pathlib.Path(args.baseline)
    candidate_path = pathlib.Path(args.candidate)

    try:
        baseline = load_jsonl(baseline_path)
        candidate = load_jsonl(candidate_path)
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        return 2

    common = min(len(baseline), len(candidate))
    for idx in range(common):
        if baseline[idx] != candidate[idx]:
            print("trace mismatch")
            print(f"  event_index={idx}")
            print(f"  last_matching_event={idx - 1}")
            print(f"  baseline={json.dumps(baseline[idx], sort_keys=True)}")
            print(f"  candidate={json.dumps(candidate[idx], sort_keys=True)}")
            return 1

    if len(baseline) != len(candidate):
        print("trace length mismatch")
        print(f"  common_events={common}")
        print(f"  baseline_len={len(baseline)}")
        print(f"  candidate_len={len(candidate)}")
        if len(baseline) > common:
            print(f"  next_baseline={json.dumps(baseline[common], sort_keys=True)}")
        if len(candidate) > common:
            print(f"  next_candidate={json.dumps(candidate[common], sort_keys=True)}")
        return 1

    print(f"trace match: {len(baseline)} events")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
