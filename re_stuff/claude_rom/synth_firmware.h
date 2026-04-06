/*
 * synth_firmware.h - Native C++ reimplementation of the RD200 CPU B sound engine
 *
 * Pure synth core: takes a PatchData and responds to note/pedal/tuning events.
 * No ROM loading, no MIDI parsing, no command queue.
 * The caller is responsible for parsing ROMs and dispatching MIDI.
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

    // Load a patch (parsed from IC18). Stops all voices.
    void loadPatch(const PatchData &patch);

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

    // Convenience: dispatch a MIDI message (handles note/pedal, ignores program change)
    void sendMidi(uint8_t status, uint8_t data1, uint8_t data2);

    // true = 32kHz, false = 20kHz. Set by loadPatch based on patch flags.
    bool sampleRate32k = false;

private:
    SoundChip m_chip;
    const PatchData *m_patch = nullptr;

    // ROM tables (loaded once in constructor)
    struct ProgramConfig { uint8_t voice_mask, release_threshold, release_param; };
    ProgramConfig m_program_config[NUM_PROGRAMS];
    uint8_t m_env_scale[NUM_ENV_SCALE_TABLES][NUM_ENV_SCALE_ENTRIES];

    // State
    uint8_t m_soft_pedal = 0;
    uint8_t m_sustain_mode = 0;
    uint8_t m_env_init_value = 0xFF;
    uint8_t m_global_env_offset = 0;
    uint8_t m_voice_release_mask = 0;
    uint8_t m_release_threshold = 0;
    uint8_t m_release_param = 0;
    int16_t m_tuning = 0;

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
        uint8_t wave_param = 0;
        uint8_t flags = 0;        // bit 7=active, 5=sustain, 4=sent, 6=sostenuto, 0=env
        uint8_t assignment = 0;   // parts still sounding
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

    void on_envelope_irq(int voice_id, int part_id);
    uint16_t interpolate(const EnvChainEntry &e, uint8_t wp_double, uint8_t vel_level);
    uint8_t scale_lookup(uint8_t scaling_idx, uint8_t wp_quarter);
};
