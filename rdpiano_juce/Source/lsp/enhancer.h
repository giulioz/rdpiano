/*
  ==============================================================================

    enhancer.h
    Created: 12 Jul 2025 8:51:22pm
    Author:  Giulio Zausa

  ==============================================================================
*/

#pragma once

#include <cmath>
#include <stdint.h>

class Enhancer {
public:
  void process();
  void reset();

  int32_t audioInL;
  int32_t audioInR;
  int32_t audioOutL;
  int32_t audioOutR;

private:
  int32_t accA;
  uint8_t bufferPos;
  int32_t iram[0x200];

  inline void writeMemOffs(uint8_t memOffs, int32_t value) {
    uint32_t ramPos = ((uint32_t)memOffs + bufferPos) & 0x7f;
    iram[ramPos] = value;
  }
  inline int64_t readMemOffs(uint8_t memOffs) {
    uint32_t ramPos = ((uint32_t)memOffs + bufferPos) & 0x7f;
    return iram[ramPos];
  }
};
