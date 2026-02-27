#!/usr/bin/env python3
"""
Emit flattened linear chains from rd200_rom_b_lifted.cpp for reverse-engineering.

This does not alter runtime code. It creates a readable artifact by concatenating
straight-line block bodies and removing intermediate `s.pc = ...` hops.
"""

from __future__ import annotations

import argparse
import pathlib
import re
from collections import defaultdict


BLOCK_RE = re.compile(
    r"// ([0-9A-F]{4}): (.*?)\nvoid (block_[0-9a-f]+)\(Rd200RomBLiftedCore &core\)\n\{(.*?)\n\}\n",
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


def strip_pc_lines(body: str) -> str:
    lines = []
    for ln in body.strip("\n").splitlines():
        s = ln.strip()
        if s.startswith("auto &s = core.state();"):
            continue
        if s.startswith("(void)core;"):
            continue
        if NEXT_PC_RE.search(s):
            continue
        lines.append(ln.rstrip())
    return "\n".join(lines).strip()


def build_chains(text: str, min_len: int) -> tuple[list[list[int]], dict[int, tuple[str, str]]]:
    registered = {int(m.group(1), 16) for m in REG_RE.finditer(text)}
    succ: dict[int, int] = {}
    indeg: defaultdict[int, int] = defaultdict(int)
    blocks: dict[int, tuple[str, str]] = {}

    for m in BLOCK_RE.finditer(text):
        pc = int(m.group(1), 16)
        asm = m.group(2).strip()
        body = m.group(4)
        blocks[pc] = (asm, body)
        nxt = is_linear(body)
        if nxt is None:
            continue
        if pc not in registered or nxt not in registered:
            continue
        succ[pc] = nxt
        indeg[nxt] += 1

    chains: list[list[int]] = []
    seen: set[int] = set()
    for start in sorted(succ):
        if start in seen:
            continue
        if indeg[start] == 1:
            continue
        cur = start
        chain = [cur]
        while cur in succ:
            nxt = succ[cur]
            if nxt in seen:
                break
            chain.append(nxt)
            cur = nxt
            if indeg[cur] != 1:
                break
        if len(chain) >= min_len:
            chains.append(chain)
            for n in chain:
                seen.add(n)

    chains.sort(key=len, reverse=True)
    return chains, blocks


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--input", default="librdpiano/generated/rd200_rom_b_lifted.cpp")
    ap.add_argument(
        "--out",
        default="re_stuff/rd200_flattened_chains.md",
        help="Output markdown file",
    )
    ap.add_argument("--min-len", type=int, default=4)
    ap.add_argument("--limit", type=int, default=30)
    args = ap.parse_args()

    src = pathlib.Path(args.input).read_text()
    chains, blocks = build_chains(src, args.min_len)

    out = []
    out.append("# RD-200 Flattened Linear Chains")
    out.append("")
    out.append(f"Source: `{args.input}`")
    out.append(f"Min length: {args.min_len}")
    out.append(f"Chains emitted: {min(len(chains), args.limit)} / {len(chains)}")
    out.append("")

    for idx, chain in enumerate(chains[: args.limit], 1):
        out.append(f"## {idx:02d}. Chain len={len(chain)}")
        out.append("")
        out.append("PCs: " + " -> ".join(f"`{pc:04X}`" for pc in chain))
        out.append("")
        out.append("```cpp")
        out.append("void merged_chain(...)")
        out.append("{")
        out.append("  auto &s = core.state();")
        for pc in chain:
            asm, body = blocks[pc]
            out.append(f"  // {pc:04X}: {asm}")
            chunk = strip_pc_lines(body)
            if chunk:
                out.append("  {")
                for ln in chunk.splitlines():
                    out.append("  " + ln)
                out.append("  }")
        out.append("}")
        out.append("```")
        out.append("")

    out_path = pathlib.Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text("\n".join(out) + "\n")
    print(f"wrote: {out_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
