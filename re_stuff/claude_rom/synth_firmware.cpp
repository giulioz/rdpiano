/*
 * synth_firmware.cpp - RD200/MKS-20/MK-80 sound engine (native C++ reimplementation)
 */

#include "synth_firmware.h"
#include "sound_chip.h"
#include <algorithm>
#include <cstdlib>

// ============================================================================
// Construction
// ============================================================================

SynthFirmware::SynthFirmware() {
    for (int v = 0; v < NUM_VOICES; v++)
        for (int p = 0; p < PARTS_PER_VOICE_MEM; p++)
            m_chip.clearPart(v, p);

    m_voice_rr = 0;
    for (int i = 0; i < NUM_VOICES; i++) m_voice_order[i] = i;

    m_chip.onEnvelopeIRQ = [this](int voice, int part) {
        on_envelope_irq(voice, part);
    };
}

void SynthFirmware::loadSamples(const SampleData &data) {
    m_chip.loadSamples(data);
}

// ============================================================================
// Load patch
// ============================================================================

void SynthFirmware::loadPatch(const PatchSet &set, int program) {
    all_voices_off();
    m_patch = &set.patches[program];
    m_current_program = program;
    sampleRate32k = !(m_patch->flags & 0x04);

    // Load model-specific tables
    for (int t = 0; t < NUM_ENV_SCALE_TABLES; t++)
        std::copy_n(set.env_scale_tables[t], NUM_ENV_SCALE_ENTRIES, m_env_scale[t]);
    std::copy_n(set.program_config, NUM_PROGRAMS, m_program_config);

    m_voice_release_mask = m_program_config[program].voice_mask;
    m_release_threshold = m_program_config[program].release_threshold;
    m_release_param = m_program_config[program].release_param;

    // MK-80 tables (null if not loaded)
    m_mk80 = set.mk80_tables.loaded ? &set.mk80_tables : nullptr;

    m_voice_rr = 0;
    for (int i = 0; i < NUM_VOICES; i++) { m_voice_order[i] = i; m_voices[i] = Voice(); }
    m_sustain_mode = 0;
}

// ============================================================================
// MK-80 parameter setters
// ============================================================================

// ~329 pitch units per semitone (measured from IC18 note mapping)
static constexpr int PITCH_UNITS_PER_SEMITONE = 329;

void SynthFirmware::setPitchBendRange(uint8_t semitones) {
    m_pitch_bend_range = semitones;
    // Recompute from stored raw value
    if (m_pitch_bend_raw != 0) setPitchBend(m_pitch_bend_raw);
}

void SynthFirmware::setPitchBend(int16_t value) {
    m_pitch_bend_raw = value;
    // Scale: MIDI range ±8192 → ±(bend_range * PITCH_UNITS_PER_SEMITONE)
    int32_t max_offset = (int32_t)m_pitch_bend_range * PITCH_UNITS_PER_SEMITONE;
    int16_t old_bend = m_pitch_bend;
    m_pitch_bend = (int16_t)((int32_t)value * max_offset / 8192);
    if (m_pitch_bend == old_bend) return;
    // Update all active voices' pitches in real-time
    for (int i = 0; i < NUM_VOICES; i++) {
        Voice &v = m_voices[i];
        if (!v.flags && !v.assignment) continue;
        for (int p = 0; p < PARTS_PER_VOICE; p++)
            m_chip.setPitch(i, p, v.parts[p].pitch + m_pitch_bend + v.auto_bend_offset);
    }
}

void SynthFirmware::setPunch(uint8_t value) { m_punch = value; }
void SynthFirmware::setTightness(uint8_t value) { m_tightness = value; }
void SynthFirmware::setBody(uint8_t value) { m_body = value; }
void SynthFirmware::setBrightness(uint8_t value) { m_brightness = value; }
void SynthFirmware::setStretchTuning(uint8_t mode) { m_stretch_tuning_mode = mode; }

void SynthFirmware::setAutoBend(uint8_t pitch, uint8_t time, uint8_t vel_sens, bool enable) {
    m_auto_bend_enable = enable;
    m_auto_bend_time = time;
    m_auto_bend_vel_sens = vel_sens;

    // compute_pitch_from_value: quadratic curve with deadzone
    int offset = (int)pitch - 100;
    if (offset >= 0) {
        if (offset < 19) m_auto_bend_amount = 0;
        else {
            int raw = offset * (offset - 18);  // positive quadratic
            m_auto_bend_amount = (int16_t)std::min(raw, 0x2000);
        }
    } else {
        int aoff = -offset;
        if (aoff < 19) m_auto_bend_amount = 0;
        else {
            int raw = -(aoff * (aoff - 18));  // negative quadratic
            m_auto_bend_amount = (int16_t)std::max(raw, -0x2000);
        }
    }

    // compute_auto_bend_decay: decay per table entry
    if (m_auto_bend_amount == 0) {
        m_auto_bend_decay = 0;
        m_auto_bend_step = 0;
    } else {
        // Decay rate: time 1=>>8, 2=>>7, 3=>>6, 4=>>5, 0/default=>>8
        int shift = (time == 2) ? 7 : (time == 3) ? 6 : (time == 4) ? 5 : 8;
        m_auto_bend_decay = m_auto_bend_amount >> shift;  // arithmetic shift
        if (m_auto_bend_decay == 0) m_auto_bend_decay = (m_auto_bend_amount >= 0) ? 1 : -1;

        // auto_bend_step_calc: step from amount scaled by velocity_sens
        // ROM: TAB, ASRB x4 = high byte of amount >> 4
        int8_t step_base = (int8_t)(m_auto_bend_amount >> 8) >> 4;  // signed shift
        if (step_base == 0 && m_auto_bend_amount > 0) step_base = 1;

        if (vel_sens == 0xFF) m_auto_bend_step = m_auto_bend_amount;
        else if (vel_sens == 0xFE) m_auto_bend_step = m_auto_bend_amount >> 1;
        else if (vel_sens == 0xFD) m_auto_bend_step = m_auto_bend_amount >> 2;
        else if (vel_sens == 0xFC) m_auto_bend_step = m_auto_bend_amount >> 3;
        else if (m_auto_bend_amount >= 0) {
            int16_t s = (int16_t)((uint8_t)step_base * vel_sens);
            m_auto_bend_step = s ? s : 1;
        } else {
            int16_t s = (int16_t)((uint8_t)(-step_base) * vel_sens);
            m_auto_bend_step = s ? -s : -1;
        }
    }
}

// ============================================================================
// Audio generation
// ============================================================================

int32_t SynthFirmware::generateSample() {
    voice_gc();
    if (m_auto_bend_enable) update_auto_bend();
    return m_chip.update();
}

// ============================================================================
// Auto bend: decay pitch offset toward zero each sample
// ============================================================================

// OCF timer in the MK-80 runs at ~750Hz (2MHz / 0x0A6B).
// We approximate this by ticking every N samples where N = sample_rate / 750.
static constexpr int OCF_TICK_RATE = 750;

void SynthFirmware::update_auto_bend() {
    // Rate-limit to ~750Hz OCF tick rate
    int tick_interval = (sampleRate32k ? 32000 : 20000) / OCF_TICK_RATE;
    if (++m_auto_bend_tick_counter < tick_interval) return;
    m_auto_bend_tick_counter = 0;

    for (int i = 0; i < NUM_VOICES; i++) {
        Voice &v = m_voices[i];
        if (v.auto_bend_offset == 0) continue;
        if (!v.flags && !v.assignment) continue;

        // Subtract step, clamp at zero crossing
        int16_t old = v.auto_bend_offset;
        v.auto_bend_offset -= m_auto_bend_step;
        // Check for zero crossing
        if ((old > 0 && v.auto_bend_offset <= 0) || (old < 0 && v.auto_bend_offset >= 0))
            v.auto_bend_offset = 0;

        // Update all parts' pitches
        for (int p = 0; p < PARTS_PER_VOICE; p++)
            m_chip.setPitch(i, p, v.parts[p].pitch + m_pitch_bend + v.auto_bend_offset);
    }
}

// ============================================================================
// Tone shaping: modify envelope based on partial range and note
// ============================================================================

uint16_t SynthFirmware::apply_tone_shaping(uint16_t ds, int note, int part) {
    if (m_tightness == 0 && m_body == 0 && m_brightness == 0) return ds;
    if (note < 0 || note >= 99) return ds;

    // Determine amount (signed) and table_val for this partial range
    int8_t amount = 0;
    uint8_t table_val = 0x80;  // neutral

    if (part <= 2) {
        // Bass range: tightness
        amount = (int8_t)m_tightness;
        if (amount == 0) return ds;
        // Special case: programs 0-1, high notes get reduced tightness
        if (m_mk80 && m_current_program < 2 && note >= 0x53) {
            amount = (int8_t)(((int)m_tightness + 8) >> 2);
        }
        if (m_mk80)
            table_val = m_mk80->bass_scale[m_current_program][note][part];
    } else if (part <= 7) {
        // Mid range: body
        amount = (int8_t)m_body;
        if (amount == 0) return ds;
        if (m_mk80)
            table_val = m_mk80->mid_scale[m_current_program][note][part - 3];
    } else {
        // Partials 8-9: check split point
        bool use_brightness = true;
        if (m_mk80) {
            uint8_t sp = m_mk80->split_point[m_current_program][part - 8];
            use_brightness = (note >= sp);
            table_val = m_mk80->mid_scale[m_current_program][note][part - 3];
        }
        if (use_brightness) {
            amount = (int8_t)m_brightness;
        } else {
            amount = (int8_t)m_body;
        }
        if (amount == 0) return ds;
    }

    uint8_t env_speed = (ds >> 8) & 0xFF;
    uint8_t env_dest = ds & 0xFF;

    if (m_mk80) {
        // ROM algorithm (env_apply_velocity at CFAF):
        // Positive amount: use high nibble; negative amount: use low nibble
        int nibble;
        int abs_amount;
        if (amount >= 0) {
            nibble = (int)(table_val >> 4) - 8;   // high nibble - 8 → signed -8..+7
            abs_amount = amount;
        } else {
            nibble = (int)(table_val & 0x0F) - 8; // low nibble - 8 → signed -8..+7
            abs_amount = -amount;
            nibble = -nibble;  // flip sign when amount is negative
        }

        if (nibble >= 0) {
            // Add: env_dest += (abs_amount * nibble) >> 1
            int result = (abs_amount * nibble) >> 1;
            int d = (int)env_dest + result;
            env_dest = (uint8_t)(d > 0xFF ? 0xFF : d);
        } else {
            // Subtract: env_dest -= (abs_amount * (-nibble))
            int result = abs_amount * (-nibble);
            int d = (int)env_dest - result;
            env_dest = (uint8_t)(d < 0 ? 0 : d);
        }
    } else {
        // Simplified for RD200/MKS-20: flat scaling (no per-note tables)
        int adj = (int)amount >> 2;
        int d = (int)env_dest + adj;
        env_dest = (uint8_t)(d > 0xFE ? 0xFE : (d < 0 ? 0 : d));
    }

    return (env_speed << 8) | env_dest;
}

// ============================================================================
// Envelope helpers
// ============================================================================

uint16_t SynthFirmware::interpolate(const EnvChainEntry &e, uint8_t wp2, uint8_t vl) {
    uint8_t d = wp2 ? (uint8_t)(((uint16_t)wp2*e.dest_hi_wp + (uint16_t)(256-wp2)*e.dest_lo_wp) >> 8) : e.dest_lo_wp;
    uint8_t s = vl  ? (uint8_t)(((uint16_t)vl*e.speed_hi_vel + (uint16_t)(256-vl)*e.speed_lo_vel) >> 8) : e.speed_lo_vel;
    return (s << 8) | d;
}

uint8_t SynthFirmware::scale_lookup(uint8_t idx, uint8_t wpq) {
    return (idx <= (NUM_ENV_SCALE_TABLES-1)*2 && !(idx & 1)) ? m_env_scale[idx/2][wpq<NUM_ENV_SCALE_ENTRIES?wpq:NUM_ENV_SCALE_ENTRIES-1] : 0xFF;
}

// ============================================================================
// Note On
// ============================================================================

void SynthFirmware::noteOn(uint8_t note, uint8_t velocity) {
    if (!m_patch || velocity == 0) { noteOff(note); return; }

    uint8_t wp = m_patch->velocity_table[velocity];
    int vi = allocate_voice();
    if (vi < 0) return;

    Voice &v = m_voices[vi];
    if (v.flags || v.assignment) kill_voice(vi);

    v.wave_param = wp;
    v.note = note;

    uint8_t wp2 = wp << 1, wpq = wp2 >> 2;
    bool wp_hi = wp & 0x80;

    int adj = (int)note - 15;
    while (adj < 0) adj += 12;
    while (adj > 98) adj -= 12;
    if (adj >= (int)m_patch->note_map.size()) return;
    v.adj_note = adj;

    const NoteMapping &nm = m_patch->note_map[adj];
    if (nm.env_index >= (int)m_patch->env_table.size()) return;
    const EnvSetup &es = m_patch->env_table[nm.env_index];

    // Stretch tuning: per-note pitch offset
    int16_t stretch = 0;
    if (m_mk80 && m_stretch_tuning_mode > 0) {
        if (m_stretch_tuning_mode == 1)
            stretch = (adj < 99) ? m_mk80->stretch_a[adj] : 0;
        else
            stretch = (adj < 54) ? m_mk80->stretch_b[adj] :
                      (adj - 54 < 45) ? m_mk80->stretch_c[adj - 54] : 0;
    }

    // Auto bend: initial pitch offset
    v.auto_bend_offset = m_auto_bend_enable ? m_auto_bend_amount : 0;

    for (int p = 0; p < PARTS_PER_VOICE; p++) {
        const auto &eps = es.parts[p];

        // Flags/env_offset
        m_chip.setFlags(vi, p, 0x00);
        m_chip.setEnvOffset(vi, p, m_env_init_value);

        // Pitch (with stretch tuning, pitch bend, and auto bend)
        uint16_t pit = nm.pitch[p] + m_tuning + stretch;
        v.parts[p].pitch = pit;
        m_chip.setPitch(vi, p, pit + m_pitch_bend + v.auto_bend_offset);

        // Wave address
        uint8_t wh = eps.wave_high + (p == 0 ? m_global_env_offset : 0);
        m_chip.setWave(vi, p, eps.wave_loop, wh);

        // Release speed base
        v.parts[p].field0 = eps.field0;

        // Envelope chain
        uint8_t si = wp_hi ? eps.scaling_idx : eps.scaling_idx_alt;
        uint8_t vl = scale_lookup(si, wpq);
        v.parts[p].velocity_level = vl;

        const auto *ch = wp_hi ? &eps.chain_alt : &eps.chain;
        v.parts[p].chain = ch;

        if (ch->empty()) {
            v.parts[p].chain_index = -1;
            m_chip.setEnvelope(vi, p, 0x00, 0x01);
        } else {
            v.parts[p].chain_index = 0;
            uint16_t ds = interpolate((*ch)[0], wp2, vl);
            ds = apply_tone_shaping(ds, adj, p);
            m_chip.setEnvelope(vi, p, (ds >> 8) & 0xFF, ds & 0xFF);
        }
    }

    // Phase 5: Final marker
    m_chip.setFlags(vi, PARTS_PER_VOICE - 1, 0xFF);
    m_chip.setEnvOffset(vi, PARTS_PER_VOICE - 1, m_env_init_value);

    v.flags = 0x91 | m_sustain_mode;
    v.assignment = PARTS_PER_VOICE;
}

// ============================================================================
// Note Off
// ============================================================================

void SynthFirmware::noteOff(uint8_t note) {
    for (int i = 0; i < NUM_VOICES; i++) {
        Voice &v = m_voices[i];
        if ((v.flags & 0x80) && v.note == note) {
            v.flags &= ~0x80;
            if (!(v.flags & 0x20) && !(v.flags & 0x40)) release_voice(i);
            return;
        }
    }
}

// ============================================================================
// Pedals & Tuning
// ============================================================================

void SynthFirmware::sustainPedal(bool on) {
    if (on) {
        m_sustain_mode = 0x20;
        for (int i = 0; i < NUM_VOICES; i++) {
            Voice &v = m_voices[i];
            if ((v.flags & 0xC0) == 0xC0 || !(v.flags & 0x10) || !v.assignment) continue;
            v.flags |= 0x20;
        }
    } else {
        m_sustain_mode = 0;
        for (int i = 0; i < NUM_VOICES; i++) {
            Voice &v = m_voices[i];
            if (v.flags & 0xC0) v.flags &= ~0x30;
            else if (v.flags & 0x20) { v.flags &= ~0x30; if (v.assignment) release_voice(i); }
        }
    }
}

void SynthFirmware::sostenutoPedal(bool on) {
    if (on) { for (int i = 0; i < NUM_VOICES; i++) if (m_voices[i].flags & 0x80) m_voices[i].flags |= 0x40; }
    else { for (int i = 0; i < NUM_VOICES; i++) {
        Voice &v = m_voices[i];
        if (v.flags & 0x40) { v.flags &= ~0x40; if (!(v.flags & 0x80) && !(v.flags & 0x20)) release_voice(i); }
    }}
}

void SynthFirmware::softPedal(bool on) { m_soft_pedal = on ? 0x80 : 0; }
void SynthFirmware::setTuning(int16_t value) { m_tuning = value; }

void SynthFirmware::sendMidi(uint8_t status, uint8_t data1, uint8_t data2) {
    uint8_t cmd = status >> 4;
    if (cmd == 0x9 && data2 > 0) noteOn(data1, data2);
    else if (cmd == 0x9 || cmd == 0x8) noteOff(data1);
    else if (cmd == 0xB && data1 == 64) sustainPedal(data2 >= 64);
    else if (cmd == 0xB && data1 == 66) sostenutoPedal(data2 >= 64);
    else if (cmd == 0xB && data1 == 67) softPedal(data2 >= 64);
    else if (cmd == 0xB && data1 == 6 && m_rpn == 0) setPitchBendRange(data2);  // RPN 0 data entry
    else if (cmd == 0xB && data1 == 100) m_rpn = (m_rpn & 0xFF00) | data2;      // RPN LSB
    else if (cmd == 0xB && data1 == 101) m_rpn = (data2 << 8) | (m_rpn & 0xFF); // RPN MSB
    else if (cmd == 0xE) setPitchBend(((int16_t)((data2 << 7) | data1)) - 8192);
}

// ============================================================================
// Voice management
// ============================================================================

int SynthFirmware::allocate_voice() {
    int vi = m_voice_order[m_voice_rr];
    m_voice_rr = (m_voice_rr + 1) % NUM_VOICES;
    return vi;
}

void SynthFirmware::release_voice(int vi) {
    Voice &v = m_voices[vi];
    uint8_t rel[8];
    int nb = (int)v.note - 0x15;
    if (nb < 0) std::fill_n(rel, 8, (uint8_t)0);
    else {
        uint16_t d = (uint16_t)0x76 * (uint8_t)nb; d = (d<<2)&0xFFFF;
        d = (uint16_t)((d>>8)&0xFF) * m_release_param; d = (d<<1)&0xFFFF;
        uint8_t base = (d>>8)&0xFF; rel[0] = base;
        uint16_t inc = (nb < 0x1B)
            ? (uint16_t)(((uint16_t)((((uint16_t)0x97*(uint8_t)nb)<<3)>>8)&0xFF)*0x6D)>>6
            : 0x00DB;
        uint16_t acc = inc;
        rel[1] = ((acc>>8)&0xFF)+base; acc = ((uint16_t)rel[1]<<8)|(acc&0xFF);
        for (int i=2;i<8;i++){acc=(acc+inc)&0xFFFF; rel[i]=(acc>>8)&0xFF;}
    }

    for (int p = 0; p < PARTS_PER_VOICE; p++) v.parts[p].chain_index = -1;
    static const int rm[PARTS_PER_VOICE]={0,1,2,3,4,5,6,7,0,0};
    for (int p = 0; p < PARTS_PER_VOICE; p++) {
        uint16_t s = (uint16_t)rel[rm[p]] + v.parts[p].field0 + m_punch;
        m_chip.setEnvelope(vi, p, 0x00, (uint8_t)(s > 0xFF ? 0xFF : s));
    }
    v.assignment = PARTS_PER_VOICE;
}

void SynthFirmware::kill_voice(int vi) {
    for (int p = 0; p < PARTS_PER_VOICE_MEM; p++) m_chip.clearPart(vi, p);
    m_voices[vi].flags = 0;
    m_voices[vi].assignment = 0;
}

void SynthFirmware::all_voices_off() {
    for (int i = 0; i < NUM_VOICES; i++) kill_voice(i);
}

void SynthFirmware::voice_gc() {
    for (int i = 0; i < NUM_VOICES; i++) {
        Voice &v = m_voices[i];
        if (!v.flags) continue;
        bool done = false;
        if ((v.flags & 1) && !v.assignment) { v.flags = 0; done = true; }
        else if (!(v.flags & 1)) v.assignment = 0;
        if (v.flags && !(v.flags & 0xE0)) {
            bool all = true;
            for (int p = 0; p < PARTS_PER_VOICE; p++) if (v.parts[p].chain_index >= 0) { all = false; break; }
            if (all) { v.flags = 0; v.assignment = 0; done = true; }
        }
        if (done) {
            for (int pos = 0; pos < NUM_VOICES; pos++) if (m_voice_order[pos] == i) {
                uint8_t s = m_voice_order[pos];
                if (pos > m_voice_rr) { for (int k=pos;k>m_voice_rr;k--) m_voice_order[k]=m_voice_order[k-1]; m_voice_order[m_voice_rr]=s; }
                else if (pos < m_voice_rr) { for (int k=pos;k<m_voice_rr-1;k++) m_voice_order[k]=m_voice_order[k+1]; m_voice_order[m_voice_rr-1]=s; if (m_voice_rr>0) m_voice_rr--; }
                break;
            }
        }
    }
}

// ============================================================================
// Envelope IRQ
// ============================================================================

void SynthFirmware::on_envelope_irq(int vid, int pid) {
    if (vid >= NUM_VOICES || pid >= PARTS_PER_VOICE) return;
    Voice &v = m_voices[vid]; VoicePart &vp = v.parts[pid];

    if (vp.chain_index < 0 || !vp.chain) {
        m_chip.silencePart(vid, pid);
        if (v.assignment > 0) v.assignment--;
        return;
    }

    vp.chain_index++;
    if (vp.chain_index >= (int)vp.chain->size()) {
        vp.chain_index = -1;
        m_chip.silencePart(vid, pid);
        if (v.assignment > 0) v.assignment--;
        return;
    }

    uint16_t ds = interpolate((*vp.chain)[vp.chain_index], v.wave_param << 1, vp.velocity_level);
    ds = apply_tone_shaping(ds, v.adj_note, pid);
    m_chip.setEnvelope(vid, pid, (ds >> 8) & 0xFF, ds & 0xFF);
    if (!(ds >> 8)) vp.chain_index = -1;
}
