#include "../include/mcu.h"
#include "../include/rd200_lifted_core.h"
#include "../generated/rd200_rom_b_lifted.h"

#include <algorithm>
#include <utility>
#include <vector>

#define pPC m_pc
#define pX m_x

#define PC m_pc.w.l
#define PCD m_pc.d
#define S m_s.w.l
#define SD m_s.d
#define A m_d.b.h
#define B m_d.b.l
#define CC m_cc

#define RM(Addr) (read_byte(Addr))
#define WM(Addr, Value) (write_byte(Addr, Value))

#define PUSHBYTE(b) \
  do               \
  {                \
    WM(SD, b);     \
    --S;           \
  } while (0)

#define PUSHWORD(w) \
  do                \
  {                 \
    WM(SD, w.b.l);  \
    --S;            \
    WM(SD, w.b.h);  \
    --S;            \
  } while (0)

#define TCSR_IEDG   0x02
#define TCSR_EICI   0x10
#define TCSR_ICF    0x80
#define CT      m_counter.w.l

// Can be 13 bit or 14 bit depending on the model
#define UNSCRAMBLE_ADDR_CPUB(i) \
  bitswap<14>(i,13,12,11,8,9,10,7,6,5,4,3,2,1,0)
#define UNSCRAMBLE_DATA_CPUB(_data) \
  bitswap<8>(_data,7,0,6,1,5,2,4,3)

#define UNSCRAMBLE_ADDR_PARAMS(i) \
  bitswap<17>(i,16,15,13,12,14,11,8,9,10,7,6,5,4,3,2,1,0)
#define UNSCRAMBLE_DATA_PARAMS(_data) \
  bitswap<8>(_data,7,0,6,1,5,2,4,3)

Mcu::Mcu(const u8 *temp_ic5, const u8 *temp_ic6, const u8 *temp_ic7, const u8 *temp_progrom, const u8 *temp_paramsrom)
  : sound_chip(temp_ic5, temp_ic6, temp_ic7)
{
  for (size_t srcpos = 0x00; srcpos < 0x2000; srcpos++) {
    program_rom[srcpos] = UNSCRAMBLE_DATA_CPUB(temp_progrom[UNSCRAMBLE_ADDR_CPUB(srcpos)]);
  }

  loadSounds(temp_ic5, temp_ic6, temp_ic7, temp_paramsrom, 0x00);
  reset();
}

void Mcu::reset()
{
  clearLiftedStats();
  m_pc.d = 0;
  m_s.d = 0;
  m_x.d = 0;
  m_d.d = 0;
  m_cc = 0;
  m_nmi_state = 0;
  m_nmi_pending = 0;
  std::fill(std::begin(m_irq_state), std::end(m_irq_state), 0);

  m_cc = 0xc0;
  m_cc |= 0x10; /* IRQ disabled */
  PCD = RM16(0xfffe);

  m_nmi_state = 0;
  m_nmi_pending = 0;

  ensure_lifted_core();
  m_lifted_core->reset(PCD);

  // We need to run the CPU for a bit before being able to send commands to it.
  for (size_t i = 0; i < 1024 * 8; i++)
    execute_run();
}

Mcu::~Mcu()
{}

Mcu::LiftedStats Mcu::getLiftedStats() const
{
  LiftedStats s;
  s.step_attempts = m_lifted_step_attempts;
  s.lifted_steps = m_lifted_steps;
  s.fallback_steps = m_lifted_fallback_steps;
  s.unlifted_hits = m_lifted_unlifted_hits;
  s.unique_unlifted_pcs = m_lifted_unlifted_pcs.size();
  return s;
}

std::vector<u16> Mcu::getLiftedUnliftedPcs() const
{
  std::vector<u16> pcs;
  pcs.reserve(m_lifted_unlifted_pcs.size());
  for (u16 pc : m_lifted_unlifted_pcs)
    pcs.push_back(pc);
  std::sort(pcs.begin(), pcs.end());
  return pcs;
}

std::vector<std::pair<u16, uint64_t>> Mcu::getLiftedUnliftedPcHits() const
{
  std::vector<std::pair<u16, uint64_t>> hits;
  hits.reserve(m_lifted_unlifted_pc_hits.size());
  for (const auto &it : m_lifted_unlifted_pc_hits)
    hits.push_back(it);
  std::sort(hits.begin(), hits.end(), [](const auto &a, const auto &b) {
    if (a.second != b.second)
      return a.second > b.second;
    return a.first < b.first;
  });
  return hits;
}

void Mcu::clearLiftedStats()
{
  m_lifted_step_attempts = 0;
  m_lifted_steps = 0;
  m_lifted_fallback_steps = 0;
  m_lifted_unlifted_hits = 0;
  m_lifted_unlifted_pcs.clear();
  m_lifted_unlifted_pc_hits.clear();
}

void Mcu::setTraceSink(Rd200TraceSink *trace_sink)
{
  m_trace_sink = trace_sink;
  if (m_lifted_core)
    m_lifted_core->setTraceSink(trace_sink);
}

u16 Mcu::current_pc_for_io() const
{
  return m_has_pc_override ? m_pc_override : PCD;
}

void Mcu::ensure_lifted_core()
{
  if (m_lifted_core)
    return;

  Rd200RomBLiftedCore::Bus bus;
  bus.read8 = [this](u16 addr) { return this->lifted_bus_read(addr); };
  bus.write8 = [this](u16 addr, u8 data) { this->lifted_bus_write(addr, data); };

  Rd200RomBLiftedCore::Config config;
  config.halt_on_unlifted_pc = true;
  config.on_unlifted_pc = [this](u16 pc) {
    m_lifted_unlifted_hits++;
    m_lifted_unlifted_pcs.insert(pc);
    m_lifted_unlifted_pc_hits[pc]++;
  };
  m_lifted_core = std::make_unique<Rd200RomBLiftedCore>(std::move(bus), std::move(config));
  rd200_rom_b_register_blocks(*m_lifted_core);
  m_lifted_core->setTraceSink(m_trace_sink);
}

u8 Mcu::lifted_bus_read(u16 addr)
{
  if (!m_lifted_core)
    return read_byte(addr);

  const bool prev_override = m_has_pc_override;
  const u16 prev_pc = m_pc_override;
  const bool prev_suppress_trace = m_suppress_mcu_trace;

  m_has_pc_override = true;
  m_pc_override = m_lifted_core->state().pc;
  m_suppress_mcu_trace = true;
  const u8 value = read_byte(addr);

  m_has_pc_override = prev_override;
  m_pc_override = prev_pc;
  m_suppress_mcu_trace = prev_suppress_trace;
  return value;
}

void Mcu::lifted_bus_write(u16 addr, u8 data)
{
  if (!m_lifted_core)
  {
    write_byte(addr, data);
    return;
  }

  const bool prev_override = m_has_pc_override;
  const u16 prev_pc = m_pc_override;
  const bool prev_suppress_trace = m_suppress_mcu_trace;

  m_has_pc_override = true;
  m_pc_override = m_lifted_core->state().pc;
  m_suppress_mcu_trace = true;
  write_byte(addr, data);

  m_has_pc_override = prev_override;
  m_pc_override = prev_pc;
  m_suppress_mcu_trace = prev_suppress_trace;
}

bool Mcu::is_traced_mmio_addr(u16 addr) const
{
  if (addr == 0x0002 || addr == 0x0003 || addr == 0x0008 || addr == 0x000d || addr == 0x000e)
    return true;
  if (addr >= 0x1000 && addr < 0x2000)
    return true;
  if (addr >= 0x4000 && addr <= 0xbfff)
    return true;
  return false;
}

Rd200CpuStateSnapshot Mcu::snapshot_state() const
{
  Rd200CpuStateSnapshot s;
  s.cc = m_cc;
  s.a = m_d.b.h;
  s.b = m_d.b.l;
  s.x = m_x.w.l;
  s.s = m_s.w.l;
  s.pc = m_pc.w.l;
  s.tcsr = m_tcsr;
  return s;
}

/* check the IRQ lines for pending interrupts */
void Mcu::check_irq_lines()
{
  if (m_nmi_pending)
  {
    m_nmi_pending = false;
    enter_interrupt("NMI", 0xfffc);
  }
  else if (m_irq_state[M6800_IRQ_LINE] != CLEAR_LINE)
  {
    /* standard IRQ */
    if (!(CC & 0x10))
    {
      // standard_irq_callback(M6800_IRQ_LINE, m_pc.w.l);
      enter_interrupt("IRQ1", 0xfff8);
    }
  }
  else if ((m_tcsr & (TCSR_EICI|TCSR_ICF)) == (TCSR_EICI|TCSR_ICF))
  {
    // if (!(m_cc & 0x10))
    // 	standard_irq_callback(M6801_TIN_LINE, m_pc.w.l);

    if (!(CC & 0x10)) {
      enter_interrupt("ICI", 0xfff6);
    }
  }
}

u32 Mcu::RM16(u32 Addr)
{
  u32 result = RM(Addr) << 8;
  return result | RM((Addr+1) & 0xffff);
}

/* IRQ enter */
void Mcu::enter_interrupt(const char *message, u16 irq_vector)
{
  PUSHWORD(pPC);
  PUSHWORD(pX);
  PUSHBYTE(A);
  PUSHBYTE(B);
  PUSHBYTE(CC);
  m_cc |= 0x10;
  PCD = RM16(irq_vector);
  if (m_trace_sink != nullptr) {
    Rd200CpuStateSnapshot s = snapshot_state();
    m_trace_sink->onIrqEnter(s.pc, irq_vector, message, s);
    m_trace_sink->onStateSnapshot(s.pc, "irq_boundary", s);
  }
}

void Mcu::execute_set_input(int irqline, int state)
{
  ensure_lifted_core();

  switch (irqline)
  {
  case INPUT_LINE_NMI:
    if (!m_nmi_state && state != CLEAR_LINE)
      m_nmi_pending = true;
    m_nmi_state = state;
    if (m_lifted_core)
      m_lifted_core->set_nmi_level(state != CLEAR_LINE);
    break;

  case M6801_TIN_LINE:
    if (state != m_irq_state[M6801_TIN_LINE])
    {
      m_irq_state[M6801_TIN_LINE] = state;
      if (m_lifted_core)
        m_lifted_core->set_tin_level(state != CLEAR_LINE);
    }
    break;

  default:
    m_irq_state[irqline] = state;
    if (m_lifted_core && irqline == M6800_IRQ_LINE)
      m_lifted_core->set_irq1_level(state != CLEAR_LINE);
    break;
  }
}

void Mcu::execute_run()
{
  ensure_lifted_core();

  if (!commands_queue.empty())
    execute_set_input(M6801_TIN_LINE, ASSERT_LINE);

  execute_set_input(0, sound_chip.m_irq_triggered ? ASSERT_LINE : CLEAR_LINE);

  m_lifted_step_attempts++;
  if (m_lifted_core->step())
  {
    m_lifted_steps++;
    return;
  }

  m_lifted_fallback_steps++;
}

u8 Mcu::tcsr_r()
{
  m_pending_tcsr = 0;
  return m_tcsr;
}

void Mcu::tcsr_w(u8 data)
{
  data &= 0x1f;

  m_tcsr = data | (m_tcsr & 0xe0);
  m_pending_tcsr &= m_tcsr;
}


u8 Mcu::read_byte(u16 addr)
{
  const u16 io_pc = current_pc_for_io();
  u8 value = 0xff;

  // program rom
  if (addr >= 0xc000)
    value = program_rom[(addr - 0xc000) & 0x1fff];
  
  // port 1 DATA
  else if (addr == 0x0002) {
    u8 data_comm_bus = 0xff;

    // HACK: only works with the RD200 ROM
    if (!commands_queue.empty() && (io_pc == 0xE12B || io_pc == 0xE15E || io_pc == 0xE168))
    {
      data_comm_bus = commands_queue.front();
      commands_queue.pop();
    }

    value = data_comm_bus;
  }
  
  // port 2 CONTROL
  else if (addr == 0x0003) {
    // HACK: only works with the RD200 ROM
    if (io_pc == 0xE15A) value = 0xFF;
    else value = 0x00;
  }

  // tcsr
  else if (addr == 0x0008)
    value = tcsr_r();
  else if (addr == 0x000d) {
    if (!(m_pending_tcsr & TCSR_ICF))
      m_tcsr &= ~TCSR_ICF;
    value = (m_input_capture >> 0) & 0xff;
  }
  else if (addr == 0x000e) {
    value = (m_input_capture >> 8) & 0xff;
  }
  
  else if (addr < 0x20) {
    value = 0xFF;
  }
  
  // ram
  else if (addr < 0x1000)
    value = ram[addr];
  
  // sound chip
  else if (addr < 0x2000)
    value = sound_chip.read(addr - 0x1000);
  
  // params rom
  else if (addr >= 0x4000 && addr <= 0xbfff)
    value = params_rom[(addr - 0x4000) | ((latch_val & 0b11) << 15)];
  else {
    value = 0xFF;
  }

  if (!m_suppress_mcu_trace && m_trace_sink != nullptr && is_traced_mmio_addr(addr))
    m_trace_sink->onMmioRead(io_pc, addr, value);

  return value;
}

void Mcu::write_byte(u16 addr, u8 data)
{
  const u16 io_pc = current_pc_for_io();

  // port dir
  if (addr == 0x0000 || addr == 0x0001) {
    // noop
  }

  // port 1 DATA
  else if (addr == 0x0002) {
  }
  
  // port 2 CONTROL
  else if (addr == 0x0003) {
    // TODO: Currently not working, investigate
    current_sample_rate = (data >> 2) & 1;

    execute_set_input(M6801_TIN_LINE, CLEAR_LINE);
  }
  
  // tcsr
  else if (addr == 0x0008) {
    tcsr_w(data);
  }
  
  else if (addr < 0x20) {
    (void)data;
  }
  
  // ram
  else if (addr < 0x1000) {
    ram[addr] = data;
  }
  
  // sound chip
  else if (addr >= 0x1000 && addr < 0x2000) {
    sound_chip.write(addr - 0x1000, data);

    if (sound_chip.m_irq_triggered) {
      sound_chip.m_irq_triggered = false;
      execute_set_input(0, CLEAR_LINE);
    }
  }
  
  // latch
  else {
    latch_val = data;
  }

  if (!m_suppress_mcu_trace && m_trace_sink != nullptr && (is_traced_mmio_addr(addr) || addr >= 0x2000))
    m_trace_sink->onMmioWrite(io_pc, addr, data);
}

s32 Mcu::generate_next_sample(bool sampleRate32)
{
  s32 sample = sound_chip.update();

  // 20kHz sample rate, 2000kHz CPU clock
  for (size_t cycle = 0; cycle < (sampleRate32 ? 62 : 100); cycle++) {
    execute_run();
  }

  return sample;
}

void Mcu::sendMidiCmd(u8 data1, u8 data2, u8 data3)
{
  uint8_t command = data1 >> 4;

  // program change
  if (command == 0xC) {
    commands_queue.push(0x30 | (data2 & 0xF));
  }

  // note off
  else if (command == 0x8 || (command == 0x9 && data3 == 0)) {
    commands_queue.push(0xB0);
    commands_queue.push(data2);
    commands_queue.push(0x00);
  }
  
  // note on
  else if (command == 0x9) {
    commands_queue.push(0xC0);
    commands_queue.push(data2);
    commands_queue.push(data3);
  }
  
  // sustain
  else if (command == 0xB && data2 == 64) {
     commands_queue.push(0x50 | (data3 >= 64 ? 0xF : 0x0));
  }

  // sostenuto
  else if (command == 0xB && data2 == 66) {
    commands_queue.push(0x60 | (data3 >= 64 ? 0xF : 0x0));
  }

  // soft pedal
  else if (command == 0xB && data2 == 67) {
    commands_queue.push(0x70 | (data3 >= 64 ? 0xF : 0x0));
  }
}

void Mcu::loadSounds(const u8 *temp_ic5, const u8 *temp_ic6, const u8 *temp_ic7, const u8 *temp_paramsrom, size_t from_addr)
{
  sound_chip.load_samples(temp_ic5, temp_ic6, temp_ic7);
  
  for (size_t srcpos = 0x00; srcpos < 0x20000; srcpos++) {
    params_rom_tmp[srcpos] = UNSCRAMBLE_DATA_CPUB(temp_paramsrom[UNSCRAMBLE_ADDR_PARAMS(srcpos)]);
  }

  for (size_t srcpos = 0x00; srcpos < 0x20000; srcpos++) {
    params_rom[srcpos] = 0xff;
  }
  
  size_t from_addr_aligned = from_addr >> 15 << 15;
  for (size_t srcpos = 0x00; srcpos < 0x8000; srcpos++) {
    params_rom[srcpos+0x8000] = params_rom_tmp[srcpos+from_addr_aligned];
  }

  size_t target = (from_addr - from_addr_aligned) + 0x4000;
  params_rom[0x00] = 0x01;
  params_rom[0x01] = (target >> 8) & 0xff;
  params_rom[0x02] = target & 0xff;
}
