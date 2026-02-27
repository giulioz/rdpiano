#!/usr/bin/env python3
"""Load ROM/disassembly inputs for rd200_rom_b lift pipeline."""

import argparse
from pathlib import Path


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--rom", required=True)
    ap.add_argument("--disasm", required=True)
    args = ap.parse_args()

    rom = Path(args.rom)
    disasm = Path(args.disasm)
    if not rom.exists() or not disasm.exists():
        raise SystemExit("missing input files")

    print(f"rom_parser: rom={rom} disasm={disasm}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
