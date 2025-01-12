#ifndef SOUND_CHIP_H
#define SOUND_CHIP_H

#include <stdio.h>
#include "mame_utils.h"

class SoundChip {
public:
  SoundChip(const u8 *temp_ic5, const u8 *temp_ic6, const u8 *temp_ic7);

  u8 read(size_t offset);
  void write(size_t offset, u8 data);

  s16 update();

  void load_samples(const u8 *temp_ic5, const u8 *temp_ic6, const u8 *temp_ic7);

  // if there is an IRQ currently waiting
  bool m_irq_triggered;

private:
  static constexpr unsigned NUM_VOICES = 16;
  static constexpr unsigned PARTS_PER_VOICE = 10;

  uint16_t samples_exp[0x20000];
  bool samples_exp_sign[0x20000];
  uint16_t samples_delta[0x20000];
  bool samples_delta_sign[0x20000];

  uint32_t phase_exp_table[0x10000];
  uint16_t samples_exp_table[0x8000];

  struct SA_Part {
    uint32_t sub_phase = 0;
    uint32_t env_value = 0;
  };

  SA_Part m_parts[NUM_VOICES][PARTS_PER_VOICE];    // channel memory
  uint8_t m_ctrl_mem[0x2000];											 // RAM IC12 (as the CPU writes it)
  uint8_t m_irq_id;																 // voice/part that triggered the IRQ
};

#endif
