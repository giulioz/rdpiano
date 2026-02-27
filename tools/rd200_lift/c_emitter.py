#!/usr/bin/env python3
"""Emit deterministic C-like label/goto source for lifted rd200_rom_b blocks."""

import argparse
from pathlib import Path

HEADER = """#ifndef RD200_ROM_B_LIFTED_H\n#define RD200_ROM_B_LIFTED_H\n\nclass Rd200RomBLiftedCore;\n\nvoid rd200_rom_b_register_blocks(Rd200RomBLiftedCore &core);\n\n#endif\n"""

CPP = """#include \"../include/rd200_lifted_core.h\"\n#include \"rd200_rom_b_lifted.h\"\n\nvoid rd200_rom_b_register_blocks(Rd200RomBLiftedCore &core)\n{\n  (void)core;\n  // Generated block registration will be emitted by tools/rd200_lift.\n}\n"""


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--cfg", required=True)
    ap.add_argument("--out-dir", required=True)
    args = ap.parse_args()

    out_dir = Path(args.out_dir)
    out_dir.mkdir(parents=True, exist_ok=True)
    (out_dir / "rd200_rom_b_lifted.h").write_text(HEADER)
    (out_dir / "rd200_rom_b_lifted.cpp").write_text(CPP)

    print(f"c_emitter: cfg={args.cfg} out={out_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
