/*
  ==============================================================================

    phaser.h
    Created: 12 Jul 2025 9:04:50pm
    Author:  Giulio Zausa

  ==============================================================================
*/

#pragma once

#include <cmath>
#include <stdint.h>

extern int32_t phaserRateTable[];
extern int32_t phaserDepthTable[];
extern int32_t phaserResonanceTable[];

class Phaser {
public:
  void process();
  void reset();

  int32_t audioInL;
  int32_t audioInR;
  int32_t audioOutL;
  int32_t audioOutR;

  int32_t rate;
  int32_t depth;
  int32_t resonance;

private:
  int32_t accA;
  uint8_t bufferPos;
  int32_t iram[0x200];
  int32_t multiplCoef1;
  int32_t multiplCoef2;

  inline void writeMemOffs(uint8_t memOffs, int32_t value) {
    uint32_t ramPos = ((uint32_t)memOffs + bufferPos) & 0x7f;
    iram[ramPos] = value;
  }
  inline int64_t readMemOffs(uint8_t memOffs) {
    uint32_t ramPos = ((uint32_t)memOffs + bufferPos) & 0x7f;
    return iram[ramPos];
  }
};
