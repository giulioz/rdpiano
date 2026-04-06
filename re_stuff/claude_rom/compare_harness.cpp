/*
 * compare_harness.cpp - Compare emulated MCU vs native firmware
 *
 * Captures exact SoundChip::write() sequences from both implementations
 * during identical MIDI input, then diffs them.
 *
 * Usage: ./compare_harness <ic5> <ic6> <ic7> <progrom_b> <paramsrom>
 */

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <vector>
#include <cstdarg>

#include "../../librdpiano/include/sound_chip.h"
#include "../../librdpiano/include/mcu.h"
#include "synth_firmware.h"

// ============================================================================
// ROM Loading / Descrambling
// ============================================================================

static uint8_t* load_file(const char *path, size_t expected_size) {
    FILE *f = fopen(path, "rb");
    if (!f) { fprintf(stderr, "Failed to open: %s\n", path); return nullptr; }
    uint8_t *data = (uint8_t*)malloc(expected_size);
    size_t n = fread(data, 1, expected_size, f);
    fclose(f);
    if (n != expected_size) {
        fprintf(stderr, "Wrong size for %s: got %zu expected %zu\n", path, n, expected_size);
        free(data); return nullptr;
    }
    return data;
}

template<int W>
static unsigned bitswap(unsigned val, ...) {
    va_list ap; va_start(ap, val);
    int bits[W];
    for (int i = W-1; i >= 0; i--) bits[i] = va_arg(ap, int);
    va_end(ap);
    unsigned result = 0;
    for (int i = 0; i < W; i++)
        if (val & (1 << bits[i])) result |= (1 << i);
    return result;
}

static void descramble_cpub(const uint8_t *src, uint8_t *dst, size_t size) {
    for (size_t i = 0; i < size; i++) {
        size_t addr = bitswap<14>(i, 13,12,11,8,9,10,7,6,5,4,3,2,1,0);
        dst[i] = bitswap<8>(src[addr], 7,0,6,1,5,2,4,3);
    }
}

static void descramble_params(const uint8_t *src, uint8_t *dst, size_t size) {
    for (size_t i = 0; i < size; i++) {
        size_t addr = bitswap<17>(i, 16,15,13,12,14,11,8,9,10,7,6,5,4,3,2,1,0);
        dst[i] = bitswap<8>(src[addr], 7,0,6,1,5,2,4,3);
    }
}

// ============================================================================
// Write Log Formatting
// ============================================================================

static const char* field_name(int field) {
    static const char* names[] = {
        "pitch_hi", "pitch_lo", "wave_loop", "wave_high",
        "env_dest", "env_speed", "flags", "env_offset"
    };
    return (field >= 0 && field < 8) ? names[field] : "???";
}

static void print_write(const SoundChipWrite &w, const char *prefix) {
    int voice = w.offset >> 8;
    int part = (w.offset >> 4) & 0xF;
    int field = w.offset & 0x7;
    printf("  %s v%02d.p%02d.%-9s = 0x%02X\n", prefix, voice, part, field_name(field), w.value);
}

static void dump_writes(const std::vector<SoundChipWrite> &log, const char *label) {
    printf("--- %s: %zu writes ---\n", label, log.size());
    for (size_t i = 0; i < log.size() && i < 200; i++) {
        print_write(log[i], label);
    }
    if (log.size() > 200) printf("  ... (%zu more)\n", log.size() - 200);
}

// Filter writes to only a specific voice
static std::vector<SoundChipWrite> filter_voice(const std::vector<SoundChipWrite> &log, int voice) {
    std::vector<SoundChipWrite> out;
    for (auto &w : log) {
        if ((int)(w.offset >> 8) == voice) out.push_back(w);
    }
    return out;
}

// Compare two write logs and report differences
static int compare_logs(const std::vector<SoundChipWrite> &emu_log,
                        const std::vector<SoundChipWrite> &native_log,
                        const char *phase_name) {
    int diffs = 0;
    size_t max_len = std::max(emu_log.size(), native_log.size());
    size_t min_len = std::min(emu_log.size(), native_log.size());

    printf("\n=== %s: EMU %zu writes vs NATIVE %zu writes ===\n",
           phase_name, emu_log.size(), native_log.size());

    for (size_t i = 0; i < min_len; i++) {
        auto &e = emu_log[i];
        auto &n = native_log[i];
        if (e.offset != n.offset || e.value != n.value) {
            if (diffs < 50) {
                int ev = e.offset >> 8, ep = (e.offset >> 4)&0xF, ef = e.offset & 7;
                int nv = n.offset >> 8, np = (n.offset >> 4)&0xF, nf = n.offset & 7;
                printf("  [%3zu] EMU: v%02d.p%02d.%-9s=0x%02X  NATIVE: v%02d.p%02d.%-9s=0x%02X\n",
                       i, ev, ep, field_name(ef), e.value,
                       nv, np, field_name(nf), n.value);
            }
            diffs++;
        }
    }

    if (emu_log.size() != native_log.size()) {
        printf("  Length difference: EMU has %zu, NATIVE has %zu (diff=%zd)\n",
               emu_log.size(), native_log.size(),
               (ssize_t)emu_log.size() - (ssize_t)native_log.size());
        // Show extra writes from the longer log
        const auto &longer = (emu_log.size() > native_log.size()) ? emu_log : native_log;
        const char *longer_name = (emu_log.size() > native_log.size()) ? "EMU" : "NATIVE";
        for (size_t i = min_len; i < std::min(max_len, min_len + 20); i++) {
            print_write(longer[i], longer_name);
            diffs++;
        }
    }

    if (diffs == 0) {
        printf("  PERFECT MATCH!\n");
    } else {
        printf("  Total differences: %d\n", diffs);
    }

    return diffs;
}

// ============================================================================
// Main
// ============================================================================

int main(int argc, char *argv[]) {
    if (argc < 6) {
        fprintf(stderr, "Usage: %s <ic5> <ic6> <ic7> <progrom_b_raw> <paramsrom_raw>\n", argv[0]);
        return 1;
    }

    uint8_t *ic5 = load_file(argv[1], 0x20000);
    uint8_t *ic6 = load_file(argv[2], 0x20000);
    uint8_t *ic7 = load_file(argv[3], 0x20000);
    uint8_t *progrom_raw = load_file(argv[4], 0x2000);
    uint8_t *paramsrom_raw = load_file(argv[5], 0x20000);
    if (!ic5 || !ic6 || !ic7 || !progrom_raw || !paramsrom_raw) return 1;

    // Descramble for native firmware
    uint8_t progrom[0x2000], paramsrom[0x20000];
    descramble_cpub(progrom_raw, progrom, 0x2000);
    descramble_params(paramsrom_raw, paramsrom, 0x20000);

    printf("ROMs loaded and descrambled.\n\n");

    bool is_rd200 = (argc > 6 && strcmp(argv[6], "rd200") == 0);
    auto fmt = is_rd200 ? ParamsRomFormat::RD200 : ParamsRomFormat::MKS20;

    // ---- Create both implementations ----
    Mcu emu(ic5, ic6, ic7, progrom_raw, paramsrom_raw);
    SoundChip &emu_chip = emu.getSoundChip();

    if (is_rd200) {
        // Load bank 0 for program 0 (RD200 Piano 1)
        int bank = paramsrom[0];
        int addr = (paramsrom[1] << 8) | paramsrom[2];
        size_t from_addr = (size_t)bank * 0x8000 + (addr - 0x4000);
        emu.loadSounds(ic5, ic6, ic7, paramsrom_raw, from_addr);
    }

    SoundChip native_chip(ic5, ic6, ic7);
    SynthFirmware native(native_chip, paramsrom, fmt);

    printf("Booting EMU...\n");
    emu.reset();
    bool sr32 = is_rd200 ? false : false; // Piano 1 is 20kHz (bit2=1→20kHz)
    for (int i = 0; i < 2000; i++)
        emu.generate_next_sample(sr32);
    printf("EMU boot complete.\n\n");

    // ======================================================================
    // TEST 1: Program Change
    // ======================================================================
    {
        printf("========================================\n");
        printf("TEST 1: Program Change to Piano 1 (pgm 0)\n");
        printf("========================================\n");

        emu_chip.log_writes = true;
        emu_chip.write_log.clear();
        native_chip.log_writes = true;
        native_chip.write_log.clear();

        emu.sendMidiCmd(0xC0, 0x00, 0x00);
        native.sendMidiCmd(0xC0, 0x00, 0x00);

        // Run enough samples for the command to be processed
        for (int i = 0; i < 500; i++) {
            emu.generate_next_sample(false);
            native.generate_next_sample(false);
        }

        emu_chip.log_writes = false;
        native_chip.log_writes = false;

        compare_logs(emu_chip.write_log, native_chip.write_log, "Program Change");
    }

    // ======================================================================
    // TEST 2: Note On (middle C, velocity 100)
    // ======================================================================
    {
        printf("\n========================================\n");
        printf("TEST 2: Note On - C4 (60) vel=100\n");
        printf("========================================\n");

        emu_chip.log_writes = true;
        emu_chip.write_log.clear();
        native_chip.log_writes = true;
        native_chip.write_log.clear();

        emu.sendMidiCmd(0x90, 60, 100);
        native.sendMidiCmd(0x90, 60, 100);

        // Run enough samples for note-on + first envelope IRQs
        for (int i = 0; i < 2000; i++) {
            emu.generate_next_sample(false);
            native.generate_next_sample(false);
        }

        emu_chip.log_writes = false;
        native_chip.log_writes = false;

        printf("\n--- EMU writes (first voice): ---\n");
        auto emu_v0 = filter_voice(emu_chip.write_log, 0);
        for (size_t i = 0; i < std::min(emu_v0.size(), (size_t)60); i++) {
            print_write(emu_v0[i], "EMU");
        }
        if (emu_v0.size() > 60) printf("  ... (%zu more)\n", emu_v0.size() - 60);

        printf("\n--- NATIVE writes (first voice): ---\n");
        auto native_v0 = filter_voice(native_chip.write_log, 0);
        for (size_t i = 0; i < std::min(native_v0.size(), (size_t)60); i++) {
            print_write(native_v0[i], "NAT");
        }
        if (native_v0.size() > 60) printf("  ... (%zu more)\n", native_v0.size() - 60);

        // Find which voice the EMU actually used
        printf("\n--- EMU write distribution by voice: ---\n");
        int voice_counts[16] = {};
        for (auto &w : emu_chip.write_log) {
            voice_counts[w.offset >> 8]++;
        }
        for (int v = 0; v < 16; v++) {
            if (voice_counts[v] > 0) {
                printf("  voice %d: %d writes\n", v, voice_counts[v]);
            }
        }

        printf("\n--- NATIVE write distribution by voice: ---\n");
        memset(voice_counts, 0, sizeof(voice_counts));
        for (auto &w : native_chip.write_log) {
            voice_counts[w.offset >> 8]++;
        }
        for (int v = 0; v < 16; v++) {
            if (voice_counts[v] > 0) {
                printf("  voice %d: %d writes\n", v, voice_counts[v]);
            }
        }

        // Full comparison
        compare_logs(emu_chip.write_log, native_chip.write_log, "Note On");
    }

    // ======================================================================
    // TEST 3: Note Off
    // ======================================================================
    {
        printf("\n========================================\n");
        printf("TEST 3: Note Off - C4 (60)\n");
        printf("========================================\n");

        emu_chip.log_writes = true;
        emu_chip.write_log.clear();
        native_chip.log_writes = true;
        native_chip.write_log.clear();

        emu.sendMidiCmd(0x80, 60, 0);
        native.sendMidiCmd(0x80, 60, 0);

        for (int i = 0; i < 2000; i++) {
            emu.generate_next_sample(false);
            native.generate_next_sample(false);
        }

        emu_chip.log_writes = false;
        native_chip.log_writes = false;

        compare_logs(emu_chip.write_log, native_chip.write_log, "Note Off");
    }

    // ======================================================================
    // TEST 4: Audio output comparison - play a note and compare samples
    // ======================================================================
    {
        printf("\n========================================\n");
        printf("TEST 4: Audio output comparison\n");
        printf("========================================\n");

        // Reset both (fresh state)
        // Can't easily reset EMU, so just play another note

        emu_chip.log_writes = false;
        native_chip.log_writes = false;

        emu.sendMidiCmd(0xC0, 0x00, 0x00);  // program change
        native.sendMidiCmd(0xC0, 0x00, 0x00);
        for (int i = 0; i < 500; i++) {
            emu.generate_next_sample(false);
            native.generate_next_sample(false);
        }

        emu.sendMidiCmd(0x90, 48, 80);  // C3 note on
        native.sendMidiCmd(0x90, 48, 80);

        int64_t total_diff = 0;
        int max_diff = 0;
        int nonzero_emu = 0, nonzero_native = 0;
        for (int s = 0; s < 10000; s++) {
            int32_t e = emu.generate_next_sample(false);
            int32_t n = native.generate_next_sample(false);
            int diff = abs(e - n);
            total_diff += diff;
            if (diff > max_diff) max_diff = diff;
            if (e != 0) nonzero_emu++;
            if (n != 0) nonzero_native++;
            if (s < 20 || (s % 2000 == 0))
                printf("  [%5d] emu=%7d native=%7d diff=%d\n", s, e, n, diff);
        }
        printf("\n  Summary: avg_diff=%.1f max_diff=%d\n", (double)total_diff/10000, max_diff);
        printf("  EMU non-zero samples: %d, NATIVE non-zero: %d\n", nonzero_emu, nonzero_native);
    }

    // ======================================================================
    // TEST 4: Voice stealing stress test (isolated)
    // ======================================================================
    {
        printf("\n========================================\n");
        printf("TEST 4: Voice stealing - 20 overlapping notes\n");
        printf("========================================\n");

        // Fresh program change to reset state
        emu.sendMidiCmd(0xC0, 0x00, 0x00);
        native.sendMidiCmd(0xC0, 0x00, 0x00);
        for (int i = 0; i < 1000; i++) {
            emu.generate_next_sample(sr32);
            native.generate_next_sample(sr32);
        }

        emu_chip.log_writes = true; emu_chip.write_log.clear();
        native_chip.log_writes = true; native_chip.write_log.clear();

        // Play 20 notes 50ms apart (heavy overlap, forces voice stealing)
        int sr = sr32 ? 32000 : 20000;
        int notes_played = 0;
        for (int s = 0; s < sr * 3; s++) {  // 3 seconds
            // Send notes every 50ms
            if (s % (sr / 20) == 0 && notes_played < 20) {
                uint8_t note = 36 + notes_played * 3;
                if (note > 96) note = 96;
                emu.sendMidiCmd(0x90, note, 100);
                native.sendMidiCmd(0x90, note, 100);
                notes_played++;
            }
            emu.generate_next_sample(sr32);
            native.generate_next_sample(sr32);
        }

        emu_chip.log_writes = false;
        native_chip.log_writes = false;

        // Count writes per voice
        printf("\nEMU writes by voice:\n");
        int emu_vcounts[16] = {};
        for (auto &w : emu_chip.write_log) emu_vcounts[w.offset >> 8]++;
        for (int v = 0; v < 16; v++)
            if (emu_vcounts[v]) printf("  v%02d: %d writes\n", v, emu_vcounts[v]);

        printf("\nNATIVE writes by voice:\n");
        int nat_vcounts[16] = {};
        for (auto &w : native_chip.write_log) nat_vcounts[w.offset >> 8]++;
        for (int v = 0; v < 16; v++)
            if (nat_vcounts[v]) printf("  v%02d: %d writes\n", v, nat_vcounts[v]);

        printf("\nEMU total: %zu writes, NATIVE total: %zu writes\n",
               emu_chip.write_log.size(), native_chip.write_log.size());

        // Count how many unique voices were used for note-on (pitch writes)
        // A note-on writes pitch_hi (field 0) - count unique voices that got pitch writes
        int emu_noteons = 0, nat_noteons = 0;
        bool emu_v_used[16] = {}, nat_v_used[16] = {};
        for (auto &w : emu_chip.write_log) {
            if ((w.offset & 0xF) == 0) emu_v_used[w.offset >> 8] = true;
        }
        for (auto &w : native_chip.write_log) {
            if ((w.offset & 0xF) == 0) nat_v_used[w.offset >> 8] = true;
        }
        for (int v = 0; v < 16; v++) {
            if (emu_v_used[v]) emu_noteons++;
            if (nat_v_used[v]) nat_noteons++;
        }
        printf("\nVoices used: EMU=%d NATIVE=%d\n", emu_noteons, nat_noteons);

        // Show first 20 pitch writes from each to see allocation order
        printf("\nEMU note-on allocation order (first pitch_hi writes):\n");
        int count = 0;
        for (auto &w : emu_chip.write_log) {
            int field = w.offset & 0xF;
            int voice = w.offset >> 8;
            int part = (w.offset >> 4) & 0xF;
            if (field == 0 && part == 0 && count < 20) {
                printf("  [%d] voice %d pitch_hi=0x%02X\n", count++, voice, w.value);
            }
        }
        printf("\nNATIVE note-on allocation order (first pitch_hi writes):\n");
        count = 0;
        for (auto &w : native_chip.write_log) {
            int field = w.offset & 0xF;
            int voice = w.offset >> 8;
            int part = (w.offset >> 4) & 0xF;
            if (field == 0 && part == 0 && count < 20) {
                printf("  [%d] voice %d pitch_hi=0x%02X\n", count++, voice, w.value);
            }
        }
    }

    // ======================================================================
    // TEST 5: Audio level comparison
    // ======================================================================
    {
        printf("\n========================================\n");
        printf("TEST 4: Audio output comparison\n");
        printf("========================================\n");

        emu_chip.log_writes = false;
        native_chip.log_writes = false;

        emu.sendMidiCmd(0xC0, 0x00, 0x00);
        native.sendMidiCmd(0xC0, 0x00, 0x00);
        for (int i = 0; i < 500; i++) {
            emu.generate_next_sample(false);
            native.generate_next_sample(false);
        }

        emu.sendMidiCmd(0x90, 60, 100);
        native.sendMidiCmd(0x90, 60, 100);

        int32_t emu_peak = 0, nat_peak = 0;
        for (int s = 0; s < 5000; s++) {
            int32_t e = emu.generate_next_sample(false);
            int32_t n = native.generate_next_sample(false);
            if (abs(e) > emu_peak) emu_peak = abs(e);
            if (abs(n) > nat_peak) nat_peak = abs(n);
        }
        printf("  EMU peak: %d, NATIVE peak: %d, ratio: %.2f\n",
               emu_peak, nat_peak, (double)nat_peak / emu_peak);
    }

    printf("\n========================================\n");
    printf("Comparison complete.\n");

    free(ic5); free(ic6); free(ic7); free(progrom_raw); free(paramsrom_raw);
    return 0;
}
