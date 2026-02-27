#!/usr/bin/env python3
"""Run interpreter/lifted trace capture for deterministic corpus."""

import argparse
import pathlib
import subprocess
import sys


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--runtime", choices=["interpreter", "lifted"], required=True)
    ap.add_argument("--corpus", required=True)
    ap.add_argument("--out", required=True)
    ap.add_argument("--rom-dir", default=".")
    ap.add_argument("--program", type=int, default=0)
    ap.add_argument("--stats-out")
    ap.add_argument("--trace-runner")
    args = ap.parse_args()

    if args.trace_runner:
        runner = pathlib.Path(args.trace_runner)
    else:
        here = pathlib.Path(__file__).resolve()
        runner = here.parents[2] / "librdpiano" / "build" / "rd200_trace_runner"

    cmd = [
        str(runner),
        "--runtime",
        args.runtime,
        "--corpus",
        args.corpus,
        "--out",
        args.out,
        "--rom-dir",
        args.rom_dir,
        "--program",
        str(args.program),
    ]
    if args.stats_out:
        cmd.extend(["--stats-out", args.stats_out])

    print("running:", " ".join(cmd))
    try:
        completed = subprocess.run(cmd, check=False)
    except FileNotFoundError:
        print(f"trace runner not found: {runner}", file=sys.stderr)
        return 2

    return completed.returncode


if __name__ == "__main__":
    raise SystemExit(main())
