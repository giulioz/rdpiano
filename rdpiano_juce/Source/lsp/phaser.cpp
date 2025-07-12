/*
  ==============================================================================

    phaser.cpp
    Created: 12 Jul 2025 9:04:50pm
    Author:  Giulio Zausa

  ==============================================================================
*/

#include "phaser.h"

#include <string.h>

int32_t phaserRateTable[] = {
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

int32_t phaserDepthTable[] = {
    0,     139,   279,   419,   561,   703,   846,   989,   1134,  1279,  1425,
    1572,  1720,  1868,  2018,  2168,  2319,  2470,  2623,  2776,  2930,  3086,
    3242,  3398,  3556,  3714,  3874,  4034,  4195,  4357,  4520,  4684,  4849,
    5014,  5181,  5348,  5516,  5686,  5856,  6027,  6199,  6372,  6546,  6721,
    6897,  7073,  7251,  7430,  7610,  7790,  7972,  8155,  8338,  8523,  8709,
    8895,  9083,  9272,  9462,  9653,  9844,  10037, 10231, 10426, 10623, 10820,
    11018, 11217, 11418, 11619, 11822, 12026, 12231, 12437, 12644, 12852, 13061,
    13272, 13484, 13696, 13910, 14126, 14342, 14559, 14778, 14998, 15219, 15442,
    15665, 15890, 16116, 16343, 16572, 16801, 17032, 17265, 17498, 17733, 17969,
    18207, 18445, 18685, 18927, 19169, 19413, 19658, 19905, 20153, 20402, 20653,
    20905, 21159, 21414, 21670, 21927, 22186, 22447, 22709, 22972, 23237, 23503,
    23771, 24040, 24311, 24583, 24856, 25131, 25408};

int32_t phaserResonanceTable[] = {
    0,   1,   1,   2,   3,   3,   4,   4,  5,  6,  6,   7,   8,   8,   9,
    10,  10,  11,  12,  12,  13,  14,  15, 15, 16, 17,  17,  18,  19,  20,
    20,  21,  22,  22,  23,  24,  25,  26, 26, 27, 28,  29,  29,  30,  31,
    32,  33,  33,  34,  35,  36,  37,  37, 38, 39, 40,  41,  42,  42,  43,
    44,  45,  46,  47,  48,  49,  49,  50, 51, 52, 53,  54,  55,  56,  57,
    58,  59,  60,  60,  61,  62,  63,  64, 65, 66, 67,  68,  69,  70,  71,
    72,  73,  74,  75,  76,  77,  79,  80, 81, 82, 83,  84,  85,  86,  87,
    88,  89,  90,  92,  93,  94,  95,  96, 97, 98, 100, 101, 102, 103, 104,
    105, 107, 108, 109, 110, 112, 113, 114};

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

void Phaser::reset() {
  accA = 0;
  bufferPos = 0;
  multiplCoef1 = 0;
  multiplCoef2 = 0;

  audioInL = 0;
  audioInR = 0;
  audioOutL = 0;
  audioOutR = 0;

  rate = phaserRateTable[16];
  depth = phaserDepthTable[64];
  resonance = phaserResonanceTable[32];

  memset(iram, 0, sizeof(iram));
}

void Phaser::process() {
  int32_t accA_0;
  int32_t accA_1;
  int32_t accA_3;
  int32_t accA_4;
  int32_t accA_6;
  int32_t accA_10;
  int32_t accA_13;
  int32_t accA_17;
  int32_t accA_21;
  int32_t accA_25;
  int32_t accA_28;
  int32_t accA_32;
  int32_t accA_36;
  int32_t accA_42;
  int32_t accA_45;
  int32_t accA_49;
  int32_t accA_54;
  int32_t accA_58;
  int32_t accA_59;
  int32_t accA_63;
  int32_t accA_64;
  int32_t accA_68;
  int32_t accA_77;
  int32_t accA_86;
  int32_t accA_95;
  int32_t accA_104;
  int32_t accA_105;
  int32_t accA_109;
  int32_t accA_118;
  int32_t accA_127;
  int32_t accA_136;
  int32_t accA_145;
  int32_t accA_146;
  int32_t accA_150;
  int32_t accA_153;
  int32_t accA_161;
  int32_t accA_167;
  int32_t accA_168;
  int32_t accA_172;
  int32_t accA_175;
  int32_t accA_183;
  int32_t accA_189;
  int32_t accA_190;
  int32_t accA_370;
  int32_t accA_371;
  int32_t accA_373;
  int32_t accA_374;
  int32_t accA_376;

  accA = (readMemOffs(120) * 127) >> 7;
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

  accA = (readMemOffs(51) * resonance) >> 7;
  writeMemOffs(117, clamp_24(accA_10));
  accA += (readMemOffs(117) * 16) >> 7;
  accA_13 = accA;

  accA = readMemOffs(8);
  writeMemOffs(117, clamp_24(accA_13));
  accA += (readMemOffs(117) * 127) >> 7;
  accA += ((readMemOffs(117) * 192) >> 7) >> 8;
  accA_17 = accA;

  accA = readMemOffs(8);
  writeMemOffs(48, clamp_24(accA_17));
  accA += (readMemOffs(48) * -1) >> 7;
  accA += ((readMemOffs(48) * 128) >> 7) >> 8;
  accA_21 = accA;

  writeMemOffs(7, clamp_24(accA_21));

  accA = (readMemOffs(126) * 127) >> 7;
  accA_25 = accA;

  accA = (readMemOffs(53) * resonance) >> 7;
  writeMemOffs(117, clamp_24(accA_25));
  accA += (readMemOffs(117) * 16) >> 7;
  accA_28 = accA;

  accA = readMemOffs(10);
  writeMemOffs(117, clamp_24(accA_28));
  accA += (readMemOffs(117) * 127) >> 7;
  accA += ((readMemOffs(117) * 192) >> 7) >> 8;
  accA_32 = accA;

  accA = readMemOffs(10);
  writeMemOffs(49, clamp_24(accA_32));
  accA += (readMemOffs(49) * -1) >> 7;
  accA += ((readMemOffs(49) * 128) >> 7) >> 8;
  accA_36 = accA;

  writeMemOffs(9, clamp_24(accA_36));

  accA = readMemOffs(6);
  accA += rate;
  accA_42 = accA;

  writeMemOffs(5, sign_extend_24(accA_42));
  accA = (readMemOffs(5) * -128) >> 7;
  if (accA < 0)
    accA = -accA;
  accA_45 = accA;

  writeMemOffs(117, clamp_24(accA_45));
  accA = (readMemOffs(117) * (depth >> 8)) >> 7;
  accA += ((readMemOffs(117) * (depth & 0xff)) >> 7) >> 8;
  accA_49 = accA;

  writeMemOffs(117, clamp_24(accA_49));
  accA = (readMemOffs(117) * 79) >> 7;
  accA += 4325376;
  accA += 8192000 >> 6;
  accA_54 = accA;

  writeMemOffs(117, clamp_24(accA_54));
  accA = (readMemOffs(117) * 115) >> 7;
  accA += ((readMemOffs(117) * 51) >> 7) >> 8;
  accA_58 = accA;

  accA_59 = accA;

  multiplCoef2 = clamp_24(accA_58);
  writeMemOffs(117, clamp_24(accA_59));
  accA = (readMemOffs(117) * (multiplCoef2 >> 16)) >> 7;
  accA = ((readMemOffs(117) * ((multiplCoef2 & 0xffff) >> 9)) >> 14) +
         clamp_24(accA);
  accA_63 = accA;

  accA = (readMemOffs(117) * 64) >> 7;
  accA_64 = accA;

  multiplCoef1 = clamp_24(accA_63);
  multiplCoef2 = clamp_24(accA_64);
  accA = readMemOffs(48);
  accA_68 = accA;

  accA = -((readMemOffs(17) * (multiplCoef2 >> 16)) >> 5);
  accA = (-((readMemOffs(17) * ((multiplCoef2 & 0xffff) >> 9)) >> 12)) +
         clamp_24(accA);
  writeMemOffs(16, clamp_24(accA_68));
  accA = ((readMemOffs(16) * (multiplCoef1 >> 16)) >> 7) + clamp_24(accA);
  accA = ((readMemOffs(16) * ((multiplCoef1 & 0xffff) >> 9)) >> 14) +
         clamp_24(accA);
  accA += readMemOffs(18);
  accA = ((readMemOffs(19) * (multiplCoef2 >> 16)) >> 5) + clamp_24(accA);
  accA = ((readMemOffs(19) * ((multiplCoef2 & 0xffff) >> 9)) >> 12) +
         clamp_24(accA);
  accA = (-((readMemOffs(20) * (multiplCoef1 >> 16)) >> 7)) + clamp_24(accA);
  accA = (-((readMemOffs(20) * ((multiplCoef1 & 0xffff) >> 9)) >> 14)) +
         clamp_24(accA);
  accA_77 = accA;

  accA = -((readMemOffs(19) * (multiplCoef2 >> 16)) >> 5);
  accA = (-((readMemOffs(19) * ((multiplCoef2 & 0xffff) >> 9)) >> 12)) +
         clamp_24(accA);
  writeMemOffs(18, clamp_24(accA_77));
  accA = ((readMemOffs(18) * (multiplCoef1 >> 16)) >> 7) + clamp_24(accA);
  accA = ((readMemOffs(18) * ((multiplCoef1 & 0xffff) >> 9)) >> 14) +
         clamp_24(accA);
  accA += readMemOffs(20);
  accA = ((readMemOffs(21) * (multiplCoef2 >> 16)) >> 5) + clamp_24(accA);
  accA = ((readMemOffs(21) * ((multiplCoef2 & 0xffff) >> 9)) >> 12) +
         clamp_24(accA);
  accA = (-((readMemOffs(22) * (multiplCoef1 >> 16)) >> 7)) + clamp_24(accA);
  accA = (-((readMemOffs(22) * ((multiplCoef1 & 0xffff) >> 9)) >> 14)) +
         clamp_24(accA);
  accA_86 = accA;

  accA = -((readMemOffs(21) * (multiplCoef2 >> 16)) >> 5);
  accA = (-((readMemOffs(21) * ((multiplCoef2 & 0xffff) >> 9)) >> 12)) +
         clamp_24(accA);
  writeMemOffs(20, clamp_24(accA_86));
  accA = ((readMemOffs(20) * (multiplCoef1 >> 16)) >> 7) + clamp_24(accA);
  accA = ((readMemOffs(20) * ((multiplCoef1 & 0xffff) >> 9)) >> 14) +
         clamp_24(accA);
  accA += readMemOffs(22);
  accA = ((readMemOffs(23) * (multiplCoef2 >> 16)) >> 5) + clamp_24(accA);
  accA = ((readMemOffs(23) * ((multiplCoef2 & 0xffff) >> 9)) >> 12) +
         clamp_24(accA);
  accA = (-((readMemOffs(24) * (multiplCoef1 >> 16)) >> 7)) + clamp_24(accA);
  accA = (-((readMemOffs(24) * ((multiplCoef1 & 0xffff) >> 9)) >> 14)) +
         clamp_24(accA);
  accA_95 = accA;

  accA = -((readMemOffs(23) * (multiplCoef2 >> 16)) >> 5);
  accA = (-((readMemOffs(23) * ((multiplCoef2 & 0xffff) >> 9)) >> 12)) +
         clamp_24(accA);
  writeMemOffs(22, clamp_24(accA_95));
  accA = ((readMemOffs(22) * (multiplCoef1 >> 16)) >> 7) + clamp_24(accA);
  accA = ((readMemOffs(22) * ((multiplCoef1 & 0xffff) >> 9)) >> 14) +
         clamp_24(accA);
  accA += readMemOffs(24);
  accA = ((readMemOffs(25) * (multiplCoef2 >> 16)) >> 5) + clamp_24(accA);
  accA = ((readMemOffs(25) * ((multiplCoef2 & 0xffff) >> 9)) >> 12) +
         clamp_24(accA);
  accA = (-((readMemOffs(26) * (multiplCoef1 >> 16)) >> 7)) + clamp_24(accA);
  accA = (-((readMemOffs(26) * ((multiplCoef1 & 0xffff) >> 9)) >> 14)) +
         clamp_24(accA);
  accA_104 = accA;

  accA_105 = accA;

  writeMemOffs(24, clamp_24(accA_104));

  writeMemOffs(50, clamp_24(accA_105));

  accA = readMemOffs(49);
  accA_109 = accA;

  accA = -((readMemOffs(33) * (multiplCoef2 >> 16)) >> 5);
  accA = (-((readMemOffs(33) * ((multiplCoef2 & 0xffff) >> 9)) >> 12)) +
         clamp_24(accA);
  writeMemOffs(32, clamp_24(accA_109));
  accA = ((readMemOffs(32) * (multiplCoef1 >> 16)) >> 7) + clamp_24(accA);
  accA = ((readMemOffs(32) * ((multiplCoef1 & 0xffff) >> 9)) >> 14) +
         clamp_24(accA);
  accA += readMemOffs(34);
  accA = ((readMemOffs(35) * (multiplCoef2 >> 16)) >> 5) + clamp_24(accA);
  accA = ((readMemOffs(35) * ((multiplCoef2 & 0xffff) >> 9)) >> 12) +
         clamp_24(accA);
  accA = (-((readMemOffs(36) * (multiplCoef1 >> 16)) >> 7)) + clamp_24(accA);
  accA = (-((readMemOffs(36) * ((multiplCoef1 & 0xffff) >> 9)) >> 14)) +
         clamp_24(accA);
  accA_118 = accA;

  accA = -((readMemOffs(35) * (multiplCoef2 >> 16)) >> 5);
  accA = (-((readMemOffs(35) * ((multiplCoef2 & 0xffff) >> 9)) >> 12)) +
         clamp_24(accA);
  writeMemOffs(34, clamp_24(accA_118));
  accA = ((readMemOffs(34) * (multiplCoef1 >> 16)) >> 7) + clamp_24(accA);
  accA = ((readMemOffs(34) * ((multiplCoef1 & 0xffff) >> 9)) >> 14) +
         clamp_24(accA);
  accA += readMemOffs(36);
  accA = ((readMemOffs(37) * (multiplCoef2 >> 16)) >> 5) + clamp_24(accA);
  accA = ((readMemOffs(37) * ((multiplCoef2 & 0xffff) >> 9)) >> 12) +
         clamp_24(accA);
  accA = (-((readMemOffs(38) * (multiplCoef1 >> 16)) >> 7)) + clamp_24(accA);
  accA = (-((readMemOffs(38) * ((multiplCoef1 & 0xffff) >> 9)) >> 14)) +
         clamp_24(accA);
  accA_127 = accA;

  accA = -((readMemOffs(37) * (multiplCoef2 >> 16)) >> 5);
  accA = (-((readMemOffs(37) * ((multiplCoef2 & 0xffff) >> 9)) >> 12)) +
         clamp_24(accA);
  writeMemOffs(36, clamp_24(accA_127));
  accA = ((readMemOffs(36) * (multiplCoef1 >> 16)) >> 7) + clamp_24(accA);
  accA = ((readMemOffs(36) * ((multiplCoef1 & 0xffff) >> 9)) >> 14) +
         clamp_24(accA);
  accA += readMemOffs(38);
  accA = ((readMemOffs(39) * (multiplCoef2 >> 16)) >> 5) + clamp_24(accA);
  accA = ((readMemOffs(39) * ((multiplCoef2 & 0xffff) >> 9)) >> 12) +
         clamp_24(accA);
  accA = (-((readMemOffs(40) * (multiplCoef1 >> 16)) >> 7)) + clamp_24(accA);
  accA = (-((readMemOffs(40) * ((multiplCoef1 & 0xffff) >> 9)) >> 14)) +
         clamp_24(accA);
  accA_136 = accA;

  accA = -((readMemOffs(39) * (multiplCoef2 >> 16)) >> 5);
  accA = (-((readMemOffs(39) * ((multiplCoef2 & 0xffff) >> 9)) >> 12)) +
         clamp_24(accA);
  writeMemOffs(38, clamp_24(accA_136));
  accA = ((readMemOffs(38) * (multiplCoef1 >> 16)) >> 7) + clamp_24(accA);
  accA = ((readMemOffs(38) * ((multiplCoef1 & 0xffff) >> 9)) >> 14) +
         clamp_24(accA);
  accA += readMemOffs(40);
  accA = ((readMemOffs(41) * (multiplCoef2 >> 16)) >> 5) + clamp_24(accA);
  accA = ((readMemOffs(41) * ((multiplCoef2 & 0xffff) >> 9)) >> 12) +
         clamp_24(accA);
  accA = (-((readMemOffs(42) * (multiplCoef1 >> 16)) >> 7)) + clamp_24(accA);
  accA = (-((readMemOffs(42) * ((multiplCoef1 & 0xffff) >> 9)) >> 14)) +
         clamp_24(accA);
  accA_145 = accA;

  accA_146 = accA;

  writeMemOffs(40, clamp_24(accA_145));

  writeMemOffs(52, clamp_24(accA_146));

  accA = (readMemOffs(50) * 64) >> 5;
  accA_150 = accA;

  accA = readMemOffs(127);
  writeMemOffs(117, clamp_24(accA_150));
  accA += (readMemOffs(117) * 127) >> 5;
  accA_153 = accA;

  writeMemOffs(96, clamp_24(accA_153));
  accA = readMemOffs(96);
  accA += ((readMemOffs(96) * 0) >> 7) >> 6;
  accA += (readMemOffs(97) * -123) >> 7;
  accA += ((readMemOffs(97) * 134) >> 7) >> 8;
  accA += (readMemOffs(98) * 122) >> 7;
  accA += ((readMemOffs(98) * 122) >> 7) >> 8;
  accA_161 = accA;

  accA = (readMemOffs(98) * -54) >> 7;
  accA += ((readMemOffs(98) * 127) >> 7) >> 8;
  writeMemOffs(97, clamp_24(accA_161));
  accA += readMemOffs(97);
  accA += ((readMemOffs(97) * 0) >> 7) >> 6;
  accA += (readMemOffs(99) * 53) >> 7;
  accA += ((readMemOffs(99) * 129) >> 7) >> 8;
  accA_167 = accA;

  accA_168 = accA;

  writeMemOffs(98, clamp_24(accA_167));

  writeMemOffs(121, clamp_24(accA_168));

  accA = (readMemOffs(52) * 64) >> 5;
  accA_172 = accA;

  accA = readMemOffs(126);
  writeMemOffs(117, clamp_24(accA_172));
  accA += (readMemOffs(117) * 127) >> 5;
  accA_175 = accA;

  writeMemOffs(100, clamp_24(accA_175));
  accA = readMemOffs(100);
  accA += ((readMemOffs(100) * 0) >> 7) >> 6;
  accA += (readMemOffs(101) * -123) >> 7;
  accA += ((readMemOffs(101) * 134) >> 7) >> 8;
  accA += (readMemOffs(102) * 122) >> 7;
  accA += ((readMemOffs(102) * 122) >> 7) >> 8;
  accA_183 = accA;

  accA = (readMemOffs(102) * -54) >> 7;
  accA += ((readMemOffs(102) * 127) >> 7) >> 8;
  writeMemOffs(101, clamp_24(accA_183));
  accA += readMemOffs(101);
  accA += ((readMemOffs(101) * 0) >> 7) >> 6;
  accA += (readMemOffs(103) * 53) >> 7;
  accA += ((readMemOffs(103) * 129) >> 7) >> 8;
  accA_189 = accA;

  accA_190 = accA;

  writeMemOffs(102, clamp_24(accA_189));

  writeMemOffs(119, clamp_24(accA_190));

  accA = (readMemOffs(121) * 127) >> 7;
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
}
