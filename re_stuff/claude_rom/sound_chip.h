#ifndef SOUND_CHIP_H
#define SOUND_CHIP_H

#include <cstdint>
#include "mame_utils.h"

class SoundChip {
public:
  SoundChip(const u8 *ic5, const u8 *ic6, const u8 *ic7);

  // Audio generation: produce one sample
  s32 update();

  // Reload sample ROMs
  void load_samples(const u8 *ic5, const u8 *ic6, const u8 *ic7);

  // Voice/part register API
  void setPitch(int voice, int part, uint16_t pitch);
  void setWave(int voice, int part, uint8_t wave_loop, uint8_t wave_high);
  void setEnvelope(int voice, int part, uint8_t env_dest, uint8_t env_speed);
  void setFlags(int voice, int part, uint8_t flags);
  void setEnvOffset(int voice, int part, uint8_t offset);
  void silencePart(int voice, int part);
  void clearPart(int voice, int part);

  // IRQ
  bool irqTriggered = false;
  uint8_t getIrqId() const { return m_irq_id; }

private:
  static constexpr unsigned NUM_VOICES = 16;
  static constexpr unsigned PARTS_PER_VOICE = 10;
  static constexpr unsigned PARTS_PER_VOICE_MEM = 16;

  uint16_t samples_exp[0x20000];
  bool samples_exp_sign[0x20000];
  uint16_t samples_delta[0x20000];
  bool samples_delta_sign[0x20000];

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
  uint8_t m_irq_id = 0;
};

#endif
