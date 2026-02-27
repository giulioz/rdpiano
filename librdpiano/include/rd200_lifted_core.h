#ifndef RD200_LIFTED_CORE_H
#define RD200_LIFTED_CORE_H

#include <array>
#include <cstddef>
#include <cstdint>
#include <functional>

#include "mame_utils.h"
#include "rd200_trace.h"

// Scaffold for progressively replacing rd200_rom_b CPU emulation with lifted blocks.
// The core owns CPU-visible state and interrupt/timer side effects; memory/IO is delegated
// to callbacks so lifted code can be integrated without changing board code all at once.
class Rd200RomBLiftedCore {
public:
  struct CpuState {
    u16 pc = 0;
    u16 s = 0;
    u16 x = 0;
    u8 a = 0;
    u8 b = 0;
    u8 cc = 0;

    u8 tcsr = 0;
    u8 pending_tcsr = 0;
    u16 input_capture = 0;
    u16 free_running_counter = 0;

    bool wai = false;
    bool slp = false;
    bool nmi_pending = false;
    bool nmi_level = false;
    bool irq1_level = false;
    bool tin_level = false;
    bool in_ici_handler = false;
  };

  struct Bus {
    std::function<u8(u16)> read8;
    std::function<void(u16, u8)> write8;
  };

  struct Config {
    bool strict_dead_ops = false;
    bool halt_on_unlifted_pc = true;
    std::function<void(u16)> on_unlifted_pc;
  };

  using BlockFn = void (*)(Rd200RomBLiftedCore &);

  explicit Rd200RomBLiftedCore(Bus bus);
  Rd200RomBLiftedCore(Bus bus, Config config);

  void reset(u16 reset_vector);
  bool step();
  void run_steps(size_t steps);

  void register_block(u16 pc, BlockFn fn);
  void clear_blocks();
  bool has_block(u16 pc) const;

  void set_irq1_level(bool asserted);
  void set_nmi_level(bool asserted);
  void set_tin_level(bool level);

  CpuState &state();
  const CpuState &state() const;

  u8 read8(u16 addr);
  void write8(u16 addr, u8 data);
  u16 read16(u16 addr);
  void write16(u16 addr, u16 data);

  void push8(u8 v);
  void push16(u16 v);
  u8 pop8();
  u16 pop16();

  void enter_irq1();
  void enter_ici();
  void enter_nmi();
  void enter_interrupt(u16 vector, const char *name);

  void rti();

  void branch_rel8(s8 delta);
  void set_pc(u16 next_pc);
  bool halted() const;
  void halt();
  void setTraceSink(Rd200TraceSink *trace_sink);

private:
  static constexpr u8 CC_I = 0x10;
  static constexpr u8 TCSR_IEDG = 0x02;
  static constexpr u8 TCSR_EICI = 0x10;
  static constexpr u8 TCSR_ICF = 0x80;

  bool interrupt_masked() const;
  void check_interrupts();
  u8 tcsr_read();
  void tcsr_write(u8 data);
  bool is_traced_mmio_addr(u16 addr) const;
  Rd200CpuStateSnapshot snapshot_state() const;

  Bus m_bus;
  Config m_config;
  CpuState m_state;
  bool m_halted = false;
  std::array<BlockFn, 65536> m_blocks{};
  Rd200TraceSink *m_trace_sink = nullptr;
};

#endif
