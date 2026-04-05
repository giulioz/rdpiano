/*
 * synth_firmware.cpp - Native C++ reimplementation of the RD200 CPU B firmware
 */

#include "synth_firmware.h"
#include "../../librdpiano/include/sound_chip.h"
#include <cstring>
#include <algorithm>

// ============================================================================
// Construction / Reset
// ============================================================================

SynthFirmware::SynthFirmware(SoundChip &chip,
                             const uint8_t *params_rom_descrambled,
                             const uint8_t *program_rom_descrambled,
                             ParamsRomFormat format)
    : m_chip(chip), m_params_rom(params_rom_descrambled), m_rom_format(format)
{
    const uint8_t *rom = program_rom_descrambled;
    for (int i = 0; i < 8; i++) {
        m_program_config[i].voice_mask = rom[0x0254 + i*3];
        m_program_config[i].release_threshold = rom[0x0254 + i*3 + 1];
        m_program_config[i].release_param = rom[0x0254 + i*3 + 2];
    }
    for (int p = 0; p < 16; p++)
        memcpy(m_env_scale[p], &rom[0x1049 + p*64], 64);
    memcpy(m_cpub_rom, rom, 0x2000);

    if (m_rom_format == ParamsRomFormat::RD200) {
        // RD200: IC18 has a real program table at offset 0.
        // Map all 4 banks directly: IC18 bank N → params_emu slot N
        //   latch=0 → params_emu[0x0000-0x7FFF] = IC18[0x0000-0x7FFF]
        //   latch=1 → params_emu[0x8000-0xFFFF] = IC18[0x8000-0xFFFF]
        //   latch=2 → params_emu[0x10000-0x17FFF] = IC18[0x10000-0x17FFF]
        //   latch=3 → params_emu[0x18000-0x1FFFF] = IC18[0x18000-0x1FFFF]
        // Firmware reads program table from latch=0, addr 0x4000+pgm*3
        memcpy(m_params_emu, params_rom_descrambled, 0x20000);
    } else {
        // MKS-20: IC18 starts with raw patch data (no program table).
        // Copy first 32KB to bank 1 (matching EMU's loadSounds behavior).
        // Create fake program table at bank 0 so all 8 programs play this patch.
        memset(m_params_emu, 0xFF, sizeof(m_params_emu));
        memcpy(&m_params_emu[0x8000], params_rom_descrambled, 0x8000);
        for (int pgm = 0; pgm < 8; pgm++) {
            m_params_emu[pgm * 3 + 0] = 0x01;  // bank 1
            m_params_emu[pgm * 3 + 1] = 0x40;  // addr_hi
            m_params_emu[pgm * 3 + 2] = 0x00;  // addr_lo → 0x4000
        }
    }

    reset();
}

void SynthFirmware::reset()
{
    m_current_program = 0;
    m_velocity_mode = 0;
    m_soft_pedal = 0;
    m_env_init_value = 0xFF;
    m_tuning_value = 0;
    m_tuning_prev = 0;
    m_bank_latch = 0;
    m_num_active_parts = 0x10;
    m_num_voices = 0;
    m_voice_rr = 0;
    m_global_env_offset = 0;
    m_release_mask_override = 0;
    memset(m_sched_rr, 0, sizeof(m_sched_rr));
    while (!m_cmd_queue.empty()) m_cmd_queue.pop();
    for (int i = 0; i < MAX_VOICES; i++)
        m_voices[i] = Voice();
}

// ============================================================================
// IC18 Params Access (matches EMU's read_byte)
// ============================================================================

uint8_t SynthFirmware::params_read(uint32_t cpu_addr) const
{
    // IC18 params ROM: 0x4000-0xBFFF
    if (cpu_addr >= 0x4000 && cpu_addr <= 0xBFFF)
        return m_params_emu[(cpu_addr - 0x4000) | ((m_bank_latch & 3) << 15)];
    // CPU B program ROM: 0xC000-0xFFFF (8KB mirrored, mask 0x1FFF)
    if (cpu_addr >= 0xC000)
        return m_cpub_rom[(cpu_addr - 0xC000) & 0x1FFF];
    // RAM (0x0000-0x3FFF): all zeroed
    return 0x00;
}

// ============================================================================
// Bilinear interpolation (ZEB16)
// chain[0]=speed_lo_vel, chain[1]=dest_lo_wp, chain[2]=speed_hi_vel, chain[3]=dest_hi_wp
// Returns: high byte = env_speed blend, low byte = env_dest blend
// Written to sound chip as [field4=A=speed_blend, field5=B=dest_blend]
// ============================================================================

// Replicate the firmware's scaling table lookup exactly (E92D pattern)
// LDX #env_scaling_ptr_table; ABX; LDX ,X; LDAB wp_quarter; ABX; LDAB ,X
uint8_t SynthFirmware::lookup_env_scaling(uint8_t scaling_idx, uint8_t wp_quarter)
{
    // env_scaling_ptr_table is at ROM offset 0x0D9D (addr ED9D)
    // ABX adds scaling_idx (byte) to table base, reads 2-byte pointer
    uint16_t table_offset = 0x0D9D + scaling_idx;
    if (table_offset + 1 >= 0x2000) return 0xFF;  // past ROM end

    uint16_t ptr = (m_cpub_rom[table_offset] << 8) | m_cpub_rom[table_offset + 1];

    // Read from that pointer + wp_quarter
    // If pointer is in ROM range (E000-FFFF), read from ROM
    if (ptr >= 0xE000 && (ptr + wp_quarter) < 0x10000) {
        uint16_t rom_off = (ptr - 0xE000) + wp_quarter;
        if (rom_off < 0x2000) return m_cpub_rom[rom_off];
    }
    // Otherwise it's unmapped → 0xFF
    return 0xFF;
}

uint16_t SynthFirmware::interpolate_envelope(uint16_t chain_addr, uint8_t wp_double, uint8_t vel_level)
{
    uint8_t c0 = params_read(chain_addr);
    uint8_t c1 = params_read(chain_addr + 1);
    uint8_t c2 = params_read(chain_addr + 2);
    uint8_t c3 = params_read(chain_addr + 3);

    // Wave param blend → env_dest (high byte of first MUL result)
    uint8_t env_dest;
    if (wp_double == 0) {
        env_dest = c1;  // no blend, use low-wp value (ZEB12)
    } else {
        uint16_t blend = (uint16_t)wp_double * c3 + (uint16_t)(256 - wp_double) * c1;
        env_dest = blend >> 8;
    }

    // Velocity blend → env_speed
    uint8_t env_speed;
    if (vel_level == 0) {
        env_speed = c0;  // no blend, use low-vel value (ZEB3B)
    } else {
        uint16_t blend = (uint16_t)vel_level * c2 + (uint16_t)(256 - vel_level) * c0;
        env_speed = blend >> 8;
    }

    // Firmware does STD $04,X: A→field4(env_dest), B→field5(env_speed)
    // ZEB16: A = wp_blend (used for env_dest), pushed then pulled into B
    //        velocity blend result ends in A
    // So return: high byte = vel_blend → field4 = env_dest
    //            low byte = wp_blend → field5 = env_speed
    // Wait - the firmware PUSHES wp_blend, does vel_blend into A, PULB gets wp_blend into B
    // Final: A = vel_blend, B = wp_blend
    // STD: field4(env_dest) = A = vel_blend, field5(env_speed) = B = wp_blend
    // So the VELOCITY blend determines env_dest and WAVE_PARAM blend determines env_speed!
    return (env_speed << 8) | env_dest;  // env_speed=vel_blend→A→field4, env_dest=wp_blend→B→field5
}

// ============================================================================
// External API
// ============================================================================

void SynthFirmware::sendMidiCmd(uint8_t status, uint8_t data1, uint8_t data2)
{
    // CPU A always sends F0,05,01 during normal operation (E27E in CPU A ROM).
    // This sets release_mask_override=1, which forces release_param/threshold to 0.
    // Ensure it's set on first use.
    if (m_release_mask_override == 0) {
        cmd_f0_config(0x05, 0x01);
    }

    uint8_t cmd = status >> 4;
    if (cmd == 0xC) {
        push_command(0x30 | (data1 & 0x07));
    } else if (cmd == 0x8 || (cmd == 0x9 && data2 == 0)) {
        push_command(0xB0, data1, 0x00);
    } else if (cmd == 0x9) {
        push_command(0xC0, data1, data2);
    } else if (cmd == 0xB && data1 == 64) {
        push_command(0x50 | (data2 >= 64 ? 0x0F : 0x00));
    }
}

void SynthFirmware::push_command(uint8_t cmd) { m_cmd_queue.push(cmd); }
void SynthFirmware::push_command(uint8_t cmd, uint8_t d1, uint8_t d2) {
    m_cmd_queue.push(cmd); m_cmd_queue.push(d1); m_cmd_queue.push(d2);
}

int32_t SynthFirmware::generate_next_sample(bool sampleRate32)
{
    process_commands();
    cmd_voice_update_tick();

    if (m_chip.m_irq_triggered) {
        m_chip.m_irq_triggered = false;
        uint8_t irq_id = m_chip.read(0);
        on_envelope_irq(irq_id >> 4, irq_id & 0x0F);
    }

    return m_chip.update();
}

// ============================================================================
// Command Processing
// ============================================================================

void SynthFirmware::process_commands()
{
    while (!m_cmd_queue.empty()) {
        uint8_t cmd = m_cmd_queue.front(); m_cmd_queue.pop();
        if (cmd & 0x80) {
            if (m_cmd_queue.size() < 2) break;
            uint8_t d1 = m_cmd_queue.front(); m_cmd_queue.pop();
            uint8_t d2 = m_cmd_queue.front(); m_cmd_queue.pop();
            process_command_3byte(cmd, d1, d2);
        } else {
            process_command(cmd);
        }
    }
}

void SynthFirmware::process_command(uint8_t cmd) {
    uint8_t hi = (cmd >> 4) & 0x0F, lo = cmd & 0x0F;
    switch (hi) {
        case 0x0: cmd_voice_reset(lo); break;
        case 0x1: cmd_voice_update_tick(); break;
        case 0x3: cmd_program_change(lo); break;
        case 0x5: cmd_sustain(lo != 0); break;
        case 0x6: cmd_sostenuto(lo != 0); break;
        case 0x7: cmd_soft_pedal(lo != 0); break;
        default: break;
    }
}

void SynthFirmware::process_command_3byte(uint8_t cmd, uint8_t d1, uint8_t d2) {
    uint8_t hi = (cmd >> 4) & 0x0F;
    switch (hi) {
        case 0xB: cmd_note_off(d1); break;
        case 0xC: cmd_note_on(d1, d2, 0); break;
        case 0xD: cmd_note_on(d1, d2, 1); break;
        case 0xE: cmd_tuning(d1, d2); break;
        case 0xF: cmd_f0_config(d1, d2); break;
        default: break;
    }
}

// ============================================================================
// Program Change (E19B)
// ============================================================================

void SynthFirmware::cmd_program_change(uint8_t program)
{
    m_velocity_mode = 0;
    all_voices_off();
    m_current_program = program & 0x07;

    m_bank_latch = 0;
    uint16_t table_addr = 0x4000 + m_current_program * 3;
    uint8_t bank = params_read(table_addr);
    uint16_t base_addr = (params_read(table_addr + 1) << 8) | params_read(table_addr + 2);

    m_bank_latch = bank;
    m_base_addr = base_addr;
    m_note_map_addr = base_addr + 0x0100;
    m_env_map_addr = base_addr + 0x091F;

    m_program_flags = params_read(base_addr);

    // bit2=1 → 16 parts, ~20kHz (more CPU time per sample = more parts)
    // bit2=0 → 10 parts, 32kHz (less CPU time per sample = fewer parts)
    if (m_program_flags & 0x04) {
        m_num_active_parts = 0x10;
        m_num_parts_limit = 0x10;
        current_sample_rate = false;  // 20kHz
    } else {
        m_num_active_parts = 0x0A;
        m_num_parts_limit = 0x0A;
        current_sample_rate = true;   // 32kHz
    }

    m_voice_release_mask = m_program_config[m_current_program].voice_mask;
    m_release_threshold = (m_release_mask_override == 0)
        ? m_program_config[m_current_program].release_threshold : 0;
    m_release_param = (m_release_mask_override == 0)
        ? m_program_config[m_current_program].release_param : 0;

    m_num_voices = m_num_active_parts;
    m_voice_rr = 0;
    memset(m_sched_rr, 0, sizeof(m_sched_rr));
    for (int i = 0; i < MAX_VOICES; i++)
        m_voices[i] = Voice();
}

// ============================================================================
// Note On (E5A1 → ZE79B full envelope chain setup)
// ============================================================================

void SynthFirmware::cmd_note_on(uint8_t note, uint8_t velocity, uint8_t layer)
{
    uint8_t wave_param = params_read(m_base_addr + velocity);

    int vi = allocate_voice();
    if (vi < 0) return;

    Voice &v = m_voices[vi];
    v.wave_param = wave_param;
    v.env_level = note;
    int nparts = std::min((int)m_num_active_parts, MAX_PARTS);

    // Derived values (E7C7-E7CE)
    uint8_t wp_double = wave_param << 1;            // ASLB: wave_param * 2 (8-bit truncated)
    uint8_t wp_quarter = wp_double >> 2;            // LSRB;LSRB: wp_double / 4 (NOT wave_param/4!)
    // BPL ZE7C7 at E7C3: branches if wp < 0x80 (positive), skipping INX;INX
    // So wp >= 0x80 → INX;INX → offset = 2; wp < 0x80 → offset = 0
    uint16_t wp_offset = (wave_param & 0x80) ? 2 : 0;  // M00C4
    // BMI at E924: branches if wp >= 0x80 (negative), skipping INX
    // So wp >= 0x80 → no adj; wp < 0x80 → adj = 1
    uint8_t wp_chain_adj = (wave_param & 0x80) ? 0 : 1; // env_chain offset

    // Octave-wrap note (E60F-E621)
    int adj = (int)note - 0x0F;
    while (adj < 0) adj += 12;
    while (adj > 0x62) adj -= 12;

    // IC18 pointers
    uint16_t note_entry_addr = m_note_map_addr + adj * 21;
    uint8_t env_index = params_read(note_entry_addr);
    uint16_t env_entry_addr = m_env_map_addr + env_index * 70;

    // env_chain_ptr base = env_entry_addr + wp_chain_adj
    uint16_t env_chain_base = env_entry_addr + wp_chain_adj;

    // --- Phase 1: Clear flags/env_offset for all parts (E7E1) ---
    for (int p = 0; p < nparts; p++) {
        write_sound_chip(vi, p, 6, 0x00);
        write_sound_chip(vi, p, 7, m_env_init_value);
    }

    // --- Phase 2: Write pitches from IC18 note mapping (E80B) ---
    for (int p = 0; p < nparts; p++) {
        uint8_t ph = params_read(note_entry_addr + 1 + p*2);
        uint8_t pl = params_read(note_entry_addr + 1 + p*2 + 1);
        uint16_t pitch = ((uint16_t)ph << 8) | pl;
        uint16_t pitched = pitch + m_tuning_value;
        // Store in voice RAM for re-tuning
        v.parts[p].pitch_with_tuning = pitched;
        write_sound_chip(vi, p, 0, pitched >> 8);
        write_sound_chip(vi, p, 1, pitched & 0xFF);
    }

    // --- Phase 3: Write wave_loop/wave_high from IC18 envelope table (E88D) ---
    for (int p = 0; p < nparts; p++) {
        uint16_t part_env = env_entry_addr + p * 7;
        uint8_t wl = params_read(part_env);
        uint8_t wh = params_read(part_env + 1);
        if (p == 0) wh += m_global_env_offset;  // only part 0 gets offset
        write_sound_chip(vi, p, 2, wl);
        write_sound_chip(vi, p, 3, wh);
    }

    // --- Phase 3b: Write env_data field to voice RAM (E8DA) ---
    // Reads byte [6] of each 7-byte part in the envelope table
    // Writes to voice_ram parts at offset +0 (field0)
    for (int p = 0; p < nparts; p++) {
        v.parts[p].field0 = params_read(env_entry_addr + p * 7 + 6);
    }

    // --- Phase 4: Envelope chain setup with scaling (E920-EB11) ---
    for (int p = 0; p < nparts; p++) {
        // Read scaling index from env_chain[part*7 + 4]
        uint8_t scaling_idx = params_read(env_chain_base + p * 7 + 4);

        // Look up velocity_level using exact firmware ROM lookup
        uint8_t vel_level = lookup_env_scaling(scaling_idx, wp_quarter);

        v.parts[p].velocity_level = vel_level;

        // Read initial chain pointer from envelope table bytes [2-3] of this part
        uint16_t chain_raw = (params_read(env_entry_addr + p * 7 + 2) << 8)
                           |  params_read(env_entry_addr + p * 7 + 3);

        uint16_t env_dest_speed;
        if (chain_raw == 0) {
            // No chain: write env_dest=0, env_speed=1
            v.parts[p].env_chain_ptr = 0;
            env_dest_speed = 0x0001;  // A=0x00 (speed), B=0x01 (dest)
        } else {
            // Adjust chain pointer by wp_offset
            uint16_t chain_ptr = chain_raw + wp_offset;
            v.parts[p].env_chain_ptr = chain_ptr;
            // Bilinear interpolation
            env_dest_speed = interpolate_envelope(chain_ptr, wp_double, vel_level);
        }

        write_sound_chip(vi, p, 4, (env_dest_speed >> 8) & 0xFF);  // env_speed blend → field 4
        write_sound_chip(vi, p, 5, env_dest_speed & 0xFF);          // env_dest blend → field 5
    }

    // --- Phase 5: Final writes (EB09-EB11) ---
    // Write flags=0xFF, env_offset=env_init_value to last active part (part nparts-1)
    // offset $96 = part 9 fields 6,7 when nparts=10
    {
        int last_part = nparts - 1;
        write_sound_chip(vi, last_part, 6, 0xFF);
        write_sound_chip(vi, last_part, 7, m_env_init_value);
    }

    v.flags = 0x81;
    v.assignment = 0x0A;
}

// ============================================================================
// Note Off (E556)
// ============================================================================

void SynthFirmware::cmd_note_off(uint8_t note)
{
    for (int i = 0; i < m_num_voices; i++) {
        Voice &v = m_voices[i];
        if ((v.flags & 0x80) && v.env_level == note) {
            v.flags &= ~0x80;
            if (!(v.flags & 0x20) && !(v.flags & 0x40))
                release_voice(i);
            return;
        }
    }
}

// ============================================================================
// Pedals & Config
// ============================================================================

void SynthFirmware::cmd_sustain(bool on) {
    if (on) {
        for (int i = 0; i < m_num_voices; i++)
            if (m_voices[i].flags & 0x80) m_voices[i].flags |= 0x20;
    } else {
        for (int i = 0; i < m_num_voices; i++) {
            Voice &v = m_voices[i];
            if (v.flags & 0x20) {
                v.flags &= ~0x20;
                if (!(v.flags & 0x80) && !(v.flags & 0x40)) release_voice(i);
            }
        }
    }
}

void SynthFirmware::cmd_sostenuto(bool on) {
    if (on) {
        for (int i = 0; i < m_num_voices; i++)
            if (m_voices[i].flags & 0x80) m_voices[i].flags |= 0x40;
    } else {
        for (int i = 0; i < m_num_voices; i++) {
            Voice &v = m_voices[i];
            if (v.flags & 0x40) {
                v.flags &= ~0x40;
                if (!(v.flags & 0x80) && !(v.flags & 0x20)) release_voice(i);
            }
        }
    }
}

void SynthFirmware::cmd_soft_pedal(bool on) { m_soft_pedal = on ? 0x80 : 0x00; }

void SynthFirmware::cmd_tuning(uint8_t hi, uint8_t lo) {
    uint16_t raw = ((hi << 8) | lo) << 1;
    raw >>= 1;
    if (hi & 0x20) raw |= 0xC000;
    m_tuning_value = (int16_t)raw;
}

void SynthFirmware::cmd_voice_reset(uint8_t param) { /* TODO */ }
void SynthFirmware::cmd_param_update(uint8_t cmd, uint8_t note, uint8_t param) { /* TODO */ }

void SynthFirmware::cmd_f0_config(uint8_t subcmd, uint8_t value) {
    switch (subcmd) {
        case 0x00: m_velocity_mode = (value == 0) ? 1 : 3; break;
        case 0x03: m_global_env_offset = value; break;
        case 0x04: m_bank_latch = (value == 0) ? 0 : 4; break;
        case 0x05: m_release_mask_override = value; break;
        default: break;
    }
}

void SynthFirmware::cmd_voice_update_tick() {
    if (m_velocity_mode != 0) return;
    for (int i = 0; i < m_num_voices; i++) {
        Voice &v = m_voices[i];
        if ((v.flags & 0x01) && v.assignment == 0) v.flags = 0;
        else if (!(v.flags & 0x01)) v.assignment = 0;
    }
}

// ============================================================================
// Voice Management
// ============================================================================

int SynthFirmware::allocate_voice() {
    int start = m_voice_rr;
    for (int t = 0; t < m_num_voices; t++) {
        int vi = (start + t) % m_num_voices;
        if (m_voices[vi].assignment == 0 && m_voices[vi].flags == 0) {
            m_voice_rr = (vi + 1) % m_num_voices;
            return vi;
        }
    }
    int vi = m_voice_rr;
    m_voice_rr = (vi + 1) % m_num_voices;
    kill_voice(vi);
    return vi;
}

void SynthFirmware::release_voice(int vi) {
    Voice &v = m_voices[vi];
    int nparts = std::min((int)m_num_active_parts, MAX_PARTS);
    uint8_t note_val = v.env_level;

    // Compute 8 release envelope speed values (ZEB3F-EBB5)
    uint8_t rel[8];

    if (note_val > m_release_threshold) {
        // High note: use voice_release_common (EBBF)
        // A = wave_param rotated left 3× then complemented, ANDed with mask
        uint8_t wp = v.wave_param;
        uint8_t a = wp;
        // ROLA×3: rotate left through carry 3 times (effectively: a = (wp << 3) | (wp >> 5))
        // But since ROLA uses carry, and carry starts as 0 from LDAA:
        // Actually the firmware does LDAA $40,X which doesn't set carry, then ROLA×3
        // ROLA shifts A left, bit 7 → carry, carry → bit 0
        // Starting with carry=0 (from LDAA):
        uint16_t r = (uint16_t)a << 1; // first ROLA
        uint8_t c = (r >> 8) & 1; a = (r & 0xFE) | 0; // carry was 0
        a = (a << 1) | c; c = (a >> 7) & 1; a &= 0xFE; a |= ((r >> 8) & 1); // hmm this is getting complicated

        // Simpler: just do what the 6301 does
        // ROLA: {C, A} <<= 1 (9-bit shift left)
        uint16_t ca = (uint16_t)wp; // C=0 initially
        ca = (ca << 1); // ROLA 1: C=bit7, A=A<<1
        ca = ((ca & 0x1FE) | ((ca >> 8) & 1)) & 0x1FF; // nope...

        // Let me just do it with explicit carry tracking
        uint8_t carry = 0;
        a = wp;
        for (int i = 0; i < 3; i++) {
            uint8_t new_carry = (a >> 7) & 1;
            a = (a << 1) | carry;
            carry = new_carry;
        }
        a = ~a;  // COMA
        a &= m_voice_release_mask;  // ANDA

        // voice_release_write_env: TAB, then STD to all slots
        // A = B = same value → all 8 release values are identical
        for (int i = 0; i < 8; i++) rel[i] = a;

    } else {
        int nb = (int)note_val - 0x15;
        if (nb < 0) {
            // Note < 21: all zero speeds (ZEB47 → voice_release_write_env with A=0)
            for (int i = 0; i < 8; i++) rel[i] = 0;
        } else {
            // Compute base speed (EB4E-EB57)
            uint16_t d = (uint16_t)0x76 * (uint8_t)nb;  // 118 * (note-21)
            d <<= 2;  // ASLD×2
            uint8_t a_val = (d >> 8) & 0xFF;
            d = (uint16_t)a_val * m_release_param;  // MUL with release_param
            d <<= 1;  // ASLD
            uint8_t base = (d >> 8) & 0xFF;
            rel[0] = base;  // release_env_lo_0

            if (nb < 0x1B) {
                // Variable increment (EB61-EB8E)
                uint16_t d2 = (uint16_t)0x97 * (uint8_t)nb;
                d2 <<= 3;  // ASLD×3
                uint8_t a2 = (d2 >> 8) & 0xFF;
                d2 = (uint16_t)a2 * 0x6D;
                d2 >>= 6;  // LSRD×6
                // d2 is the increment (16-bit with fraction)
                uint16_t acc = (uint16_t)base << 8; // put base in high byte... no

                // The accumulation: D starts at some value, repeatedly ADDD increment
                // Let me trace it exactly:
                // After STD M00CE (increment stored), then:
                // ADDA rel_lo_0: A = (d2>>8) + base
                // Actually D = d2 here. A = d2 high, B = d2 low.
                uint16_t inc = d2 & 0xFFFF;
                uint16_t acc16 = inc;  // D after STD M00CE
                // ADDA release_env_lo_0: A = (acc16 >> 8) + base
                uint8_t a_acc = ((acc16 >> 8) & 0xFF) + base;
                rel[1] = a_acc;  // release_env_hi_0

                acc16 = ((uint16_t)a_acc << 8) | (acc16 & 0xFF);
                acc16 += inc;
                rel[2] = (acc16 >> 8) & 0xFF;  // release_env_lo_1

                acc16 += inc;
                rel[3] = (acc16 >> 8) & 0xFF;  // release_env_hi_1

                acc16 += inc;
                rel[4] = (acc16 >> 8) & 0xFF;  // release_env_lo_2

                acc16 += inc;
                rel[5] = (acc16 >> 8) & 0xFF;  // release_env_hi_2

                acc16 += inc;
                rel[6] = (acc16 >> 8) & 0xFF;  // release_env_lo_3

                acc16 += inc;
                rel[7] = (acc16 >> 8) & 0xFF;  // release_env_hi_3
            } else {
                // Fixed increment 0x00DB (EB90-EBB5)
                uint16_t acc16 = 0x00DB;
                uint8_t a_acc = ((acc16 >> 8) & 0xFF) + base;  // ADDA base
                rel[1] = a_acc;

                acc16 = ((uint16_t)a_acc << 8) | (acc16 & 0xFF);
                for (int i = 2; i < 8; i++) {
                    acc16 += 0x00DB;
                    rel[i] = (acc16 >> 8) & 0xFF;
                }
            }
        }
    }

    // Now write release to sound chip (EBD0-EC83)
    // First: clear all chain pointers in voice RAM
    for (int p = 0; p < nparts; p++)
        v.parts[p].env_chain_ptr = 0;

    // Mapping: 10 parts use 8 release values with pattern:
    // p0→rel[0], p1→rel[1], p2→rel[2], p3→rel[3],
    // p4→rel[4], p5→rel[5], p6→rel[6], p7→rel[7],
    // p8→rel[0], p9→rel[0]
    static const int rel_map[10] = {0, 1, 2, 3, 4, 5, 6, 7, 0, 0};

    for (int p = 0; p < nparts; p++) {
        uint8_t release_speed = rel[rel_map[p]];
        // Add field0 from voice RAM with saturation
        uint16_t sum = (uint16_t)release_speed + v.parts[p].field0;
        if (sum > 0xFF) sum = 0xFF;
        write_sound_chip(vi, p, 4, 0x00);          // env_dest = 0
        write_sound_chip(vi, p, 5, (uint8_t)sum);  // env_speed
    }

    v.assignment = 0x0A;
}

void SynthFirmware::kill_voice(int vi) {
    Voice &v = m_voices[vi];
    for (int p = 0; p < 16; p++)
        write_sound_chip_word(vi, p, 4, 0x0000);
    v.flags = 0;
    v.assignment = 0;
}

void SynthFirmware::all_voices_off() {
    for (int i = 0; i < MAX_VOICES; i++)
        if (m_voices[i].assignment != 0) kill_voice(i);
}

// ============================================================================
// Sound Chip Interface
// ============================================================================

void SynthFirmware::write_sound_chip(int voice, int part, int field, uint8_t value) {
    m_chip.write((voice << 8) | (part << 4) | field, value);
}
void SynthFirmware::write_sound_chip_word(int voice, int part, int field, uint16_t value) {
    write_sound_chip(voice, part, field, (value >> 8) & 0xFF);
    write_sound_chip(voice, part, field + 1, value & 0xFF);
}

// ============================================================================
// Envelope IRQ (ED1A) - fires when sound chip part finishes envelope segment
// ============================================================================

void SynthFirmware::on_envelope_irq(uint8_t voice_id, uint8_t part_id)
{
    if (voice_id >= MAX_VOICES || part_id >= MAX_PARTS) return;

    Voice &v = m_voices[voice_id];
    VoicePart &vp = v.parts[part_id];

    uint16_t chain_ptr = vp.env_chain_ptr;
    if (chain_ptr == 0) {
        // Chain ended: silence this part, decrement assignment
        write_sound_chip(voice_id, part_id, 4, 0x00);
        write_sound_chip(voice_id, part_id, 5, 0x00);
        if (v.assignment > 0) v.assignment--;
        return;
    }

    // Advance chain by 6 bytes
    uint16_t new_ptr = chain_ptr + 6;
    vp.env_chain_ptr = new_ptr;

    // Read wave_param from voice
    uint8_t wp_double = v.wave_param << 1;
    uint8_t vel_level = vp.velocity_level;

    // Bilinear interpolation from new chain position
    uint16_t env_ds = interpolate_envelope(new_ptr, wp_double, vel_level);
    uint8_t env_speed = (env_ds >> 8) & 0xFF;
    uint8_t env_dest = env_ds & 0xFF;

    write_sound_chip(voice_id, part_id, 4, env_speed);
    write_sound_chip(voice_id, part_id, 5, env_dest);

    // If env_speed == 0, terminate chain (ED89-ED92)
    if (env_speed == 0) {
        vp.env_chain_ptr = 0;
    }
}
