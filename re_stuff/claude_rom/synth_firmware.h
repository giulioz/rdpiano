/*
 * synth_firmware.h - Native C++ reimplementation of the RD200/MKS-20/MK-80 sound engine
 *
 * Pure synth core: takes a PatchData and responds to note/pedal/tuning events.
 * Supports MK-80 features: punch, stretch tuning, auto bend, tightness/body/brightness.
 */

#pragma once
#include <cstdint>
#include "patch_data.h"
#include "sound_chip.h"

class SynthFirmware {
public:
    SynthFirmware();

    // Load parsed wave ROM sample data. Can be called multiple times (e.g. MKS-20 ROM set switching).
    void loadSamples(const SampleData &data);

    // Load a patch from a PatchSet. Stops all voices and loads model-specific tables.
    void loadPatch(const PatchSet &set, int program);

    // Generate one audio sample. Call at the rate matching the loaded patch.
    int32_t generateSample();

    // Note events
    void noteOn(uint8_t note, uint8_t velocity);
    void noteOff(uint8_t note);

    // Pedals
    void sustainPedal(bool on);
    void sostenutoPedal(bool on);
    void softPedal(bool on);

    // Tuning offset (signed, 0 = concert pitch)
    void setTuning(int16_t value);

    // MIDI pitch bend (-8192..+8191, 0 = center)
    void setPitchBend(int16_t value);
    void setPitchBendRange(uint8_t semitones);  // default = 2

    // MK-80 tone shaping (works for all formats; full accuracy with MK-80 tables)
    void setPunch(uint8_t value);          // 0-32, softens attack
    void setTightness(uint8_t value);      // scales bass partial envelopes
    void setBody(uint8_t value);           // scales mid partial envelopes
    void setBrightness(uint8_t value);     // scales treble partial envelopes
    void setStretchTuning(uint8_t mode);   // 0=off, 1=curve A, 2+=curve B/C
    // Auto bend: pitch slides from offset to true pitch over time
    // pitch: 0-200 (center=100), time: 1-4 (1=slow, 4=fast), vel_sens: 0-255 (0xFF=full)
    void setAutoBend(uint8_t pitch, uint8_t time, uint8_t vel_sens, bool enable);

    // Convenience: dispatch a MIDI message (handles note/pedal, ignores program change)
    void sendMidi(uint8_t status, uint8_t data1, uint8_t data2);

    // true = 32kHz, false = 20kHz. Set by loadPatch based on patch flags.
    bool sampleRate32k = false;

private:
    SoundChip m_chip;
    const PatchData *m_patch = nullptr;
    const MK80Tables *m_mk80 = nullptr;

    // Model-specific tables (loaded from PatchSet)
    ProgramConfig m_program_config[NUM_PROGRAMS];
    uint8_t m_env_scale[NUM_ENV_SCALE_TABLES][NUM_ENV_SCALE_ENTRIES];

    // State
    uint8_t m_current_program = 0;
    uint8_t m_soft_pedal = 0;
    uint8_t m_sustain_mode = 0;
    uint8_t m_env_init_value = 0xFF;
    uint8_t m_global_env_offset = 0;
    uint8_t m_voice_release_mask = 0;
    uint8_t m_release_threshold = 0;
    uint8_t m_release_param = 0;
    int16_t m_tuning = 0;
    int16_t m_pitch_bend = 0;       // current pitch bend in chip pitch units
    int16_t m_pitch_bend_raw = 0;   // raw MIDI value (-8192..+8191)
    uint8_t m_pitch_bend_range = 2; // bend range in semitones (default ±2)
    uint16_t m_rpn = 0x7F7F;        // current RPN (0x7F7F = none selected)

    // MK-80 tone shaping params
    uint8_t m_punch = 0;
    uint8_t m_tightness = 0;
    uint8_t m_body = 0;
    uint8_t m_brightness = 0;
    uint8_t m_stretch_tuning_mode = 0;

    // Auto bend state
    int16_t m_auto_bend_amount = 0;     // initial pitch offset (from quadratic curve)
    int16_t m_auto_bend_step = 0;       // per-OCF-tick decay step (applied at ~750Hz)
    int16_t m_auto_bend_decay = 0;      // per-entry decay for pre-computed table
    uint8_t m_auto_bend_time = 0;       // 1-4 (decay rate), 0=same as 1
    uint8_t m_auto_bend_vel_sens = 0;   // velocity sensitivity for step scaling
    bool m_auto_bend_enable = false;
    int m_auto_bend_tick_counter = 0;   // counts samples between OCF-rate ticks

    // Voice state
    struct VoicePart {
        uint8_t field0 = 0;
        uint8_t velocity_level = 0;
        int chain_index = -1;
        const std::vector<EnvChainEntry> *chain = nullptr;
        uint16_t pitch = 0;
    };

    struct Voice {
        VoicePart parts[PARTS_PER_VOICE];
        uint8_t note = 0;
        uint8_t adj_note = 0;     // adjusted note (0-98), cached for tone shaping
        uint8_t wave_param = 0;
        uint8_t flags = 0;        // bit 7=active, 5=sustain, 4=sent, 6=sostenuto, 0=env
        uint8_t assignment = 0;   // parts still sounding
        int16_t auto_bend_offset = 0;  // current pitch bend offset (decays to 0)
    };

    Voice m_voices[NUM_VOICES];
    uint8_t m_voice_rr = 0;
    uint8_t m_voice_order[NUM_VOICES] = {};

    // Internal
    int allocate_voice();
    void release_voice(int vi);
    void kill_voice(int vi);
    void all_voices_off();
    void voice_gc();
    void update_auto_bend();

    void on_envelope_irq(int voice_id, int part_id);
    uint16_t interpolate(const EnvChainEntry &e, uint8_t wp_double, uint8_t vel_level);
    uint8_t scale_lookup(uint8_t scaling_idx, uint8_t wp_quarter);
    uint16_t apply_tone_shaping(uint16_t ds, int note, int part);
};
