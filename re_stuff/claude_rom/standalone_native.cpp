/*
 * standalone_native.cpp - Standalone test app for the native firmware
 *
 * Receives MIDI via PortMidi virtual input "RdPiano Native"
 * Plays audio via SDL2 at the correct sample rate
 *
 * Usage: ./standalone_native <ic5> <ic6> <ic7> <paramsrom> [rd200|mks20] [ic5b ic6b ic7b]
 *
 * Examples:
 *   ./standalone_native RD200_IC5.bin RD200_IC6.bin RD200_IC7.bin RD200_IC18.bin rd200
 *   ./standalone_native mks20_738.BIN mks20_737.BIN mks20_736.BIN mks20_757.BIN mks20 mks20_741.BIN mks20_740.BIN mks20_739.BIN
 */

#include <cstdio>
#include <cstring>
#include <atomic>
#include <memory>
#include <vector>

#define SDL_MAIN_HANDLED
#include "SDL.h"
#include <portmidi.h>

#include "synth_firmware.h"
#include "bitswap.h"

// ============================================================================
// Globals
// ============================================================================

static std::unique_ptr<SynthFirmware> firmware;
static PatchSet patch_set;
static SDL_AudioDeviceID sdl_audio;
static SDL_SpinLock fw_lock;
static std::atomic<bool> quit_requested{false};
static constexpr int OUTPUT_SCALE = 4;

// For MKS-20: two parsed sample ROM sets
static std::unique_ptr<SampleData> samples_a, samples_b;
static bool has_rom_set_b = false;
static int current_rom_set = -1;  // 0=A, 1=B

// ============================================================================
// ROM loading
// ============================================================================

static std::vector<uint8_t> load_rom(const char *path, size_t sz) {
    FILE *f = fopen(path, "rb");
    if (!f) { fprintf(stderr, "Error opening %s\n", path); return {}; }
    std::vector<uint8_t> d(sz);
    fread(d.data(), 1, sz, f);
    fclose(f);
    return d;
}

static void descramble_params(const uint8_t *src, uint8_t *dst, size_t size) {
    for (size_t i = 0; i < size; i++)
        dst[i] = bitswap<8>(src[bitswap<17>(i,16,15,13,12,14,11,8,9,10,7,6,5,4,3,2,1,0)],7,0,6,1,5,2,4,3);
}

static void descramble_wave_rom(const uint8_t *src, uint8_t *dst, size_t size) {
    for (size_t i = 0; i < size; i++) {
        uint32_t addr = (BIT(i, 16) << 16) | (BIT(i, 15) << 15) | (BIT(i, 14) << 14) |
                        (BIT(i, 1) << 13)  | (BIT(i, 4) << 12)  | (BIT(i, 9) << 11)  |
                        (BIT(i, 5) << 10)  | (BIT(i, 10) << 9)  | (BIT(i, 3) << 8)   |
                        (BIT(i, 0) << 7)   | (BIT(i, 6) << 6)   | (BIT(i, 11) << 5)  |
                        (BIT(i, 7) << 4)   | (BIT(i, 2) << 3)   | (BIT(i, 12) << 2)  |
                        (BIT(i, 8) << 1)   | (BIT(i, 13) << 0);
        dst[i] = src[addr];
    }
}

static SampleData parse_wave_roms(const uint8_t *ic5, const uint8_t *ic6, const uint8_t *ic7) {
    SampleData data;
    for (size_t i = 0; i < 0x20000; i++) {
        size_t di = (
            ((i >> 0) & 1) << 0  | ((~i >> 1) & 1) << 1  | ((i >> 2) & 1) << 2  |
            ((~i >> 3) & 1) << 3 | ((i >> 4) & 1) << 4   | ((~i >> 5) & 1) << 5 |
            ((i >> 6) & 1) << 6  | ((i >> 7) & 1) << 7   | ((~i >> 8) & 1) << 8 |
            ((~i >> 9) & 1) << 9 | ((i >> 10) & 1) << 10 | ((i >> 11) & 1) << 11 |
            ((i >> 12) & 1) << 12 | ((i >> 13) & 1) << 13 | ((i >> 14) & 1) << 14 |
            ((i >> 15) & 1) << 15 | ((i >> 16) & 1) << 16
        );
        data.exp[i] = (
            ((ic5[di] >> 0) & 1) << 13 | ((ic6[di] >> 4) & 1) << 12 |
            ((ic7[di] >> 4) & 1) << 11 | ((~ic6[di] >> 0) & 1) << 10 |
            ((ic7[di] >> 7) & 1) << 9  | ((ic5[di] >> 7) & 1) << 8 |
            ((~ic5[di] >> 5) & 1) << 7 | ((ic6[di] >> 2) & 1) << 6 |
            ((ic7[di] >> 2) & 1) << 5  | ((ic7[di] >> 1) & 1) << 4 |
            ((~ic5[di] >> 1) & 1) << 3 | ((ic5[di] >> 3) & 1) << 2 |
            ((ic6[di] >> 5) & 1) << 1  | ((~ic6[di] >> 7) & 1) << 0
        );
        data.exp_sign[i] = (~ic7[di] >> 3) & 1;
        data.delta[i] = (
            ((~ic7[di] >> 6) & 1) << 8 | ((ic5[di] >> 4) & 1) << 7 |
            ((ic7[di] >> 0) & 1) << 6  | ((~ic6[di] >> 3) & 1) << 5 |
            ((ic5[di] >> 2) & 1) << 4  | ((~ic5[di] >> 6) & 1) << 3 |
            ((ic6[di] >> 6) & 1) << 2  | ((ic7[di] >> 5) & 1) << 1 |
            ((~ic6[di] >> 7) & 1) << 0
        );
        data.delta_sign[i] = (ic6[di] >> 1) & 1;
    }
    return data;
}

// ============================================================================
// Audio callback
// ============================================================================

void audio_callback(void *, Uint8 *stream, int len) {
    auto *out = reinterpret_cast<int16_t *>(stream);
    int samples = len / 4;  // stereo 16-bit

    SDL_AtomicLock(&fw_lock);
    for (int i = 0; i < samples; i++) {
        int32_t raw = firmware->generateSample() / OUTPUT_SCALE;
        int16_t s = static_cast<int16_t>(std::clamp(raw, -32768, 32767));
        out[i * 2] = s;
        out[i * 2 + 1] = s;
    }
    SDL_AtomicUnlock(&fw_lock);
}

// ============================================================================
// MIDI via PortMidi (optional)
// ============================================================================

static PmStream *midiInStream = nullptr;

int MIDI_Init() {
    Pm_Initialize();
    int in_id = Pm_CreateVirtualInput("RdPiano Native", NULL, NULL);
    if (in_id < 0) {
        fprintf(stderr, "Failed to create virtual MIDI input\n");
        return 0;
    }
    Pm_OpenInput(&midiInStream, in_id, NULL, 0, NULL, NULL);
    Pm_SetFilter(midiInStream, PM_FILT_ACTIVE | PM_FILT_CLOCK | PM_FILT_SYSEX);
    while (Pm_Poll(midiInStream)) {
        PmEvent buf[1];
        Pm_Read(midiInStream, buf, 1);
    }
    printf("MIDI input: 'RdPiano Native' (virtual port)\n");
    return 1;
}

void MIDI_UpdatePortMidi() {
    PmEvent event;
    while (Pm_Read(midiInStream, &event, 1)) {
        uint8_t status = Pm_MessageStatus(event.message);
        uint8_t data1 = Pm_MessageData1(event.message);
        uint8_t data2 = Pm_MessageData2(event.message);

        SDL_AtomicLock(&fw_lock);
        firmware->sendMidi(status, data1, data2);
        SDL_AtomicUnlock(&fw_lock);

        printf("MIDI: %02X %02X %02X\n", status, data1, data2);
    }
}

void MIDI_Quit() {
    if (midiInStream) Pm_Close(midiInStream);
    Pm_Terminate();
}

// ============================================================================
// Computer keyboard → MIDI (always available)
// Maps ASDF... row to white keys, WER... row to black keys
// ============================================================================

static int key_to_note(SDL_Keycode key) {
    switch (key) {
        // Lower row: C4-B4 white keys
        case SDLK_a: return 60;  // C4
        case SDLK_s: return 62;  // D4
        case SDLK_d: return 64;  // E4
        case SDLK_f: return 65;  // F4
        case SDLK_g: return 67;  // G4
        case SDLK_h: return 69;  // A4
        case SDLK_j: return 71;  // B4
        case SDLK_k: return 72;  // C5
        case SDLK_l: return 74;  // D5
        // Upper row: black keys
        case SDLK_w: return 61;  // C#4
        case SDLK_e: return 63;  // D#4
        case SDLK_t: return 66;  // F#4
        case SDLK_y: return 68;  // G#4
        case SDLK_u: return 70;  // A#4
        case SDLK_o: return 73;  // C#5
        // Lower octave: Z row
        case SDLK_z: return 48;  // C3
        case SDLK_x: return 50;  // D3
        case SDLK_c: return 52;  // E3
        case SDLK_v: return 53;  // F3
        case SDLK_b: return 55;  // G3
        case SDLK_n: return 57;  // A3
        case SDLK_m: return 59;  // B3
        default: return -1;
    }
}

static void send_midi(uint8_t status, uint8_t d1, uint8_t d2) {
    SDL_AtomicLock(&fw_lock);
    firmware->sendMidi(status, d1, d2);
    SDL_AtomicUnlock(&fw_lock);
}

static int current_program = 0;

// Tone shaping params (adjustable at runtime)
static uint8_t param_punch = 0;
static uint8_t param_tightness = 0;
static uint8_t param_body = 0;
static uint8_t param_brightness = 0;
static uint8_t param_stretch = 0;
static uint8_t param_auto_bend_pitch = 100;
static uint8_t param_auto_bend_time = 2;
static uint8_t param_auto_bend_vel = 4;

static void print_params() {
    printf("  Punch=%d Tight=%d Body=%d Bright=%d Stretch=%d AutoBend=%d/%d/%d\n",
           param_punch, param_tightness, param_body, param_brightness,
           param_stretch, param_auto_bend_pitch, param_auto_bend_time, param_auto_bend_vel);
}

// MKS-20: patches 0-2 use ROM set A, patches 3-7 use ROM set B
static int rom_set_for_program(int pgm) { return (has_rom_set_b && pgm >= 3) ? 1 : 0; }

static void switch_program(int pgm) {
    current_program = pgm;
    int needed_set = rom_set_for_program(pgm);
    if (needed_set != current_rom_set) {
        current_rom_set = needed_set;
        firmware->loadSamples(needed_set == 0 ? *samples_a : *samples_b);
        printf("ROM set: %c\n", 'A' + needed_set);
    }
    firmware->loadPatch(patch_set, pgm);
}

static void apply_param(uint8_t &param, int delta, uint8_t max_val, const char *name) {
    int v = (int)param + delta;
    param = (uint8_t)std::clamp(v, 0, (int)max_val);
    printf("%s = %d\n", name, param);
}

void handle_keyboard(SDL_Event &ev) {
    if (ev.type == SDL_KEYDOWN && !ev.key.repeat) {
        int note = key_to_note(ev.key.keysym.sym);
        if (note >= 0) {
            send_midi(0x90, note, 100);
            printf("Key ON:  note %d\n", note);
        }
        // Number keys 1-8 → program change
        if (ev.key.keysym.sym >= SDLK_1 && ev.key.keysym.sym <= SDLK_8) {
            SDL_AtomicLock(&fw_lock);
            switch_program(ev.key.keysym.sym - SDLK_1);
            SDL_AtomicUnlock(&fw_lock);
            printf("Program change: %d\n", current_program);
        }
        // Space → sustain pedal
        if (ev.key.keysym.sym == SDLK_SPACE) {
            send_midi(0xB0, 64, 127);
            printf("Sustain ON\n");
        }

        // F1/F2: Punch ±4
        // F3/F4: Tightness ±8
        // F5/F6: Body ±8
        // F7/F8: Brightness ±8
        // F9/F10: Stretch tuning cycle 0/1/2
        // F11/F12: Auto bend pitch ±10
        // 9/0: Auto bend time ±1
        bool param_changed = false;
        switch (ev.key.keysym.sym) {
        case SDLK_F1: apply_param(param_punch, -4, 32, "Punch"); param_changed = true; break;
        case SDLK_F2: apply_param(param_punch, +4, 32, "Punch"); param_changed = true; break;
        case SDLK_F3: apply_param(param_tightness, -8, 127, "Tightness"); param_changed = true; break;
        case SDLK_F4: apply_param(param_tightness, +8, 127, "Tightness"); param_changed = true; break;
        case SDLK_F5: apply_param(param_body, -8, 127, "Body"); param_changed = true; break;
        case SDLK_F6: apply_param(param_body, +8, 127, "Body"); param_changed = true; break;
        case SDLK_F7: apply_param(param_brightness, -8, 127, "Brightness"); param_changed = true; break;
        case SDLK_F8: apply_param(param_brightness, +8, 127, "Brightness"); param_changed = true; break;
        case SDLK_F9:  param_stretch = (param_stretch + 2) % 3; printf("Stretch = %d\n", param_stretch); param_changed = true; break;
        case SDLK_F10: param_stretch = (param_stretch + 1) % 3; printf("Stretch = %d\n", param_stretch); param_changed = true; break;
        case SDLK_F11: apply_param(param_auto_bend_pitch, -10, 200, "AutoBend Pitch"); param_changed = true; break;
        case SDLK_F12: apply_param(param_auto_bend_pitch, +10, 200, "AutoBend Pitch"); param_changed = true; break;
        case SDLK_9: apply_param(param_auto_bend_time, -1, 4, "AutoBend Time"); param_changed = true; break;
        case SDLK_0: apply_param(param_auto_bend_time, +1, 4, "AutoBend Time"); param_changed = true; break;
        case SDLK_MINUS: apply_param(param_auto_bend_vel, -2, 255, "AutoBend VelSens"); param_changed = true; break;
        case SDLK_EQUALS: apply_param(param_auto_bend_vel, +2, 255, "AutoBend VelSens"); param_changed = true; break;
        default: break;
        }

        if (param_changed) {
            SDL_AtomicLock(&fw_lock);
            firmware->setPunch(param_punch);
            firmware->setTightness(param_tightness);
            firmware->setBody(param_body);
            firmware->setBrightness(param_brightness);
            firmware->setStretchTuning(param_stretch);
            firmware->setAutoBend(param_auto_bend_pitch, param_auto_bend_time,
                                  param_auto_bend_vel, param_auto_bend_pitch != 100);
            SDL_AtomicUnlock(&fw_lock);
        }
    }
    if (ev.type == SDL_KEYUP) {
        int note = key_to_note(ev.key.keysym.sym);
        if (note >= 0) {
            send_midi(0x80, note, 0);
            printf("Key OFF: note %d\n", note);
        }
        if (ev.key.keysym.sym == SDLK_SPACE) {
            send_midi(0xB0, 64, 0);
            printf("Sustain OFF\n");
        }
    }
}

// ============================================================================
// Main
// ============================================================================

int main(int argc, char *argv[]) {
    if (argc < 6) {
        fprintf(stderr, "Usage: %s <ic5> <ic6> <ic7> <paramsrom> <rd200|mks20|mk80> [ic5b ic6b ic7b]\n", argv[0]);
        return 1;
    }

    auto ic5 = load_rom(argv[1], 0x20000);
    auto ic6 = load_rom(argv[2], 0x20000);
    auto ic7 = load_rom(argv[3], 0x20000);
    auto paramsrom_raw = load_rom(argv[4], 0x20000);
    if (ic5.empty() || ic6.empty() || ic7.empty() || paramsrom_raw.empty()) return 1;

    bool is_rd200 = (strcmp(argv[5], "rd200") == 0);
    bool is_mk80  = (strcmp(argv[5], "mk80") == 0);
    auto fmt = is_rd200 ? ParamsRomFormat::RD200
             : is_mk80  ? ParamsRomFormat::MK80
             : ParamsRomFormat::MKS20;

    // Descramble and parse wave ROMs (set A)
    std::vector<uint8_t> ic5d(0x20000), ic6d(0x20000), ic7d(0x20000);
    descramble_wave_rom(ic5.data(), ic5d.data(), 0x20000);
    descramble_wave_rom(ic6.data(), ic6d.data(), 0x20000);
    descramble_wave_rom(ic7.data(), ic7d.data(), 0x20000);
    samples_a = std::make_unique<SampleData>(parse_wave_roms(ic5d.data(), ic6d.data(), ic7d.data()));

    // MKS-20: parse ROM set B for patches 3-7
    if (!is_rd200 && argc >= 9) {
        auto ic5b = load_rom(argv[6], 0x20000);
        auto ic6b = load_rom(argv[7], 0x20000);
        auto ic7b = load_rom(argv[8], 0x20000);
        if (!ic5b.empty() && !ic6b.empty() && !ic7b.empty()) {
            descramble_wave_rom(ic5b.data(), ic5d.data(), 0x20000);
            descramble_wave_rom(ic6b.data(), ic6d.data(), 0x20000);
            descramble_wave_rom(ic7b.data(), ic7d.data(), 0x20000);
            samples_b = std::make_unique<SampleData>(parse_wave_roms(ic5d.data(), ic6d.data(), ic7d.data()));
            has_rom_set_b = true;
            printf("MKS-20 mode: ROM set B loaded for patches 3-7\n");
        }
    }

    // Descramble params ROM and parse patches
    uint8_t paramsrom[0x20000];
    descramble_params(paramsrom_raw.data(), paramsrom, 0x20000);
    patch_set.load(paramsrom, fmt);

    // Create firmware and load initial program
    firmware = std::make_unique<SynthFirmware>();
    switch_program(0);

    printf("%s mode. Send MIDI to 'RdPiano Native' virtual port.\n",
           is_rd200 ? "RD200" : "MKS-20");
    printf("Program change (CC#0) selects patches 0-7.\n");

    // Init SDL (need VIDEO for keyboard input)
    SDL_SetMainReady();
    if (SDL_Init(SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_TIMER) < 0) {
        fprintf(stderr, "SDL init failed: %s\n", SDL_GetError());
        return 2;
    }

    SDL_AudioSpec spec = {}, actual = {};
    spec.format = AUDIO_S16SYS;
    spec.freq = 20000;
    spec.channels = 2;
    spec.callback = audio_callback;
    spec.samples = 256;

    sdl_audio = SDL_OpenAudioDevice(NULL, 0, &spec, &actual, 0);
    if (!sdl_audio) {
        fprintf(stderr, "SDL audio open failed: %s\n", SDL_GetError());
        return 2;
    }
    printf("Audio: %dHz, %d channels, %d buffer\n", actual.freq, actual.channels, actual.samples);
    SDL_PauseAudioDevice(sdl_audio, 0);

    // Init MIDI (optional)
    bool has_midi = MIDI_Init();
    if (!has_midi) {
        printf("No MIDI input — use computer keyboard to play.\n");
    }

    // Create a small window for keyboard focus
    SDL_Window *win = SDL_CreateWindow("RdPiano Native",
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 400, 200, 0);

    printf("\nReady!\n");
    printf("  Keys: A-L = white keys (C4-D5), W/E/T/Y/U/O = black keys\n");
    printf("  Keys: Z-M = lower octave (C3-B3)\n");
    printf("  1-8 = program change, Space = sustain pedal\n");
    printf("  F1/F2=Punch  F3/F4=Tightness  F5/F6=Body  F7/F8=Brightness\n");
    printf("  F9/F10=Stretch  F11/F12=AutoBend pitch  9/0=time  -/+=vel\n");
    printf("  Esc/close window = quit\n\n");

    // Main loop
    while (!quit_requested) {
        MIDI_UpdatePortMidi();

        SDL_Event ev;
        while (SDL_PollEvent(&ev)) {
            if (ev.type == SDL_QUIT) quit_requested = true;
            if (ev.type == SDL_KEYDOWN && ev.key.keysym.sym == SDLK_ESCAPE) quit_requested = true;
            handle_keyboard(ev);
        }
        SDL_Delay(1);
    }

    SDL_DestroyWindow(win);

    // Cleanup
    SDL_CloseAudioDevice(sdl_audio);
    MIDI_Quit();
    SDL_Quit();

    // unique_ptrs clean up automatically, vectors too
    return 0;
}
