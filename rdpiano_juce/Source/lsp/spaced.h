/*
  ==============================================================================

    spaced.h
    Created: 12 Jul 2025 3:32:22pm
    Author:  Giulio Zausa

  ==============================================================================
*/

#pragma once

#include <stdint.h>
#include <cmath>

static constexpr int32_t spaceDRateTable[] = {
    26,   52,   78,   104,  131,  157,  183,  209,  235,  262,  288,  314,
    340,  367,  393,  419,  445,  471,  498,  524,  550,  576,  602,  629,
    655,  681,  707,  734,  760,  786,  812,  838,  865,  891,  917,  943,
    969,  996,  1022, 1048, 1074, 1101, 1127, 1153, 1179, 1205, 1232, 1258,
    1284, 1310, 1336, 1363, 1389, 1415, 1441, 1468, 1494, 1520, 1546, 1572,
    1599, 1625, 1651, 1677, 1703, 1730, 1756, 1782, 1808, 1835, 1861, 1887,
    1913, 1939, 1966, 1992, 2018, 2044, 2070, 2097, 2123, 2149, 2175, 2202,
    2228, 2254, 2280, 2306, 2333, 2359, 2385, 2411, 2437, 2464, 2490, 2516,
    2542, 2569, 2595, 2621, 2673, 2726, 2778, 2831, 2883, 2936, 2988, 3040,
    3093, 3145, 3198, 3250, 3303, 3355, 3407, 3460, 3512, 3565, 3617, 3670,
    3932, 4194, 4456, 4718, 4980, 5242, 5242, 5242,
};

static constexpr int32_t spaceDDepthTable[] = {
    0,   2,   4,   6,   8,   10,  13,  15,  17,  19,  22,  24,  26,  29,  31,
    33,  36,  38,  40,  43,  45,  48,  50,  53,  55,  58,  60,  63,  65,  68,
    70,  73,  75,  78,  80,  83,  86,  88,  91,  94,  96,  99,  102, 105, 107,
    110, 113, 116, 118, 121, 124, 127, 130, 133, 136, 138, 141, 144, 147, 150,
    153, 156, 159, 162, 165, 169, 172, 175, 178, 181, 184, 187, 191, 194, 197,
    200, 204, 207, 210, 214, 217, 220, 224, 227, 230, 234, 237, 241, 244, 248,
    251, 255, 258, 262, 266, 269, 273, 277, 280, 284, 288, 291, 295, 299, 303,
    307, 311, 314, 318, 322, 326, 330, 334, 338, 342, 346, 350, 354, 358, 363,
    367, 371, 375, 379, 384, 388, 392, 397};

constexpr int32_t spaceDRateFromMs(float ms) { return ms * 498.0f; }
constexpr int32_t spaceDDepth(float amount) { return spaceDDepthTable[(int)floor(amount * 0x80)]; }

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
