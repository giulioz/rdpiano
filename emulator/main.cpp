#define SDL_MAIN_HANDLED
#include "SDL.h"

#include "mame_utils.h"
#include "mcu.h"
#include "sound_chip.h"

static int audio_buffer_size;
static int audio_page_size;
static short *sample_buffer;

static int sample_read_ptr;
static int sample_write_ptr;

static SDL_AudioDeviceID sdl_audio;

Mcu *mcu;
SoundChip *sound_chip;

bool prev_irq = false;

unsigned long cnt = 0;

void audio_callback(void * /*userdata*/, Uint8 *stream, int len) {
  len /= 4;
  // memcpy(stream, &sample_buffer[sample_read_ptr], len * 2);
  // memset(&sample_buffer[sample_read_ptr], 0, len * 2);
  // sample_read_ptr += len;
  // sample_read_ptr %= audio_buffer_size;

  if (cnt == 100) {
    mcu->commands_queue.push(0xC0);
    mcu->commands_queue.push(0x3C);
    mcu->commands_queue.push(0x40);
  }
  if (cnt == 120) {
    // mcu->commands_queue.push(0xB0);
    // mcu->commands_queue.push(0x3C);
    // mcu->commands_queue.push(0x00);
  }
  if (cnt == 130) {
    // mcu->commands_queue.push(0xC0);
    // mcu->commands_queue.push(0x40);
    // mcu->commands_queue.push(0x40);
  }
  if (cnt == 150) {
    // mcu->commands_queue.push(0xC0);
    // mcu->commands_queue.push(0x43);
    // mcu->commands_queue.push(0x40);
  }
  cnt++;
  // printf("cnt: %lu\n", cnt);

  for (size_t i = 0; i < len; i++) {
    s16 sample = sound_chip->update();
    ((int16_t *)stream)[i * 2] = sample;
    ((int16_t *)stream)[i * 2 + 1] = sample;

    if (sound_chip->m_irq_triggered && !prev_irq) {
      mcu->execute_set_input(0, ASSERT_LINE);
      prev_irq = true;
    } else if (!sound_chip->m_irq_triggered && prev_irq) {
      mcu->execute_set_input(0, CLEAR_LINE);
      prev_irq = false;
    }

    // 20kHz sample rate, 2000kHz CPU clock
    for (size_t cycle = 0; cycle < 100; cycle++) {
      mcu->execute_run();
    }
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

  sample_buffer = (short *)calloc(audio_buffer_size, sizeof(short));
  if (!sample_buffer) {
    printf("Cannot allocate audio buffer.\n");
    return 0;
  }
  sample_read_ptr = 0;
  sample_write_ptr = 0;

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

void MCU_CloseAudio(void) {
  SDL_CloseAudio();
  if (sample_buffer)
    free(sample_buffer);
}

#define UNSCRAMBLE_ADDR_WAVE(i) \
	((BIT(i, 16) << 16) | (BIT(i, 15) << 15) | (BIT(i, 14) << 14) | \
	(BIT(i, 1) << 13)   | (BIT(i, 4) << 12)  | (BIT(i, 9) << 11)  | \
	(BIT(i, 5) << 10)   | (BIT(i, 10) << 9)  | (BIT(i, 3) << 8)   | \
	(BIT(i, 0) << 7)    | (BIT(i, 6) << 6)   | (BIT(i, 11) << 5)  | \
	(BIT(i, 7) << 4)    | (BIT(i, 2) << 3)   | (BIT(i, 12) << 2)  | \
	(BIT(i, 8) << 1)    | (BIT(i, 13) << 0))
#define UNSCRAMBLE_DATA_WAVE(_data) \
	bitswap<8>(_data,7,6,5,4,3,2,1,0)

int main() {
  u8 temp_ic5[0x20000];
  u8 temp_ic6[0x20000];
  u8 temp_ic7[0x20000];
  u8 temp_rom[0x20000];
  FILE *f;

  f = fopen("RD200_IC5.bin", "rb");
  if (f == NULL)
    printf("Error opening RD200_IC5.bin\n");
  fread(temp_rom, 1, 0x20000, f);
  fclose(f);
	for (size_t srcpos = 0x00; srcpos < 0x20000; srcpos++) {
		temp_ic5[srcpos] = UNSCRAMBLE_DATA_WAVE(temp_rom[UNSCRAMBLE_ADDR_WAVE(srcpos)]);
	}
  f = fopen("RD200_IC6.bin", "rb");
  if (f == NULL)
    printf("Error opening RD200_IC6.bin\n");
  fread(temp_rom, 1, 0x20000, f);
  fclose(f);
	for (size_t srcpos = 0x00; srcpos < 0x20000; srcpos++) {
		temp_ic6[srcpos] = UNSCRAMBLE_DATA_WAVE(temp_rom[UNSCRAMBLE_ADDR_WAVE(srcpos)]);
	}
  f = fopen("RD200_IC7.bin", "rb");
  if (f == NULL)
    printf("Error opening RD200_IC7.bin\n");
  fread(temp_rom, 1, 0x20000, f);
  fclose(f);
	for (size_t srcpos = 0x00; srcpos < 0x20000; srcpos++) {
		temp_ic7[srcpos] = UNSCRAMBLE_DATA_WAVE(temp_rom[UNSCRAMBLE_ADDR_WAVE(srcpos)]);
	}

  sound_chip = new SoundChip(temp_ic5, temp_ic6, temp_ic7);
  mcu = new Mcu(sound_chip);

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

  // if (!MIDI_Init(port)) {
  //   fprintf(stderr, "ERROR: Failed to initialize the MIDI Input.\nWARNING: "
  //                   "Continuing without MIDI Input...\n");
  //   fflush(stderr);
  // }

  // Test sine wave
  // sound_chip->write(0x00, 0x6C);
  // sound_chip->write(0x01, 0x00);
  // sound_chip->write(0x02, 0x10);
  // sound_chip->write(0x03, 0x00);
  // sound_chip->write(0x04, 0xFF);
  // sound_chip->write(0x05, 0xFF);
  // sound_chip->write(0x06, 0x00);
  // sound_chip->write(0x07, 0xFF);

  mcu->commands_queue.push(0x36);

  // mcu->commands_queue.push(0xC0);
  // mcu->commands_queue.push(0x3C);
  // mcu->commands_queue.push(0x40);

  while (true) {
    SDL_Delay(15);
  }

  MCU_CloseAudio();
  // MIDI_Quit();
  SDL_Quit();

  delete mcu;
  delete sound_chip;

  return 0;
}
