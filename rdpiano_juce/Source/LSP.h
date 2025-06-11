/*
  ==============================================================================

    LSP.h
    Created: 11 Jun 2025 3:43:55am
    Author:  Giulio Zausa

  ==============================================================================
*/

#pragma once

#include <cstdint>
#include <fstream>
#include <limits>
#include <queue>
#include <stdio.h>
#include <stdlib.h>
#include <string>

static constexpr int32_t sign_extend_24(int32_t x) {
  x &= 0xffffff;
  if (x & 0x800000) // If sign bit is set
    x |= ~0xffffff;
  return x;
}

static constexpr int DATA_BITS = 24;
static constexpr int64_t MIN_VAL = -(1LL << (DATA_BITS - 1));
static constexpr int64_t MAX_VAL = (1LL << (DATA_BITS - 1)) - 1;
static constexpr int64_t MASK = (1LL << DATA_BITS) - 1;
static constexpr int32_t clamp_24(int64_t v) {
  if (v > MAX_VAL)
    return static_cast<int32_t>(MAX_VAL);
  if (v < MIN_VAL)
    return static_cast<int32_t>(MIN_VAL);
  return static_cast<int32_t>(v);
}

class DspAccumulator {
  int32_t acc = 0;
  std::array<int32_t, 8> hist{};
  std::size_t head = 0;

public:
  inline void set(int32_t v) { acc = v; }
  inline void add(int32_t v) { acc += v; }

  inline void abs() {
    if (acc < 0)
      acc = -acc;
  }

  inline int32_t sat24() const { return clamp_24(acc); }
  inline int32_t raw24() const { return sign_extend_24(acc & MASK); }

  inline int32_t historySat24(std::size_t n) const {
    std::size_t idx = (head - n) & 7;
    return clamp_24(hist[idx]);
  }
  inline int32_t historyRaw24(std::size_t n) const {
    std::size_t idx = (head - n) & 7;
    return sign_extend_24(hist[idx] & MASK);
  }

  inline void fwdPipeline() { head = (head + 1) & 7; }
  inline void storePipeline() { hist[head] = acc; }
};

struct RamOperationStage2 {
  bool isWrite = false;
  uint16_t addr = 0;
  int32_t writeData = 0;
  bool active = false;
  uint8_t stage = 0;

  int32_t *eram;
  std::queue<int32_t> *eramReadFifo;

  RamOperationStage2(int32_t *eram, std::queue<int32_t> *eramReadFifo);
  void start(bool isWrite, uint16_t addr, uint8_t stage);
  void tick(int32_t eramWriteLatch);
};

struct RamOperationStage1 {
  uint32_t addr = 0;
  uint8_t stage = 0;
  bool isWrite = false;
  bool active = false;
  uint8_t startCommand = 0;

  void startTransaction(uint8_t command, uint16_t baseAddr, int32_t offsetAddr);
  bool sendCommand(RamOperationStage2 &ramStage2, uint8_t command,
                   uint16_t baseAddr, int32_t offsetAddr);
};

class LspState {
public:
  // Public audio inteface
  int32_t audioInL = 0;
  int32_t audioInR = 0;
  int32_t audioOutL = 0;
  int32_t audioOutR = 0;

  // Internal state
  DspAccumulator accA;
  DspAccumulator accB;
  uint8_t bufferPos = 0;
  int32_t iram[0x200] = {0};
  uint16_t pc = 0x80;

  // External RAM
  int32_t eram[0x10000] = {0};
  uint16_t eramPos = 0;
  std::queue<int32_t> eramReadFifo;
  RamOperationStage1 ramStage1;
  RamOperationStage2 ramStage2;

  // Pipeline
  uint8_t prevRR = 0;

  // Special regs
  int32_t eramWriteLatch = 0;    // 0x10
  int32_t eramSecondTapOffs = 0; // 0x13
  int32_t multiplCoef1 = 0;      // 0x14
  int32_t multiplCoef2 = 0;      // 0x15
  int32_t audioOut = 0;          // 0x18
  int32_t audioIn = 0;           // 0x1e

  LspState();
  void runProgram();

private:
  void step(uint32_t instr);
  void commonDoEram(uint8_t command);
  void commonDoStore(uint8_t ii, uint8_t rr);
  int32_t commonGetMemOrImmediate(uint8_t rr, int8_t cc);
  void doInstrMac(uint8_t ii, uint8_t rr, int8_t cc);
  void doInstrMul(uint8_t ii, uint8_t rr, int8_t cc);
  void doInstrSpecialReg(uint8_t ii, uint8_t rr, int8_t cc);
  void writeMemOffs(uint8_t memOffs, int32_t value);
  int64_t readMemOffs(uint8_t memOffs);
};
