/*
 * patch_data.cpp - IC18 ROM parser
 */

#include "patch_data.h"

void PatchSet::load(const uint8_t *ic18, ParamsRomFormat format) {
    if (format == ParamsRomFormat::RD200) {
        // RD200: program table at IC18[0], 8 entries of {bank, addr_hi, addr_lo}
        for (int pgm = 0; pgm < NUM_PROGRAMS; pgm++) {
            uint8_t bank = ic18[pgm * 3];
            uint16_t addr = (ic18[pgm * 3 + 1] << 8) | ic18[pgm * 3 + 2];
            parse_patch(ic18, bank, addr, patches[pgm]);
        }
    } else {
        // MKS-20: patches at hardcoded offsets, no program table in ROM
        static const uint32_t offsets[NUM_PROGRAMS] = {
            0x000000, 0x008000, 0x010000, 0x018000,
            0x003C20, 0x00AB50, 0x014260, 0x01BEF0
        };
        // Build a full IC18 mapping (all 4 banks accessible)
        for (int pgm = 0; pgm < NUM_PROGRAMS; pgm++) {
            uint8_t bank = offsets[pgm] / 0x8000;
            uint16_t addr = 0x4000 + (offsets[pgm] % 0x8000);
            parse_patch(ic18, bank, addr, patches[pgm]);
        }
    }
}

void PatchSet::parse_patch(const uint8_t *ic18, uint8_t bank, uint16_t base_addr, PatchData &out) {
    auto rd = [&](uint16_t addr) -> uint8_t { return rom_read(ic18, addr, bank); };

    // Flags
    out.flags = rd(base_addr);

    // Velocity table (256 bytes at base)
    for (int i = 0; i < 256; i++)
        out.velocity_table[i] = rd(base_addr + i);

    // Note mapping table (at base + 0x100, 21 bytes per note)
    // Notes are octave-wrapped to 0-98 range
    uint16_t note_map_addr = base_addr + 0x0100;
    int max_notes = 99;  // adjusted note range 0-98
    out.note_map.resize(max_notes);
    for (int n = 0; n < max_notes; n++) {
        uint16_t entry = note_map_addr + n * 21;
        out.note_map[n].env_index = rd(entry);
        for (int p = 0; p < PARTS_PER_VOICE; p++) {
            uint8_t hi = rd(entry + 1 + p * 2);
            uint8_t lo = rd(entry + 1 + p * 2 + 1);
            out.note_map[n].pitch[p] = (hi << 8) | lo;
        }
    }

    // Envelope table (at base + 0x91F, 70 bytes per entry)
    // Find the max env_index referenced by note_map
    uint8_t max_env = 0;
    for (auto &nm : out.note_map)
        if (nm.env_index > max_env) max_env = nm.env_index;

    uint16_t env_map_addr = base_addr + 0x091F;
    out.env_table.resize(max_env + 1);

    for (int ei = 0; ei <= max_env; ei++) {
        uint16_t env_base = env_map_addr + ei * 70;
        EnvSetup &es = out.env_table[ei];

        for (int p = 0; p < PARTS_PER_VOICE; p++) {
            uint16_t pe = env_base + p * 7;
            EnvPartSetup &eps = es.parts[p];

            eps.wave_loop = rd(pe);
            eps.wave_high = rd(pe + 1);
            eps.field0 = rd(pe + 6);

            // Scaling index: byte 4 from env_chain (no wp_chain_adj)
            eps.scaling_idx = rd(pe + 4);
            // Alternate: byte 4 with +1 offset (wp_chain_adj=1)
            eps.scaling_idx_alt = rd(pe + 5);

            // Chain pointer: bytes 2-3 of this part
            uint16_t chain_raw = (rd(pe + 2) << 8) | rd(pe + 3);

            // Parse both chain variants (wp_offset=0 and wp_offset=2)
            if (chain_raw != 0) {
                parse_chain(ic18, bank, chain_raw, eps.chain);
                if (chain_raw + 2 != chain_raw) // always true
                    parse_chain(ic18, bank, chain_raw + 2, eps.chain_alt);
            }
        }
    }
}

void PatchSet::parse_chain(const uint8_t *ic18, uint8_t bank, uint16_t chain_ptr,
                           std::vector<EnvChainEntry> &out, int max_entries) {
    out.clear();

    // The initial entry is at chain_ptr. After that, IRQ advances by 6 each time.
    // Chain terminates when interpolated env_speed = 0, but we can't know that
    // without knowing wave_param and vel_level at runtime.
    // Instead, read entries until we hit all-zeros or reach a reasonable limit.

    uint16_t addr = chain_ptr;
    for (int i = 0; i < max_entries; i++) {
        uint8_t c0 = rom_read(ic18, addr, bank);
        uint8_t c1 = rom_read(ic18, addr + 1, bank);
        uint8_t c2 = rom_read(ic18, addr + 2, bank);
        uint8_t c3 = rom_read(ic18, addr + 3, bank);

        out.push_back({c0, c1, c2, c3});

        // Stop if this entry is all-zero (will always produce env_speed=0 → terminate)
        if (c0 == 0 && c1 == 0 && c2 == 0 && c3 == 0)
            break;

        addr += 6;  // next entry (6 bytes apart, 4 data + 2 padding)
    }
}
