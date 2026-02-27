# RD200 ROM B Lift Contract

Scope: contract for replacing the HD63701 CPU emulation with static lifted C-like code for `rd200_rom_b`.

## 1. CPU/Core Scope

Required behavior:

- Preserve PC flow and flags behavior for executed opcodes in this ROM path.
- Preserve IRQ entry/return semantics (`IRQ1`, `ICI`, `RTI`).
- Preserve stack layout used by interrupt entry/`RTI`.

Observed dead (current workload):

- `TAP (0x06)`, `SLP (0x1A)`, `WAI (0x3E)`, `SWI (0x3F)`, `TRAP`.

## 2. Memory/MMIO Contract

The lifted code must preserve these effective mappings and side effects:

- `0x0002` (`P1DR`): command/MIDI ingress byte source.
- `0x0003` (`P2DR`): control/handshake register; writes participate in TIN edge handling.
- `0x0008` (`TCSR`): timer control/status read/write behavior.
- `0x000D`/`0x000E` (`IN_CAPTURE` low/high): read ordering and flag-clear side effects.
- `0x0020-0x0FFF`: RAM.
- `0x1000-0x1FFF`: sound-chip MMIO.
- `0x4000-0xBFFF`: params ROM window, bank selected by `latch_val & 0x3`.
- `0xC000-0xFFFF`: program ROM.
- Writes outside mapped ranges update latch (`latch_val`).

## 3. Interrupt Contract

Priority and vectors to preserve:

1. NMI -> `0xFFFC`
2. IRQ1 -> `0xFFF8`
3. ICI (TIN input capture interrupt) -> `0xFFF6`

For `rd200_rom_b` in observed runs:

- IRQ traffic is dominated by `IRQ1` (sound-chip flow).
- `ICI` is active and must be preserved.

## 4. TIN/TCSR/ICR Contract (Critical)

TIN edge handling must preserve:

- Edge qualification via `TCSR.IEDG`.
- On active edge: set `TCSR.ICF`, latch `IN_CAPTURE`, and make `ICI` eligible when `TCSR.EICI=1`.

Read-side behavior to preserve:

- `TCSR` read participates in interrupt-flag clear protocol.
- `IN_CAPTURE` low/high reads are performed by ROM mostly in ICI handler path.
- In `rd200_rom_b`, dominant read site is around `E14F..E156` and reads appear side-effect/ack oriented.

Phase-1 simplification allowed:

- Free-running counter accuracy can be deferred if TIN/ICF/ICI side effects and register read/write protocol remain equivalent.

## 5. Sound-Chip IRQ Contract

- Sound chip raises pending IRQ (`m_irq_triggered`) and IRQ id.
- CPU-side IRQ1 assertion/deassertion flow must remain equivalent.
- Reading sound-chip register returns IRQ id as currently modeled.

## 6. Host Integration Contract

- MIDI ingress may remain a host shim.
- Handshake timing can be emulated at API level, but visible ROM-side MMIO semantics above must stay stable.

## 7. Validation Gates

Use A/B comparison against current emulator:

- IRQ counts (`IRQ1`, `ICI`) over the same MIDI sequence.
- `RTI` count and control-flow landmarks.
- `IN_CAPTURE` read-site PC histogram (dominant PCs must match).
- Sound-chip register write trace equivalence.

## 8. Lifted Core Scaffold

`librdpiano/include/rd200_lifted_core.h` and `librdpiano/src/rd200_lifted_core.cpp` provide:

- CPU state container for rd200 lift work.
- IRQ priority/entry/`RTI` scaffolding.
- TIN/TCSR/ICR side-effect handling matching current emulator contract.
- Bus callbacks for memory/IO delegation.
- PC-to-block registration (`register_block(pc, fn)`) for incremental static lifting.

This scaffold is intentionally minimal and does not include a full opcode interpreter fallback.
Unlifted PCs can halt or call `on_unlifted_pc` based on config.

## 9. Runtime Cutover Status

- `Mcu` defaults to lifted runtime for `rd200_rom_b` paths.
- Debug override remains available via `RDPIANO_FORCE_INTERPRETER=1` or `RDPIANO_MCU_RUNTIME=interpreter`.
- Lift equivalence gate now targets zero fallback PCs in the deterministic corpus.
