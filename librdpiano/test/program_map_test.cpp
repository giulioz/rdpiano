#include <cassert>
#include <cstdint>

#include "../include/rdpiano_program_map.h"

int main() {
  uint8_t a5 = 0, a6 = 0, a7 = 0, a18 = 0;
  uint8_t b5 = 0, b6 = 0, b7 = 0, b18 = 0;
  uint8_t k5 = 0, k6 = 0, k7 = 0, k18 = 0;

  RomSet setA = {&a5, &a6, &a7, &a18};
  RomSet setB = {&b5, &b6, &b7, &b18};
  RomSet setK = {&k5, &k6, &k7, &k18};
  set_program_rom_sets(&setA, &setB, &setK);

  const size_t expected_offsets[kProgramCount] = {
      0x000000, 0x008000, 0x010000, 0x018000, 0x003c20, 0x00ab50, 0x014260, 0x01bef0,
      0x000020, 0x008000, 0x010000, 0x018000, 0x002c00, 0x00b1f0, 0x012910, 0x0199f0};
  const int expected_rates[kProgramCount] = {
      20000, 20000, 20000, 32000, 32000, 20000, 20000, 32000,
      20000, 20000, 20000, 32000, 20000, 20000, 32000, 20000};

  for (int i = 0; i < kProgramCount; i++) {
    ProgramConfig cfg = get_program_config(i);
    assert(cfg.params_offset == expected_offsets[i]);
    assert(cfg.source_sample_rate == expected_rates[i]);

    const ProgramRomFamily family = get_program_rom_family(i);
    if (family == ProgramRomFamily::Mks20A) {
      assert(cfg.rom_set == &setA);
    } else if (family == ProgramRomFamily::Mks20B) {
      assert(cfg.rom_set == &setB);
    } else {
      assert(family == ProgramRomFamily::Mk80);
      assert(cfg.rom_set == &setK);
    }
  }

  ProgramConfig clamped_low = get_program_config(-100);
  ProgramConfig clamped_high = get_program_config(100);
  assert(clamped_low.params_offset == expected_offsets[0]);
  assert(clamped_high.params_offset == expected_offsets[kProgramCount - 1]);

  return 0;
}
