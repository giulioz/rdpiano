#pragma once

#include <cstdint>
#include <functional>
#include "constants.h"

// Parsed wave ROM sample data (ROM-independent after parsing)
struct SampleData {
  uint16_t exp[0x20000];
  bool exp_sign[0x20000];
  uint16_t delta[0x20000];
  bool delta_sign[0x20000];
};

class SoundChip {
public:
  SoundChip();

  // Load parsed sample data
  void loadSamples(const SampleData &data);

  // Audio generation: produce one sample
  int32_t update();

  // Voice/part register API
  void setPitch(int voice, int part, uint16_t pitch);
  void setWave(int voice, int part, uint8_t wave_loop, uint8_t wave_high);
  void setEnvelope(int voice, int part, uint8_t env_dest, uint8_t env_speed);
  void setFlags(int voice, int part, uint8_t flags);
  void setEnvOffset(int voice, int part, uint8_t offset);
  void silencePart(int voice, int part);
  void clearPart(int voice, int part);

  // Envelope IRQ callback: called with (voice, part) when envelope reaches destination
  std::function<void(int voice, int part)> onEnvelopeIRQ;

private:
  uint16_t samples_exp[0x20000] = {};
  bool samples_exp_sign[0x20000] = {};
  uint16_t samples_delta[0x20000] = {};
  bool samples_delta_sign[0x20000] = {};

  uint32_t phase_exp_table[0x10000];
  uint16_t samples_exp_table[0x8000];

  struct SA_Part {
    uint32_t sub_phase = 0;
    uint32_t env_value = 0;
    uint16_t pitch_lut_i = 0;
    uint8_t wave_addr_loop = 0;
    uint8_t wave_addr_high = 0;
    uint8_t env_dest = 0;
    uint8_t env_speed = 0;
    bool flags_0 = false;
    bool flags_1 = false;
    uint8_t env_offset = 0xFF;
  };

  SA_Part m_parts[NUM_VOICES][PARTS_PER_VOICE_MEM];
};
