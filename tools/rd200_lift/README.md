# RD200 Lift Toolchain (Scaffold)

This folder is the home for the static lift pipeline for `rd200_rom_b`.

Planned stages:

1. `rom_parser.py`: load ROM/disassembly artifacts.
2. `disasm_index.py`: indexed address/opcode/label model.
3. `cfg_builder.py`: basic block graph and reachable-set analysis.
4. `c_emitter.py`: deterministic C-like label/goto emitter.

Current state:

- Skeleton scripts are present.
- Final generated output target is:
  - `librdpiano/generated/rd200_rom_b_lifted.h`
  - `librdpiano/generated/rd200_rom_b_lifted.cpp`

Determinism contract:

- Given the same ROM/disassembly inputs and options, output must be byte-identical.
