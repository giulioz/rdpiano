#define SDL_MAIN_HANDLED
#include "SDL.h"
#include <portmidi.h>

#include "mame_utils.h"
#include "mcu.h"
#include "sound_chip.h"

static int audio_buffer_size;
static int audio_page_size;

static SDL_AudioDeviceID sdl_audio;

Mcu *mcu;

void audio_callback(void * /*userdata*/, Uint8 *stream, int len) {
  len /= 4;

  for (size_t i = 0; i < len; i++) {
    s16 sample = mcu->generate_next_sample();
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
  // spec.freq = 32000;
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

#define MODEL "RD200"
// #define MODEL "MK80"

int main() {
  u8 temp_ic5[0x20000];
  u8 temp_ic6[0x20000];
  u8 temp_ic7[0x20000];
  u8 temp_progrom[0x2000];
  u8 temp_paramsrom[0x20000];
  FILE *f;

  f = fopen(MODEL "_IC5.bin", "rb");
  if (f == NULL)
    printf("Error opening " MODEL "_IC5.bin\n");
  fread(temp_ic5, 1, 0x20000, f);
  fclose(f);
  f = fopen(MODEL "_IC6.bin", "rb");
  if (f == NULL)
    printf("Error opening " MODEL "_IC6.bin\n");
  fread(temp_ic6, 1, 0x20000, f);
  fclose(f);
  f = fopen(MODEL "_IC7.bin", "rb");
  if (f == NULL)
    printf("Error opening " MODEL "_IC7.bin\n");
  fread(temp_ic7, 1, 0x20000, f);
  fclose(f);
  f = fopen("RD200_B.bin", "rb");
  if (f == NULL)
    printf("Error opening RD200_B.bin\n");
  fread(temp_progrom, 1, 0x2000, f);
  fclose(f);
  f = fopen(MODEL "_IC18.bin", "rb");
  if (f == NULL)
    printf("Error opening " MODEL "_IC18.bin\n");
  fread(temp_paramsrom, 1, 0x20000, f);
  fclose(f);

  // It's important to send a program change after boot to init the parameters
  mcu = new Mcu(temp_ic5, temp_ic6, temp_ic7, temp_progrom, temp_paramsrom);
  mcu->commands_queue.push(0x30);

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

  bool quit_requested = false;
  while (!quit_requested) {
    MIDI_Update();

    SDL_Event sdl_event;
    while (SDL_PollEvent(&sdl_event)) {
      switch (sdl_event.type) {
      case SDL_QUIT:
        quit_requested = true;
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
