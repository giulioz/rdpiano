/*
  ==============================================================================

    spaced.cpp
    Created: 12 Jul 2025 3:32:22pm
    Author:  Giulio Zausa

  ==============================================================================
*/

#include "spaced.h"

#include <string.h>

int32_t spaceDRateTable[] = {
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

int32_t spaceDDepthTable[] = {
    0,   2,   4,   6,   8,   10,  13,  15,  17,  19,  22,  24,  26,  29,  31,
    33,  36,  38,  40,  43,  45,  48,  50,  53,  55,  58,  60,  63,  65,  68,
    70,  73,  75,  78,  80,  83,  86,  88,  91,  94,  96,  99,  102, 105, 107,
    110, 113, 116, 118, 121, 124, 127, 130, 133, 136, 138, 141, 144, 147, 150,
    153, 156, 159, 162, 165, 169, 172, 175, 178, 181, 184, 187, 191, 194, 197,
    200, 204, 207, 210, 214, 217, 220, 224, 227, 230, 234, 237, 241, 244, 248,
    251, 255, 258, 262, 266, 269, 273, 277, 280, 284, 288, 291, 295, 299, 303,
    307, 311, 314, 318, 322, 326, 330, 334, 338, 342, 346, 350, 354, 358, 363,
    367, 371, 375, 379, 384, 388, 392, 397};

static constexpr int DATA_BITS = 24;
static constexpr int64_t MIN_VAL = -(1LL << (DATA_BITS - 1));
static constexpr int64_t MAX_VAL = (1LL << (DATA_BITS - 1)) - 1;
static constexpr int32_t clamp_24(int64_t v) {
  if (v > MAX_VAL)
    return static_cast<int32_t>(MAX_VAL);
  if (v < MIN_VAL)
    return static_cast<int32_t>(MIN_VAL);
  return static_cast<int32_t>(v);
}
static constexpr int32_t sign_extend_24(int32_t x) {
  x &= 0xffffff;
  if (x & 0x800000) // If sign bit is set
    x |= ~0xffffff;
  return x;
}

void SpaceD::reset() {
  audioInL = 0;
  audioInR = 0;
  audioOutL = 0;
  audioOutR = 0;

  accA = 0;
  accB = 0;
  bufferPos = 0;
  eramPos = 0;
  eramWriteLatch = 0;
  eramSecondTapOffs = 0;
  eramReadValue = 0;
  multiplCoef1 = 0;

  memset(eram, 0, sizeof(eram));
  memset(iram, 0, sizeof(iram));

  level = 127;
  depth = spaceDDepthTable[0x7f];
  rate = spaceDRateTable[8];
  phase = 8388608 + (0 >> 6);
  amountWet = 0x7f;
  amountDry = 0x7f;
  preDelay1 = 0 + (3342336 >> 6);
  preDelay2 = 8388608 + (3866624 >> 6);
}

void SpaceD::process() {
  int32_t accA_0;
  int32_t accA_1;
  int32_t accA_3;
  int32_t accA_4;
  int32_t accA_6;
  int32_t accA_10;
  int32_t accB_13;
  int32_t accA_15;
  int32_t accA_16;
  int32_t accB_19;
  int32_t accB_21;
  int32_t accA_23;
  int32_t accB_25;
  int32_t accA_31;
  int32_t accA_34;
  int32_t accA_41;
  int32_t accA_64;
  int32_t accA_70;
  int32_t accA_73;
  int32_t accA_80;
  int32_t accA_103;
  int32_t accA_108;
  int32_t accA_111;
  int32_t accA_114;
  int32_t accA_120;
  int32_t accA_126;
  int32_t accA_127;
  int32_t accA_132;
  int32_t accA_135;
  int32_t accA_138;
  int32_t accA_144;
  int32_t accA_150;
  int32_t accA_151;
  int32_t accA_370;
  int32_t accA_371;
  int32_t accA_373;
  int32_t accA_374;
  int32_t accA_376;

  accA = (readMemOffs(120) * level) >> 7;
  accA_0 = accA;

  writeMemOffs(0x7e, audioInR);
  accA = (audioInR * 127) >> 7;
  accA_1 = accA;

  writeMemOffs(117, clamp_24(accA_0));
  accA = (readMemOffs(117) * 127) >> 5;
  accA_3 = accA;

  writeMemOffs(117, clamp_24(accA_1));
  accA = (readMemOffs(117) * 32) >> 7;
  accA_4 = accA;

  accA = 128;
  writeMemOffs(117, clamp_24(accA_3));
  accA += (readMemOffs(117) * 127) >> 7;
  accA_6 = accA;

  writeMemOffs(126, clamp_24(accA_4));

  audioOutR = clamp_24(accA_6);
  writeMemOffs(0x78, audioOutR);
  accA += (clamp_24(accA_6) * 0) >> 7;
  accA = (readMemOffs(127) * 127) >> 7;
  accA_10 = accA;

  accB = (readMemOffs(126) * 127) >> 7;
  accA = readMemOffs(8);
  writeMemOffs(117, clamp_24(accA_10));
  accA += (readMemOffs(117) * 127) >> 7;
  accB_13 = accB;

  accA += ((readMemOffs(117) * 192) >> 7) >> 8;
  accB = readMemOffs(10);
  accA_15 = accA;

  writeMemOffs(117, clamp_24(accB_13));
  accB += (readMemOffs(117) * 127) >> 7;
  accA_16 = accA;

  accB += ((readMemOffs(117) * 192) >> 7) >> 8;
  eramWriteLatch = clamp_24(accA_15);
  eram[(eramPos + 0) & 0xffff] = eramWriteLatch >> 4;
  writeMemOffs(117, clamp_24(accA_16));
  accA = (readMemOffs(117) * -1) >> 7;
  accB_19 = accB;

  accA += ((readMemOffs(117) * 128) >> 7) >> 8;
  accA += readMemOffs(8);
  accB_21 = accB;

  writeMemOffs(117, clamp_24(accB_19));
  accB = (readMemOffs(117) * -1) >> 7;
  accB += ((readMemOffs(117) * 128) >> 7) >> 8;
  accA_23 = accA;

  eramWriteLatch = clamp_24(accB_21);
  eram[(eramPos + 16384) & 0xffff] = eramWriteLatch >> 4;
  accB += readMemOffs(10);
  accB_25 = accB;

  writeMemOffs(7, clamp_24(accA_23));

  writeMemOffs(9, clamp_24(accB_25));

  accA = readMemOffs(22);
  accA += rate;
  accA_31 = accA;

  writeMemOffs(21, sign_extend_24(accA_31));
  accA = (readMemOffs(21) * -128) >> 7;
  if (accA < 0)
    accA = -accA;
  accA_34 = accA;

  accA = preDelay1;
  writeMemOffs(117, clamp_24(accA_34));
  accA += (readMemOffs(117) * (depth >> 8)) >> 7;
  accA += ((readMemOffs(117) * (depth & 0xff)) >> 7) >> 8;

  accA += preDelay1;
  accA_41 = accA;

  eramSecondTapOffs = accA_41;
  multiplCoef1 = (eramSecondTapOffs & 0x3ff) << 13;
  eramSecondTapOffs >>= 10;

  eramReadValue = eram[(eramPos + 1 + eramSecondTapOffs) & 0xffff] << 4;
  writeMemOffs(123, eramReadValue);
  accA = (eramReadValue * 0) >> 7;

  accA = (readMemOffs(123) * (multiplCoef1 >> 16)) >> 7;
  eramReadValue = eram[(eramPos + 0 + eramSecondTapOffs) & 0xffff] << 4;
  writeMemOffs(122, eramReadValue);
  accA += (eramReadValue * 32) >> 5;
  accA = (-((readMemOffs(122) * (multiplCoef1 >> 16)) >> 7)) + clamp_24(accA);
  accA_64 = accA;

  writeMemOffs(16, clamp_24(accA_64));

  accA = readMemOffs(21);
  accA += phase;
  accA_70 = accA;

  writeMemOffs(117, sign_extend_24(accA_70));
  accA = (readMemOffs(117) * -128) >> 7;
  if (accA < 0)
    accA = -accA;
  accA_73 = accA;

  accA = preDelay2;
  writeMemOffs(117, clamp_24(accA_73));
  accA += (readMemOffs(117) * (depth >> 8)) >> 7;
  accA += ((readMemOffs(117) * (depth & 0xff)) >> 7) >> 8;

  accA += preDelay2;
  accA_80 = accA;

  eramSecondTapOffs = accA_80;
  multiplCoef1 = (eramSecondTapOffs & 0x3ff) << 13;
  eramSecondTapOffs >>= 10;

  eramReadValue = eram[(eramPos + 1 + eramSecondTapOffs) & 0xffff] << 4;
  writeMemOffs(123, eramReadValue);
  accA = (eramReadValue * 0) >> 7;

  accA = (readMemOffs(123) * (multiplCoef1 >> 16)) >> 7;
  eramReadValue = eram[(eramPos + 0 + eramSecondTapOffs) & 0xffff] << 4;
  writeMemOffs(122, eramReadValue);
  accA += (eramReadValue * 32) >> 5;
  accA = (-((readMemOffs(122) * (multiplCoef1 >> 16)) >> 7)) + clamp_24(accA);
  accA_103 = accA;

  writeMemOffs(17, clamp_24(accA_103));

  accA = readMemOffs(16);
  accA += (readMemOffs(17) * -128) >> 7;
  accA_108 = accA;

  writeMemOffs(117, clamp_24(accA_108));
  accA = readMemOffs(117);
  accA_111 = accA;

  accA = (readMemOffs(127) * amountDry) >> 7;
  writeMemOffs(117, clamp_24(accA_111));
  accA += (readMemOffs(117) * amountWet) >> 7;
  accA_114 = accA;

  accA = (readMemOffs(97) * -118) >> 7;
  accA += ((readMemOffs(97) * 67) >> 7) >> 8;
  writeMemOffs(96, clamp_24(accA_114));
  accA += readMemOffs(96);
  accA += ((readMemOffs(96) * 0) >> 7) >> 6;
  accA += (readMemOffs(98) * 117) >> 7;
  accA += ((readMemOffs(98) * 189) >> 7) >> 8;
  accA_120 = accA;

  accA = (readMemOffs(98) * -54) >> 7;
  accA += ((readMemOffs(98) * 127) >> 7) >> 8;
  writeMemOffs(97, clamp_24(accA_120));
  accA += readMemOffs(97);
  accA += ((readMemOffs(97) * 0) >> 7) >> 6;
  accA += (readMemOffs(99) * 53) >> 7;
  accA += ((readMemOffs(99) * 129) >> 7) >> 8;
  accA_126 = accA;

  accA_127 = accA;

  writeMemOffs(98, clamp_24(accA_126));

  writeMemOffs(121, clamp_24(accA_127));

  accA = (readMemOffs(16) * -128) >> 7;
  accA += readMemOffs(17);
  accA_132 = accA;

  writeMemOffs(117, clamp_24(accA_132));
  accA = readMemOffs(117);
  accA_135 = accA;

  accA = (readMemOffs(126) * amountDry) >> 7;
  writeMemOffs(117, clamp_24(accA_135));
  accA += (readMemOffs(117) * amountWet) >> 7;
  accA_138 = accA;

  accA = (readMemOffs(101) * -118) >> 7;
  accA += ((readMemOffs(101) * 67) >> 7) >> 8;
  writeMemOffs(100, clamp_24(accA_138));
  accA += readMemOffs(100);
  accA += ((readMemOffs(100) * 0) >> 7) >> 6;
  accA += (readMemOffs(102) * 117) >> 7;
  accA += ((readMemOffs(102) * 189) >> 7) >> 8;
  accA_144 = accA;

  accA = (readMemOffs(102) * -54) >> 7;
  accA += ((readMemOffs(102) * 127) >> 7) >> 8;
  writeMemOffs(101, clamp_24(accA_144));
  accA += readMemOffs(101);
  accA += ((readMemOffs(101) * 0) >> 7) >> 6;
  accA += (readMemOffs(103) * 53) >> 7;
  accA += ((readMemOffs(103) * 129) >> 7) >> 8;
  accA_150 = accA;

  accA_151 = accA;

  writeMemOffs(102, clamp_24(accA_150));

  writeMemOffs(119, clamp_24(accA_151));

  accA = (readMemOffs(121) * level) >> 7;
  accA_370 = accA;

  writeMemOffs(0x7e, audioInL);
  accA = (audioInL * 127) >> 7;
  accA_371 = accA;

  writeMemOffs(117, clamp_24(accA_370));
  accA = (readMemOffs(117) * 127) >> 5;
  accA_373 = accA;

  writeMemOffs(117, clamp_24(accA_371));
  accA = (readMemOffs(117) * 32) >> 7;
  accA_374 = accA;

  accA = 128;
  writeMemOffs(117, clamp_24(accA_373));
  accA += (readMemOffs(117) * 127) >> 7;
  accA_376 = accA;

  writeMemOffs(126, clamp_24(accA_374));

  audioOutL = clamp_24(accA_376);
  writeMemOffs(0x78, audioOutL);
  accA += (clamp_24(accA_376) * 0) >> 7;

  bufferPos = (bufferPos - 1) & 0x7f;
  eramPos -= 1;
}
