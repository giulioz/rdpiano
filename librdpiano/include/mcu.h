#ifndef MCU_H
#define MCU_H

#include <cstdint>
#include <cstdio>
#include <memory>
#include <queue>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "mame_utils.h"
#include "rd200_trace.h"
#include "sound_chip.h"

class Rd200RomBLiftedCore;

enum
{
  M6800_IRQ_LINE = 0,
  M6800_LINE_MAX
};

enum
{
  M6801_TIN_LINE = M6800_LINE_MAX,
  M6801_IS3_LINE,
  M6801_STBY_LINE,
  M6801_LINE_MAX
};

class Mcu
{
public:
  struct LiftedStats {
    uint64_t step_attempts = 0;
    uint64_t lifted_steps = 0;
    uint64_t fallback_steps = 0;
    uint64_t unlifted_hits = 0;
    size_t unique_unlifted_pcs = 0;
  };

  Mcu(const u8 *temp_ic5, const u8 *temp_ic6, const u8 *temp_ic7, const u8 *temp_progrom, const u8 *temp_paramsrom);
  ~Mcu();

  void execute_set_input(int irqline, int state);
  void execute_run();

  std::queue<u8> commands_queue;

  s32 generate_next_sample(bool sampleRate32 = false);
  bool current_sample_rate = false;

  void sendMidiCmd(u8 cmd, u8 data1, u8 data2);
  void loadSounds(const u8 *temp_ic5, const u8 *temp_ic6, const u8 *temp_ic7, const u8 *temp_paramsrom, size_t from_addr);
  void reset();
  void setTraceSink(Rd200TraceSink *trace_sink);
  LiftedStats getLiftedStats() const;
  std::vector<u16> getLiftedUnliftedPcs() const;
  std::vector<std::pair<u16, uint64_t>> getLiftedUnliftedPcHits() const;
  void clearLiftedStats();

private:
  u8 read_byte(u16 addr);
  void write_byte(u16 addr, u8 data);
  u8 lifted_bus_read(u16 addr);
  void lifted_bus_write(u16 addr, u8 data);
  void ensure_lifted_core();
  u16 current_pc_for_io() const;

  void check_irq_lines();
  u32 RM16(u32 addr);
  void enter_interrupt(const char *message, u16 irq_vector);
  void increment_counter(int amount);

  u8 tcsr_r();
  void tcsr_w(u8 data);
  bool is_traced_mmio_addr(u16 addr) const;
  Rd200CpuStateSnapshot snapshot_state() const;

  SoundChip sound_chip;

  u8 latch_val = 0x00;
  u8 program_rom[0x2000];
  u8 params_rom[0x20000];
  u8 params_rom_tmp[0x20000];
  u8 ram[0x10000] = {0};

  PAIR m_pc = {0, 0};
  PAIR m_s = {0, 0};
  PAIR m_x = {0, 0};
  PAIR m_d = {0, 0};
  u8 m_cc = 0;
  u8 m_wai_state = 0;
  u8 m_nmi_state = 0;
  u8 m_nmi_pending = 0;
  u8 m_irq_state[5] = {0};

  u8 m_tcsr = 0;
  PAIR m_counter = {0, 0};
  u8 m_pending_tcsr = 0;
  u16 m_input_capture = 0;

  int m_icount = 0;
  Rd200TraceSink *m_trace_sink = nullptr;
  std::unique_ptr<Rd200RomBLiftedCore> m_lifted_core;
  bool m_has_pc_override = false;
  u16 m_pc_override = 0;
  bool m_suppress_mcu_trace = false;

  uint64_t m_lifted_step_attempts = 0;
  uint64_t m_lifted_steps = 0;
  uint64_t m_lifted_fallback_steps = 0;
  uint64_t m_lifted_unlifted_hits = 0;
  std::unordered_set<u16> m_lifted_unlifted_pcs;
  std::unordered_map<u16, uint64_t> m_lifted_unlifted_pc_hits;

  enum
  {
    M6800_WAI = 8,
    M6800_SLP = 0x10
  };
};

#endif
