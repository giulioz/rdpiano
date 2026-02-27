#ifndef RDPIANO_PROGRAM_MAP_H
#define RDPIANO_PROGRAM_MAP_H

#include <cstddef>
#include <cstdint>

struct RomSet {
  const uint8_t *ic5;
  const uint8_t *ic6;
  const uint8_t *ic7;
  const uint8_t *ic18;
};

struct ProgramConfig {
  const RomSet *rom_set;
  size_t params_offset;
  int source_sample_rate;
};

enum class ProgramRomFamily : uint8_t {
  Mks20A = 0,
  Mks20B = 1,
  Mk80 = 2
};

constexpr int kProgramCount = 16;

void set_program_rom_sets(const RomSet *mks20a, const RomSet *mks20b, const RomSet *mk80);
ProgramConfig get_program_config(int program_index);
ProgramRomFamily get_program_rom_family(int program_index);
size_t get_program_params_offset(int program_index);
int get_program_source_sample_rate(int program_index);

#endif
