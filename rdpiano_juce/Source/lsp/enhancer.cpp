/*
  ==============================================================================

    enhancer.cpp
    Created: 12 Jul 2025 8:51:22pm
    Author:  Giulio Zausa

  ==============================================================================
*/

#include "enhancer.h"

#include <string.h>

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

void Enhancer::reset() {
  audioInL = 0;
  audioInR = 0;
  audioOutL = 0;
  audioOutR = 0;

  accA = 0;
  bufferPos = 0;

  memset(iram, 0, sizeof(iram));
}

void Enhancer::process() {
  int32_t accA_0;
  int32_t accA_1;
  int32_t accA_3;
  int32_t accA_4;
  int32_t accA_6;
  int32_t accA_10;
  int32_t accA_14;
  int32_t accA_18;
  int32_t accA_24;
  int32_t accA_27;
  int32_t accA_30;
  int32_t accA_33;
  int32_t accA_36;
  int32_t accA_39;
  int32_t accA_42;
  int32_t accA_48;
  int32_t accA_54;
  int32_t accA_55;
  int32_t accA_59;
  int32_t accA_63;
  int32_t accA_67;
  int32_t accA_73;
  int32_t accA_76;
  int32_t accA_79;
  int32_t accA_82;
  int32_t accA_85;
  int32_t accA_88;
  int32_t accA_91;
  int32_t accA_97;
  int32_t accA_103;
  int32_t accA_104;
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

  accA = readMemOffs(17);
  writeMemOffs(117, clamp_24(accA_10));
  accA += (readMemOffs(117) * 127) >> 7;
  accA += ((readMemOffs(117) * 192) >> 7) >> 8;
  accA_14 = accA;

  accA = readMemOffs(17);
  writeMemOffs(18, clamp_24(accA_14));
  accA += (readMemOffs(18) * -1) >> 7;
  accA += ((readMemOffs(18) * 128) >> 7) >> 8;
  accA_18 = accA;

  writeMemOffs(16, clamp_24(accA_18));

  accA = (readMemOffs(18) * 73) >> 7;
  accA += (readMemOffs(19) * -73) >> 7;
  accA += (readMemOffs(21) * 18) >> 7;
  accA_24 = accA;

  writeMemOffs(20, clamp_24(accA_24));
  accA = (readMemOffs(20) * 64) >> 5;
  accA_27 = accA;

  writeMemOffs(117, clamp_24(accA_27));
  accA = (readMemOffs(117) * -128) >> 5;
  accA_30 = accA;

  writeMemOffs(117, clamp_24(accA_30));
  accA = (readMemOffs(117) * -128) >> 5;
  accA_33 = accA;

  writeMemOffs(117, clamp_24(accA_33));
  accA = (readMemOffs(117) * 16) >> 7;
  accA_36 = accA;

  accA = (readMemOffs(25) * 6) >> 7;
  accA += (readMemOffs(23) * -67) >> 7;
  writeMemOffs(22, clamp_24(accA_36));
  accA += (readMemOffs(22) * 67) >> 7;
  accA_39 = accA;

  accA = readMemOffs(18);
  writeMemOffs(24, clamp_24(accA_39));
  accA += (readMemOffs(24) * 127) >> 7;
  accA_42 = accA;

  accA = (readMemOffs(97) * -120) >> 7;
  accA += ((readMemOffs(97) * 222) >> 7) >> 8;
  writeMemOffs(96, clamp_24(accA_42));
  accA += readMemOffs(96);
  accA += ((readMemOffs(96) * 97) >> 7) >> 6;
  accA += (readMemOffs(98) * 120) >> 7;
  accA += ((readMemOffs(98) * 166) >> 7) >> 8;
  accA_48 = accA;

  accA = (readMemOffs(98) * -54) >> 7;
  accA += ((readMemOffs(98) * 127) >> 7) >> 8;
  writeMemOffs(97, clamp_24(accA_48));
  accA += readMemOffs(97);
  accA += ((readMemOffs(97) * 0) >> 7) >> 6;
  accA += (readMemOffs(99) * 53) >> 7;
  accA += ((readMemOffs(99) * 129) >> 7) >> 8;
  accA_54 = accA;

  accA_55 = accA;

  writeMemOffs(98, clamp_24(accA_54));

  writeMemOffs(121, clamp_24(accA_55));

  accA = (readMemOffs(126) * 127) >> 7;
  accA_59 = accA;

  accA = readMemOffs(33);
  writeMemOffs(117, clamp_24(accA_59));
  accA += (readMemOffs(117) * 127) >> 7;
  accA += ((readMemOffs(117) * 192) >> 7) >> 8;
  accA_63 = accA;

  accA = readMemOffs(33);
  writeMemOffs(34, clamp_24(accA_63));
  accA += (readMemOffs(34) * -1) >> 7;
  accA += ((readMemOffs(34) * 128) >> 7) >> 8;
  accA_67 = accA;

  writeMemOffs(32, clamp_24(accA_67));

  accA = (readMemOffs(34) * 73) >> 7;
  accA += (readMemOffs(35) * -73) >> 7;
  accA += (readMemOffs(37) * 18) >> 7;
  accA_73 = accA;

  writeMemOffs(36, clamp_24(accA_73));
  accA = (readMemOffs(36) * 64) >> 5;
  accA_76 = accA;

  writeMemOffs(117, clamp_24(accA_76));
  accA = (readMemOffs(117) * -128) >> 5;
  accA_79 = accA;

  writeMemOffs(117, clamp_24(accA_79));
  accA = (readMemOffs(117) * -128) >> 5;
  accA_82 = accA;

  writeMemOffs(117, clamp_24(accA_82));
  accA = (readMemOffs(117) * 16) >> 7;
  accA_85 = accA;

  accA = (readMemOffs(41) * 6) >> 7;
  accA += (readMemOffs(39) * -67) >> 7;
  writeMemOffs(38, clamp_24(accA_85));
  accA += (readMemOffs(38) * 67) >> 7;
  accA_88 = accA;

  accA = readMemOffs(34);
  writeMemOffs(40, clamp_24(accA_88));
  accA += (readMemOffs(40) * 127) >> 7;
  accA_91 = accA;

  accA = (readMemOffs(101) * -120) >> 7;
  accA += ((readMemOffs(101) * 222) >> 7) >> 8;
  writeMemOffs(100, clamp_24(accA_91));
  accA += readMemOffs(100);
  accA += ((readMemOffs(100) * 97) >> 7) >> 6;
  accA += (readMemOffs(102) * 120) >> 7;
  accA += ((readMemOffs(102) * 166) >> 7) >> 8;
  accA_97 = accA;

  accA = (readMemOffs(102) * -54) >> 7;
  accA += ((readMemOffs(102) * 127) >> 7) >> 8;
  writeMemOffs(101, clamp_24(accA_97));
  accA += readMemOffs(101);
  accA += ((readMemOffs(101) * 0) >> 7) >> 6;
  accA += (readMemOffs(103) * 53) >> 7;
  accA += ((readMemOffs(103) * 129) >> 7) >> 8;
  accA_103 = accA;

  accA_104 = accA;

  writeMemOffs(102, clamp_24(accA_103));

  writeMemOffs(119, clamp_24(accA_104));

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
