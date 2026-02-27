#!/usr/bin/env python3
"""
Rewrite constant RAM accesses in generated lifted C++ to direct RAM helpers.

This is intentionally a post-pass so we can keep manual hotfixes in the
generated file and still re-apply deterministic memory-access simplification.
"""

from __future__ import annotations

import argparse
import pathlib
import re


RAM_LO = 0x0020
RAM_HI_EXCL = 0x1000
RAM16_HI_EXCL = 0x0FFF  # last valid start for 16-bit read/write


def in_ram(hex_addr: str) -> bool:
    v = int(hex_addr, 16)
    return RAM_LO <= v < RAM_HI_EXCL


def in_ram16(hex_addr: str) -> bool:
    v = int(hex_addr, 16)
    return RAM_LO <= v < RAM16_HI_EXCL


def rewrite(text: str) -> str:
    text = re.sub(
        r"core\.read8\((0x[0-9A-Fa-f]+)\)",
        lambda m: f"core.ram_read8({m.group(1)})" if in_ram(m.group(1)) else m.group(0),
        text,
    )
    text = re.sub(
        r"core\.write8\((0x[0-9A-Fa-f]+),\s*([^)]+)\)",
        lambda m: f"core.ram_write8({m.group(1)}, {m.group(2)})" if in_ram(m.group(1)) else m.group(0),
        text,
    )
    text = re.sub(
        r"core\.read16\((0x[0-9A-Fa-f]+)\)",
        lambda m: f"core.ram_read16({m.group(1)})" if in_ram16(m.group(1)) else m.group(0),
        text,
    )
    text = re.sub(
        r"core\.write16\((0x[0-9A-Fa-f]+),\s*([^)]+)\)",
        lambda m: f"core.ram_write16({m.group(1)}, {m.group(2)})" if in_ram16(m.group(1)) else m.group(0),
        text,
    )

    # Indexed/dynamic accesses: use RAM-first fast path, preserve full semantics on fallback.
    text = re.sub(
        r"core\.read8\(static_cast<uint16_t>\(s\.x \+ 0x([0-9A-Fa-f]+)\)\)",
        r"core.read8_fast(static_cast<uint16_t>(s.x + 0x\1))",
        text,
    )
    text = re.sub(
        r"core\.write8\(static_cast<uint16_t>\(s\.x \+ 0x([0-9A-Fa-f]+)\),\s*([^)]+)\)",
        r"core.write8_fast(static_cast<uint16_t>(s.x + 0x\1), \2)",
        text,
    )
    text = re.sub(
        r"core\.read16\(static_cast<uint16_t>\(s\.x \+ 0x([0-9A-Fa-f]+)\)\)",
        r"core.read16_fast(static_cast<uint16_t>(s.x + 0x\1))",
        text,
    )
    text = re.sub(
        r"core\.write16\(static_cast<uint16_t>\(s\.x \+ 0x([0-9A-Fa-f]+)\),\s*([^)]+)\)",
        r"core.write16_fast(static_cast<uint16_t>(s.x + 0x\1), \2)",
        text,
    )
    text = text.replace("core.read8(idx_addr())", "core.read8_fast(idx_addr())")
    text = text.replace("core.write8(idx_addr(),", "core.write8_fast(idx_addr(),")
    text = text.replace("core.read16(idx_addr())", "core.read16_fast(idx_addr())")
    text = text.replace("core.write16(idx_addr(),", "core.write16_fast(idx_addr(),")
    return text


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("path", help="Path to rd200_rom_b_lifted.cpp")
    args = parser.parse_args()

    p = pathlib.Path(args.path)
    src = p.read_text()
    out = rewrite(src)
    if out != src:
        p.write_text(out)
        print(f"updated: {p}")
    else:
        print(f"no changes: {p}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
