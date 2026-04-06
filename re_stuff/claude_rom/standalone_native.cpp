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
#include <cstdlib>
#include <cstring>
#include <cstdarg>
#include <atomic>

#define SDL_MAIN_HANDLED
#include "SDL.h"
#include <portmidi.h>

#include "synth_firmware.h"
#include "sound_chip.h"

// ============================================================================
// Globals
// ============================================================================

static SynthFirmware *firmware = nullptr;
static SoundChip *sound_chip = nullptr;
PatchSet patch_set;
static SDL_AudioDeviceID sdl_audio;
static SDL_SpinLock fw_lock;
static std::atomic<bool> quit_requested{false};
static int current_sample_rate = 20000;
static constexpr int OUTPUT_SCALE = 4;

// For MKS-20: extra sample ROMs for patches 3-7
static uint8_t *ic5b_data = nullptr, *ic6b_data = nullptr, *ic7b_data = nullptr;
static bool has_rom_set_b = false;

// ============================================================================
// ROM loading
// ============================================================================

template<int W> static unsigned bitswap(unsigned val, ...) {
    va_list ap; va_start(ap, val); int bits[W];
    for (int i = W-1; i >= 0; i--) bits[i] = va_arg(ap, int);
    va_end(ap); unsigned r = 0;
    for (int i = 0; i < W; i++) if (val & (1 << bits[i])) r |= (1 << i);
    return r;
}

static uint8_t* load_rom(const char *path, size_t sz) {
    FILE *f = fopen(path, "rb");
    if (!f) { fprintf(stderr, "Error opening %s\n", path); return nullptr; }
    uint8_t *d = (uint8_t*)malloc(sz);
    fread(d, 1, sz, f); fclose(f);
    return d;
}

static void descramble_params(const uint8_t *src, uint8_t *dst, size_t size) {
    for (size_t i = 0; i < size; i++)
        dst[i] = bitswap<8>(src[bitswap<17>(i,16,15,13,12,14,11,8,9,10,7,6,5,4,3,2,1,0)],7,0,6,1,5,2,4,3);
}

// ============================================================================
// Audio callback
// ============================================================================

void audio_callback(void *, Uint8 *stream, int len) {
    int16_t *out = (int16_t *)stream;
    int samples = len / 4;  // stereo 16-bit

    SDL_AtomicLock(&fw_lock);
    bool sr32 = firmware->sampleRate32k;
    for (int i = 0; i < samples; i++) {
        int32_t raw = firmware->generateSample() / OUTPUT_SCALE;
        if (raw > 32767) raw = 32767;
        if (raw < -32768) raw = -32768;
        int16_t s = (int16_t)raw;
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

// QWERTY keyboard → MIDI note mapping (middle octave starting at C4=60)
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

void handle_keyboard(SDL_Event &ev) {
    if (ev.type == SDL_KEYDOWN && !ev.key.repeat) {
        int note = key_to_note(ev.key.keysym.sym);
        if (note >= 0) {
            send_midi(0x90, note, 100);
            printf("Key ON:  note %d\n", note);
        }
        // Number keys 1-8 → program change
        if (ev.key.keysym.sym >= SDLK_1 && ev.key.keysym.sym <= SDLK_8) {
            current_program = ev.key.keysym.sym - SDLK_1;
            SDL_AtomicLock(&fw_lock);
            firmware->loadPatch(patch_set.patches[current_program]);
            SDL_AtomicUnlock(&fw_lock);
            printf("Program change: %d\n", current_program);
        }
        // Space → sustain pedal
        if (ev.key.keysym.sym == SDLK_SPACE) {
            send_midi(0xB0, 64, 127);
            printf("Sustain ON\n");
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
        fprintf(stderr, "Usage: %s <ic5> <ic6> <ic7> <paramsrom> <rd200|mks20> [ic5b ic6b ic7b]\n", argv[0]);
        return 1;
    }

    uint8_t *ic5 = load_rom(argv[1], 0x20000);
    uint8_t *ic6 = load_rom(argv[2], 0x20000);
    uint8_t *ic7 = load_rom(argv[3], 0x20000);
    uint8_t *paramsrom_raw = load_rom(argv[4], 0x20000);
    if (!ic5 || !ic6 || !ic7 || !paramsrom_raw) return 1;

    bool is_rd200 = (strcmp(argv[5], "rd200") == 0);
    auto fmt = is_rd200 ? ParamsRomFormat::RD200 : ParamsRomFormat::MKS20;

    if (!is_rd200 && argc >= 9) {
        ic5b_data = load_rom(argv[6], 0x20000);
        ic6b_data = load_rom(argv[7], 0x20000);
        ic7b_data = load_rom(argv[8], 0x20000);
        has_rom_set_b = (ic5b_data && ic6b_data && ic7b_data);
        if (has_rom_set_b)
            printf("MKS-20 mode: ROM set B loaded for patches 3-7\n");
    }

    // Descramble params ROM
    uint8_t paramsrom[0x20000];
    descramble_params(paramsrom_raw, paramsrom, 0x20000);

    // Parse patches and create firmware
    sound_chip = new SoundChip(ic5, ic6, ic7);
    patch_set.load(paramsrom, fmt);
    firmware = new SynthFirmware(*sound_chip);
    firmware->loadPatch(patch_set.patches[0]);

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
    spec.freq = 20000;  // will be updated per program
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

    delete firmware;
    delete sound_chip;
    free(ic5); free(ic6); free(ic7); free(paramsrom_raw);
    if (ic5b_data) { free(ic5b_data); free(ic6b_data); free(ic7b_data); }

    return 0;
}
