#!/usr/bin/env python3
"""Build basic-block CFG and reachable set for rd200_rom_b."""

import argparse


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--index", required=True)
    args = ap.parse_args()

    print(f"cfg_builder: index={args.index}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
