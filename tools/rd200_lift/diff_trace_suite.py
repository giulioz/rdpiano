#!/usr/bin/env python3
"""Compare two trace directories file-by-file."""

import argparse
import pathlib
import subprocess
import sys


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--baseline-dir", required=True)
    ap.add_argument("--candidate-dir", required=True)
    ap.add_argument("--diff-script", default="tools/rd200_lift/diff_trace.py")
    args = ap.parse_args()

    baseline_dir = pathlib.Path(args.baseline_dir)
    candidate_dir = pathlib.Path(args.candidate_dir)
    diff_script = pathlib.Path(args.diff_script)

    baseline_files = sorted(baseline_dir.glob("*.jsonl"))
    if not baseline_files:
        print(f"no baseline traces found in {baseline_dir}", file=sys.stderr)
        return 2

    for baseline in baseline_files:
        candidate = candidate_dir / baseline.name
        if not candidate.exists():
            print(f"missing candidate trace: {candidate}", file=sys.stderr)
            return 1

        cmd = [
            str(diff_script),
            "--baseline",
            str(baseline),
            "--candidate",
            str(candidate),
        ]
        print("diffing:", baseline.name)
        completed = subprocess.run(cmd, check=False)
        if completed.returncode != 0:
            return completed.returncode

    print(f"all traces matched ({len(baseline_files)} files)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
