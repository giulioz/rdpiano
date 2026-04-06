/*
 * synth_firmware.cpp - RD200 CPU B sound engine (native C++ reimplementation)
 */

#include "synth_firmware.h"
#include "sound_chip.h"
#include <algorithm>

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
    sampleRate32k = !(m_patch->flags & 0x04);

    // Load model-specific tables
    for (int t = 0; t < NUM_ENV_SCALE_TABLES; t++)
        std::copy_n(set.env_scale_tables[t], NUM_ENV_SCALE_ENTRIES, m_env_scale[t]);
    std::copy_n(set.program_config, NUM_PROGRAMS, m_program_config);

    m_voice_release_mask = m_program_config[program].voice_mask;
    m_release_threshold = m_program_config[program].release_threshold;
    m_release_param = m_program_config[program].release_param;

    m_voice_rr = 0;
    for (int i = 0; i < NUM_VOICES; i++) { m_voice_order[i] = i; m_voices[i] = Voice(); }
    m_sustain_mode = 0;
}

// ============================================================================
// Audio generation
// ============================================================================

int32_t SynthFirmware::generateSample() {
    voice_gc();
    return m_chip.update();
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

    const NoteMapping &nm = m_patch->note_map[adj];
    if (nm.env_index >= (int)m_patch->env_table.size()) return;
    const EnvSetup &es = m_patch->env_table[nm.env_index];

    for (int p = 0; p < PARTS_PER_VOICE; p++) {
        const auto &eps = es.parts[p];

        // Flags/env_offset
        m_chip.setFlags(vi, p, 0x00);
        m_chip.setEnvOffset(vi, p, m_env_init_value);

        // Pitch
        uint16_t pit = nm.pitch[p] + m_tuning;
        v.parts[p].pitch = pit;
        m_chip.setPitch(vi, p, pit);

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
        uint16_t s = (uint16_t)rel[rm[p]] + v.parts[p].field0;
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
    m_chip.setEnvelope(vid, pid, (ds >> 8) & 0xFF, ds & 0xFF);
    if (!(ds >> 8)) vp.chain_index = -1;
}
