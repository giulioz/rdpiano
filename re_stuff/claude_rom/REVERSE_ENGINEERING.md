# Roland RD-200 / MKS-20 Reverse Engineering Notes

## Hardware Overview

The RD-200 is a digital piano from 1986 with two CPUs:

- **CPU A** (HD63B03RP): Front panel, MIDI I/O, key scanner
- **CPU B** (HD63B03RP): Sound engine, controls the sound chip

Both CPUs use the **HD6301 instruction set** (6800-compatible with extensions: AIM, OIM, EIM, TIM, XGDX, MUL, etc.). Use `-6301` mode in f9dasm, not `-6803`.

### ROM Scrambling

**CPU B program ROM** is scrambled in hardware:
```
Address: bitswap<14>(i, 13,12,11, 8,9,10, 7,6,5,4,3,2,1,0)
Data:    bitswap<8>(d, 7,0,6,1,5,2,4,3)
```

**IC18 params ROM** (128KB) uses different scrambling:
```
Address: bitswap<17>(i, 16,15, 13,12,14, 11, 8,9,10, 7,6,5,4,3,2,1,0)
Data:    bitswap<8>(d, 7,0,6,1,5,2,4,3)  (same data scramble as CPU B)
```

**Wave ROMs** (IC5/IC6/IC7, 128KB each) have address-only scrambling:
```
Address: complex bitswap (see UNSCRAMBLE_ADDR_WAVE in sound_chip.cpp)
Data:    identity (no scramble)
```

**CPU A ROM** is NOT scrambled.

---

## CPU A (Front Panel / MIDI)

### Memory Map
| Address | Device |
|---------|--------|
| 0x0000-0x001F | HD6301 internal registers (ports, timer, SCI) |
| 0x0080-0x00FF | Internal RAM (128 bytes) |
| 0x0100-0x0FFF | External RAM |
| 0x1000 | Key scanner input (active low) |
| 0x1800 | Volume ADC / hardware config input |
| 0x2000 | LED output / key scanner row select |
| 0x2800 | LED output 2 |
| 0x3000 | DAC output |
| 0xE000-0xFFFF | Program ROM (8KB) |

### Key Registers
| Address | Name | Purpose |
|---------|------|---------|
| 0x0000 | PORT1_DDR | Port 1 data direction |
| 0x0001 | PORT2_DDR | Port 2 data direction (bits 0,4 = output) |
| 0x0002 | PORT1_DATA | Port 1 data (8-bit bus to CPU B) |
| 0x0003 | PORT2_CTRL | Port 2 (bit 0=clock out, bit 1=ACK in from CPU B) |
| 0x0008 | TCSR | Timer control/status |
| 0x0010 | RMCR | Rate/mode control |
| 0x0011 | TRCSR | Transmit/receive control status |
| 0x0012 | SCI_RDR | Serial receive data (MIDI in) |
| 0x0013 | SCI_TDR | Serial transmit data (MIDI out) |

### CPU A → CPU B Communication Protocol

Uses P1 as 8-bit data bus, P2.0 as clock (triggers Input Capture IRQ on CPU B), CPU B P2.4 as acknowledge.

**1-byte command** (bit 7 = 0):
1. CPU A waits for ACK clear (P2.1=0)
2. Sets clock HIGH (P2.0=1, triggers ICF on CPU B)
3. Writes data to P1 latch
4. CPU B releases bus (P1 DDR=0) → P1 reads 0xFF via pullups
5. CPU A detects 0xFF, drives P1 with data
6. CPU A sets clock LOW → CPU B reads data, sends ACK

**3-byte command** (bit 7 = 1): same first byte, then 2 more bytes with clock toggling.

### MIDI Handling

CPU A receives MIDI via SCI interrupt (E793). Supported messages:
- 0x80 Note Off (velocity forced to 0)
- 0x90 Note On
- 0xB0 Control Change (CC#64 sustain, CC#66 sostenuto, CC#67 soft, CC#92 tremolo, CC#93 chorus, CC#123 all notes off, CC#124-127 channel mode)
- 0xC0 Program Change
- **NOT supported**: 0xA0 poly aftertouch, 0xD0 channel aftertouch, 0xE0 pitch bend

Channel filtering via M0080 (channel number) and M009F (omni/mono flags).

### Internal Command Format (CPU A → CPU B)

| Command | Type | Meaning |
|---------|------|---------|
| 0x0n | 1-byte | Voice reset with param n |
| 0x1n | 1-byte | Voice update tick |
| 0x30\|pgm | 1-byte | Program change (pgm 0-7) |
| 0x50/0x5F | 1-byte | Sustain OFF/ON |
| 0x60/0x6F | 1-byte | Sostenuto OFF/ON |
| 0x70/0x7F | 1-byte | Soft pedal OFF/ON |
| 0x80,note,param | 3-byte | Voice param update (low range) |
| 0x90,data,data | 3-byte | Voice update with data |
| 0xA0,note,param | 3-byte | Voice param update (high range, +0x80 to note) |
| 0xB0,note,0x00 | 3-byte | Note off |
| 0xC0,note,vel | 3-byte | Note on (layer 1) |
| 0xD0,note,vel | 3-byte | Note on (layer 2) |
| 0xE0,hi,lo | 3-byte | Tuning/transpose |
| 0xF0,subcmd,val | 3-byte | Configuration (see below) |

### F0 Sub-commands

| Sub | Purpose |
|-----|---------|
| F0,00,val | Velocity mode (val=0: on, val≠0: on+curve2) |
| F0,01,val | Sample rate muting (P2.2/P2.3 control) |
| F0,02,val | Load alternative params table |
| F0,03,val | Set global envelope offset (M00B9) |
| F0,04,val | Bank latch control |
| F0,05,val | Release mask override (always sent as F0,05,01 during normal operation) |

### Test Mode

Entered at boot when internal service switch (M1800 bit 5 LOW) AND CHORUS button held:
- **Sine wave test** (M1000 bit 1): plays repeating test tone via CPU B
- **RAM test** (M1000 bit 3): writes/reads 0x0800-0x08FF, shows errors on LEDs

### Data Tables in CPU A ROM

| Address | Size | Name | Purpose |
|---------|------|------|---------|
| E000 | 12 | serial_config | 2 MIDI baud rate configs |
| E88B | 8 | cc_mode_table | CC#124-127 omni/mono masks |
| EB00 | 32 | adc_tuning_lut | Front panel ADC → tuning |
| EC0E/1A/26 | 3×12 | handler_ptrs | Key config dispatch tables |
| EC6C | 8 | bit_mask | Powers of 2 |
| EF01 | 12 | transpose_note | Transpose lookup |
| F086 | 19 | key_scanner_map | Physical key → note offset |

---

## CPU B (Sound Engine)

### Memory Map
| Address | Device |
|---------|--------|
| 0x0000-0x001F | HD6301 internal registers |
| 0x0020-0x006F | Voice state (16 voices × per-field arrays) |
| 0x0080-0x00FF | Internal RAM (variables, some overlaps with voice queues) |
| 0x0100-0x01FF | External RAM |
| 0x0200-0x05BF | Voice RAM (16 voices × 0x3C bytes each) |
| 0x1000-0x1FFF | Sound chip registers (16 voices × 16 parts × 8 bytes) |
| 0x4000-0xBFFF | IC18 params ROM (32KB window, banked) |
| 0xC000-0xDFFF | Program ROM mirror (same as E000-FFFF) |
| 0xE000-0xFFFF | Program ROM (8KB) |

### Bank Switching

IC18 (128KB) is banked into 0x4000-0xBFFF via a write-only **latch at 0xE000**. Writing a value to any address in the ROM space captures bits 0-1 for bank selection (4 banks × 32KB = 128KB).

### Port 2 Pin Assignments (CPU B)
| Pin | Direction | Purpose |
|-----|-----------|---------|
| P2.0 | Input | Clock from CPU A (Input Capture trigger) |
| P2.1 | Input | (unused) |
| P2.2 | Output | Mute control for sample rate mode A |
| P2.3 | Output | Mute control for sample rate mode B |
| P2.4 | Output | Acknowledge to CPU A |

### Voice State Layout

Each voice uses fields at fixed offsets from the voice index X (0-15):

| Offset | Field | Notes |
|--------|-------|-------|
| +$20 | alloc_order | Indirection table for allocation (initially 0-15) |
| +$30 | note | MIDI note number |
| +$40 | wave_param | From velocity lookup table |
| +$50 | flags | Bit 7=active, 6=sostenuto, 5=sustain, 4=sent, 0=env |
| +$60 | env_phase | 0xFF = inactive |
| +$70 | assignment | Parts still sounding (0 = free) |
| +$80 | queue_note | Note queue (sorted) |
| +$84 | queue_param | Parameter queue |
| +$88 | queue_wavep | Wave param queue |

**Important**: M0092 (address 0x0092) overlaps with `voice[10].queue_wavep` ($88+10). This becomes non-zero when notes are playing, which makes the voice iteration loops work. This is an intentional side effect of the memory layout.

### Voice RAM Layout (at 0x0200 + voice × 0x3C)

Each voice has 10 parts × 6 bytes:

| Offset | Field |
|--------|-------|
| +0 | field0 (release speed base, from IC18 byte 6 of envelope entry) |
| +1 | velocity_level (from scaling table lookup) |
| +2-3 | envelope chain pointer (CPU address, 0 = no chain) |
| +4-5 | current env_dest/speed |

### Sound Chip Registers (at 0x1000 + voice × 0x100 + part × 0x10)

| Offset | Field | Written by |
|--------|-------|------------|
| +0 | pitch_hi | Note-on (from IC18 note mapping) |
| +1 | pitch_lo | Note-on |
| +2 | wave_addr_loop | Note-on (from IC18 envelope table) |
| +3 | wave_addr_high | Note-on |
| +4 | env_dest | Note-on, IRQ handler, note-off |
| +5 | env_speed | Note-on, IRQ handler, note-off |
| +6 | flags | Note-on (shared across voice, stored on part 0) |
| +7 | env_offset | Note-on (0xFF init) |

### Note-On Write Sequence (always 10 parts, unrolled)

1. Clear flags (0x00) + env_offset (0xFF) for parts 0-9
2. Write pitches from IC18 note mapping + tuning offset
3. Write wave_loop/wave_high from IC18 envelope table (global_env_offset added to part 0 only)
4. Store field0 values to voice RAM (IC18 envelope table byte 6 per part)
5. Envelope chain setup: scaling lookup + bilinear interpolation → initial env_dest/speed
6. Final: flags=0xFF, env_offset=0xFF on last part (part 9)

### Envelope Chain Processing (IRQ Handler at ED1A)

When a sound chip part finishes its envelope segment, it fires IRQ. The handler:

1. Reads `M1000` for voice:part identification (high nibble = voice, low = part)
2. Computes voice RAM address: `0x200 + voice*0x3C + part*6`
3. Reads chain pointer from voice RAM (+2:3)
4. If 0: silence the part, decrement voice assignment counter
5. Advance chain: `new_ptr = old_ptr + 6`
6. Read 4 bytes from new pointer, bilinear interpolation → new env_dest/speed
7. If env_speed = 0: terminate chain (set pointer to 0)

### Bilinear Interpolation (ZEB16)

Chain entry = 4 bytes: `[speed_lo_vel, dest_lo_wp, speed_hi_vel, dest_hi_wp]`

```
env_dest  = blend(dest_lo_wp,  dest_hi_wp,  wave_param_double)
env_speed = blend(speed_lo_vel, speed_hi_vel, velocity_level)

blend(a, b, t) = (t * b + (256 - t) * a) >> 8
```

Written to sound chip as: field4 = env_speed, field5 = env_dest.

### Wave Param Derived Values

```
wp_double  = (wave_param << 1) & 0xFF        // ASLB
wp_quarter = wp_double >> 2                    // LSRB; LSRB (NOT wave_param >> 2!)
wp_offset  = (wave_param & 0x80) ? 2 : 0     // BPL: inverted from what you'd expect
wp_chain_adj = (wave_param & 0x80) ? 0 : 1   // BMI
```

### Data Tables in CPU B ROM

| Address | Size | Name | Purpose |
|---------|------|------|---------|
| E16E | 32 | cmd_dispatch | 16 command handler addresses |
| E254 | 24 | program_config | 8 × {voice_mask, release_threshold, release_param} |
| ED9D | 32 | env_scaling_ptrs | 16 pointers to 64-byte scaling curves |
| EDCB | 12 | f0_subdispatch | 6 F0 sub-command handler addresses |
| EE0F-EE26 | 24 | params_ptr_table | Alternative params ROM pointer indirection |
| EE27-EE50 | 42 | alt_note_maps | 2 × 21-byte alternative note mapping entries |
| EE51-EEDD | ~140 | env_chain_templates | Default envelope chain templates |
| EF29-F048 | 192 | release_env_table | Release envelope dest/speed pairs |
| F049-F448 | 1024 | env_scaling_tables | 16 × 64-byte velocity/wave scaling curves |
| F449-FFEF | padding | (0xFF fill) |
| FFF0-FFFF | 16 | vector_table | Interrupt vectors |

---

## IC18 Params ROM Format

### RD200 Format

IC18[0x0000-0x0017]: Program table — 8 entries × 3 bytes:
```
[bank(1), addr_hi(1), addr_lo(1)]
```
Bank 0-3 selects which 32KB of the 128KB ROM. Addr is the CPU address (0x4000-0xBFFF).

### MKS-20 Format

No program table. Patches at hardcoded offsets:
```
Piano 1:     0x000000    Piano 2:     0x008000    Piano 3:     0x010000
Harpsichord: 0x018000    Clavi:       0x003C20    Vibraphone:  0x00AB50
E-Piano 1:   0x014260    E-Piano 2:   0x01BEF0
```

MKS-20 uses **two sets of wave ROMs**: set A (IC5=15179738, IC6=737, IC7=736) for patches 0-2, set B (IC5=15179741, IC6=740, IC7=739) for patches 3-7. Same params ROM (15179757) for all.

### Patch Data Structure (per program)

Starting at the base address for the program:

| Offset | Size | Content |
|--------|------|---------|
| 0x0000 | 256 | Velocity table: byte 0 = flags, bytes 1-255 = velocity → wave_param |
| 0x0100 | 21 × N | Note mapping: 21 bytes per note (octave-wrapped 0-98) |
| 0x091F | 70 × M | Envelope table: 70 bytes per env_index |

**Flags byte** (offset 0):
- Bit 2: sample rate. **1 = 20kHz (16 parts), 0 = 32kHz (10 parts)**
- (Counterintuitive: more parts = lower sample rate = more CPU time per sample)

**Note mapping entry** (21 bytes):
```
[env_index(1), pitch_0(2), pitch_1(2), ..., pitch_9(2)]
```
10 pitch values (big-endian 16-bit) for the 10 sound chip parts per note.

**Envelope table entry** (70 bytes = 10 parts × 7 bytes):
```
Per part: [wave_loop(1), wave_high(1), chain_ptr(2), scaling_data(2), field0(1)]
```
- `chain_ptr`: CPU address of the envelope chain. Can point to IC18 (0x4000-0xBFFF), RAM (0x0000-0x3FFF → zeros → silent), or program ROM (0xC000-0xFFFF → code as data).
- `scaling_data[0]` at offset +4 from env_chain base: scaling table index (byte index into env_scaling_ptr_table at ED9D)
- `field0` at byte 6: release speed base, added to the computed release speed during note-off

### Envelope Chain Format

Chains are sequences of 6-byte entries, 4 data + 2 padding:
```
[speed_lo_vel, dest_lo_wp, speed_hi_vel, dest_hi_wp, pad, pad]
```
The chain starts at `chain_ptr + wp_offset` (0 or 2 depending on wave_param bit 7). IRQ handler advances by 6 each time. Chain terminates when interpolated env_speed = 0 or when chain pointer reaches all-zero data.

---

## Sound Chip

Custom Roland chip with 16 voices × 10 active parts per voice (16 memory slots, 10 used).

### Per-Part State
- **Phase accumulator** (24-bit): advances by pitch-dependent increment each sample
- **Envelope** (25-bit): ramps toward `env_dest` at rate `env_speed`. Triggers IRQ when destination reached.
- **Wave ROM addressing**: `(wave_addr_high << 11) | ((sub_phase >> 9) & 0x7FF)`, with loop via `wave_addr_loop`

### Sample Generation
- Exponential sample format: 14-bit mantissa + sign + 9-bit delta + sign
- Decoded from three 128KB ROMs (IC5/IC6/IC7) via complex bit extraction
- Volume = inverted envelope value (env_value=0 → full volume, counter-intuitive)
- Output: sum of all parts across all voices

### Sample Rates
- **20kHz mode** (flags bit 2 = 1): 16 parts per voice, ~100 CPU cycles per sample
- **32kHz mode** (flags bit 2 = 0): 10 parts per voice, ~62 CPU cycles per sample

---

## MKS-20 CPU B Comparison

The MKS-20 Digital Piano Module (1986) shares the same hardware as the RD-200 — identical sound chip, same CPU B (HD63B03RP), same IC18 params ROM format, same wave ROM format. The CPU B ROM is a different firmware revision with a simplified architecture.

### ROM Layout Comparison

| Region | RD200 Address | MKS-20 Address | Notes |
|--------|---------------|----------------|-------|
| Init/main loop | E000-E120 | E000-E11F | Very similar |
| ICF handler | E121-E16D | E120-E163 | Same protocol |
| Cmd dispatch table | E16E-E18D | E164-E183 | Different cmd numbers |
| Program change | E19B | E191 | MKS-20 has IC18 offset table in ROM |
| Pedal handlers | E3F2-E4F9 | *absent* | MKS-20 has no pedal commands |
| Voice alloc | E51B-E655 | (within E30E-E63E) | Restructured |
| Note setup | E79B-EBB6 | E30E-E63E | Same algorithm, compacted |
| IRQ handler | ED1A-ED9C | E78B-E80A | Same algorithm |
| Env scaling ptrs | ED9D | E80B | Same structure, 16 entries |
| Env scale curves | F049-F448 | E843-EC42 | 16 × 64 bytes, minor value diffs |
| F0 config handler | EDBD-EDFE | EC43-EC8C | 5 subcmds (vs 6 for RD200) |
| Program config | E254 | *absent* | MKS-20 has no per-program release tuning |
| IC18 patch table | (in IC18 ROM) | E82B | MKS-20 stores offsets in CPU B ROM |
| Release env table | EF29 | EDAD | **Identical** content |
| Sound chip I/O | (inline) | (inline) | Both write directly to 0x1000 |
| Padding (0xFF) | F449-FFEF | F000-FFED | MKS-20 is more compact |
| Vectors | FFF0-FFFF | FFF0-FFFF | Different handler addresses |

Overall: 54% byte-identical (mostly due to shared padding and identical sound chip I/O patterns).

### Architecture Difference: "Smart CPU A" vs "Smart CPU B"

The fundamental difference is where musical intelligence lives:

| Feature | RD200 | MKS-20 |
|---------|-------|--------|
| Voice allocation | CPU B (round-robin with steal) | CPU A (pre-assigned in command byte) |
| Sustain pedal | CPU B (internal flag, prevents release) | CPU A (withholds note-off commands) |
| Sostenuto pedal | CPU B (internal flag per voice) | CPU A (same approach as sustain) |
| Soft pedal | CPU B (receives value from CPU A) | CPU A only (not sent to CPU B) |
| Voice stealing | CPU B (searches for reclaimable voice) | CPU A (chooses which slot to reuse) |
| Note-off matching | CPU B (searches by note number) | CPU A (targets slot directly by index) |

The MKS-20 CPU B is a **"dumb voice player"** — it just plays slot V when told and releases slot V when told. CPU A does all the decision-making.

### Command Protocol Differences

Both use the same physical protocol: P1 data bus, P2.0 clock (ICF interrupt), P2.4 acknowledge. Bit 7 of first byte determines 1-byte vs 3-byte command. Upper nibble indexes dispatch table.

**RD200 Command Map:**

| Byte | Type | Command |
|------|------|---------|
| 0x0n | 1-byte | Voice reset with param n |
| 0x1n | 1-byte | Voice update tick |
| 0x3n | 1-byte | Program change (n = program 0-7) |
| 0x50/0x5F | 1-byte | Sustain OFF/ON |
| 0x60/0x6F | 1-byte | Sostenuto OFF/ON |
| 0x70/0x7F | 1-byte | Soft pedal OFF/ON |
| 0x80,off,val | 3-byte | Param update (low range) |
| 0xA0,off,val | 3-byte | Param update (high range) |
| 0xB0,note,0 | 3-byte | Note off (CPU B searches by note) |
| 0xC0,note,vel | 3-byte | Note on layer 1 (CPU B allocates voice) |
| 0xD0,note,vel | 3-byte | Note on layer 2 |
| 0xE0,hi,lo | 3-byte | Tuning (14-bit signed) |
| 0xF0,sub,val | 3-byte | Config (6 sub-commands) |

**MKS-20 Command Map:**

| Byte | Type | Command |
|------|------|---------|
| 0x0V | 3-byte | Note off voice slot V (CPU A specifies slot) |
| 0x1V,_,val | 3-byte | Set env_init_value for voice V |
| 0x4n | 1-byte | Program change (n = program 0-7) |
| 0x8V,note,vel | 3-byte | Note on layer 1, voice slot V |
| 0xAV,note,vel | 3-byte | Note on layer 2, voice slot V |
| 0xCV,_,val | 3-byte | Set env_init_value (alias for 0x1V) |
| 0xE0,hi,lo | 3-byte | Tuning (14-bit signed, identical) |
| 0xF0,sub,val | 3-byte | Config (5 sub-commands) |

Key differences:
- **Voice slot in command byte**: MKS-20 embeds the voice slot (0-15) in the lower nibble of note-on/off commands. CPU A pre-assigns voices.
- **No pedal commands**: Sustain/sostenuto/soft are handled entirely by CPU A.
- **No param update**: The 0x80/0xA0 hot-update commands don't exist.
- **New set_env_init (0x10/0xC0)**: Allows CPU A to set the envelope initial value per-voice before note-on. RD200 hardcodes this to 0xFF.

### F0 Config Sub-commands

| Sub | RD200 | MKS-20 | Identical? |
|-----|-------|--------|------------|
| F0,00 | Velocity mode (stores 0x01) | Velocity mode (stores 0xFF) | Functionally same |
| F0,01 | Sample rate muting | Sample rate muting | Yes |
| F0,02 | Alt params table | Alt params table | Yes |
| F0,03 | Global env offset | Global env offset | Yes |
| F0,04 | Bank latch | Bank latch | Yes |
| F0,05 | Release mask override | *absent* | RD200 only |

The `F0,05` command sets `release_mask_override` which works with the `program_config_table` to tune release behavior per-program (e.g., piano programs get `mask=0x03, threshold=0x5A, param=0x06` for damper simulation). The MKS-20 has no such table — all programs share the same release behavior.

### IC18 Patch Table

RD200 reads the patch offset table from IC18 ROM offset 0 (8 entries × 3 bytes: bank, addr_hi, addr_lo).

MKS-20 stores the patch offset table **in the CPU B ROM itself** at E82B:

| Program | Bank | CPU Address | Linear Offset |
|---------|------|-------------|---------------|
| 0 Piano 1 | 0x00 | 0x4000 | 0x000000 |
| 1 Piano 2 | 0x01 | 0x4000 | 0x008000 |
| 2 Piano 3 | 0x02 | 0x4000 | 0x010000 |
| 3 Harpsichord | 0x07 | 0x4000 | 0x038000 |
| 4 Clavi | 0x04 | 0x7C20 | 0x023C20 |
| 5 Vibraphone | 0x05 | 0x6B50 | 0x02AB50 |
| 6 E-Piano 1 | 0x06 | 0x8260 | 0x034260 |
| 7 E-Piano 2 | 0x07 | 0x7EF0 | 0x03BEF0 |

Note: The bank/address encoding is different from the hardcoded offsets used by the JUCE plugin. The MKS-20 CPU B ROM calculates `bank & 0x03` for the actual bank select and adds a `prev_program & 0x04` carry for upper bank selection.

### Voice RAM Layout Comparison

Both ROMs use the same per-part structure for the first 60 bytes ($3C):

| Offset | Size | Field | Both ROMs |
|--------|------|-------|-----------|
| +$00 | 2 | Envelope chain pointer | Yes |
| +$02 | 2 | field0 / release data | Yes |
| +$04 | 2 | Pitch value | Yes |
| (×10 parts, stride 6) | | | |

The extra fields differ:

**RD200** ($3C = 60 bytes per voice):
- No extra fields in voice RAM. Per-voice bookkeeping (flags, wave_param, note) stored in internal RAM arrays at $0020-$006F (indexed by voice number).
- Voice flags at internal RAM offset `$50 + voice_index`.

**MKS-20** ($60 = 96 bytes per voice):
- $3C-$43: wave_param copies, envelope work area, scaling index
- $44-$55: Pitch register shadow copies for all 10 parts (2 bytes each)
- $45: Voice flags/assignment counter (overlaps pitch area)
- $55: Additional state byte

The MKS-20 keeps everything per-voice in one contiguous block in external RAM. The RD200 splits it between internal RAM arrays and external voice RAM. No new data — just a different memory layout. The MKS-20 approach is cleaner (fully self-contained voice state) but uses more external RAM.

### Envelope Scaling Table Differences

Both ROMs have 16 envelope scaling curves (64 bytes each). Tables 0 and 12 are identical. Most others differ by ±1-2 per byte (minor rounding adjustments). Two tables are significantly different:

| Table | RD200 | MKS-20 | Delta |
|-------|-------|--------|-------|
| 0 (linear) | Identical | Identical | 0 |
| 1-9 | Standard curves | Slightly adjusted | ±1-3 per byte, 3-25 bytes differ |
| 10 | S-curve variant | Completely different curve | 63/64 bytes differ, max ±131 |
| 11 | S-curve variant | Completely different curve | 63/64 bytes differ, max ±154 |
| 12 | Inverse S-curve | Identical | 0 |
| 13-15 | Various curves | Minor tweaks | 1-4 bytes differ, ±1 |

Tables 10 and 11 appear to serve a different purpose in the MKS-20 — possibly tailored for the different patch voicing (Harpsichord/Clavi vs the RD200's E-Piano patches that use these indices).

### Disassembly Files

| File | Description |
|------|-------------|
| `RD200_B.info` | f9dasm info file for RD200 CPU B ROM |
| `RD200_B.asm` | Annotated RD200 CPU B disassembly |
| `RD200_B_descrambled.bin` | Descrambled RD200 CPU B ROM |
| `MKS20_B.info` | f9dasm info file for MKS-20 CPU B ROM |
| `MKS20_B.asm` | Annotated MKS-20 CPU B disassembly |
| `MKS20_B_descrambled.bin` | Descrambled MKS-20 CPU B ROM |
| `MK80_B.info` | f9dasm info file for MK-80 CPU B ROM |
| `MK80_B.asm` | Annotated MK-80 CPU B disassembly (6044 lines) |
| `MK80_B_descrambled.bin` | Descrambled MK-80 CPU B ROM |
| `RD200_A.info` | f9dasm info file for RD200 CPU A ROM |
| `RD200_A.asm` | Annotated RD200 CPU A disassembly |

---

## MK-80 CPU B Analysis

The MK-80 Electronic Piano (1987) is the most feature-rich of the three instruments. It shares the same sound chip board but has a 16KB CPU B ROM (double the 8KB of RD-200 and MKS-20), enabling significantly more features.

### ROM Overview

- **Size:** 16KB, mapped at C000-FFFF (vs E000-FFFF for 8KB ROMs)
- **No padding:** The full 16KB is used (RD200/MKS-20 have ~3KB of 0xFF padding)
- **Descrambling:** Same address/data bitswap as the 8KB ROMs, with bit 13 passing through
- **Envelope scaling tables:** All 16 curves are **byte-identical** to the RD-200
- **Release env table:** **Identical** to RD-200 (at D80B instead of EF29)

### Command Map Comparison

| Cmd | MK-80 | RD200 | MKS-20 | Notes |
|-----|-------|-------|--------|-------|
| 0x00 | voice_reset | voice_reset | note_off | MK-80 matches RD200 |
| 0x10 | voice_update_tick | voice_update_tick | set_env_init | MK-80 matches RD200 |
| 0x30 | program_change | program_change | — | MK-80 matches RD200 |
| **0x40** | **program_change_respond** | — | program_change | **NEW**: handshake with CPU A |
| 0x50 | sustain | sustain | — | MK-80 matches RD200 |
| 0x60 | sostenuto | sostenuto | — | MK-80 matches RD200 |
| 0x70 | — | soft_pedal | — | Not implemented |
| 0x80 | param_update | param_update | note_on_L1 | MK-80 matches RD200 |
| **0x90** | **param_subdispatch** | (note_off alias) | — | **NEW**: structured params |
| 0xA0 | param_update_hi | param_update_hi | note_on_L2 | MK-80 matches RD200 |
| 0xB0 | note_off | note_off | — | Same as RD200 |
| 0xC0 | note_on_L1 | note_on_L1 | set_env_init | MK-80 matches RD200 |
| 0xD0 | note_on_L2 | note_on_L2 | — | Same as RD200 |
| 0xE0 | tuning | tuning | tuning | Same across all |
| 0xF0 | config | config | config | Same F0,00-04 sub-commands |

The MK-80 command set is a **superset of the RD-200** with two new commands. It uses the same command numbering as the RD-200 (not the MKS-20's renumbered scheme).

### New Feature: OCF Timer Interrupt (C693)

The MK-80 adds an **output compare flag (OCF) timer interrupt** that the other two ROMs don't use (their OCF vectors point to the reset handler). This runs periodically at ~2.7kHz (timer reload value 0x0A6B) and handles:

1. **Per-voice countdown timers** for auto-release — when a voice's timer reaches zero, it triggers note-off automatically
2. **Auto bend step application** with decay toward zero across all 16 voice allocation slots — enables smooth real-time auto bend that the RD-200 doesn't have
3. **Envelope rate processing** on a divided tick (every 12th OCF trigger) — offloads periodic envelope maintenance from the main loop

This is the most significant architectural addition over the RD-200.

### New Command: 0x40 — Program Change with Handshake (C4C8)

After performing a program change (same logic as 0x30), this command additionally signals CPU A with the sample rate byte via PORT1 and performs a clock handshake. This allows CPU A to know when program loading is complete — the RD-200's program change is fire-and-forget.

### New Command: 0x90 — Parameter Sub-dispatch (C50D)

Routes to 8 sub-commands for extended sound parameters that the RD-200 handles via the simpler 0x80/0xA0 param update commands:

| Sub | Purpose |
|-----|---------|
| 0x90,00 | Stretch tuning mode select |
| 0x90,01 | Tightness (bass envelope scaling) |
| 0x90,02 | Brightness (treble envelope scaling) |
| 0x90,03 | Body (mid envelope scaling) |
| 0x90,04 | Auto bend pitch (14-bit) |
| 0x90,05 | Auto bend velocity sensitivity |
| 0x90,06 | Auto bend time |
| 0x90,07 | Auto bend key follow |

These enable the MK-80's expanded sound shaping capabilities: per-register tonal shaping (brightness, punch, tightness, body), auto bend with configurable decay, and stretch tuning.

### Extra Envelope Scaling Tables

Beyond the standard 16 tables (identical to RD-200), the MK-80 has:

- **5 additional 64-byte scaling curves** (at DCEB-DE53) — used for the tightness/brightness/body per-program envelope shaping controlled by cmd 0x90 sub-commands 01-03
- **3 stretch tuning tables** (at DD8E-DE53) — pitch offsets applied when stretch tuning mode is active
- **Envelope split point table** (at DE54) — defines the note boundary between tightness and brightness envelope regions for per-program tonal shaping

### Architecture: Like RD-200, Not MKS-20

The MK-80 follows the RD-200's "smart CPU B" architecture:
- **Voice allocation** is internal (round-robin with steal, 16 slots)
- **Sustain/sostenuto** handled internally by CPU B
- **Note-off** searches by note number (not slot-addressed like MKS-20)
- **Program config table** was not found — may be absent like MKS-20, or stored differently
- **IC18 reading** likely uses program table at IC18 offset 0 (like RD-200)

### F0 Config Sub-commands

Same 5 sub-commands as MKS-20 (no F0,05 release_mask_override):

| Sub | Purpose | Same as RD200? |
|-----|---------|----------------|
| F0,00 | Velocity mode | Yes (functionally) |
| F0,01 | Sample rate muting | Yes |
| F0,02 | Alt params table | Yes |
| F0,03 | Global env offset | Yes |
| F0,04 | Bank latch | Yes |
