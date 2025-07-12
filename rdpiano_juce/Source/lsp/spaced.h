/*
  ==============================================================================

    spaced.h
    Created: 12 Jul 2025 3:32:22pm
    Author:  Giulio Zausa

  ==============================================================================
*/

#pragma once

#include <cmath>
#include <stdint.h>


extern int32_t spaceDRateTable[];
extern int32_t spaceDDepthTable[];

inline int32_t spaceDRateFromMs(float ms) { return ms * 498.0f; }
inline int32_t spaceDDepth(float amount) {
  return spaceDDepthTable[(int)floor(amount * 0x80)];
}

class SpaceD {
public:
  void process();
  void reset();

  int32_t audioInL;
  int32_t audioInR;
  int32_t audioOutL;
  int32_t audioOutR;

  int32_t level;
  int32_t depth;
  int32_t rate;
  int32_t phase;
  int32_t amountWet;
  int32_t amountDry;
  int32_t preDelay1;
  int32_t preDelay2;

private:
  int32_t accA;
  int32_t accB;
  uint8_t bufferPos;
  uint16_t eramPos;
  int32_t eramWriteLatch;
  int32_t eramSecondTapOffs;
  int32_t eramReadValue;
  int32_t multiplCoef1;
  int32_t eram[0x10000];
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
