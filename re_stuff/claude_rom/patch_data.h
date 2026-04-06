/*
 * patch_data.h - Parsed IC18 instrument data structures
 *
 * Replaces raw byte-array ROM access with named structs.
 * All data is parsed once during load from the descrambled IC18 ROM.
 */

#pragma once
#include <cstdint>
#include <vector>
#include <cstring>

enum class ParamsRomFormat {
    MKS20,
    RD200,
};

// 4 bytes used for bilinear envelope interpolation
struct EnvChainEntry {
    uint8_t speed_lo_vel;   // c[0]: env_speed at low velocity
    uint8_t dest_lo_wp;     // c[1]: env_dest at low wave_param
    uint8_t speed_hi_vel;   // c[2]: env_speed at high velocity
    uint8_t dest_hi_wp;     // c[3]: env_dest at high wave_param
};

// Per-part data from the 70-byte envelope table (7 bytes per part)
struct EnvPartSetup {
    uint8_t wave_loop;
    uint8_t wave_high;
    uint8_t scaling_idx;        // index into scaling table (from env_chain offset)
    uint8_t scaling_idx_alt;    // alternate scaling idx (shifted by wp_chain_adj)
    uint8_t field0;             // release speed base (byte 6)

    // Envelope chain: sequence of interpolation entries, walked by IRQ handler.
    // Two chains depending on wave_param bit 7 (wp_offset = 0 or 2)
    std::vector<EnvChainEntry> chain;      // for wp_offset = 0
    std::vector<EnvChainEntry> chain_alt;  // for wp_offset = 2
};

// Per-envelope-index entry (10 parts)
struct EnvSetup {
    EnvPartSetup parts[10];
};

// Per-note entry from the note mapping table (21 bytes)
struct NoteMapping {
    uint8_t env_index;
    uint16_t pitch[10];  // 10 pitch values (big-endian in ROM)
};

// Complete parsed patch data
struct PatchData {
    uint8_t flags;                    // bit 2: sample rate flag
    uint8_t velocity_table[256];      // velocity/wave_param → wave parameter index
    std::vector<NoteMapping> note_map; // indexed by adjusted note (0 to ~98)
    std::vector<EnvSetup> env_table;   // indexed by env_index
};

// ============================================================================
// IC18 ROM parser
// ============================================================================

enum class ParamsRomFormat;

struct PatchSet {
    PatchData patches[8];

    // Parse IC18 into patch data
    void load(const uint8_t *ic18_descrambled, ParamsRomFormat format);

private:
    // Read from the banked IC18 ROM
    uint8_t rom_read(const uint8_t *ic18, uint32_t cpu_addr, uint8_t bank) const {
        if (cpu_addr >= 0x4000 && cpu_addr <= 0xBFFF)
            return ic18[(cpu_addr - 0x4000) | ((bank & 3) << 15)];
        return 0x00; // RAM or program ROM → zero
    }

    void parse_patch(const uint8_t *ic18, uint8_t bank, uint16_t base_addr, PatchData &out);
    void parse_chain(const uint8_t *ic18, uint8_t bank, uint16_t chain_ptr,
                     std::vector<EnvChainEntry> &out, int max_entries = 256);
};
