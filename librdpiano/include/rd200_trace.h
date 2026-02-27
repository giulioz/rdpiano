#ifndef RD200_TRACE_H
#define RD200_TRACE_H

#include <cstdint>
#include <cstdio>

struct Rd200CpuStateSnapshot {
  uint8_t cc = 0;
  uint8_t a = 0;
  uint8_t b = 0;
  uint16_t x = 0;
  uint16_t s = 0;
  uint16_t pc = 0;
  uint8_t tcsr = 0;
};

class Rd200TraceSink {
public:
  virtual ~Rd200TraceSink() = default;
  virtual void onMmioRead(uint16_t pc, uint16_t addr, uint8_t value) = 0;
  virtual void onMmioWrite(uint16_t pc, uint16_t addr, uint8_t value) = 0;
  virtual void onIrqEnter(uint16_t pc, uint16_t vector, const char *name, const Rd200CpuStateSnapshot &state) = 0;
  virtual void onRti(uint16_t pc, const Rd200CpuStateSnapshot &state) = 0;
  virtual void onStateSnapshot(uint16_t pc, const char *reason, const Rd200CpuStateSnapshot &state) = 0;
};

class Rd200JsonlTraceSink final : public Rd200TraceSink {
public:
  explicit Rd200JsonlTraceSink(FILE *f);

  void onMmioRead(uint16_t pc, uint16_t addr, uint8_t value) override;
  void onMmioWrite(uint16_t pc, uint16_t addr, uint8_t value) override;
  void onIrqEnter(uint16_t pc, uint16_t vector, const char *name, const Rd200CpuStateSnapshot &state) override;
  void onRti(uint16_t pc, const Rd200CpuStateSnapshot &state) override;
  void onStateSnapshot(uint16_t pc, const char *reason, const Rd200CpuStateSnapshot &state) override;

private:
  void print_state_fields(const Rd200CpuStateSnapshot &state);
  FILE *m_file = nullptr;
  uint64_t m_seq = 0;
};

#endif
