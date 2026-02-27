#!/usr/bin/env python3
"""Run interpreter/lifted trace capture for deterministic corpus (scaffold)."""

import argparse


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--runtime", choices=["interpreter", "lifted"], required=True)
    ap.add_argument("--corpus", required=True)
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    print(f"run_trace: runtime={args.runtime} corpus={args.corpus} out={args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
