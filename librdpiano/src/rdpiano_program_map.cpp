#include "../include/rdpiano_program_map.h"

namespace {

constexpr ProgramRomFamily kProgramRomFamily[kProgramCount] = {
    // MKS-20
    ProgramRomFamily::Mks20A, ProgramRomFamily::Mks20A, ProgramRomFamily::Mks20A, ProgramRomFamily::Mks20B,
    ProgramRomFamily::Mks20B, ProgramRomFamily::Mks20B, ProgramRomFamily::Mks20B, ProgramRomFamily::Mks20B,
    // MK80
    ProgramRomFamily::Mk80, ProgramRomFamily::Mk80, ProgramRomFamily::Mk80, ProgramRomFamily::Mk80,
    ProgramRomFamily::Mk80, ProgramRomFamily::Mk80, ProgramRomFamily::Mk80, ProgramRomFamily::Mk80};

constexpr size_t kProgramParamsOffset[kProgramCount] = {
    // MKS-20
    0x000000, // Piano 1
    0x008000, // Piano 2
    0x010000, // Piano 3
    0x018000, // Harpsichord
    0x003c20, // Clavi
    0x00ab50, // Vibraphone
    0x014260, // E-Piano 1
    0x01bef0, // E-Piano 2

    // MK80
    0x000020, // Classic
    0x008000, // Special
    0x010000, // Blend
    0x018000, // Contemporary
    0x002c00, // A. Piano 1
    0x00b1f0, // A. Piano 2
    0x012910, // Clavi
    0x0199f0, // Vibraphone
};

constexpr int kProgramSampleRate[kProgramCount] = {
    // MKS-20
    20000, 20000, 20000, 32000, 32000, 20000, 20000, 32000,
    // MK80
    20000, 20000, 20000, 32000, 20000, 20000, 32000, 20000};

const RomSet *g_mks20a = nullptr;
const RomSet *g_mks20b = nullptr;
const RomSet *g_mk80 = nullptr;

int clamp_program_index(int program_index)
{
  if (program_index < 0)
    return 0;
  if (program_index >= kProgramCount)
    return kProgramCount - 1;
  return program_index;
}

const RomSet *rom_set_for_family(ProgramRomFamily family)
{
  switch (family) {
  case ProgramRomFamily::Mks20A:
    return g_mks20a;
  case ProgramRomFamily::Mks20B:
    return g_mks20b;
  case ProgramRomFamily::Mk80:
    return g_mk80;
  }
  return nullptr;
}

} // namespace

void set_program_rom_sets(const RomSet *mks20a, const RomSet *mks20b, const RomSet *mk80)
{
  g_mks20a = mks20a;
  g_mks20b = mks20b;
  g_mk80 = mk80;
}

ProgramConfig get_program_config(int program_index)
{
  const int i = clamp_program_index(program_index);
  return {rom_set_for_family(kProgramRomFamily[i]), kProgramParamsOffset[i], kProgramSampleRate[i]};
}

ProgramRomFamily get_program_rom_family(int program_index)
{
  return kProgramRomFamily[clamp_program_index(program_index)];
}

size_t get_program_params_offset(int program_index)
{
  return kProgramParamsOffset[clamp_program_index(program_index)];
}

int get_program_source_sample_rate(int program_index)
{
  return kProgramSampleRate[clamp_program_index(program_index)];
}
