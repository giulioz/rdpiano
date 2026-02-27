#include "../include/rd200_lifted_core.h"

#include <utility>

Rd200RomBLiftedCore::Rd200RomBLiftedCore(Bus bus)
    : Rd200RomBLiftedCore(std::move(bus), Config{})
{
}

Rd200RomBLiftedCore::Rd200RomBLiftedCore(Bus bus, Config config)
    : m_bus(std::move(bus)), m_config(std::move(config))
{
}

void Rd200RomBLiftedCore::reset(u16 reset_vector)
{
  m_state = {};
  m_state.pc = reset_vector;
  m_state.cc = 0xc0 | CC_I;
  m_halted = false;
}

bool Rd200RomBLiftedCore::step()
{
  if (m_halted)
    return false;

  check_interrupts();
  if (m_halted)
    return false;

  u16 executed_pc = m_state.pc;
  BlockFn fn = m_blocks[executed_pc];
  if (!fn)
  {
    if (m_config.on_unlifted_pc)
      m_config.on_unlifted_pc(m_state.pc);
    if (m_config.halt_on_unlifted_pc)
      m_halted = true;
    return false;
  }

  fn(*this);

  if (!m_config.enable_linear_chaining)
    return true;

  size_t chained = 0;
  while (!m_halted && chained < m_config.max_chain_blocks)
  {
    const u16 expected_next = m_linear_next[executed_pc];
    if (expected_next == 0 || m_state.pc != expected_next)
      break;

    // Preserve interrupt boundary semantics between original blocks.
    check_interrupts();
    if (m_halted || m_state.pc != expected_next)
      break;

    executed_pc = m_state.pc;
    BlockFn next_fn = m_blocks[executed_pc];
    if (!next_fn)
      break;

    next_fn(*this);
    ++chained;
  }

  return true;
}

void Rd200RomBLiftedCore::run_steps(size_t steps)
{
  for (size_t i = 0; i < steps && !m_halted; i++)
    step();
}

void Rd200RomBLiftedCore::register_block(u16 pc, BlockFn fn)
{
  m_blocks[pc] = fn;
}

void Rd200RomBLiftedCore::register_linear_next(u16 from_pc, u16 to_pc)
{
  m_linear_next[from_pc] = to_pc;
}

void Rd200RomBLiftedCore::clear_blocks()
{
  m_blocks.fill(nullptr);
  m_linear_next.fill(0);
}

bool Rd200RomBLiftedCore::has_block(u16 pc) const
{
  return m_blocks[pc] != nullptr;
}

void Rd200RomBLiftedCore::set_irq1_level(bool asserted)
{
  m_state.irq1_level = asserted;
}

void Rd200RomBLiftedCore::set_nmi_level(bool asserted)
{
  if (!m_state.nmi_level && asserted)
    m_state.nmi_pending = true;
  m_state.nmi_level = asserted;
}

void Rd200RomBLiftedCore::set_tin_level(bool level)
{
  if (level == m_state.tin_level)
    return;

  m_state.tin_level = level;

  // Mirror current emulator behavior: set capture on active edge selected by TCSR.IEDG.
  if (((m_state.tcsr & TCSR_IEDG) ^ (level ? 0 : TCSR_IEDG)) == 0)
    return;

  m_state.tcsr |= TCSR_ICF;
  m_state.pending_tcsr |= TCSR_ICF;
  m_state.input_capture = m_state.free_running_counter;
}

Rd200RomBLiftedCore::CpuState &Rd200RomBLiftedCore::state()
{
  return m_state;
}

const Rd200RomBLiftedCore::CpuState &Rd200RomBLiftedCore::state() const
{
  return m_state;
}

u8 Rd200RomBLiftedCore::read8(u16 addr)
{
  u8 value = 0xff;

  if (addr >= 0xc000 && m_bus.program_rom != nullptr)
    value = m_bus.program_rom[(addr - 0xc000) & 0x1fff];
  else if (addr == 0x0008)
    value = tcsr_read();
  else if (addr == 0x000d)
  {
    if (!(m_state.pending_tcsr & TCSR_ICF))
      m_state.tcsr &= ~TCSR_ICF;
    value = static_cast<u8>(m_state.input_capture & 0xff);
  }
  else if (addr == 0x000e)
    value = static_cast<u8>((m_state.input_capture >> 8) & 0xff);
  else if (addr >= 0x0020 && addr < 0x1000)
    value = m_state.ram[addr];
  else if (addr >= 0x4000 && addr <= 0xbfff && m_bus.params_rom != nullptr)
    value = m_bus.params_rom[(addr - 0x4000) | ((m_state.latch_val & 0x03) << 15)];
  else if (m_bus.mmio_read8)
    value = m_bus.mmio_read8(addr, m_state.pc);

  if (m_trace_sink != nullptr && is_traced_mmio_addr(addr))
    m_trace_sink->onMmioRead(m_state.pc, addr, value);

  return value;
}

void Rd200RomBLiftedCore::write8(u16 addr, u8 data)
{
  if (addr == 0x0008)
  {
    tcsr_write(data);
  }
  else if (addr >= 0x0020 && addr < 0x1000)
  {
    m_state.ram[addr] = data;
  }
  else if (addr >= 0x2000)
  {
    m_state.latch_val = data;
  }
  else if (m_bus.mmio_write8)
    m_bus.mmio_write8(addr, data, m_state.pc);

  if (m_trace_sink != nullptr && (is_traced_mmio_addr(addr) || addr >= 0x2000))
    m_trace_sink->onMmioWrite(m_state.pc, addr, data);
}

u16 Rd200RomBLiftedCore::read16(u16 addr)
{
  return (static_cast<u16>(read8(addr)) << 8) | read8(addr + 1);
}

void Rd200RomBLiftedCore::write16(u16 addr, u16 data)
{
  write8(addr, static_cast<u8>((data >> 8) & 0xff));
  write8(addr + 1, static_cast<u8>(data & 0xff));
}

u8 Rd200RomBLiftedCore::read8_fast(u16 addr)
{
  if (addr >= 0x0020 && addr < 0x1000)
    return m_state.ram[addr];
  return read8(addr);
}

void Rd200RomBLiftedCore::write8_fast(u16 addr, u8 data)
{
  if (addr >= 0x0020 && addr < 0x1000)
  {
    m_state.ram[addr] = data;
    return;
  }
  write8(addr, data);
}

u16 Rd200RomBLiftedCore::read16_fast(u16 addr)
{
  if (addr >= 0x0020 && addr < 0x0fff)
    return static_cast<u16>((static_cast<u16>(m_state.ram[addr]) << 8) | m_state.ram[addr + 1]);
  return read16(addr);
}

void Rd200RomBLiftedCore::write16_fast(u16 addr, u16 data)
{
  if (addr >= 0x0020 && addr < 0x0fff)
  {
    m_state.ram[addr] = static_cast<u8>((data >> 8) & 0xff);
    m_state.ram[addr + 1] = static_cast<u8>(data & 0xff);
    return;
  }
  write16(addr, data);
}

u8 Rd200RomBLiftedCore::ram_read8(u16 addr) const
{
  return m_state.ram[addr];
}

void Rd200RomBLiftedCore::ram_write8(u16 addr, u8 data)
{
  m_state.ram[addr] = data;
}

u16 Rd200RomBLiftedCore::ram_read16(u16 addr) const
{
  return static_cast<u16>((static_cast<u16>(m_state.ram[addr]) << 8) | m_state.ram[addr + 1]);
}

void Rd200RomBLiftedCore::ram_write16(u16 addr, u16 data)
{
  m_state.ram[addr] = static_cast<u8>((data >> 8) & 0xff);
  m_state.ram[addr + 1] = static_cast<u8>(data & 0xff);
}

void Rd200RomBLiftedCore::push8(u8 v)
{
  write8(m_state.s, v);
  m_state.s--;
}

void Rd200RomBLiftedCore::push16(u16 v)
{
  push8(static_cast<u8>(v & 0xff));
  push8(static_cast<u8>((v >> 8) & 0xff));
}

u8 Rd200RomBLiftedCore::pop8()
{
  m_state.s++;
  return read8(m_state.s);
}

u16 Rd200RomBLiftedCore::pop16()
{
  const u16 hi = pop8();
  const u16 lo = pop8();
  return static_cast<u16>((hi << 8) | lo);
}

void Rd200RomBLiftedCore::enter_irq1()
{
  enter_interrupt(0xfff8, "IRQ1");
}

void Rd200RomBLiftedCore::enter_ici()
{
  enter_interrupt(0xfff6, "ICI");
}

void Rd200RomBLiftedCore::enter_nmi()
{
  enter_interrupt(0xfffc, "NMI");
}

void Rd200RomBLiftedCore::enter_interrupt(u16 vector, const char *name)
{
  const bool from_wai = m_state.wai;

  if (from_wai)
  {
    m_state.wai = false;
  }
  else
  {
    push16(m_state.pc);
    push16(m_state.x);
    push8(m_state.a);
    push8(m_state.b);
    push8(m_state.cc);
  }

  if (vector == 0xfff6)
    m_state.in_ici_handler = true;

  m_state.cc |= CC_I;
  m_state.pc = read16(vector);

  if (m_trace_sink != nullptr)
  {
    Rd200CpuStateSnapshot s = snapshot_state();
    m_trace_sink->onIrqEnter(s.pc, vector, name, s);
    m_trace_sink->onStateSnapshot(s.pc, "irq_boundary", s);
  }
}

void Rd200RomBLiftedCore::rti()
{
  m_state.cc = pop8();
  m_state.b = pop8();
  m_state.a = pop8();
  m_state.x = pop16();
  m_state.pc = pop16();
  m_state.in_ici_handler = false;

  if (m_trace_sink != nullptr)
  {
    Rd200CpuStateSnapshot s = snapshot_state();
    m_trace_sink->onRti(s.pc, s);
    m_trace_sink->onStateSnapshot(s.pc, "rti_boundary", s);
  }
}

void Rd200RomBLiftedCore::branch_rel8(s8 delta)
{
  m_state.pc = static_cast<u16>(m_state.pc + delta);
}

void Rd200RomBLiftedCore::set_pc(u16 next_pc)
{
  m_state.pc = next_pc;
}

bool Rd200RomBLiftedCore::halted() const
{
  return m_halted;
}

void Rd200RomBLiftedCore::halt()
{
  m_halted = true;
}

void Rd200RomBLiftedCore::setTraceSink(Rd200TraceSink *trace_sink)
{
  m_trace_sink = trace_sink;
}

bool Rd200RomBLiftedCore::interrupt_masked() const
{
  return (m_state.cc & CC_I) != 0;
}

void Rd200RomBLiftedCore::check_interrupts()
{
  if (m_state.nmi_pending)
  {
    m_state.slp = false;
    m_state.nmi_pending = false;
    enter_nmi();
    return;
  }

  if (m_state.irq1_level)
  {
    m_state.slp = false;
    if (!interrupt_masked())
      enter_irq1();
    return;
  }

  if ((m_state.tcsr & (TCSR_EICI | TCSR_ICF)) == (TCSR_EICI | TCSR_ICF))
  {
    m_state.slp = false;
    if (!interrupt_masked())
      enter_ici();
  }
}

u8 Rd200RomBLiftedCore::tcsr_read()
{
  m_state.pending_tcsr = 0;
  return m_state.tcsr;
}

void Rd200RomBLiftedCore::tcsr_write(u8 data)
{
  data &= 0x1f;
  m_state.tcsr = data | (m_state.tcsr & 0xe0);
  m_state.pending_tcsr &= m_state.tcsr;
  check_interrupts();
}

bool Rd200RomBLiftedCore::is_traced_mmio_addr(u16 addr) const
{
  if (addr == 0x0002 || addr == 0x0003 || addr == 0x0008 || addr == 0x000d || addr == 0x000e)
    return true;
  if (addr >= 0x1000 && addr < 0x2000)
    return true;
  if (addr >= 0x4000 && addr <= 0xbfff)
    return true;
  return false;
}

Rd200CpuStateSnapshot Rd200RomBLiftedCore::snapshot_state() const
{
  Rd200CpuStateSnapshot s;
  s.cc = m_state.cc;
  s.a = m_state.a;
  s.b = m_state.b;
  s.x = m_state.x;
  s.s = m_state.s;
  s.pc = m_state.pc;
  s.tcsr = m_state.tcsr;
  return s;
}
