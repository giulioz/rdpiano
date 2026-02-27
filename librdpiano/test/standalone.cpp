#include <stdlib.h>
#include <cstring>
#include <cmath>

#define SDL_MAIN_HANDLED
#include "SDL.h"
#include <portmidi.h>

#include "mame_utils.h"
#include "mcu.h"
#include "rdpiano_program_map.h"
#include "sound_chip.h"

static int audio_buffer_size;
static int audio_page_size;
static bool g_mode32khz = false;
static int g_current_program = 0;

static SDL_AudioDeviceID sdl_audio;

Mcu *mcu;

static void push_master_tune_handshake(Mcu *mcu, int16_t masterTune) {
  if (!mcu)
    return;

  uint8_t tuneMsb = masterTune < 0 ? 0x7f : 0x00;
  uint8_t tuneLsb =
      (int8_t)(std::floor(std::abs(masterTune) / 32767.0 * 16.0) * 4) & 0xff;
  if (tuneLsb > 0x3c)
    tuneLsb = 0x3c;
  if (masterTune < 0)
    tuneLsb = 0x48 + tuneLsb;

  // Match JUCE reset handshake ordering.
  mcu->commands_queue.push(0x30);
  mcu->commands_queue.push(0xE0);
  mcu->commands_queue.push(tuneMsb);
  mcu->commands_queue.push(tuneLsb);
  for (size_t cycle = 0; cycle < 1024; cycle++)
    mcu->generate_next_sample();
  mcu->commands_queue.push(0x31);
  mcu->commands_queue.push(0x30);
}

void audio_callback(void * /*userdata*/, Uint8 *stream, int len) {
  len /= 4;

  for (size_t i = 0; i < len; i++) {
    s16 sample = mcu->generate_next_sample(g_mode32khz) >> 3;
    ((int16_t *)stream)[i * 2] = sample;
    ((int16_t *)stream)[i * 2 + 1] = sample;
  }
}

static const char *audio_format_to_str(int format) {
  switch (format) {
  case AUDIO_S8:
    return "S8";
  case AUDIO_U8:
    return "U8";
  case AUDIO_S16MSB:
    return "S16MSB";
  case AUDIO_S16LSB:
    return "S16LSB";
  case AUDIO_U16MSB:
    return "U16MSB";
  case AUDIO_U16LSB:
    return "U16LSB";
  case AUDIO_S32MSB:
    return "S32MSB";
  case AUDIO_S32LSB:
    return "S32LSB";
  case AUDIO_F32MSB:
    return "F32MSB";
  case AUDIO_F32LSB:
    return "F32LSB";
  }
  return "UNK";
}

int MCU_OpenAudio(int deviceIndex, int pageSize, int pageNum) {
  SDL_AudioSpec spec = {};
  SDL_AudioSpec spec_actual = {};

  audio_page_size = (pageSize / 2) * 2; // must be even
  audio_buffer_size = audio_page_size * pageNum;

  spec.format = AUDIO_S16SYS;
  spec.freq = 20000;
  spec.channels = 2;
  spec.callback = audio_callback;
  spec.samples = audio_page_size / 4;

  int num = SDL_GetNumAudioDevices(0);
  if (num == 0) {
    printf("No audio output device found.\n");
    return 0;
  }

  if (deviceIndex < -1 || deviceIndex >= num) {
    printf("Out of range audio device index is requested. Default audio output "
           "device is selected.\n");
    deviceIndex = -1;
  }

  const char *audioDevicename = deviceIndex == -1
                                    ? "Default device"
                                    : SDL_GetAudioDeviceName(deviceIndex, 0);

  sdl_audio = SDL_OpenAudioDevice(deviceIndex == -1 ? NULL : audioDevicename, 0,
                                  &spec, &spec_actual, 0);
  if (!sdl_audio) {
    return 0;
  }

  printf("Audio device: %s\n", audioDevicename);

  printf("Audio Requested: F=%s, C=%d, R=%d, B=%d\n",
         audio_format_to_str(spec.format), spec.channels, spec.freq,
         spec.samples);

  printf("Audio Actual: F=%s, C=%d, R=%d, B=%d\n",
         audio_format_to_str(spec_actual.format), spec_actual.channels,
         spec_actual.freq, spec_actual.samples);
  fflush(stdout);

  SDL_PauseAudioDevice(sdl_audio, 0);

  return 1;
}

void MCU_CloseAudio(void) { SDL_CloseAudio(); }

static PmStream *midiInStream;

int MIDI_Init() {
  Pm_Initialize();

  int in_id = Pm_CreateVirtualInput("RdPiano", NULL, NULL);

  Pm_OpenInput(&midiInStream, in_id, NULL, 0, NULL, NULL);
  Pm_SetFilter(midiInStream, PM_FILT_ACTIVE | PM_FILT_CLOCK | PM_FILT_SYSEX);

  // Empty the buffer, just in case anything got through
  PmEvent receiveBuffer[1];
  while (Pm_Poll(midiInStream)) {
    Pm_Read(midiInStream, receiveBuffer, 1);
  }

  return 1;
}

void MIDI_Quit() { Pm_Terminate(); }

void MIDI_Update() {
  PmEvent event;
  while (Pm_Read(midiInStream, &event, 1)) {
    mcu->sendMidiCmd(Pm_MessageStatus(event.message),
                     Pm_MessageData1(event.message),
                     Pm_MessageData2(event.message));
    printf("MIDI: %02X %02X %02X\n", Pm_MessageStatus(event.message),
           Pm_MessageData1(event.message), Pm_MessageData2(event.message));
  }
}

void load_rom(u8 *data, size_t len, const char *filename) {
  FILE *f = fopen(filename, "rb");
  if (f == NULL) {
    printf("Error opening %s\n", filename);
    exit(2);
  }
  fread(data, 1, len, f);
  fclose(f);
}

void apply_program(int program) {
  ProgramConfig program_cfg = get_program_config(program);
  if (!program_cfg.rom_set)
    return;

  if (sdl_audio)
    SDL_LockAudioDevice(sdl_audio);

  mcu->loadSounds(program_cfg.rom_set->ic5, program_cfg.rom_set->ic6,
                  program_cfg.rom_set->ic7, program_cfg.rom_set->ic18,
                  program_cfg.params_offset);
  mcu->commands_queue.push(0x31);
  mcu->commands_queue.push(0x30);

  g_mode32khz = (program_cfg.source_sample_rate == 32000);
  g_current_program = program;

  if (sdl_audio)
    SDL_UnlockAudioDevice(sdl_audio);

  printf("Program %d loaded: offset=0x%06zx mode=%s\n", program,
         program_cfg.params_offset, g_mode32khz ? "32k" : "20k");
  fflush(stdout);
}

int parse_program_from_args(int argc, char **argv) {
  for (int i = 1; i < argc; i++) {
    if (strcmp(argv[i], "--program") == 0 && i + 1 < argc) {
      int p = atoi(argv[i + 1]);
      if (p < 0)
        p = 0;
      if (p >= kProgramCount)
        p = kProgramCount - 1;
      return p;
    }
  }
  return 0;
}

int main(int argc, char **argv) {
  u8 mks20a_ic5[0x20000];
  u8 mks20a_ic6[0x20000];
  u8 mks20a_ic7[0x20000];
  u8 mks20b_ic5[0x20000];
  u8 mks20b_ic6[0x20000];
  u8 mks20b_ic7[0x20000];
  u8 mk80_ic5[0x20000];
  u8 mk80_ic6[0x20000];
  u8 mk80_ic7[0x20000];
  u8 mks20_ic18[0x20000];
  u8 mk80_ic18[0x20000];
  u8 temp_progrom[0x2000];

  load_rom(mks20a_ic5, sizeof mks20a_ic5, "mks20_15179738.BIN");
  load_rom(mks20a_ic6, sizeof mks20a_ic6, "mks20_15179737.BIN");
  load_rom(mks20a_ic7, sizeof mks20a_ic7, "mks20_15179736.BIN");
  load_rom(mks20b_ic5, sizeof mks20b_ic5, "mks20_15179741.BIN");
  load_rom(mks20b_ic6, sizeof mks20b_ic6, "mks20_15179740.BIN");
  load_rom(mks20b_ic7, sizeof mks20b_ic7, "mks20_15179739.BIN");
  load_rom(mk80_ic5, sizeof mk80_ic5, "MK80_IC5.bin");
  load_rom(mk80_ic6, sizeof mk80_ic6, "MK80_IC6.bin");
  load_rom(mk80_ic7, sizeof mk80_ic7, "MK80_IC7.bin");
  load_rom(mks20_ic18, sizeof mks20_ic18, "mks20_15179757.BIN");
  load_rom(mk80_ic18, sizeof mk80_ic18, "MK80_IC18.bin");
  load_rom(temp_progrom, sizeof temp_progrom, "RD200_B.bin");

  RomSet mks20a_set = {mks20a_ic5, mks20a_ic6, mks20a_ic7, mks20_ic18};
  RomSet mks20b_set = {mks20b_ic5, mks20b_ic6, mks20b_ic7, mks20_ic18};
  RomSet mk80_set = {mk80_ic5, mk80_ic6, mk80_ic7, mk80_ic18};
  set_program_rom_sets(&mks20a_set, &mks20b_set, &mk80_set);

  const int selected_program = parse_program_from_args(argc, argv);
  ProgramConfig selected_cfg = get_program_config(selected_program);

  // It's important to send a program change after boot to init the parameters
  mcu = new Mcu(selected_cfg.rom_set->ic5, selected_cfg.rom_set->ic6,
                selected_cfg.rom_set->ic7, temp_progrom,
                selected_cfg.rom_set->ic18);

  mcu->reset();
  push_master_tune_handshake(mcu, 0);

  if (SDL_Init(SDL_INIT_AUDIO | SDL_INIT_VIDEO | SDL_INIT_TIMER) < 0) {
    fprintf(stderr, "FATAL ERROR: Failed to initialize the SDL2: %s.\n",
            SDL_GetError());
    fflush(stderr);
    return 2;
  }

  if (!MCU_OpenAudio(-1, 512, 32)) {
    fprintf(stderr, "FATAL ERROR: Failed to open the audio stream.\n");
    fflush(stderr);
    return 2;
  }

  if (!MIDI_Init()) {
    fprintf(stderr, "ERROR: Failed to initialize the MIDI Input.\nWARNING: "
                    "Continuing without MIDI Input...\n");
    fflush(stderr);
  }

  apply_program(selected_program);

  bool quit_requested = false;
  while (!quit_requested) {
    MIDI_Update();

    SDL_Event sdl_event;
    while (SDL_PollEvent(&sdl_event)) {
      switch (sdl_event.type) {
      case SDL_QUIT:
        quit_requested = true;
        break;
      case SDL_KEYDOWN:
        if (sdl_event.key.keysym.sym == SDLK_LEFT) {
          int next_program = g_current_program - 1;
          if (next_program < 0)
            next_program = kProgramCount - 1;
          apply_program(next_program);
        } else if (sdl_event.key.keysym.sym == SDLK_RIGHT) {
          int next_program = (g_current_program + 1) % kProgramCount;
          apply_program(next_program);
        }
        break;
      }
    }
  }

  MCU_CloseAudio();
  MIDI_Quit();
  SDL_Quit();

  delete mcu;

  return 0;
}
