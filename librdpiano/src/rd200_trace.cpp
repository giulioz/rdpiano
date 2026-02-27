#include "../include/rd200_trace.h"

Rd200JsonlTraceSink::Rd200JsonlTraceSink(FILE *f) : m_file(f) {}

void Rd200JsonlTraceSink::print_state_fields(const Rd200CpuStateSnapshot &state)
{
  std::fprintf(m_file,
               "\"cc\":%u,\"a\":%u,\"b\":%u,\"x\":%u,\"s\":%u,\"pc_state\":%u,\"tcsr\":%u",
               state.cc, state.a, state.b, state.x, state.s, state.pc, state.tcsr);
}

void Rd200JsonlTraceSink::onMmioRead(uint16_t pc, uint16_t addr, uint8_t value)
{
  std::fprintf(m_file,
               "{\"seq\":%llu,\"kind\":\"mmio_read\",\"pc\":%u,\"addr\":%u,\"value\":%u}\n",
               static_cast<unsigned long long>(m_seq++), pc, addr, value);
}

void Rd200JsonlTraceSink::onMmioWrite(uint16_t pc, uint16_t addr, uint8_t value)
{
  std::fprintf(m_file,
               "{\"seq\":%llu,\"kind\":\"mmio_write\",\"pc\":%u,\"addr\":%u,\"value\":%u}\n",
               static_cast<unsigned long long>(m_seq++), pc, addr, value);
}

void Rd200JsonlTraceSink::onIrqEnter(uint16_t pc, uint16_t vector, const char *name,
                                     const Rd200CpuStateSnapshot &state)
{
  std::fprintf(m_file,
               "{\"seq\":%llu,\"kind\":\"irq_enter\",\"pc\":%u,\"vector\":%u,\"name\":\"%s\",",
               static_cast<unsigned long long>(m_seq++), pc, vector, name ? name : "");
  print_state_fields(state);
  std::fprintf(m_file, "}\n");
}

void Rd200JsonlTraceSink::onRti(uint16_t pc, const Rd200CpuStateSnapshot &state)
{
  std::fprintf(m_file, "{\"seq\":%llu,\"kind\":\"rti\",\"pc\":%u,",
               static_cast<unsigned long long>(m_seq++), pc);
  print_state_fields(state);
  std::fprintf(m_file, "}\n");
}

void Rd200JsonlTraceSink::onStateSnapshot(uint16_t pc, const char *reason, const Rd200CpuStateSnapshot &state)
{
  std::fprintf(m_file,
               "{\"seq\":%llu,\"kind\":\"state_snapshot\",\"pc\":%u,\"reason\":\"%s\",",
               static_cast<unsigned long long>(m_seq++), pc, reason ? reason : "");
  print_state_fields(state);
  std::fprintf(m_file, "}\n");
}
