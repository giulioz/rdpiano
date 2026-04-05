/*
 * export_wav.cpp - Export audio from both EMU and NATIVE to WAV files
 * Supports MKS-20 and RD200 IC18 ROM formats.
 *
 * Usage: ./export_wav <ic5> <ic6> <ic7> <progrom_b> <paramsrom> [rd200]
 */

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cstdarg>
#include <vector>

#include "../../librdpiano/include/sound_chip.h"
#include "../../librdpiano/include/mcu.h"
#include "synth_firmware.h"

// Scale factor: sound chip output can reach ~±80000 with chords.
// Divide by 3 to fit in 16-bit with headroom for peaks.
static constexpr int OUTPUT_SCALE = 3;

static void write_wav(const char *path, const std::vector<int16_t> &samples, int sample_rate) {
    FILE *f = fopen(path, "wb");
    if (!f) { fprintf(stderr, "Can't write %s\n", path); return; }
    uint32_t data_size = samples.size() * 2;
    uint32_t file_size = 36 + data_size;
    fwrite("RIFF", 1, 4, f); fwrite(&file_size, 4, 1, f); fwrite("WAVE", 1, 4, f);
    fwrite("fmt ", 1, 4, f);
    uint32_t fmt_size = 16; uint16_t audio_fmt = 1, channels = 1;
    uint32_t sr = sample_rate, byte_rate = sample_rate * 2;
    uint16_t block_align = 2, bits = 16;
    fwrite(&fmt_size,4,1,f); fwrite(&audio_fmt,2,1,f); fwrite(&channels,2,1,f);
    fwrite(&sr,4,1,f); fwrite(&byte_rate,4,1,f); fwrite(&block_align,2,1,f); fwrite(&bits,2,1,f);
    fwrite("data", 1, 4, f); fwrite(&data_size, 4, 1, f);
    fwrite(samples.data(), 2, samples.size(), f);
    fclose(f);
    printf("  Wrote %s (%zu samples, %.2fs at %dHz)\n", path, samples.size(),
           (double)samples.size() / sample_rate, sample_rate);
}

static uint8_t* load_file(const char *path, size_t expected_size) {
    FILE *f = fopen(path, "rb");
    if (!f) { fprintf(stderr, "Failed to open: %s\n", path); return nullptr; }
    uint8_t *data = (uint8_t*)malloc(expected_size);
    size_t n = fread(data, 1, expected_size, f);
    fclose(f);
    if (n != expected_size) { free(data); return nullptr; }
    return data;
}

template<int W> static unsigned bitswap(unsigned val, ...) {
    va_list ap; va_start(ap, val);
    int bits[W]; for (int i = W-1; i >= 0; i--) bits[i] = va_arg(ap, int);
    va_end(ap);
    unsigned r = 0;
    for (int i = 0; i < W; i++) if (val & (1 << bits[i])) r |= (1 << i);
    return r;
}

static void descramble_cpub(const uint8_t *src, uint8_t *dst, size_t size) {
    for (size_t i = 0; i < size; i++)
        dst[i] = bitswap<8>(src[bitswap<14>(i,13,12,11,8,9,10,7,6,5,4,3,2,1,0)],7,0,6,1,5,2,4,3);
}
static void descramble_params(const uint8_t *src, uint8_t *dst, size_t size) {
    for (size_t i = 0; i < size; i++)
        dst[i] = bitswap<8>(src[bitswap<17>(i,16,15,13,12,14,11,8,9,10,7,6,5,4,3,2,1,0)],7,0,6,1,5,2,4,3);
}

// Build the test MIDI event sequence for a given program
struct Event { int sample; uint8_t s, d1, d2; };
static std::vector<Event> build_sequence(int pgm, int sample_rate) {
    std::vector<Event> ev;
    int t = 0;
    ev.push_back({t, 0xC0, (uint8_t)pgm, 0x00});
    t += sample_rate / 2;

    uint8_t scale[] = {48,50,52,53,55,57,59,60,62,64,65,67,69,71,72};
    for (int i = 0; i < 15; i++) {
        uint8_t vel = 30 + i * 8; if (vel > 127) vel = 127;
        ev.push_back({t, 0x90, scale[i], vel});
        t += sample_rate / 4;
        ev.push_back({t, 0x80, scale[i], 0});
        t += sample_rate / 10;
    }
    t += sample_rate / 2;
    ev.push_back({t,0x90,60,120}); ev.push_back({t,0x90,64,120}); ev.push_back({t,0x90,67,120});
    t += sample_rate;
    ev.push_back({t,0x80,60,0}); ev.push_back({t,0x80,64,0}); ev.push_back({t,0x80,67,0});
    t += sample_rate / 2;
    ev.push_back({t,0x90,36,30}); t += sample_rate;
    ev.push_back({t,0x80,36,0}); t += sample_rate / 2;
    ev.push_back({t,0x90,84,127}); t += sample_rate / 2;
    ev.push_back({t,0x80,84,0}); t += sample_rate / 2;
    for (int i = 0; i < 8; i++) {
        ev.push_back({t, 0x90, 60, (uint8_t)((i%2==0)?100:50)});
        t += sample_rate / 8;
        ev.push_back({t, 0x80, 60, 0});
        t += sample_rate / 20;
    }
    t += sample_rate / 2;
    return ev;
}

static int sequence_length(const std::vector<Event> &ev) {
    int max_t = 0;
    for (auto &e : ev) if (e.sample > max_t) max_t = e.sample;
    return max_t + 10000; // pad
}

int main(int argc, char *argv[]) {
    if (argc < 6) {
        fprintf(stderr, "Usage: %s <ic5> <ic6> <ic7> <progrom_b_raw> <paramsrom_raw> [rd200]\n", argv[0]);
        return 1;
    }
    bool is_rd200 = (argc > 6 && strcmp(argv[6], "rd200") == 0);

    uint8_t *ic5 = load_file(argv[1], 0x20000);
    uint8_t *ic6 = load_file(argv[2], 0x20000);
    uint8_t *ic7 = load_file(argv[3], 0x20000);
    uint8_t *progrom_raw = load_file(argv[4], 0x2000);
    uint8_t *paramsrom_raw = load_file(argv[5], 0x20000);
    if (!ic5||!ic6||!ic7||!progrom_raw||!paramsrom_raw) return 1;

    uint8_t progrom[0x2000], paramsrom[0x20000];
    descramble_cpub(progrom_raw, progrom, 0x2000);
    descramble_params(paramsrom_raw, paramsrom, 0x20000);

    // Determine per-program sample rates and names
    struct ProgramInfo { const char *name; int sample_rate; };
    ProgramInfo programs[8];

    if (is_rd200) {
        const char *rd200_names[] = {"Piano_1","Piano_2","Piano_3","Harpsichord",
                                      "Clavi","Vibraphone","EPiano_1","EPiano_2"};
        for (int pgm = 0; pgm < 8; pgm++) {
            int bank = paramsrom[pgm*3];
            int addr = (paramsrom[pgm*3+1]<<8) | paramsrom[pgm*3+2];
            int phys = bank * 0x8000 + (addr - 0x4000);
            uint8_t flags = (phys < 0x20000) ? paramsrom[phys] : 0;
            programs[pgm].name = rd200_names[pgm];
            // bit2=1 → 16 parts → 20kHz; bit2=0 → 10 parts → 32kHz
            programs[pgm].sample_rate = (flags & 0x04) ? 20000 : 32000;
        }
        printf("RD200 mode: 8 distinct programs\n");
    } else {
        uint8_t flags = paramsrom[0]; // MKS-20: first byte is flags
        int sr = (flags & 0x04) ? 20000 : 32000;
        for (int pgm = 0; pgm < 8; pgm++) {
            programs[pgm].name = "Patch";
            programs[pgm].sample_rate = sr;
        }
        printf("MKS-20 mode: single patch (flags=0x%02X, %dHz)\n", flags, sr);
    }

    auto fmt = is_rd200 ? ParamsRomFormat::RD200 : ParamsRomFormat::MKS20;
    int num_programs = is_rd200 ? 8 : 1; // MKS-20: only export once (all same)

    for (int pgm = 0; pgm < num_programs; pgm++) {
        int sr = programs[pgm].sample_rate;
        bool sr32 = (sr == 32000);
        printf("\n=== Program %d: %s (%dHz) ===\n", pgm, programs[pgm].name, sr);

        auto events = build_sequence(pgm, sr);
        int total = sequence_length(events);

        // EMU
        {
            Mcu emu(ic5, ic6, ic7, progrom_raw, paramsrom_raw);

            if (is_rd200) {
                // RD200: load the correct IC18 bank for this program.
                // Read bank and addr from the descrambled program table.
                int bank = paramsrom[pgm * 3];
                int addr = (paramsrom[pgm * 3 + 1] << 8) | paramsrom[pgm * 3 + 2];
                // from_addr = physical byte offset into IC18
                size_t from_addr = (size_t)bank * 0x8000 + (addr - 0x4000);
                // loadSounds loads that 32KB bank and creates a fake header
                // pointing to the correct offset within it.
                emu.loadSounds(ic5, ic6, ic7, paramsrom_raw, from_addr);
            }

            emu.reset();
            for (int i = 0; i < 2000; i++) emu.generate_next_sample(sr32);

            // For RD200: send program change 0 (the fake header only has entry 0)
            // For MKS-20: send the actual program number (all map to same data anyway)
            auto emu_events = events;
            if (is_rd200) {
                for (auto &e : emu_events)
                    if (e.s == 0xC0) e.d1 = 0; // force program 0
            }

            std::vector<int16_t> samples; samples.reserve(total);
            int ev_idx = 0;
            for (int s = 0; s < total; s++) {
                while (ev_idx < (int)emu_events.size() && emu_events[ev_idx].sample <= s) {
                    emu.sendMidiCmd(emu_events[ev_idx].s, emu_events[ev_idx].d1, emu_events[ev_idx].d2);
                    ev_idx++;
                }
                int32_t raw = emu.generate_next_sample(sr32) / OUTPUT_SCALE;
                samples.push_back((int16_t)raw);
            }
            char fname[256];
            snprintf(fname, sizeof(fname), "emu_%s.wav", programs[pgm].name);
            write_wav(fname, samples, sr);
        }

        // NATIVE
        {
            SoundChip native_chip(ic5, ic6, ic7);
            SynthFirmware native(native_chip, paramsrom, progrom, fmt);

            std::vector<int16_t> samples; samples.reserve(total);
            int ev_idx = 0;
            for (int s = 0; s < total; s++) {
                while (ev_idx < (int)events.size() && events[ev_idx].sample <= s) {
                    native.sendMidiCmd(events[ev_idx].s, events[ev_idx].d1, events[ev_idx].d2);
                    ev_idx++;
                }
                int32_t raw = native.generate_next_sample(sr32) / OUTPUT_SCALE;
                samples.push_back((int16_t)raw);
            }
            char fname[256];
            snprintf(fname, sizeof(fname), "native_%s.wav", programs[pgm].name);
            write_wav(fname, samples, sr);
        }
    }

    printf("\nDone.\n");
    free(ic5); free(ic6); free(ic7); free(progrom_raw); free(paramsrom_raw);
    return 0;
}
