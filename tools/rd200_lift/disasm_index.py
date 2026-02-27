#!/usr/bin/env python3
"""Build address/label/opcode index from disassembly."""

import argparse


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--disasm", required=True)
    args = ap.parse_args()

    print(f"disasm_index: disasm={args.disasm}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
