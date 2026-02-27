#!/usr/bin/env python3
"""Run full rd200 trace equivalence gate for a corpus directory."""

import argparse
import pathlib
import subprocess
import sys


def run(cmd: list[str]) -> int:
    print("running:", " ".join(cmd))
    return subprocess.run(cmd, check=False).returncode


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--corpus-dir", required=True)
    ap.add_argument("--work-dir", required=True)
    ap.add_argument("--rom-dir", default="roms")
    ap.add_argument("--trace-runner", required=True)
    ap.add_argument("--program", type=int, default=0)
    ap.add_argument(
        "--allow-fallback-pc",
        action="append",
        default=[],
        help="Allow fallback at this PC (hex). Repeatable.",
    )
    args = ap.parse_args()

    work = pathlib.Path(args.work_dir)
    interp_dir = work / "interpreter"
    lifted_dir = work / "lifted"
    unlifted_list = work / "unlifted_pcs.txt"

    interp_dir.mkdir(parents=True, exist_ok=True)
    lifted_dir.mkdir(parents=True, exist_ok=True)

    cmd_interp = [
        "tools/rd200_lift/run_trace_suite.py",
        "--runtime",
        "interpreter",
        "--corpus-dir",
        args.corpus_dir,
        "--out-dir",
        str(interp_dir),
        "--rom-dir",
        args.rom_dir,
        "--program",
        str(args.program),
        "--trace-runner",
        args.trace_runner,
    ]
    if run(cmd_interp) != 0:
        return 1

    cmd_lifted = [
        "tools/rd200_lift/run_trace_suite.py",
        "--runtime",
        "lifted",
        "--corpus-dir",
        args.corpus_dir,
        "--out-dir",
        str(lifted_dir),
        "--rom-dir",
        args.rom_dir,
        "--program",
        str(args.program),
        "--trace-runner",
        args.trace_runner,
    ]
    if run(cmd_lifted) != 0:
        return 1

    cmd_diff = [
        "tools/rd200_lift/diff_trace_suite.py",
        "--baseline-dir",
        str(interp_dir),
        "--candidate-dir",
        str(lifted_dir),
    ]
    if run(cmd_diff) != 0:
        return 1

    cmd_cov = [
        "tools/rd200_lift/summarize_lift_coverage.py",
        "--stats-dir",
        str(lifted_dir),
        "--dump-pcs-out",
        str(unlifted_list),
    ]
    for pc in args.allow_fallback_pc:
        cmd_cov.extend(["--allow-fallback-pc", pc])
    if run(cmd_cov) != 0:
        return 1

    print(f"equivalence gate passed; unlifted PCs list: {unlifted_list}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
