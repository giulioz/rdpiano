/*
 * synth_firmware.h - Native C++ reimplementation of the RD200 CPU B firmware
 *
 * Replaces the HD63B03RP CPU emulation with direct C++ logic.
 * Uses the same SoundChip class for audio generation.
 */

#pragma once
#include <cstdint>
#include <queue>
#include <functional>

class SoundChip;

enum class ParamsRomFormat {
    MKS20,  // No program table; IC18 contains raw patch data at offset 0
    RD200,  // Program table at IC18[0]: 8 × {bank, addr_hi, addr_lo}
};

class SynthFirmware {
public:
    SynthFirmware(SoundChip &chip,
                  const uint8_t *params_rom_descrambled,  // 128KB IC18 (descrambled)
                  ParamsRomFormat format = ParamsRomFormat::MKS20);

    // External API (matches Mcu interface)
    void sendMidiCmd(uint8_t status, uint8_t data1, uint8_t data2);
    int32_t generate_next_sample(bool sampleRate32 = false);
    void reset();

    // Direct command interface (what CPU A sends to CPU B)
    void push_command(uint8_t cmd);
    void push_command(uint8_t cmd, uint8_t data1, uint8_t data2);

    bool current_sample_rate = false;

private:
    SoundChip &m_chip;

    // =============================================
    // IC18 Params ROM
    // =============================================
    const uint8_t *m_params_rom;           // Raw descrambled IC18 (128KB)
    uint8_t m_params_emu[0x20000];         // Banked ROM mapping (accessed via params_read)
    ParamsRomFormat m_rom_format;

    // =============================================
    // Data tables from CPU B program ROM
    // =============================================
    // These are loaded from the ROM in the constructor
    struct ProgramConfig {
        uint8_t voice_mask;
        uint8_t release_threshold;
        uint8_t release_param;
    };
    ProgramConfig m_program_config[8];

    // Per-part envelope scaling curves (16 × 64 bytes)
    uint8_t m_env_scale[16][64];

    // Default envelope chain templates (70 bytes each)
    uint8_t m_env_chain_A[70];   // no next pointer
    uint8_t m_env_chain_B[70];   // chains to release table
    uint8_t m_env_chain_C[70];   // variant

    // Release envelope table
    uint8_t m_release_env[192];

    // Alternative note mapping data (21 bytes each)
    uint8_t m_alt_note_map[2][21];

    // =============================================
    // Current program state
    // =============================================
    uint8_t m_current_program = 0;
    uint8_t m_program_flags = 0;      // bit 2 = sample rate
    uint8_t m_velocity_mode = 0;      // bit 0: velocity on, bit 1: curve variant
    uint8_t m_soft_pedal = 0;         // 0x00 or 0x80
    uint8_t m_sustain_mode = 0;       // 0x00 or 0x20 (M00A0: ORed into note-on flags)
    uint8_t m_env_init_value = 0xFF;
    uint8_t m_global_env_offset = 0;
    uint8_t m_release_mask_override = 0;

    // Params ROM addresses (CPU addresses, used with params_read)
    uint16_t m_base_addr = 0x4000;    // velocity table base (CPU addr)
    uint16_t m_note_map_addr = 0x4100; // note mapping table (base + 0x100)
    uint16_t m_env_map_addr = 0x491F;  // envelope table (base + 0x91F)

    // Bank latch for IC18
    uint8_t m_bank_latch = 0;

    // Sample rate config
    uint8_t m_num_active_parts = 0x10;  // 0x10 for 32kHz, 0x0A for ~20kHz
    uint8_t m_sample_rate_mode = 0;
    uint8_t m_num_parts_limit = 0x10;

    // =============================================
    // Tuning
    // =============================================
    int16_t m_tuning_value = 0;
    int16_t m_tuning_prev = 0;

    // =============================================
    // Voice state
    // =============================================
    static constexpr int MAX_VOICES = 16;
    static constexpr int MAX_PARTS = 16;
    static constexpr int PARTS_PER_NOTE = 10;  // firmware always uses exactly 10 parts per note (unrolled)
    static constexpr int VOICE_RAM_PART_SIZE = 6;
    static constexpr int VOICE_RAM_SIZE = 0x3C;  // per voice

    struct VoicePart {
        uint8_t field0 = 0;
        uint8_t velocity_level = 0;     // +$01: used in envelope interpolation
        uint16_t env_chain_ptr = 0;     // +$02-03: next envelope segment (0 = done)
        uint16_t pitch_with_tuning = 0; // pitch + tuning (for re-tuning)
        uint8_t env_dest = 0;           // +$04: current env dest
        uint8_t env_speed = 0;          // +$05: current env speed
    };

    struct Voice {
        VoicePart parts[MAX_PARTS];
        uint8_t prev_note = 0;         // +$20
        uint8_t env_level = 0;         // +$30
        uint8_t wave_param = 0;        // +$40: from velocity lookup
        uint8_t flags = 0;             // +$50: voice state machine
        uint8_t env_phase = 0xFF;      // +$60: 0xFF = inactive
        uint8_t assignment = 0;        // +$70: parts still sounding (0 = free)

        // Note queue (for voice stealing)
        uint8_t queue_note[4] = {0xFF, 0xFF, 0xFF, 0xFF};   // +$80
        uint8_t queue_param[4] = {0xFF, 0xFF, 0xFF, 0xFF};  // +$84
        uint8_t queue_wavep[4] = {0, 0, 0, 0};              // +$88
    };

    Voice m_voices[MAX_VOICES];
    uint8_t m_num_voices = 0;
    uint8_t m_voice_rr = 0;            // round-robin pointer
    uint8_t m_voice_order[16] = {};   // indirection table: maps position → voice number
    uint8_t m_voice_order_size = 0;   // how many entries are in the free/reuse queue
    uint8_t m_sched_rr[4] = {0};       // scheduler round-robins

    // Voice release config (from program config table)
    uint8_t m_voice_release_mask = 0;
    uint8_t m_release_threshold = 0;
    uint8_t m_release_param = 0;

    // =============================================
    // Command processing
    // =============================================
    std::queue<uint8_t> m_cmd_queue;

    void process_commands();
    void process_command(uint8_t cmd);
    void process_command_3byte(uint8_t cmd, uint8_t data1, uint8_t data2);

    // Command handlers
    void cmd_program_change(uint8_t program);
    void cmd_note_on(uint8_t note, uint8_t velocity, uint8_t layer);
    void cmd_note_off(uint8_t note);
    void cmd_sustain(bool on);
    void cmd_sostenuto(bool on);
    void cmd_soft_pedal(bool on);
    void cmd_tuning(uint8_t hi, uint8_t lo);
    void cmd_voice_reset(uint8_t param);
    void cmd_param_update(uint8_t cmd, uint8_t note, uint8_t param);
    void cmd_f0_config(uint8_t subcmd, uint8_t value);
    void cmd_voice_update_tick();

    // =============================================
    // Voice management
    // =============================================
    int allocate_voice();
    void setup_voice(int voice_idx, uint8_t note, uint8_t velocity, uint8_t layer);
    void release_voice(int voice_idx);
    void kill_voice(int voice_idx);
    void all_voices_off();

    // =============================================
    // Sound chip interface
    // =============================================
    void write_sound_chip(int voice, int part, int field, uint8_t value);
    void write_sound_chip_word(int voice, int part, int field, uint16_t value);

    // =============================================
    // Envelope processing (replaces IRQ handler)
    // =============================================
    void on_envelope_irq(uint8_t voice_id, uint8_t part_id);
    void process_envelope_segment(int voice, int part);
    uint16_t interpolate_envelope(uint16_t chain_addr, uint8_t wp_double, uint8_t vel_level);
    uint8_t lookup_env_scaling(uint8_t scaling_idx, uint8_t wp_quarter);

    // =============================================
    // IC18 params access
    // =============================================
    uint8_t params_read(uint32_t addr) const;

    // Cycle counter for timing
    int m_cycles = 0;
    int m_cycles_per_sample = 100;
};
