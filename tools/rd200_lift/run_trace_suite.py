#!/usr/bin/env python3
"""Run rd200 trace capture across a corpus directory."""

import argparse
import pathlib
import subprocess
import sys


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--runtime", choices=["interpreter", "lifted"], required=True)
    ap.add_argument("--corpus-dir", required=True)
    ap.add_argument("--out-dir", required=True)
    ap.add_argument("--rom-dir", default=".")
    ap.add_argument("--program", type=int, default=0)
    ap.add_argument("--trace-runner")
    ap.add_argument("--run-trace-script", default="tools/rd200_lift/run_trace.py")
    args = ap.parse_args()

    corpus_dir = pathlib.Path(args.corpus_dir)
    out_dir = pathlib.Path(args.out_dir)
    run_trace = pathlib.Path(args.run_trace_script)

    files = sorted(corpus_dir.glob("*.txt"))
    if not files:
        print(f"no corpus files found in {corpus_dir}", file=sys.stderr)
        return 2

    out_dir.mkdir(parents=True, exist_ok=True)

    for corpus in files:
        out_file = out_dir / (corpus.stem + ".jsonl")
        stats_file = out_dir / (corpus.stem + ".stats.json")
        cmd = [
            str(run_trace),
            "--runtime",
            args.runtime,
            "--corpus",
            str(corpus),
            "--out",
            str(out_file),
            "--rom-dir",
            args.rom_dir,
            "--program",
            str(args.program),
            "--stats-out",
            str(stats_file),
        ]
        if args.trace_runner:
            cmd.extend(["--trace-runner", args.trace_runner])

        print("running:", " ".join(cmd))
        completed = subprocess.run(cmd, check=False)
        if completed.returncode != 0:
            return completed.returncode

    print(f"wrote {len(files)} traces to {out_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
