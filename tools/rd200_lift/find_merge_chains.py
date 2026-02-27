#!/usr/bin/env python3
"""
Find linear merge candidates in rd200_rom_b_lifted.cpp.

This is an analysis helper: it does not modify generated code.
"""

from __future__ import annotations

import argparse
import pathlib
import re
from collections import defaultdict


BLOCK_RE = re.compile(
    r"// ([0-9A-F]{4}): .*?\nvoid (block_[0-9a-f]+)\(Rd200RomBLiftedCore &core\)\n\{(.*?)\n\}\n",
    re.DOTALL,
)
NEXT_PC_RE = re.compile(r"\bs\.pc\s*=\s*0x([0-9A-Fa-f]{4});")
REG_RE = re.compile(r"core\.register_block\(0x([0-9A-Fa-f]{4}),\s*&block_[0-9a-f]+\);")


def is_linear(body: str) -> int | None:
    if " ? " in body:
        return None
    if "core.pop16" in body:
        return None
    if "core.halt" in body:
        return None
    if "exec_dynamic_" in body:
        return None
    pcs = NEXT_PC_RE.findall(body)
    if len(pcs) != 1:
        return None
    return int(pcs[0], 16)


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--input",
        default="librdpiano/generated/rd200_rom_b_lifted.cpp",
        help="Generated lifted C++ file",
    )
    ap.add_argument("--min-len", type=int, default=3, help="Minimum chain length")
    ap.add_argument("--limit", type=int, default=40, help="Max chains to print")
    args = ap.parse_args()

    text = pathlib.Path(args.input).read_text()

    registered = {int(m.group(1), 16) for m in REG_RE.finditer(text)}
    succ: dict[int, int] = {}
    indeg: defaultdict[int, int] = defaultdict(int)

    for m in BLOCK_RE.finditer(text):
        pc = int(m.group(1), 16)
        body = m.group(3)
        nxt = is_linear(body)
        if nxt is None:
            continue
        if pc not in registered or nxt not in registered:
            continue
        succ[pc] = nxt
        indeg[nxt] += 1

    visited: set[int] = set()
    chains: list[list[int]] = []

    for start in sorted(succ):
        if start in visited:
            continue
        if indeg[start] == 1:
            continue
        chain = [start]
        cur = start
        while cur in succ:
            nxt = succ[cur]
            if nxt in visited:
                break
            if indeg[nxt] != 1:
                chain.append(nxt)
                break
            chain.append(nxt)
            cur = nxt
            if cur == start:
                break
        if len(chain) >= args.min_len:
            for n in chain:
                visited.add(n)
            chains.append(chain)

    chains.sort(key=len, reverse=True)
    print(f"chains_found={len(chains)} min_len={args.min_len}")
    for i, ch in enumerate(chains[: args.limit], 1):
        pcs = " -> ".join(f"{pc:04X}" for pc in ch)
        print(f"{i:02d}. len={len(ch):02d} {pcs}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
