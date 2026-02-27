#include "../include/rd200_lifted_core.h"
#include "rd200_rom_b_lifted.h"

namespace {

constexpr uint8_t CC_N = 0x08;
constexpr uint8_t CC_Z = 0x04;
constexpr uint8_t CC_V = 0x02;
constexpr uint8_t CC_C = 0x01;

uint8_t nzv16(uint8_t cc, uint16_t value)
{
  cc &= static_cast<uint8_t>(~(CC_N | CC_Z | CC_V));
  if (value & 0x8000)
    cc |= CC_N;
  if (value == 0)
    cc |= CC_Z;
  return cc;
}

uint8_t nzv8(uint8_t cc, uint8_t value)
{
  cc &= static_cast<uint8_t>(~(CC_N | CC_Z | CC_V));
  if (value & 0x80)
    cc |= CC_N;
  if (value == 0)
    cc |= CC_Z;
  return cc;
}

uint8_t dec8_nzv(uint8_t cc, uint8_t value)
{
  cc &= static_cast<uint8_t>(~(CC_N | CC_Z | CC_V));
  if (value & 0x80)
    cc |= CC_N;
  if (value == 0)
    cc |= CC_Z;
  if (value == 0x7f)
    cc |= CC_V;
  return cc;
}

uint8_t inc8_nzv(uint8_t cc, uint8_t value)
{
  cc &= static_cast<uint8_t>(~(CC_N | CC_Z | CC_V));
  if (value & 0x80)
    cc |= CC_N;
  if (value == 0)
    cc |= CC_Z;
  if (value == 0x80)
    cc |= CC_V;
  return cc;
}

uint8_t sub8_nzvc(uint8_t cc, uint8_t a, uint8_t b, uint8_t r)
{
  cc &= static_cast<uint8_t>(~(CC_N | CC_Z | CC_V | CC_C));
  if (r & 0x80)
    cc |= CC_N;
  if (r == 0)
    cc |= CC_Z;
  if (((a ^ b) & (a ^ r) & 0x80) != 0)
    cc |= CC_V;
  if (a < b)
    cc |= CC_C;
  return cc;
}

uint8_t and8_nzv(uint8_t cc, uint8_t r)
{
  cc &= static_cast<uint8_t>(~(CC_N | CC_Z | CC_V));
  if (r & 0x80)
    cc |= CC_N;
  if (r == 0)
    cc |= CC_Z;
  return cc;
}

uint8_t add8_hnzvc(uint8_t cc, uint8_t a, uint8_t b, uint8_t r)
{
  cc &= static_cast<uint8_t>(~(0x20 | CC_N | CC_Z | CC_V | CC_C));
  if (r & 0x80)
    cc |= CC_N;
  if (r == 0)
    cc |= CC_Z;
  if ((((a ^ b ^ r ^ (r >> 1)) & 0x80) != 0))
    cc |= CC_V;
  if (static_cast<uint16_t>(a) + static_cast<uint16_t>(b) > 0xff)
    cc |= CC_C;
  if ((((a ^ b ^ r) & 0x10) != 0))
    cc |= 0x20; // H
  return cc;
}

uint8_t lsr8_nzvc(uint8_t cc, uint8_t in, uint8_t out)
{
  cc &= static_cast<uint8_t>(~(CC_N | CC_Z | CC_V | CC_C));
  if ((in & 0x01) != 0)
    cc |= CC_C;
  if (out == 0)
    cc |= CC_Z;
  // N is always 0 for logical shift right; V mirrors C in this implementation.
  if ((cc & CC_C) != 0)
    cc |= CC_V;
  return cc;
}

uint8_t add16_nzvc(uint8_t cc, uint16_t a, uint16_t b, uint16_t r)
{
  cc &= static_cast<uint8_t>(~(CC_N | CC_Z | CC_V | CC_C));
  if (r & 0x8000)
    cc |= CC_N;
  if (r == 0)
    cc |= CC_Z;
  if ((((a ^ b ^ r ^ (r >> 1)) & 0x8000) != 0))
    cc |= CC_V;
  if (static_cast<uint32_t>(a) + static_cast<uint32_t>(b) > 0xffff)
    cc |= CC_C;
  return cc;
}

uint8_t sub16_nzvc(uint8_t cc, uint16_t a, uint16_t b, uint16_t r)
{
  cc &= static_cast<uint8_t>(~(CC_N | CC_Z | CC_V | CC_C));
  if (r & 0x8000)
    cc |= CC_N;
  if (r == 0)
    cc |= CC_Z;
  if (((a ^ b) & (a ^ r) & 0x8000) != 0)
    cc |= CC_V;
  if (a < b)
    cc |= CC_C;
  return cc;
}

uint8_t asld16_nzvc(uint8_t cc, uint16_t in, uint16_t out)
{
  cc &= static_cast<uint8_t>(~(CC_N | CC_Z | CC_V | CC_C));
  if (out & 0x8000)
    cc |= CC_N;
  if (out == 0)
    cc |= CC_Z;
  if (in & 0x8000)
    cc |= CC_C;
  const bool n = (cc & CC_N) != 0;
  const bool c = (cc & CC_C) != 0;
  if (n != c)
    cc |= CC_V;
  return cc;
}

// E006: CLR ,X
void block_e006(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  // Interpreter traces instruction side effects using PC after opcode fetch.
  s.pc = 0xE008;
  core.write8(s.x, 0x00);

  // CLR affects NZVC; preserve upper condition bits (H and I), set Z.
  s.cc = static_cast<uint8_t>((s.cc & 0xf0) | 0x04);
}

// E008: INX
void block_e008(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE009;
  s.x = static_cast<uint16_t>(s.x + 1);
  if (s.x == 0)
    s.cc = static_cast<uint8_t>(s.cc | 0x04);
  else
    s.cc = static_cast<uint8_t>(s.cc & ~0x04);
}

// E009: SUBD #$0001
void block_e009(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE00C;

  const uint16_t a = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  constexpr uint16_t b = 0x0001;
  const uint16_t r = static_cast<uint16_t>(a - b);

  uint8_t cc = static_cast<uint8_t>(s.cc & 0xf0);
  if (r & 0x8000)
    cc |= 0x08; // N
  if (r == 0)
    cc |= 0x04; // Z
  if (((a ^ b) & (a ^ r) & 0x8000) != 0)
    cc |= 0x02; // V
  if (a < b)
    cc |= 0x01; // C (borrow)

  s.a = static_cast<uint8_t>((r >> 8) & 0xff);
  s.b = static_cast<uint8_t>(r & 0xff);
  s.cc = cc;
}

// E00C: BNE E006
void block_e00c(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & 0x04) != 0;
  s.pc = z ? 0xE00E : 0xE006;
}

// E00E: RTS
void block_e00e(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// E000: LDX #$0020
void block_e000(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE003;
  s.x = 0x0020;
  s.cc = nzv16(s.cc, s.x);
}

// E003: LDD #$014D
void block_e003(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE006;
  s.a = 0x01;
  s.b = 0x4D;
  s.cc = nzv16(s.cc, 0x014D);
}

// E02E: BSR E000
void block_e02e(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE030;
  core.push16(0xE030);
  s.pc = 0xE000;
}

// E030: LDX #$0200
void block_e030(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE033;
  s.x = 0x0200;
  s.cc = nzv16(s.cc, s.x);
}

// E033: LDD #$03C0
void block_e033(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE036;
  s.a = 0x03;
  s.b = 0xC0;
  s.cc = nzv16(s.cc, 0x03C0);
}

// E036: BSR E006
void block_e036(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE038;
  core.push16(0xE038);
  s.pc = 0xE006;
}

// E038: LDX #$0200
void block_e038(Rd200RomBLiftedCore &core)
{
  block_e030(core);
  core.state().pc = 0xE03B;
}

// E03B: LDAA #$FF
void block_e03b(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE03D;
  s.a = 0xFF;
  s.cc = nzv8(s.cc, s.a);
}

// E049: CLRA
void block_e049(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE04A;
  s.a = 0x00;
  s.cc = nzv8(s.cc, s.a);
}

// E04A: STAA $00BB
void block_e04a(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE04C;
  core.write8(0x00BB, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E04C: CLRA
void block_e04c(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xE04D;
}

// E04D: STAA $E000
void block_e04d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE050;
  core.write8(0xE000, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E050: LDX #$4000
void block_e050(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE053;
  s.x = 0x4000;
  s.cc = nzv16(s.cc, s.x);
}

// E053: LDAB ,X
void block_e053(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE055;
  s.b = core.read8(s.x);
  s.cc = nzv8(s.cc, s.b);
}

// E055: LDX $01,X
void block_e055(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE057;
  s.x = core.read16(static_cast<uint16_t>(s.x + 1));
  s.cc = nzv16(s.cc, s.x);
}

// E057: STAB $E000
void block_e057(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE05A;
  core.write8(0xE000, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E05A: LDAA ,X
void block_e05a(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE05C;
  s.a = core.read8(s.x);
  s.cc = nzv8(s.cc, s.a);
}

// E05C: STAA $00BA
void block_e05c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE05E;
  core.write8(0x00BA, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E05E: ANDA #$04
void block_e05e(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE060;
  s.a = static_cast<uint8_t>(s.a & 0x04);
  s.cc = and8_nzv(s.cc, s.a);
}

// E060: BNE E064
void block_e060(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE062 : 0xE064;
}

// E062: LDAA #$08
void block_e062(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE064;
  s.a = 0x08;
  s.cc = nzv8(s.cc, s.a);
}

// E064: LDAB $0003
void block_e064(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE066;
  s.b = core.read8(0x0003);
  s.cc = nzv8(s.cc, s.b);
}

// E066: ANDB #$F3
void block_e066(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE068;
  s.b = static_cast<uint8_t>(s.b & 0xF3);
  s.cc = and8_nzv(s.cc, s.b);
}

// E068: ABA
void block_e068(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE069;
  const uint8_t a = s.a;
  const uint8_t b = s.b;
  const uint8_t r = static_cast<uint8_t>(a + b);
  s.a = r;
  s.cc = add8_hnzvc(s.cc, a, b, r);
}

// E069: STAA $0003
void block_e069(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE06B;
  core.write8(0x0003, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E06B: XGDX
void block_e06b(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE06C;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  const uint16_t x = s.x;
  s.x = d;
  s.a = static_cast<uint8_t>((x >> 8) & 0xff);
  s.b = static_cast<uint8_t>(x & 0xff);
}

// E06C: STD $00A5
void block_e06c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE06E;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x00A5, d);
  s.cc = nzv16(s.cc, d);
}

// E06E: ADDD #$0100
void block_e06e(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE071;
  const uint16_t a = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  constexpr uint16_t b = 0x0100;
  const uint16_t r = static_cast<uint16_t>(a + b);
  s.a = static_cast<uint8_t>((r >> 8) & 0xff);
  s.b = static_cast<uint8_t>(r & 0xff);
  s.cc = add16_nzvc(s.cc, a, b, r);
}

// E071: STD $00A7
void block_e071(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE073;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x00A7, d);
  s.cc = nzv16(s.cc, d);
}

// E073: ADDD #$081F
void block_e073(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE076;
  const uint16_t a = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  constexpr uint16_t b = 0x081F;
  const uint16_t r = static_cast<uint16_t>(a + b);
  s.a = static_cast<uint8_t>((r >> 8) & 0xff);
  s.b = static_cast<uint8_t>(r & 0xff);
  s.cc = add16_nzvc(s.cc, a, b, r);
}

// E076: STD $00A9
void block_e076(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE078;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x00A9, d);
  s.cc = nzv16(s.cc, d);
}

// E121: CLRA
void block_e121(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xE122;
}

// E122: STAA $0000
void block_e122(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE124;
  core.write8(0x0000, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E124: TIM #$01,$0003
void block_e124(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE127;
  const uint8_t r = static_cast<uint8_t>(core.read8(0x0003) & 0x01);
  s.cc = and8_nzv(s.cc, r);
}

// E127: BNE E124
void block_e127(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE129 : 0xE124;
}

// E129: LDAA $0002
void block_e129(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE12B;
  s.a = core.read8(0x0002);
  s.cc = nzv8(s.cc, s.a);
}

// E12B: OIM #$10,$0003
void block_e12b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE12E;
  const uint8_t r = static_cast<uint8_t>(core.read8(0x0003) | 0x10);
  core.write8(0x0003, r);
  s.cc = and8_nzv(s.cc, r);
}

// E12E: STAA $00DC
void block_e12e(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE130;
  core.write8(0x00DC, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E130: BPL E134
void block_e130(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool n = (s.cc & CC_N) != 0;
  s.pc = n ? 0xE132 : 0xE134;
}

// E132: BSR E157
void block_e132(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE134);
  s.pc = 0xE157;
}

// E157: TIM #$01,$0003
void block_e157(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE15A;
  const uint8_t t = static_cast<uint8_t>(core.read8(0x0003) & 0x01);
  s.cc = and8_nzv(s.cc, t);
}

// E15A: BEQ E157
void block_e15a(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE157 : 0xE15C;
}

// E15C: LDAA $0002
void block_e15c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE15E;
  s.a = core.read8(0x0002);
  s.cc = nzv8(s.cc, s.a);
}

// E15E: AIM #$EF,$0003
void block_e15e(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE161;
  const uint8_t r = static_cast<uint8_t>(core.read8(0x0003) & 0xef);
  core.write8(0x0003, r);
  s.cc = and8_nzv(s.cc, r);
}

// E161: TIM #$01,$0003
void block_e161(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE164;
  const uint8_t t = static_cast<uint8_t>(core.read8(0x0003) & 0x01);
  s.cc = and8_nzv(s.cc, t);
}

// E164: BNE E161
void block_e164(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE166 : 0xE161;
}

// E166: LDAB $0002
void block_e166(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE168;
  s.b = core.read8(0x0002);
  s.cc = nzv8(s.cc, s.b);
}

// E168: OIM #$10,$0003
void block_e168(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE16B;
  const uint8_t r = static_cast<uint8_t>(core.read8(0x0003) | 0x10);
  core.write8(0x0003, r);
  s.cc = and8_nzv(s.cc, r);
}

// E16B: STD $00E1
void block_e16b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE16D;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x00E1, d);
  s.cc = nzv16(s.cc, d);
}

// E16D: RTS
void block_e16d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// E134: LDAB $00DC
void block_e134(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE136;
  s.b = core.read8(0x00DC);
  s.cc = nzv8(s.cc, s.b);
}

// E136: ANDB #$F0
void block_e136(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE138;
  s.b = static_cast<uint8_t>(s.b & 0xF0);
  s.cc = and8_nzv(s.cc, s.b);
}

// E138: LSRB
void block_e138(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE139;
  const uint8_t in = s.b;
  s.b = static_cast<uint8_t>(s.b >> 1);
  s.cc = lsr8_nzvc(s.cc, in, s.b);
}

// E139: LSRB
void block_e139(Rd200RomBLiftedCore &core)
{
  block_e138(core);
  core.state().pc = 0xE13A;
}

// E13A: LSRB
void block_e13a(Rd200RomBLiftedCore &core)
{
  block_e138(core);
  core.state().pc = 0xE13B;
}

// E13B: LDX #$E16E
void block_e13b(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE13E;
  s.x = 0xE16E;
  s.cc = nzv16(s.cc, s.x);
}

// E13E: ABX
void block_e13e(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE13F;
  s.x = static_cast<uint16_t>(s.x + s.b);
}

// E13F: LDX ,X
void block_e13f(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE141;
  s.x = core.read16(s.x);
  s.cc = nzv16(s.cc, s.x);
}

// E141: JSR ,X
void block_e141(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE143);
  s.pc = s.x;
}

// E143: LDAB #$FF
void block_e143(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE145;
  s.b = 0xff;
  s.cc = nzv8(s.cc, s.b);
}

// E145: CMPB $02
void block_e145(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE147;
  const uint8_t m = core.read8(0x0002);
  const uint8_t r = static_cast<uint8_t>(s.b - m);
  s.cc = sub8_nzvc(s.cc, s.b, m, r);
}

// E147: BNE E143
void block_e147(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE149 : 0xE143;
}

// E149: LDAA $A3
void block_e149(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE14B;
  s.a = core.read8(0x00A3);
  s.cc = nzv8(s.cc, s.a);
}

// E14B: BNE E14F
void block_e14b(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE14D : 0xE14F;
}

// E14D: STAB $00
void block_e14d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE14F;
  core.write8(0x0000, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E14F: LDAB $08
void block_e14f(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE151;
  s.b = core.read8(0x0008);
  s.cc = nzv8(s.cc, s.b);
}

// E151: LDD $0D
void block_e151(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE153;
  const uint16_t d = core.read16(0x000D);
  s.a = static_cast<uint8_t>((d >> 8) & 0xff);
  s.b = static_cast<uint8_t>(d & 0xff);
  s.cc = nzv16(s.cc, d);
}

// E153: AIM #$EF,$03
void block_e153(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE156;
  const uint8_t r = static_cast<uint8_t>(core.read8(0x0003) & 0xef);
  core.write8(0x0003, r);
  s.cc = and8_nzv(s.cc, r);
}

// E156: RTI
void block_e156(Rd200RomBLiftedCore &core)
{
  core.rti();
}

// E078: LDX #$1000
void block_e078(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE07B;
  s.x = 0x1000;
  s.cc = nzv16(s.cc, s.x);
}

// E03D: STAA ,X
void block_e03d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE03F;
  core.write8(s.x, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E03F: XGDX
void block_e03f(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE040;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  const uint16_t x = s.x;
  s.x = d;
  s.a = static_cast<uint8_t>((x >> 8) & 0xff);
  s.b = static_cast<uint8_t>(x & 0xff);
}

// E040: ADDD #$0006
void block_e040(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE043;
  const uint16_t a = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  constexpr uint16_t b = 0x0006;
  const uint16_t r = static_cast<uint16_t>(a + b);
  s.a = static_cast<uint8_t>((r >> 8) & 0xff);
  s.b = static_cast<uint8_t>(r & 0xff);
  s.cc = add16_nzvc(s.cc, a, b, r);
}

// E043: XGDX
void block_e043(Rd200RomBLiftedCore &core)
{
  block_e03f(core);
  core.state().pc = 0xE044;
}

// E044: CPX #$05C0
void block_e044(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE047;
  const uint16_t a = s.x;
  constexpr uint16_t b = 0x05C0;
  const uint16_t r = static_cast<uint16_t>(a - b);
  s.cc = sub16_nzvc(s.cc, a, b, r);
}

// E047: BCS E03D
void block_e047(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE03D : 0xE049;
}

// E22C: STAA ,X
void block_e22c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE22E;
  core.write8(s.x, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E22E: INX
void block_e22e(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE22F;
  s.x = static_cast<uint16_t>(s.x + 1);
  if (s.x == 0)
    s.cc = static_cast<uint8_t>(s.cc | CC_Z);
  else
    s.cc = static_cast<uint8_t>(s.cc & ~CC_Z);
}

// E22F: CPX #$016D
void block_e22f(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE232;
  const uint16_t a = s.x;
  constexpr uint16_t b = 0x016D;
  const uint16_t r = static_cast<uint16_t>(a - b);
  s.cc = sub16_nzvc(s.cc, a, b, r);
}

// E232: BCS E22C
void block_e232(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE22C : 0xE234;
}

// E27D: LDX $0090
void block_e27d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE27F;
  s.x = core.read16(0x0090);
  s.cc = nzv16(s.cc, s.x);
}

// E27F: LDAA $70,X
void block_e27f(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE281;
  s.a = core.read8(static_cast<uint16_t>(s.x + 0x70));
  s.cc = nzv8(s.cc, s.a);
}

// E281: BEQ E28A
void block_e281(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE28A : 0xE283;
}

// E28A: LDAA $0091
void block_e28a(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE28C;
  s.a = core.read8(0x0091);
  s.cc = nzv8(s.cc, s.a);
}

// E28C: INCA
void block_e28c(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE28D;
  s.a = static_cast<uint8_t>(s.a + 1);
  s.cc = inc8_nzv(s.cc, s.a);
}

// E28D: CMPA #$10
void block_e28d(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE28F;
  const uint8_t a = s.a;
  constexpr uint8_t b = 0x10;
  const uint8_t r = static_cast<uint8_t>(a - b);
  s.cc = sub8_nzvc(s.cc, a, b, r);
}

// E28F: BCC E2A1
void block_e28f(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE291 : 0xE2A1;
}

// E291: STAA $0091
void block_e291(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE293;
  core.write8(0x0091, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E293: LDAA $00B1
void block_e293(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE295;
  s.a = core.read8(0x00B1);
  s.cc = nzv8(s.cc, s.a);
}

// E295: INCA
void block_e295(Rd200RomBLiftedCore &core)
{
  block_e28c(core);
  core.state().pc = 0xE296;
}

// E296: STAA $00B1
void block_e296(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE298;
  core.write8(0x00B1, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E298: LDD $00B5
void block_e298(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE29A;
  const uint16_t d = core.read16(0x00B5);
  s.a = static_cast<uint8_t>((d >> 8) & 0xff);
  s.b = static_cast<uint8_t>(d & 0xff);
  s.cc = nzv16(s.cc, d);
}

// E29A: ADDD #$003C
void block_e29a(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE29D;
  const uint16_t a = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  constexpr uint16_t b = 0x003C;
  const uint16_t r = static_cast<uint16_t>(a + b);
  s.a = static_cast<uint8_t>((r >> 8) & 0xff);
  s.b = static_cast<uint8_t>(r & 0xff);
  s.cc = add16_nzvc(s.cc, a, b, r);
}

// E29D: STD $00B5
void block_e29d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE29F;
  core.write16(0x00B5, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
  s.cc = nzv16(s.cc, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
}

// E29F: BRA E27D
void block_e29f(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xE27D;
}

// E2A1: CLI
void block_e2a1(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE2A2;
  s.cc = static_cast<uint8_t>(s.cc & ~0x10);
}

// E2A2: LDX #$0000
void block_e2a2(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE2A5;
  s.x = 0x0000;
  s.cc = nzv16(s.cc, s.x);
}

// E2A5: LDAA #$1E
void block_e2a5(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE2A7;
  s.a = 0x1e;
  s.cc = nzv8(s.cc, s.a);
}

// E2A7: STAA $DB
void block_e2a7(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2A9;
  core.write8(0x00DB, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E2A9: LDAA $70,X
void block_e2a9(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2AB;
  s.a = core.read8(static_cast<uint16_t>(s.x + 0x70));
  s.cc = nzv8(s.cc, s.a);
}

// E2AB: ORAA $71,X
void block_e2ab(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2AD;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x71)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E2AD: ORAA $72,X
void block_e2ad(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2AF;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x72)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E2AF: ORAA $73,X
void block_e2af(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2B1;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x73)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E2B1: ORAA $74,X
void block_e2b1(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2B3;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x74)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E2B3: ORAA $75,X
void block_e2b3(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2B5;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x75)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E2B5: ORAA $76,X
void block_e2b5(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2B7;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x76)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E2B7: ORAA $77,X
void block_e2b7(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2B9;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x77)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E2B9: ORAA $78,X
void block_e2b9(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2BB;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x78)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E2BB: ORAA $79,X
void block_e2bb(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2BD;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x79)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E2BD: ORAA $7A,X
void block_e2bd(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2BF;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x7a)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E2BF: ORAA $7B,X
void block_e2bf(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2C1;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x7b)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E2C1: ORAA $7C,X
void block_e2c1(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2C3;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x7c)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E2C3: ORAA $7D,X
void block_e2c3(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2C5;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x7d)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E2C5: ORAA $7E,X
void block_e2c5(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2C7;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x7e)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E2C7: ORAA $7F,X
void block_e2c7(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2C9;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x7f)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E2C9: BEQ E32A
void block_e2c9(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE32A : 0xE2CB;
}

// E26C: LDAB $0008
void block_e26c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE26E;
  s.b = core.read8(0x0008);
  s.cc = nzv8(s.cc, s.b);
}

// E26E: LDD $000D
void block_e26e(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE270;
  const uint16_t d = core.read16(0x000D);
  s.a = static_cast<uint8_t>((d >> 8) & 0xff);
  s.b = static_cast<uint8_t>(d & 0xff);
  s.cc = nzv16(s.cc, d);
}

// E19B: CLRA
void block_e19b(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xE19C;
}

// E19C: STAA $00A3
void block_e19c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE19E;
  core.write8(0x00A3, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E19E: STAA $0002
void block_e19e(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1A0;
  core.write8(0x0002, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E1A0: JSR E26C
void block_e1a0(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE1A3);
  s.pc = 0xE26C;
}

// E1A3: LDAB $00DC
void block_e1a3(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1A5;
  s.b = core.read8(0x00DC);
  s.cc = nzv8(s.cc, s.b);
}

// E1A5: ANDB #$07
void block_e1a5(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE1A7;
  s.b = static_cast<uint8_t>(s.b & 0x07);
  s.cc = and8_nzv(s.cc, s.b);
}

// E1A7: STAB $00BB
void block_e1a7(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1A9;
  core.write8(0x00BB, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E1A9: CLRA
void block_e1a9(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xE1AA;
}

// E1AA: STAA $E000
void block_e1aa(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1AD;
  core.write8(0xE000, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E1AD: LDX #$4000
void block_e1ad(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE1B0;
  s.x = 0x4000;
  s.cc = nzv16(s.cc, s.x);
}

// E1B0: ABX
void block_e1b0(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE1B1;
  s.x = static_cast<uint16_t>(s.x + s.b);
}

// E1B1: ABX
void block_e1b1(Rd200RomBLiftedCore &core)
{
  block_e1b0(core);
  core.state().pc = 0xE1B2;
}

// E1B2: ABX
void block_e1b2(Rd200RomBLiftedCore &core)
{
  block_e1b0(core);
  core.state().pc = 0xE1B3;
}

// E1B3: LDAA ,X
void block_e1b3(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1B5;
  s.a = core.read8(s.x);
  s.cc = nzv8(s.cc, s.a);
}

// E1B5: LDX $01,X
void block_e1b5(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1B7;
  s.x = core.read16(static_cast<uint16_t>(s.x + 1));
  s.cc = nzv16(s.cc, s.x);
}

// E1B7: STAA $E000
void block_e1b7(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1BA;
  core.write8(0xE000, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E1BA: XGDX
void block_e1ba(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE1BB;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  const uint16_t x = s.x;
  s.x = d;
  s.a = static_cast<uint8_t>((x >> 8) & 0xff);
  s.b = static_cast<uint8_t>(x & 0xff);
}

// E1BB: STD $00A5
void block_e1bb(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1BD;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x00A5, d);
  s.cc = nzv16(s.cc, d);
}

// E1BD: ADDD #$0100
void block_e1bd(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE1C0;
  const uint16_t a = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  constexpr uint16_t b = 0x0100;
  const uint16_t r = static_cast<uint16_t>(a + b);
  s.a = static_cast<uint8_t>((r >> 8) & 0xff);
  s.b = static_cast<uint8_t>(r & 0xff);
  s.cc = add16_nzvc(s.cc, a, b, r);
}

// E1C0: STD $00A7
void block_e1c0(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1C2;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x00A7, d);
  s.cc = nzv16(s.cc, d);
}

// E1C2: ADDD #$081F
void block_e1c2(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE1C5;
  const uint16_t a = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  constexpr uint16_t b = 0x081F;
  const uint16_t r = static_cast<uint16_t>(a + b);
  s.a = static_cast<uint8_t>((r >> 8) & 0xff);
  s.b = static_cast<uint8_t>(r & 0xff);
  s.cc = add16_nzvc(s.cc, a, b, r);
}

// E1C5: STD $00A9
void block_e1c5(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1C7;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x00A9, d);
  s.cc = nzv16(s.cc, d);
}

// E1C7: LDX $00A5
void block_e1c7(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1C9;
  s.x = core.read16(0x00A5);
  s.cc = nzv16(s.cc, s.x);
}

// E1C9: LDAB #$FF
void block_e1c9(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE1CB;
  s.b = 0xFF;
  s.cc = nzv8(s.cc, s.b);
}

// E1CB: STAB $00A4
void block_e1cb(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1CD;
  core.write8(0x00A4, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E1CD: LDAB ,X
void block_e1cd(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1CF;
  s.b = core.read8(s.x);
  s.cc = nzv8(s.cc, s.b);
}

// E1CF: STAB $00BA
void block_e1cf(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1D1;
  core.write8(0x00BA, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E1D1: BITB #$04
void block_e1d1(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE1D3;
  const uint8_t r = static_cast<uint8_t>(s.b & 0x04);
  s.cc = and8_nzv(s.cc, r);
}

// E1D3: BNE E1E1
void block_e1d3(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE1D5 : 0xE1E1;
}

// E1E1: OIM #$04,$0003
void block_e1e1(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1E4;
  const uint8_t r = static_cast<uint8_t>(core.read8(0x0003) | 0x04);
  core.write8(0x0003, r);
  s.cc = and8_nzv(s.cc, r);
}

// E1E4: AIM #$F7,$0003
void block_e1e4(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1E7;
  const uint8_t r = static_cast<uint8_t>(core.read8(0x0003) & 0xF7);
  core.write8(0x0003, r);
  s.cc = and8_nzv(s.cc, r);
}

// E1E7: LDAA #$10
void block_e1e7(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE1E9;
  s.a = 0x10;
  s.cc = nzv8(s.cc, s.a);
}

// E1E9: LDAB #$03
void block_e1e9(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE1EB;
  s.b = 0x03;
  s.cc = nzv8(s.cc, s.b);
}

// E1EB: STAA $0093
void block_e1eb(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1ED;
  core.write8(0x0093, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E1ED: STAB $008F
void block_e1ed(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1EF;
  core.write8(0x008F, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E1EF: LDX #$E254
void block_e1ef(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE1F2;
  s.x = 0xE254;
  s.cc = nzv16(s.cc, s.x);
}

// E1F2: LDAB $00BB
void block_e1f2(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1F4;
  s.b = core.read8(0x00BB);
  s.cc = nzv8(s.cc, s.b);
}

// E1F4: ABX
void block_e1f4(Rd200RomBLiftedCore &core)
{
  block_e1b0(core);
  core.state().pc = 0xE1F5;
}

// E1F5: ABX
void block_e1f5(Rd200RomBLiftedCore &core)
{
  block_e1b0(core);
  core.state().pc = 0xE1F6;
}

// E1F6: ABX
void block_e1f6(Rd200RomBLiftedCore &core)
{
  block_e1b0(core);
  core.state().pc = 0xE1F7;
}

// E1F7: LDAA ,X
void block_e1f7(Rd200RomBLiftedCore &core)
{
  block_e1b3(core);
  core.state().pc = 0xE1F9;
}

// E1F9: STAA $00BC
void block_e1f9(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1FB;
  core.write8(0x00BC, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E1FB: LDD $01,X
void block_e1fb(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE1FD;
  const uint16_t d = core.read16(static_cast<uint16_t>(s.x + 1));
  s.a = static_cast<uint8_t>((d >> 8) & 0xff);
  s.b = static_cast<uint8_t>(d & 0xff);
  s.cc = nzv16(s.cc, d);
}

// E1FD: TST >$00BD
void block_e1fd(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE200;
  const uint8_t t = core.read8(0x00BD);
  s.cc = static_cast<uint8_t>(s.cc & ~(CC_N | CC_Z | CC_V | CC_C));
  if (t & 0x80)
    s.cc |= CC_N;
  if (t == 0)
    s.cc |= CC_Z;
}

// E200: BEQ E204
void block_e200(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE204 : 0xE202;
}

// E204: STAA $00BE
void block_e204(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE206;
  core.write8(0x00BE, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E206: STAB $00BF
void block_e206(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE208;
  core.write8(0x00BF, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E208: CLRA
void block_e208(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xE209;
}

// E209: STAA $00A2
void block_e209(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE20B;
  core.write8(0x00A2, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E20B: STAA $00A0
void block_e20b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE20D;
  core.write8(0x00A0, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E20D: STAA $00A1
void block_e20d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE20F;
  core.write8(0x00A1, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E20F: LDAA #$00
void block_e20f(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE211;
  s.a = 0x00;
  s.cc = nzv8(s.cc, s.a);
}

// E211: STAA $009E
void block_e211(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE213;
  core.write8(0x009E, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E213: LDD #$0000
void block_e213(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE216;
  s.a = 0x00;
  s.b = 0x00;
  s.cc = nzv16(s.cc, 0x0000);
}

// E216: STD $0094
void block_e216(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE218;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x0094, d);
  s.cc = nzv16(s.cc, d);
}

// E218: STD $0096
void block_e218(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE21A;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x0096, d);
  s.cc = nzv16(s.cc, d);
}

// E21A: STD $0098
void block_e21a(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE21C;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x0098, d);
  s.cc = nzv16(s.cc, d);
}

// E21C: STD $009A
void block_e21c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE21E;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x009A, d);
  s.cc = nzv16(s.cc, d);
}

// E21E: STD $009C
void block_e21e(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE220;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x009C, d);
  s.cc = nzv16(s.cc, d);
}

// E220: STAA $0090
void block_e220(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE222;
  core.write8(0x0090, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E222: STAA $008C
void block_e222(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE224;
  core.write8(0x008C, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E224: STAA $008E
void block_e224(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE226;
  core.write8(0x008E, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E226: STAA $0092
void block_e226(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE228;
  core.write8(0x0092, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E228: CLRA
void block_e228(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xE229;
}

// E229: LDX #$00ED
void block_e229(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE22C;
  s.x = 0x00ED;
  s.cc = nzv16(s.cc, s.x);
}

// E234: LDAA #$FF
void block_e234(Rd200RomBLiftedCore &core)
{
  block_e03b(core);
  core.state().pc = 0xE236;
}

// E236: STAA $0080
void block_e236(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE238;
  core.write8(0x0080, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E238: STAA $0081
void block_e238(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE23A;
  core.write8(0x0081, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E23A: STAA $0082
void block_e23a(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE23C;
  core.write8(0x0082, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E23C: STAA $0083
void block_e23c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE23E;
  core.write8(0x0083, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E23E: CLRB
void block_e23e(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE23F;
  s.b = 0x00;
  s.cc = nzv8(s.cc, s.b);
}

// E23F: LDAA #$FF
void block_e23f(Rd200RomBLiftedCore &core)
{
  block_e03b(core);
  core.state().pc = 0xE241;
}

// E241: LDX $0094
void block_e241(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE243;
  s.x = core.read16(0x0094);
  s.cc = nzv16(s.cc, s.x);
}

// E270: CLRA
void block_e270(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE271;
  s.a = 0x00;
  s.cc = nzv8(s.cc, s.a);
}

// E271: STAA $0091
void block_e271(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE273;
  core.write8(0x0091, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E273: LDD #$0200
void block_e273(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE276;
  s.a = 0x02;
  s.b = 0x00;
  s.cc = nzv16(s.cc, 0x0200);
}

// E276: STD $00B5
void block_e276(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE278;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x00B5, d);
  s.cc = nzv16(s.cc, d);
}

// E278: LDD #$1000
void block_e278(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE27B;
  s.a = 0x10;
  s.b = 0x00;
  s.cc = nzv16(s.cc, 0x1000);
}

// E27B: STD $00B1
void block_e27b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE27D;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x00B1, d);
  s.cc = nzv16(s.cc, d);
}

// E243: STAB $20,X
void block_e243(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE245;
  core.write8(static_cast<uint16_t>(s.x + 0x20), s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E245: STAB $30,X
void block_e245(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE247;
  core.write8(static_cast<uint16_t>(s.x + 0x30), s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E247: CLR $50,X
void block_e247(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE249;
  core.write8(static_cast<uint16_t>(s.x + 0x50), 0x00);
  s.cc = static_cast<uint8_t>((s.cc & 0xf0) | CC_Z);
}

// E249: CLR $70,X
void block_e249(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE24B;
  core.write8(static_cast<uint16_t>(s.x + 0x70), 0x00);
  s.cc = static_cast<uint8_t>((s.cc & 0xf0) | CC_Z);
}

// E24B: STAA $60,X
void block_e24b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE24D;
  core.write8(static_cast<uint16_t>(s.x + 0x60), s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E24D: INCB
void block_e24d(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE24E;
  s.b = static_cast<uint8_t>(s.b + 1);
  s.cc = inc8_nzv(s.cc, s.b);
}

// E24E: INX
void block_e24e(Rd200RomBLiftedCore &core)
{
  block_e22e(core);
  core.state().pc = 0xE24F;
}

// E24F: CMPB #$10
void block_e24f(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE251;
  const uint8_t a = s.b;
  constexpr uint8_t b = 0x10;
  const uint8_t r = static_cast<uint8_t>(a - b);
  s.cc = sub8_nzvc(s.cc, a, b, r);
}

// E251: BCS E243
void block_e251(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE243 : 0xE253;
}

// E253: RTS
void block_e253(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// E32A: SEI
void block_e32a(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE32B;
  s.cc = static_cast<uint8_t>(s.cc | 0x10);
}

// E32B: RTS
void block_e32b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// E51B: LDX $0094
void block_e51b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE51D;
  s.x = core.read16(0x0094);
  s.cc = nzv16(s.cc, s.x);
}

// E51D: LDAB $20,X
void block_e51d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE51F;
  s.b = core.read8(static_cast<uint16_t>(s.x + 0x20));
  s.cc = nzv8(s.cc, s.b);
}

// E51F: INX
void block_e51f(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE520;
  s.x = static_cast<uint16_t>(s.x + 1);
}

// E520: CPX $0092
void block_e520(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE522;
  const uint16_t a = s.x;
  const uint16_t b = core.read16(0x0092);
  const uint16_t r = static_cast<uint16_t>(a - b);
  s.cc = sub16_nzvc(s.cc, a, b, r);
}

// E522: BCS E527
void block_e522(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE527 : 0xE524;
}

// E524: LDX #$0000
void block_e524(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE527;
  s.x = 0x0000;
  s.cc = nzv16(s.cc, s.x);
}

// E527: STX $0094
void block_e527(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE529;
  core.write16(0x0094, s.x);
  s.cc = nzv16(s.cc, s.x);
}

// E529: RTS
void block_e529(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// E52A: LDAB $0097
void block_e52a(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE52C;
  s.b = core.read8(0x0097);
  s.cc = nzv8(s.cc, s.b);
}

// E52C: INCB
void block_e52c(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE52D;
  s.b = static_cast<uint8_t>(s.b + 1);
  s.cc = inc8_nzv(s.cc, s.b);
}

// E52D: CMPB $0093
void block_e52d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE52F;
  const uint8_t m = core.read8(0x0093);
  const uint8_t r = static_cast<uint8_t>(s.b - m);
  s.cc = sub8_nzvc(s.cc, s.b, m, r);
}

// E52F: BCS E532
void block_e52f(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE532 : 0xE531;
}

// E531: CLRB
void block_e531(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE532;
  s.b = 0x00;
  s.cc = nzv8(s.cc, s.b);
}

// E532: STAB $0097
void block_e532(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE534;
  core.write8(0x0097, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E534: RTS
void block_e534(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// E535: LDAB $0099
void block_e535(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE537;
  s.b = core.read8(0x0099);
  s.cc = nzv8(s.cc, s.b);
}

// E537: INCB
void block_e537(Rd200RomBLiftedCore &core)
{
  block_e52c(core);
  core.state().pc = 0xE538;
}

// E538: CMPB $0093
void block_e538(Rd200RomBLiftedCore &core)
{
  block_e52d(core);
  core.state().pc = 0xE53A;
}

// E53A: BCS E53D
void block_e53a(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE53D : 0xE53C;
}

// E53C: CLRB
void block_e53c(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE53D;
  s.b = 0x00;
  s.cc = nzv8(s.cc, s.b);
}

// E53D: STAB $0099
void block_e53d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE53F;
  core.write8(0x0099, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E53F: RTS
void block_e53f(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// E540: LDAB $009B
void block_e540(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE542;
  s.b = core.read8(0x009B);
  s.cc = nzv8(s.cc, s.b);
}

// E542: INCB
void block_e542(Rd200RomBLiftedCore &core)
{
  block_e52c(core);
  core.state().pc = 0xE543;
}

// E543: CMPB $0093
void block_e543(Rd200RomBLiftedCore &core)
{
  block_e52d(core);
  core.state().pc = 0xE545;
}

// E545: BCS E548
void block_e545(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE548 : 0xE547;
}

// E547: CLRB
void block_e547(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE548;
  s.b = 0x00;
  s.cc = nzv8(s.cc, s.b);
}

// E548: STAB $009B
void block_e548(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE54A;
  core.write8(0x009B, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E54A: RTS
void block_e54a(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// E54B: LDAB $009D
void block_e54b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE54D;
  s.b = core.read8(0x009D);
  s.cc = nzv8(s.cc, s.b);
}

// E54D: INCB
void block_e54d(Rd200RomBLiftedCore &core)
{
  block_e52c(core);
  core.state().pc = 0xE54E;
}

// E54E: CMPB $0093
void block_e54e(Rd200RomBLiftedCore &core)
{
  block_e52d(core);
  core.state().pc = 0xE550;
}

// E550: BCS E553
void block_e550(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE553 : 0xE552;
}

// E552: CLRB
void block_e552(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE553;
  s.b = 0x00;
  s.cc = nzv8(s.cc, s.b);
}

// E553: STAB $009D
void block_e553(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE555;
  core.write8(0x009D, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E555: RTS
void block_e555(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// E59D: LDAA #$40
void block_e59d(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE59F;
  s.a = 0x40;
  s.cc = nzv8(s.cc, s.a);
}

// E59F: BRA E5A2
void block_e59f(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xE5A2;
}

// E5A1: CLRA
void block_e5a1(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xE5A2;
}

// E5A2: STAA $00A2
void block_e5a2(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5A4;
  core.write8(0x00A2, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E5A4: LDAA #$FF
void block_e5a4(Rd200RomBLiftedCore &core)
{
  block_e03b(core);
  core.state().pc = 0xE5A6;
}

// E5A6: CMPA $0002
void block_e5a6(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5A8;
  const uint8_t m = core.read8(0x0002);
  const uint8_t r = static_cast<uint8_t>(s.a - m);
  s.cc = sub8_nzvc(s.cc, s.a, m, r);
}

// E5A8: BNE E5A6
void block_e5a8(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE5AA : 0xE5A6;
}

// E5AA: STAA $0000
void block_e5aa(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5AC;
  core.write8(0x0000, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E5AC: LDAA $00A1
void block_e5ac(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5AE;
  s.a = core.read8(0x00A1);
  s.cc = nzv8(s.cc, s.a);
}

// E5AE: BEQ E5BE
void block_e5ae(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE5BE : 0xE5B0;
}

// E5B0: LDAB $00E2
void block_e5b0(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5B2;
  s.b = core.read8(0x00E2);
  s.cc = nzv8(s.cc, s.b);
}

// E5B2: LDAA #$F7
void block_e5b2(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE5B4;
  s.a = 0xF7;
  s.cc = nzv8(s.cc, s.a);
}

// E5B4: MUL
void block_e5b4(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE5B5;
  const uint16_t r = static_cast<uint16_t>(static_cast<uint16_t>(s.a) * static_cast<uint16_t>(s.b));
  s.a = static_cast<uint8_t>((r >> 8) & 0xff);
  s.b = static_cast<uint8_t>(r & 0xff);
  s.cc = static_cast<uint8_t>(s.cc & ~CC_C);
  if (r & 0x0080)
    s.cc |= CC_C;
}

// E5B5: TAB
void block_e5b5(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE5B6;
  s.b = s.a;
  s.cc = nzv8(s.cc, s.b);
}

// E5B6: LDAA $00E1
void block_e5b6(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5B8;
  s.a = core.read8(0x00E1);
  s.cc = nzv8(s.cc, s.a);
}

// E5B8: LDX $00A5
void block_e5b8(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5BA;
  s.x = core.read16(0x00A5);
  s.cc = nzv16(s.cc, s.x);
}

// E5BA: ADDB #$80
void block_e5ba(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE5BC;
  const uint8_t a = s.b;
  constexpr uint8_t b = 0x80;
  const uint8_t r = static_cast<uint8_t>(a + b);
  s.b = r;
  s.cc = add8_hnzvc(s.cc, a, b, r);
}

// E5BC: BRA E5C2
void block_e5bc(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xE5C2;
}

// E5BE: LDD $00E1
void block_e5be(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5C0;
  const uint16_t d = core.read16(0x00E1);
  s.a = static_cast<uint8_t>((d >> 8) & 0xff);
  s.b = static_cast<uint8_t>(d & 0xff);
  s.cc = nzv16(s.cc, d);
}

// E5C0: LDX $00A5
void block_e5c0(Rd200RomBLiftedCore &core)
{
  block_e5b8(core);
  core.state().pc = 0xE5C2;
}

// E5C2: ABX
void block_e5c2(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE5C3;
  s.x = static_cast<uint16_t>(s.x + s.b);
}

// E5C3: LDAB ,X
void block_e5c3(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5C5;
  s.b = core.read8(s.x);
  s.cc = nzv8(s.cc, s.b);
}

// E5C5: STAB $00C0
void block_e5c5(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5C7;
  core.write8(0x00C0, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E5C7: STAA $009F
void block_e5c7(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5C9;
  core.write8(0x009F, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E5C9: JSR E51B
void block_e5c9(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE5CC);
  s.pc = 0xE51B;
}

// E5CC: STAB $0091
void block_e5cc(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5CE;
  core.write8(0x0091, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E5CE: LDX $009E
void block_e5ce(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5D0;
  s.x = core.read16(0x009E);
  s.cc = nzv16(s.cc, s.x);
}

// E5D0: ORAB #$A0
void block_e5d0(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE5D2;
  s.b = static_cast<uint8_t>(s.b | 0xA0);
  s.cc = and8_nzv(s.cc, s.b);
}

// E5D2: STAB $ED,X
void block_e5d2(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5D4;
  core.write8(static_cast<uint16_t>(s.x + 0xED), s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E5D4: LDX $0090
void block_e5d4(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5D6;
  s.x = core.read16(0x0090);
  s.cc = nzv16(s.cc, s.x);
}

// E5D6: LDAB $00C0
void block_e5d6(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5D8;
  s.b = core.read8(0x00C0);
  s.cc = nzv8(s.cc, s.b);
}

// E5D8: STAB $40,X
void block_e5d8(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5DA;
  core.write8(static_cast<uint16_t>(s.x + 0x40), s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E5DA: INC $0002
void block_e5da(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5DD;
  uint8_t v = core.read8(0x0002);
  v = static_cast<uint8_t>(v + 1);
  core.write8(0x0002, v);
  s.cc = inc8_nzv(s.cc, v);
}

// E5DD: LDAB $50,X
void block_e5dd(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5DF;
  s.b = core.read8(static_cast<uint16_t>(s.x + 0x50));
  s.cc = nzv8(s.cc, s.b);
}

// E5DF: BEQ E5FF
void block_e5df(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE5FF : 0xE5E1;
}

// E5E1: BMI E5E9
void block_e5e1(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool n = (s.cc & CC_N) != 0;
  s.pc = n ? 0xE5E9 : 0xE5E3;
}

// E5E3: BITB #$70
void block_e5e3(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE5E5;
  const uint8_t t = static_cast<uint8_t>(s.b & 0x70);
  s.cc = and8_nzv(s.cc, t);
}

// E5E5: BNE E5F4
void block_e5e5(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE5E7 : 0xE5F4;
}

// E5E7: BRA E5F7
void block_e5e7(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xE5F7;
}

// E5E9: LDAB $30,X
void block_e5e9(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5EB;
  s.b = core.read8(static_cast<uint16_t>(s.x + 0x30));
  s.cc = nzv8(s.cc, s.b);
}

// E5EB: LDAA #$00
void block_e5eb(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xE5ED;
}

// E5ED: XGDX
void block_e5ed(Rd200RomBLiftedCore &core)
{
  block_e03f(core);
  core.state().pc = 0xE5EE;
}

// E5EE: AIM #$40,$ED,X
void block_e5ee(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5F3;
  const uint16_t a = static_cast<uint16_t>(s.x + 0xED);
  const uint8_t r = static_cast<uint8_t>(core.read8(a) & 0x40);
  core.write8(a, r);
  s.cc = and8_nzv(s.cc, r);
}

// E5F3: TXS
void block_e5f3(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE5F4;
  s.s = s.x;
}

// E5F4: JSR E540
void block_e5f4(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE5F7);
  s.pc = 0xE540;
}

// E5F7: JSR E54B
void block_e5f7(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE5FA);
  s.pc = 0xE54B;
}

// E5FA: DEC $0002
void block_e5fa(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5FD;
  uint8_t v = core.read8(0x0002);
  v = static_cast<uint8_t>(v - 1);
  core.write8(0x0002, v);
  s.cc = dec8_nzv(s.cc, v);
}

// E5FD: LDX $0090
void block_e5fd(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE5FF;
  s.x = core.read16(0x0090);
  s.cc = nzv16(s.cc, s.x);
}

// E5FF: LDAA $00A2
void block_e5ff(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE601;
  s.a = core.read8(0x00A2);
  s.cc = nzv8(s.cc, s.a);
}

// E601: ORAA $00A0
void block_e601(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE603;
  s.a = static_cast<uint8_t>(s.a | core.read8(0x00A0));
  s.cc = and8_nzv(s.cc, s.a);
}

// E603: ORAA #$81
void block_e603(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE605;
  s.a = static_cast<uint8_t>(s.a | 0x81);
  s.cc = and8_nzv(s.cc, s.a);
}

// E605: STAA $50,X
void block_e605(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE607;
  core.write8(static_cast<uint16_t>(s.x + 0x50), s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E607: LDAA $009F
void block_e607(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE609;
  s.a = core.read8(0x009F);
  s.cc = nzv8(s.cc, s.a);
}

// E609: STAA $30,X
void block_e609(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE60B;
  core.write8(static_cast<uint16_t>(s.x + 0x30), s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E60B: LDAB $0091
void block_e60b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE60D;
  s.b = core.read8(0x0091);
  s.cc = nzv8(s.cc, s.b);
}

// E60D: BSR E656
void block_e60d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE60F);
  s.pc = 0xE656;
}

// E60F: LDAA $009F
void block_e60f(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE611;
  s.a = core.read8(0x009F);
  s.cc = nzv8(s.cc, s.a);
}

// E611: SUBA #$0F
void block_e611(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE613;
  constexpr uint8_t b = 0x0f;
  const uint8_t a = s.a;
  const uint8_t r = static_cast<uint8_t>(a - b);
  s.a = r;
  s.cc = sub8_nzvc(s.cc, a, b, r);
}

// E613: BCC E619
void block_e613(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE615 : 0xE619;
}

// E615: ADDA #$0C
void block_e615(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE617;
  const uint8_t a = s.a;
  constexpr uint8_t b = 0x0c;
  const uint8_t r = static_cast<uint8_t>(a + b);
  s.a = r;
  s.cc = add8_hnzvc(s.cc, a, b, r);
}

// E617: BCC E615
void block_e617(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE619 : 0xE615;
}

// E619: CMPA #$62
void block_e619(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE61B;
  constexpr uint8_t m = 0x62;
  const uint8_t r = static_cast<uint8_t>(s.a - m);
  s.cc = sub8_nzvc(s.cc, s.a, m, r);
}

// E61B: BLS E621
void block_e61b(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = (c || z) ? 0xE621 : 0xE61D;
}

// E61D: SUBA #$0C
void block_e61d(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE61F;
  constexpr uint8_t b = 0x0c;
  const uint8_t a = s.a;
  const uint8_t r = static_cast<uint8_t>(a - b);
  s.a = r;
  s.cc = sub8_nzvc(s.cc, a, b, r);
}

// E61F: BRA E619
void block_e61f(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xE619;
}

// E621: JSR E79B
void block_e621(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE624);
  s.pc = 0xE79B;
}

// E624: INS
void block_e624(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE625;
  s.s = static_cast<uint16_t>(s.s + 1);
}

// E625: INS
void block_e625(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE626;
  s.s = static_cast<uint16_t>(s.s + 1);
}

// E626: JMP E14F
void block_e626(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xE14F;
}

// E656: CMPA #$48
void block_e656(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE658;
  constexpr uint8_t m = 0x48;
  const uint8_t r = static_cast<uint8_t>(s.a - m);
  s.cc = sub8_nzvc(s.cc, s.a, m, r);
}

// E658: BHI E668
void block_e658(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = (!c && !z) ? 0xE668 : 0xE65A;
}

// E65A: LDX #$0000
void block_e65a(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE65D;
  s.x = 0x0000;
  s.cc = nzv16(s.cc, s.x);
}

// E65D: CMPA $80,X
void block_e65d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE65F;
  const uint8_t m = core.read8(static_cast<uint16_t>(s.x + 0x80));
  const uint8_t r = static_cast<uint8_t>(s.a - m);
  s.cc = sub8_nzvc(s.cc, s.a, m, r);
}

// E65F: BEQ E629
void block_e65f(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE629 : 0xE661;
}

// E661: BCS E670
void block_e661(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE670 : 0xE663;
}

// E663: INX
void block_e663(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE664;
  s.x = static_cast<uint16_t>(s.x + 1);
}

// E664: CPX $008E
void block_e664(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE666;
  const uint16_t m = core.read16(0x008E);
  const uint16_t r = static_cast<uint16_t>(s.x - m);
  s.cc = sub16_nzvc(s.cc, s.x, m, r);
}

// E666: BLS E65D
void block_e666(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = (c || z) ? 0xE65D : 0xE668;
}

// E668: TBA
void block_e668(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE669;
  s.a = s.b;
  s.cc = nzv8(s.cc, s.a);
}

// E669: JSR E4FA
void block_e669(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE66C);
  s.pc = 0xE4FA;
}

// E66C: JSR E52A
void block_e66c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE66F);
  s.pc = 0xE52A;
}

// E66F: RTS
void block_e66f(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// E670: TST $80,X
void block_e670(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE672;
  const uint8_t t = core.read8(static_cast<uint16_t>(s.x + 0x80));
  s.cc = static_cast<uint8_t>(s.cc & ~(CC_N | CC_Z | CC_V | CC_C));
  if (t & 0x80)
    s.cc |= CC_N;
  if (t == 0)
    s.cc |= CC_Z;
}

// E672: BPL E682
void block_e672(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool n = (s.cc & CC_N) != 0;
  s.pc = n ? 0xE674 : 0xE682;
}

// E674: STAA $80,X
void block_e674(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE676;
  core.write8(static_cast<uint16_t>(s.x + 0x80), s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E676: STAB $84,X
void block_e676(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE678;
  core.write8(static_cast<uint16_t>(s.x + 0x84), s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E678: LDAA $00C0
void block_e678(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE67A;
  s.a = core.read8(0x00C0);
  s.cc = nzv8(s.cc, s.a);
}

// E67A: STAA $88,X
void block_e67a(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE67C;
  core.write8(static_cast<uint16_t>(s.x + 0x88), s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E67C: LDAA #$00
void block_e67c(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xE67E;
}

// E67E: XGDX
void block_e67e(Rd200RomBLiftedCore &core)
{
  block_e03f(core);
  core.state().pc = 0xE67F;
}

// E67F: STAB $60,X
void block_e67f(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE681;
  core.write8(static_cast<uint16_t>(s.x + 0x60), s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E681: RTS
void block_e681(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// E682: STX $008C
void block_e682(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE684;
  core.write16(0x008C, s.x);
  s.cc = nzv16(s.cc, s.x);
}

// E684: LDX $008E
void block_e684(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE686;
  s.x = core.read16(0x008E);
  s.cc = nzv16(s.cc, s.x);
}

// E686: TST $80,X
void block_e686(Rd200RomBLiftedCore &core)
{
  block_e670(core);
  core.state().pc = 0xE688;
}

// E688: BMI E6AE
void block_e688(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool n = (s.cc & CC_N) != 0;
  s.pc = n ? 0xE6AE : 0xE68A;
}

// E68A: LDAA $84,X
void block_e68a(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE68C;
  s.a = core.read8(static_cast<uint16_t>(s.x + 0x84));
  s.cc = nzv8(s.cc, s.a);
}

// E68C: LDAB $0091
void block_e68c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE68E;
  s.b = core.read8(0x0091);
  s.cc = nzv8(s.cc, s.b);
}

// E68E: PSHB
void block_e68e(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE68F;
  core.push8(s.b);
}

// E68F: STAA $0091
void block_e68f(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE691;
  core.write8(0x0091, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E691: LDAB #$FF
void block_e691(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE693;
  s.b = 0xFF;
  s.cc = nzv8(s.cc, s.b);
}

// E693: LDX $0090
void block_e693(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE695;
  s.x = core.read16(0x0090);
  s.cc = nzv16(s.cc, s.x);
}

// E695: STAB $60,X
void block_e695(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE697;
  core.write8(static_cast<uint16_t>(s.x + 0x60), s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E697: TST $50,X
void block_e697(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE699;
  const uint8_t t = core.read8(static_cast<uint16_t>(s.x + 0x50));
  s.cc = static_cast<uint8_t>(s.cc & ~(CC_N | CC_Z | CC_V | CC_C));
  if (t & 0x80)
    s.cc |= CC_N;
  if (t == 0)
    s.cc |= CC_Z;
}

// E699: BPL E6A0
void block_e699(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool n = (s.cc & CC_N) != 0;
  s.pc = n ? 0xE69B : 0xE6A0;
}

// E69B: JSR E4FA
void block_e69b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE69E);
  s.pc = 0xE4FA;
}

// E69E: BRA E6A6
void block_e69e(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xE6A6;
}

// E6A0: JSR E4FE
void block_e6a0(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE6A3);
  s.pc = 0xE4FE;
}

// E6A3: JSR E535
void block_e6a3(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE6A6);
  s.pc = 0xE535;
}

// E6A6: JSR E52A
void block_e6a6(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE6A9);
  s.pc = 0xE52A;
}

// E6A9: PULB
void block_e6a9(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE6AA;
  s.b = core.pop8();
}

// E6AA: STAB $0091
void block_e6aa(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE6AC;
  core.write8(0x0091, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E6AC: LDX $008E
void block_e6ac(Rd200RomBLiftedCore &core)
{
  block_e684(core);
  core.state().pc = 0xE6AE;
}

// E6AE: CPX $008C
void block_e6ae(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE6B0;
  const uint16_t m = core.read16(0x008C);
  const uint16_t r = static_cast<uint16_t>(s.x - m);
  s.cc = sub16_nzvc(s.cc, s.x, m, r);
}

// E6B0: BLS E6CB
void block_e6b0(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = (c || z) ? 0xE6CB : 0xE6B2;
}

// E6B2: DEX
void block_e6b2(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE6B3;
  s.x = static_cast<uint16_t>(s.x - 1);
}

// E6B3: LDAA $80,X
void block_e6b3(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE6B5;
  s.a = core.read8(static_cast<uint16_t>(s.x + 0x80));
  s.cc = nzv8(s.cc, s.a);
}

// E6B5: BMI E6C7
void block_e6b5(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool n = (s.cc & CC_N) != 0;
  s.pc = n ? 0xE6C7 : 0xE6B7;
}

// E6B7: STAA $81,X
void block_e6b7(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE6B9;
  core.write8(static_cast<uint16_t>(s.x + 0x81), s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E6B9: LDAA $88,X
void block_e6b9(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE6BB;
  s.a = core.read8(static_cast<uint16_t>(s.x + 0x88));
  s.cc = nzv8(s.cc, s.a);
}

// E6BB: STAA $89,X
void block_e6bb(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE6BD;
  core.write8(static_cast<uint16_t>(s.x + 0x89), s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E6BD: LDAB $84,X
void block_e6bd(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE6BF;
  s.b = core.read8(static_cast<uint16_t>(s.x + 0x84));
  s.cc = nzv8(s.cc, s.b);
}

// E6BF: STAB $85,X
void block_e6bf(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE6C1;
  core.write8(static_cast<uint16_t>(s.x + 0x85), s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E6C1: LDAA #$00
void block_e6c1(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xE6C3;
}

// E6C3: XGDX
void block_e6c3(Rd200RomBLiftedCore &core)
{
  block_e03f(core);
  core.state().pc = 0xE6C4;
}

// E6C4: INC $60,X
void block_e6c4(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE6C6;
  const uint16_t a = static_cast<uint16_t>(s.x + 0x60);
  uint8_t v = core.read8(a);
  v = static_cast<uint8_t>(v + 1);
  core.write8(a, v);
  s.cc = inc8_nzv(s.cc, v);
}

// E6C6: XGDX
void block_e6c6(Rd200RomBLiftedCore &core)
{
  block_e03f(core);
  core.state().pc = 0xE6C7;
}

// E6C7: CPX $008C
void block_e6c7(Rd200RomBLiftedCore &core)
{
  block_e6ae(core);
  core.state().pc = 0xE6C9;
}

// E6C9: BHI E6B2
void block_e6c9(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = (!c && !z) ? 0xE6B2 : 0xE6CB;
}

// E6CB: LDAA $009F
void block_e6cb(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE6CD;
  s.a = core.read8(0x009F);
  s.cc = nzv8(s.cc, s.a);
}

// E6CD: LDAB $0091
void block_e6cd(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE6CF;
  s.b = core.read8(0x0091);
  s.cc = nzv8(s.cc, s.b);
}

// E6CF: BRA E674
void block_e6cf(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xE674;
}

// E097: LDX #$1000
void block_e097(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE09A;
  s.x = 0x1000;
  s.cc = nzv16(s.cc, s.x);
}

// E09A: LDD #$FF01
void block_e09a(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE09D;
  s.a = 0xFF;
  s.b = 0x01;
  s.cc = nzv16(s.cc, 0xFF01);
}

// E09D: STD $06,X
void block_e09d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE09F;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(static_cast<uint16_t>(s.x + 6), d);
  s.cc = nzv16(s.cc, d);
}

// E09F: XGDX
void block_e09f(Rd200RomBLiftedCore &core)
{
  block_e03f(core);
  core.state().pc = 0xE0A0;
}

// E0A0: INCA
void block_e0a0(Rd200RomBLiftedCore &core)
{
  block_e28c(core);
  core.state().pc = 0xE0A1;
}

// E0A1: XGDX
void block_e0a1(Rd200RomBLiftedCore &core)
{
  block_e03f(core);
  core.state().pc = 0xE0A2;
}

// E0A2: CPX #$2000
void block_e0a2(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE0A5;
  const uint16_t a = s.x;
  constexpr uint16_t b = 0x2000;
  const uint16_t r = static_cast<uint16_t>(a - b);
  s.cc = sub16_nzvc(s.cc, a, b, r);
}

// E0A5: BCS E09D
void block_e0a5(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE09D : 0xE0A7;
}

// E0A7: CLRA
void block_e0a7(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xE0A8;
}

// E07B: LDD #$0001
void block_e07b(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE07E;
  s.a = 0x00;
  s.b = 0x01;
  s.cc = nzv16(s.cc, 0x0001);
}

// E07E: STD $04,X
void block_e07e(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE080;
  core.write16(static_cast<uint16_t>(s.x + 4), static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
  s.cc = nzv16(s.cc, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
}

// E080: STX $00B1
void block_e080(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE082;
  core.write16(0x00B1, s.x);
  s.cc = nzv16(s.cc, s.x);
}

// E082: STD $06,X
void block_e082(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE084;
  core.write16(static_cast<uint16_t>(s.x + 6), static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
  s.cc = nzv16(s.cc, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
}

// E084: LDD $00B1
void block_e084(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE086;
  const uint16_t d = core.read16(0x00B1);
  s.a = static_cast<uint8_t>((d >> 8) & 0xff);
  s.b = static_cast<uint8_t>(d & 0xff);
  s.cc = nzv16(s.cc, d);
}

// E086: STD ,X
void block_e086(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE088;
  core.write16(s.x, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
  s.cc = nzv16(s.cc, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
}

// E088: LDD #$0000
void block_e088(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE08B;
  s.a = 0x00;
  s.b = 0x00;
  s.cc = nzv16(s.cc, 0x0000);
}

// E08B: STD $02,X
void block_e08b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE08D;
  core.write16(static_cast<uint16_t>(s.x + 2), static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
  s.cc = nzv16(s.cc, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
}

// E08D: XGDX
void block_e08d(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE08E;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  const uint16_t x = s.x;
  s.x = d;
  s.a = static_cast<uint8_t>((x >> 8) & 0xff);
  s.b = static_cast<uint8_t>(x & 0xff);
}

// E08E: ADDD #$0010
void block_e08e(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE091;
  const uint16_t a = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  constexpr uint16_t b = 0x0010;
  const uint16_t r = static_cast<uint16_t>(a + b);
  s.a = static_cast<uint8_t>((r >> 8) & 0xff);
  s.b = static_cast<uint8_t>(r & 0xff);
  s.cc = add16_nzvc(s.cc, a, b, r);
}

// E091: XGDX
void block_e091(Rd200RomBLiftedCore &core)
{
  block_e08d(core);
  core.state().pc = 0xE092;
}

// E092: CPX #$2000
void block_e092(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE095;
  const uint16_t a = s.x;
  constexpr uint16_t b = 0x2000;
  const uint16_t r = static_cast<uint16_t>(a - b);
  s.cc = sub16_nzvc(s.cc, a, b, r);
}

// E095: BCS E07B
void block_e095(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE07B : 0xE097;
}

// E0A8: DECA
void block_e0a8(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE0A9;
  s.a = static_cast<uint8_t>(s.a - 1);
  s.cc = dec8_nzv(s.cc, s.a);
}

// E0A9: BNE E0A8
void block_e0a9(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE0AB : 0xE0A8;
}

// E0AB: LDX #$1000
void block_e0ab(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE0AE;
  s.x = 0x1000;
  s.cc = nzv16(s.cc, s.x);
}

// E0AE: CLRB
void block_e0ae(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE0AF;
  s.b = 0x00;
  s.cc = nzv8(s.cc, s.b);
}

// E0AF: STD $04,X
void block_e0af(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE0B1;
  core.write16(static_cast<uint16_t>(s.x + 4), static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
  s.cc = nzv16(s.cc, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
}

// E0B1: XGDX
void block_e0b1(Rd200RomBLiftedCore &core)
{
  block_e03f(core);
  core.state().pc = 0xE0B2;
}

// E0B2: ADDD #$0010
void block_e0b2(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE0B5;
  const uint16_t a = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  constexpr uint16_t b = 0x0010;
  const uint16_t r = static_cast<uint16_t>(a + b);
  s.a = static_cast<uint8_t>((r >> 8) & 0xff);
  s.b = static_cast<uint8_t>(r & 0xff);
  s.cc = add16_nzvc(s.cc, a, b, r);
}

// E0B5: XGDX
void block_e0b5(Rd200RomBLiftedCore &core)
{
  block_e03f(core);
  core.state().pc = 0xE0B6;
}

// E0B6: CPX #$2000
void block_e0b6(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE0B9;
  const uint16_t a = s.x;
  constexpr uint16_t b = 0x2000;
  const uint16_t r = static_cast<uint16_t>(a - b);
  s.cc = sub16_nzvc(s.cc, a, b, r);
}

// E0B9: BCS E0AF
void block_e0b9(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE0AF : 0xE0BB;
}

// E0BB: CLRA
void block_e0bb(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xE0BC;
}

// E0BC: STAA $00
void block_e0bc(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE0BE;
  core.write8(0x0000, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E0BE: CLI
void block_e0be(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE0BF;
  s.cc = static_cast<uint8_t>(s.cc & ~0x10);
}

// E0BF: BRA E0C1
void block_e0bf(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xE0C1;
}

// E0C1: Main idle loop entry.
// Keep PC parked here; IRQ handlers drive MIDI ingress/sound updates asynchronously.
void block_e0c1(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xE0C1;
}

// EB05: LDX $00B1
void block_eb05(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB07;
  s.x = core.read16(0x00B1);
  s.cc = nzv16(s.cc, s.x);
}

// EB07: STD $94,X
void block_eb07(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB09;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(static_cast<uint16_t>(s.x + 0x94), d);
  s.cc = nzv16(s.cc, d);
}

// EB09: LDX $00B1
void block_eb09(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB0B;
  s.x = core.read16(0x00B1);
  s.cc = nzv16(s.cc, s.x);
}

// EB0B: LDAB $00A4
void block_eb0b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB0D;
  s.b = core.read8(0x00A4);
  s.cc = nzv8(s.cc, s.b);
}

// EB0D: LDAA #$FF
void block_eb0d(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xEB0F;
  s.a = 0xFF;
  s.cc = nzv8(s.cc, s.a);
}

// EB0F: STD $96,X
void block_eb0f(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB11;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(static_cast<uint16_t>(s.x + 0x96), d);
  s.cc = nzv16(s.cc, d);
}

// EB11: RTS
void block_eb11(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// EB12: LDAA $01,X
void block_eb12(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB14;
  s.a = core.read8(static_cast<uint16_t>(s.x + 1));
  s.cc = nzv8(s.cc, s.a);
}

// EB14: BRA EB27
void block_eb14(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xEB27;
}

// EB16: LDAA $00C2
void block_eb16(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB18;
  s.a = core.read8(0x00C2);
  s.cc = nzv8(s.cc, s.a);
}

// EB18: BEQ EB12
void block_eb18(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xEB12 : 0xEB1A;
}

// EB1A: LDAB $03,X
void block_eb1a(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB1C;
  s.b = core.read8(static_cast<uint16_t>(s.x + 3));
  s.cc = nzv8(s.cc, s.b);
}

// EB1C: MUL
void block_eb1c(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xEB1D;
  const uint16_t r = static_cast<uint16_t>(static_cast<uint16_t>(s.a) * static_cast<uint16_t>(s.b));
  s.a = static_cast<uint8_t>((r >> 8) & 0xff);
  s.b = static_cast<uint8_t>(r & 0xff);
  s.cc = static_cast<uint8_t>(s.cc & ~CC_C);
  if (r & 0x0080)
    s.cc |= CC_C;
}

// EB1D: STD $00B7
void block_eb1d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB1F;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x00B7, d);
  s.cc = nzv16(s.cc, d);
}

// EB1F: CLRA
void block_eb1f(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xEB20;
}

// EB20: SUBA $00C2
void block_eb20(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB22;
  const uint8_t a = s.a;
  const uint8_t b = core.read8(0x00C2);
  const uint8_t r = static_cast<uint8_t>(a - b);
  s.a = r;
  s.cc = sub8_nzvc(s.cc, a, b, r);
}

// EB22: LDAB $01,X
void block_eb22(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB24;
  s.b = core.read8(static_cast<uint16_t>(s.x + 1));
  s.cc = nzv8(s.cc, s.b);
}

// EB24: MUL
void block_eb24(Rd200RomBLiftedCore &core)
{
  block_eb1c(core);
  core.state().pc = 0xEB25;
}

// EB25: ADDD $00B7
void block_eb25(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB27;
  const uint16_t a = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  const uint16_t b = core.read16(0x00B7);
  const uint16_t r = static_cast<uint16_t>(a + b);
  s.a = static_cast<uint8_t>((r >> 8) & 0xff);
  s.b = static_cast<uint8_t>(r & 0xff);
  s.cc = add16_nzvc(s.cc, a, b, r);
}

// EB27: PSHA
void block_eb27(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB28;
  core.push8(s.a);
}

// EB28: LDAA $00C3
void block_eb28(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB2A;
  s.a = core.read8(0x00C3);
  s.cc = nzv8(s.cc, s.a);
}

// EB2A: BEQ EB3B
void block_eb2a(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xEB3B : 0xEB2C;
}

// EB2C: LDAB $02,X
void block_eb2c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB2E;
  s.b = core.read8(static_cast<uint16_t>(s.x + 2));
  s.cc = nzv8(s.cc, s.b);
}

// EB2E: MUL
void block_eb2e(Rd200RomBLiftedCore &core)
{
  block_eb1c(core);
  core.state().pc = 0xEB2F;
}

// EB2F: STD $00B7
void block_eb2f(Rd200RomBLiftedCore &core)
{
  block_eb1d(core);
  core.state().pc = 0xEB31;
}

// EB31: CLRA
void block_eb31(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xEB32;
}

// EB32: SUBA $00C3
void block_eb32(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB34;
  const uint8_t a = s.a;
  const uint8_t b = core.read8(0x00C3);
  const uint8_t r = static_cast<uint8_t>(a - b);
  s.a = r;
  s.cc = sub8_nzvc(s.cc, a, b, r);
}

// EB34: LDAB ,X
void block_eb34(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB36;
  s.b = core.read8(s.x);
  s.cc = nzv8(s.cc, s.b);
}

// EB36: MUL
void block_eb36(Rd200RomBLiftedCore &core)
{
  block_eb1c(core);
  core.state().pc = 0xEB37;
}

// EB37: ADDD $00B7
void block_eb37(Rd200RomBLiftedCore &core)
{
  block_eb25(core);
  core.state().pc = 0xEB39;
}

// EB39: PULB
void block_eb39(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB3A;
  s.b = core.pop8();
}

// EB3A: RTS
void block_eb3a(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// EB3B: LDAA ,X
void block_eb3b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB3D;
  s.a = core.read8(s.x);
  s.cc = nzv8(s.cc, s.a);
}

// EB3D: PULB
void block_eb3d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xEB3E;
  s.b = core.pop8();
}

// EB3E: RTS
void block_eb3e(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// ED00: LDAB $00D0
void block_ed00(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED02;
  s.b = core.read8(0x00D0);
  s.cc = nzv8(s.cc, s.b);
}

// ED02: CLRA
void block_ed02(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xED03;
}

// ED03: ASLD
void block_ed03(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED04;
  const uint16_t in = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  const uint16_t out = static_cast<uint16_t>(in << 1);
  s.a = static_cast<uint8_t>((out >> 8) & 0xff);
  s.b = static_cast<uint8_t>(out & 0xff);
  s.cc = asld16_nzvc(s.cc, in, out);
}

// ED04: ASLD
void block_ed04(Rd200RomBLiftedCore &core)
{
  block_ed03(core);
  core.state().pc = 0xED05;
}

// ED05: ASLD
void block_ed05(Rd200RomBLiftedCore &core)
{
  block_ed03(core);
  core.state().pc = 0xED06;
}

// ED06: ASLD
void block_ed06(Rd200RomBLiftedCore &core)
{
  block_ed03(core);
  core.state().pc = 0xED07;
}

// ED07: ADDA #$10
void block_ed07(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED09;
  const uint8_t a = s.a;
  constexpr uint8_t b = 0x10;
  const uint8_t r = static_cast<uint8_t>(a + b);
  s.a = r;
  s.cc = add8_hnzvc(s.cc, a, b, r);
}

// ED09: XGDX
void block_ed09(Rd200RomBLiftedCore &core)
{
  block_e03f(core);
  core.state().pc = 0xED0A;
}

// ED0A: LDD #$0000
void block_ed0a(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED0D;
  s.a = 0x00;
  s.b = 0x00;
  s.cc = nzv16(s.cc, 0x0000);
}

// ED0D: STD $04,X
void block_ed0d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED0F;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(static_cast<uint16_t>(s.x + 4), d);
  s.cc = nzv16(s.cc, d);
}

// ED0F: XGDX
void block_ed0f(Rd200RomBLiftedCore &core)
{
  block_e03f(core);
  core.state().pc = 0xED10;
}

// ED10: ANDA #$0F
void block_ed10(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED12;
  s.a = static_cast<uint8_t>(s.a & 0x0F);
  s.cc = and8_nzv(s.cc, s.a);
}

// ED12: TAB
void block_ed12(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED13;
  s.b = s.a;
  s.cc = nzv8(s.cc, s.b);
}

// ED13: LDX #$0000
void block_ed13(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED16;
  s.x = 0x0000;
  s.cc = nzv16(s.cc, s.x);
}

// ED16: ABX
void block_ed16(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED17;
  s.x = static_cast<uint16_t>(s.x + s.b);
}

// ED17: DEC $70,X
void block_ed17(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED19;
  const uint16_t a = static_cast<uint16_t>(s.x + 0x70);
  uint8_t v = core.read8(a);
  v = static_cast<uint8_t>(v - 1);
  core.write8(a, v);
  s.cc = dec8_nzv(s.cc, v);
}

// ED19: RTI
void block_ed19(Rd200RomBLiftedCore &core)
{
  core.rti();
}

// ED1A: CLRA
void block_ed1a(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xED1B;
}

// ED1B: LDAB $1000
void block_ed1b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED1E;
  s.b = core.read8(0x1000);
  s.cc = nzv8(s.cc, s.b);
}

// ED1E: STAB $00D0
void block_ed1e(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED20;
  core.write8(0x00D0, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// ED20: ANDB #$F0
void block_ed20(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED22;
  s.b = static_cast<uint8_t>(s.b & 0xF0);
  s.cc = and8_nzv(s.cc, s.b);
}

// ED22: LDAA #$A0
void block_ed22(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED24;
  s.a = 0xA0;
  s.cc = nzv8(s.cc, s.a);
}

// ED24: MUL
void block_ed24(Rd200RomBLiftedCore &core)
{
  block_eb1c(core);
  core.state().pc = 0xED25;
}

// ED25: LDAB $00D0
void block_ed25(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED27;
  s.b = core.read8(0x00D0);
  s.cc = nzv8(s.cc, s.b);
}

// ED27: ANDB #$0F
void block_ed27(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED29;
  s.b = static_cast<uint8_t>(s.b & 0x0F);
  s.cc = and8_nzv(s.cc, s.b);
}

// ED29: ABA
void block_ed29(Rd200RomBLiftedCore &core)
{
  block_e068(core);
  core.state().pc = 0xED2A;
}

// ED2A: LDAB #$06
void block_ed2a(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED2C;
  s.b = 0x06;
  s.cc = nzv8(s.cc, s.b);
}

// ED2C: MUL
void block_ed2c(Rd200RomBLiftedCore &core)
{
  block_eb1c(core);
  core.state().pc = 0xED2D;
}

// ED2D: ADDD #$0200
void block_ed2d(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED30;
  const uint16_t a = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  constexpr uint16_t b = 0x0200;
  const uint16_t r = static_cast<uint16_t>(a + b);
  s.a = static_cast<uint8_t>((r >> 8) & 0xff);
  s.b = static_cast<uint8_t>(r & 0xff);
  s.cc = add16_nzvc(s.cc, a, b, r);
}

// ED30: XGDX
void block_ed30(Rd200RomBLiftedCore &core)
{
  block_e03f(core);
  core.state().pc = 0xED31;
}

// ED31: STX $00D3
void block_ed31(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED33;
  core.write16(0x00D3, s.x);
  s.cc = nzv16(s.cc, s.x);
}

// ED33: LDAB $01,X
void block_ed33(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED35;
  s.b = core.read8(static_cast<uint16_t>(s.x + 1));
  s.cc = nzv8(s.cc, s.b);
}

// ED35: STAB $00D2
void block_ed35(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED37;
  core.write8(0x00D2, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// ED37: LDX $02,X
void block_ed37(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED39;
  s.x = core.read16(static_cast<uint16_t>(s.x + 2));
  s.cc = nzv16(s.cc, s.x);
}

// ED39: BEQ ED00
void block_ed39(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xED00 : 0xED3B;
}

// ED3B: STX $00D5
void block_ed3b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED3D;
  core.write16(0x00D5, s.x);
  s.cc = nzv16(s.cc, s.x);
}

// ED3D: LDAB $00D0
void block_ed3d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED3F;
  s.b = core.read8(0x00D0);
  s.cc = nzv8(s.cc, s.b);
}

// ED3F: LSRB
void block_ed3f(Rd200RomBLiftedCore &core)
{
  block_e138(core);
  core.state().pc = 0xED40;
}

// ED40: LSRB
void block_ed40(Rd200RomBLiftedCore &core)
{
  block_e138(core);
  core.state().pc = 0xED41;
}

// ED41: LSRB
void block_ed41(Rd200RomBLiftedCore &core)
{
  block_e138(core);
  core.state().pc = 0xED42;
}

// ED42: LSRB
void block_ed42(Rd200RomBLiftedCore &core)
{
  block_e138(core);
  core.state().pc = 0xED43;
}

// ED43: LDX #$0000
void block_ed43(Rd200RomBLiftedCore &core)
{
  block_ed13(core);
  core.state().pc = 0xED46;
}

// ED46: ABX
void block_ed46(Rd200RomBLiftedCore &core)
{
  block_ed16(core);
  core.state().pc = 0xED47;
}

// ED47: LDAB $40,X
void block_ed47(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED49;
  s.b = core.read8(static_cast<uint16_t>(s.x + 0x40));
  s.cc = nzv8(s.cc, s.b);
}

// ED49: ASLB
void block_ed49(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED4A;
  const uint8_t in = s.b;
  const uint8_t out = static_cast<uint8_t>(in << 1);
  s.b = out;
  s.cc &= static_cast<uint8_t>(~(CC_N | CC_Z | CC_V | CC_C));
  if (out & 0x80)
    s.cc |= CC_N;
  if (out == 0)
    s.cc |= CC_Z;
  if (in & 0x80)
    s.cc |= CC_C;
  if (((s.cc & CC_N) != 0) != ((s.cc & CC_C) != 0))
    s.cc |= CC_V;
}

// ED4A: STAB $00D1
void block_ed4a(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED4C;
  core.write8(0x00D1, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// ED4C: LDX $00D5
void block_ed4c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED4E;
  s.x = core.read16(0x00D5);
  s.cc = nzv16(s.cc, s.x);
}

// ED4E: XGDX
void block_ed4e(Rd200RomBLiftedCore &core)
{
  block_e03f(core);
  core.state().pc = 0xED4F;
}

// ED4F: ADDD #$0006
void block_ed4f(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED52;
  const uint16_t a = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  constexpr uint16_t b = 0x0006;
  const uint16_t r = static_cast<uint16_t>(a + b);
  s.a = static_cast<uint8_t>((r >> 8) & 0xff);
  s.b = static_cast<uint8_t>(r & 0xff);
  s.cc = add16_nzvc(s.cc, a, b, r);
}

// ED52: LDX $00D3
void block_ed52(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED54;
  s.x = core.read16(0x00D3);
  s.cc = nzv16(s.cc, s.x);
}

// ED54: STD $02,X
void block_ed54(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED56;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(static_cast<uint16_t>(s.x + 2), d);
  s.cc = nzv16(s.cc, d);
}

// ED56: XGDX
void block_ed56(Rd200RomBLiftedCore &core)
{
  block_e03f(core);
  core.state().pc = 0xED57;
}

// ED57: LDAB $00D0
void block_ed57(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED59;
  s.b = core.read8(0x00D0);
  s.cc = nzv8(s.cc, s.b);
}

// ED59: LDAA #$01
void block_ed59(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED5B;
  s.a = 0x01;
  s.cc = nzv8(s.cc, s.a);
}

// ED5B: ASLD
void block_ed5b(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED5C;
  const uint16_t in = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  const uint16_t out = static_cast<uint16_t>(in << 1);
  s.a = static_cast<uint8_t>((out >> 8) & 0xff);
  s.b = static_cast<uint8_t>(out & 0xff);
  s.cc = asld16_nzvc(s.cc, in, out);
}

// ED5C: ASLD
void block_ed5c(Rd200RomBLiftedCore &core)
{
  block_ed5b(core);
  core.state().pc = 0xED5D;
}

// ED5D: ASLD
void block_ed5d(Rd200RomBLiftedCore &core)
{
  block_ed5b(core);
  core.state().pc = 0xED5E;
}

// ED5E: ASLD
void block_ed5e(Rd200RomBLiftedCore &core)
{
  block_ed5b(core);
  core.state().pc = 0xED5F;
}

// ED5F: STD $00D7
void block_ed5f(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED61;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x00D7, d);
  s.cc = nzv16(s.cc, d);
}

// ED61: LDAA $00D1
void block_ed61(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED63;
  s.a = core.read8(0x00D1);
  s.cc = nzv8(s.cc, s.a);
}

// ED63: BEQ ED93
void block_ed63(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xED93 : 0xED65;
}

// ED65: LDAB $03,X
void block_ed65(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED67;
  s.b = core.read8(static_cast<uint16_t>(s.x + 3));
  s.cc = nzv8(s.cc, s.b);
}

// ED67: MUL
void block_ed67(Rd200RomBLiftedCore &core)
{
  block_eb1c(core);
  core.state().pc = 0xED68;
}

// ED68: STD $00B7
void block_ed68(Rd200RomBLiftedCore &core)
{
  block_eb1d(core);
  core.state().pc = 0xED6A;
}

// ED6A: CLRA
void block_ed6a(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xED6B;
}

// ED6B: SUBA $00D1
void block_ed6b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED6D;
  const uint8_t a = s.a;
  const uint8_t b = core.read8(0x00D1);
  const uint8_t r = static_cast<uint8_t>(a - b);
  s.a = r;
  s.cc = sub8_nzvc(s.cc, a, b, r);
}

// ED6D: LDAB $01,X
void block_ed6d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED6F;
  s.b = core.read8(static_cast<uint16_t>(s.x + 1));
  s.cc = nzv8(s.cc, s.b);
}

// ED6F: MUL
void block_ed6f(Rd200RomBLiftedCore &core)
{
  block_eb1c(core);
  core.state().pc = 0xED70;
}

// ED70: ADDD $00B7
void block_ed70(Rd200RomBLiftedCore &core)
{
  block_eb25(core);
  core.state().pc = 0xED72;
}

// ED72: PSHA
void block_ed72(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED73;
  core.push8(s.a);
}

// ED73: LDAA $00D2
void block_ed73(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED75;
  s.a = core.read8(0x00D2);
  s.cc = nzv8(s.cc, s.a);
}

// ED75: BEQ ED98
void block_ed75(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xED98 : 0xED77;
}

// ED77: LDAB $02,X
void block_ed77(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED79;
  s.b = core.read8(static_cast<uint16_t>(s.x + 2));
  s.cc = nzv8(s.cc, s.b);
}

// ED79: MUL
void block_ed79(Rd200RomBLiftedCore &core)
{
  block_eb1c(core);
  core.state().pc = 0xED7A;
}

// ED7A: STD $00B7
void block_ed7a(Rd200RomBLiftedCore &core)
{
  block_eb1d(core);
  core.state().pc = 0xED7C;
}

// ED7C: CLRA
void block_ed7c(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xED7D;
}

// ED7D: SUBA $00D2
void block_ed7d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED7F;
  const uint8_t a = s.a;
  const uint8_t b = core.read8(0x00D2);
  const uint8_t r = static_cast<uint8_t>(a - b);
  s.a = r;
  s.cc = sub8_nzvc(s.cc, a, b, r);
}

// ED7F: LDAB ,X
void block_ed7f(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED81;
  s.b = core.read8(s.x);
  s.cc = nzv8(s.cc, s.b);
}

// ED81: MUL
void block_ed81(Rd200RomBLiftedCore &core)
{
  block_eb1c(core);
  core.state().pc = 0xED82;
}

// ED82: ADDD $00B7
void block_ed82(Rd200RomBLiftedCore &core)
{
  block_eb25(core);
  core.state().pc = 0xED84;
}

// ED84: PULB
void block_ed84(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED85;
  s.b = core.pop8();
}

// ED85: LDX $00D7
void block_ed85(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED87;
  s.x = core.read16(0x00D7);
  s.cc = nzv16(s.cc, s.x);
}

// ED87: STD $04,X
void block_ed87(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED89;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(static_cast<uint16_t>(s.x + 4), d);
  s.cc = nzv16(s.cc, d);
}

// ED89: TSTA
void block_ed89(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED8A;
  s.cc = nzv8(s.cc, s.a);
}

// ED8A: BEQ ED8D
void block_ed8a(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xED8D : 0xED8C;
}

// ED8C: RTI
void block_ed8c(Rd200RomBLiftedCore &core)
{
  core.rti();
}

// ED8D: LDX $00D3
void block_ed8d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED8F;
  s.x = core.read16(0x00D3);
  s.cc = nzv16(s.cc, s.x);
}

// ED8F: CLRB
void block_ed8f(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xED90;
  s.b = 0x00;
  s.cc = nzv8(s.cc, s.b);
}

// ED90: STD $02,X
void block_ed90(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED92;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(static_cast<uint16_t>(s.x + 2), d);
  s.cc = nzv16(s.cc, d);
}

// ED92: RTI
void block_ed92(Rd200RomBLiftedCore &core)
{
  core.rti();
}

// ED93: LDAA $01,X
void block_ed93(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED95;
  s.a = core.read8(static_cast<uint16_t>(s.x + 1));
  s.cc = nzv8(s.cc, s.a);
}

// ED95: PSHA
void block_ed95(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED96;
  core.push8(s.a);
}

// ED96: BRA ED73
void block_ed96(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xED73;
}

// ED98: LDAA ,X
void block_ed98(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xED9A;
  s.a = core.read8(s.x);
  s.cc = nzv8(s.cc, s.a);
}

// ED9A: BRA ED84
void block_ed9a(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xED84;
}

// E2CB: DEC $00DB
void block_e2cb(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2CE;
  uint8_t v = core.read8(0x00DB);
  v = static_cast<uint8_t>(v - 1);
  core.write8(0x00DB, v);
  s.cc = dec8_nzv(s.cc, v);
}

// E2CE: BNE E2A9
void block_e2ce(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE2D0 : 0xE2A9;
}

// E2D0: SEI
void block_e2d0(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE2D1;
  s.cc = static_cast<uint8_t>(s.cc | 0x10);
}

// E2D1: CLRA
void block_e2d1(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xE2D2;
}

// E2D2: STAA $0091
void block_e2d2(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2D4;
  core.write8(0x0091, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E2D4: LDD #$1000
void block_e2d4(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE2D7;
  s.a = 0x10;
  s.b = 0x00;
  s.cc = nzv16(s.cc, 0x1000);
}

// E2D7: STD $00B1
void block_e2d7(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2D9;
  const uint16_t d = static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b);
  core.write16(0x00B1, d);
  s.cc = nzv16(s.cc, d);
}

// E2D9: LDX $0090
void block_e2d9(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2DB;
  s.x = core.read16(0x0090);
  s.cc = nzv16(s.cc, s.x);
}

// E2DB: LDAA $70,X
void block_e2db(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2DD;
  s.a = core.read8(static_cast<uint16_t>(s.x + 0x70));
  s.cc = nzv8(s.cc, s.a);
}

// E2DD: BEQ E2EB
void block_e2dd(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE2EB : 0xE2DF;
}

// E2DF: LDAA #$0A
void block_e2df(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE2E1;
  s.a = 0x0A;
  s.cc = nzv8(s.cc, s.a);
}

// E2E1: STAA $70,X
void block_e2e1(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2E3;
  core.write8(static_cast<uint16_t>(s.x + 0x70), s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E2E3: LDD #$00FF
void block_e2e3(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE2E6;
  s.a = 0x00;
  s.b = 0xFF;
  s.cc = nzv16(s.cc, 0x00FF);
}

// E2E6: LDX $00B1
void block_e2e6(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2E8;
  s.x = core.read16(0x00B1);
  s.cc = nzv16(s.cc, s.x);
}

// E2E8: JSR EC84
void block_e2e8(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE2EB);
  s.pc = 0xEC84;
}

// E2EB: LDAA $0091
void block_e2eb(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2ED;
  s.a = core.read8(0x0091);
  s.cc = nzv8(s.cc, s.a);
}

// E2ED: INCA
void block_e2ed(Rd200RomBLiftedCore &core)
{
  block_e28c(core);
  core.state().pc = 0xE2EE;
}

// E2EE: CMPA #$10
void block_e2ee(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE2F0;
  const uint8_t a = s.a;
  constexpr uint8_t b = 0x10;
  const uint8_t r = static_cast<uint8_t>(a - b);
  s.cc = sub8_nzvc(s.cc, a, b, r);
}

// E2F0: BCC E2FB
void block_e2f0(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE2F2 : 0xE2FB;
}

// E2F2: STAA $0091
void block_e2f2(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2F4;
  core.write8(0x0091, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E2F4: LDAA $00B1
void block_e2f4(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2F6;
  s.a = core.read8(0x00B1);
  s.cc = nzv8(s.cc, s.a);
}

// E2F6: INCA
void block_e2f6(Rd200RomBLiftedCore &core)
{
  block_e28c(core);
  core.state().pc = 0xE2F7;
}

// E2F7: STAA $00B1
void block_e2f7(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE2F9;
  core.write8(0x00B1, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E2F9: BRA E2D9
void block_e2f9(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xE2D9;
}

// E2FB: CLI
void block_e2fb(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE2FC;
  s.cc = static_cast<uint8_t>(s.cc & ~0x10);
}

// E2FC: LDX #$0000
void block_e2fc(Rd200RomBLiftedCore &core)
{
  block_ed13(core);
  core.state().pc = 0xE2FF;
}

// E2FF: LDAA #$1E
void block_e2ff(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE301;
  s.a = 0x1E;
  s.cc = nzv8(s.cc, s.a);
}

// E301: STAA $00DB
void block_e301(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE303;
  core.write8(0x00DB, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E303: LDAA $70,X
void block_e303(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE305;
  s.a = core.read8(static_cast<uint16_t>(s.x + 0x70));
  s.cc = nzv8(s.cc, s.a);
}

// E305: ORAA $71,X
void block_e305(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE307;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x71)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E307: ORAA $72,X
void block_e307(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE309;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x72)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E309: ORAA $73,X
void block_e309(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE30B;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x73)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E30B: ORAA $74,X
void block_e30b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE30D;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x74)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E30D: ORAA $75,X
void block_e30d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE30F;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x75)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E30F: ORAA $76,X
void block_e30f(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE311;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x76)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E311: ORAA $77,X
void block_e311(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE313;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x77)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E313: ORAA $78,X
void block_e313(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE315;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x78)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E315: ORAA $79,X
void block_e315(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE317;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x79)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E317: ORAA $7A,X
void block_e317(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE319;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x7A)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E319: ORAA $7B,X
void block_e319(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE31B;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x7B)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E31B: ORAA $7C,X
void block_e31b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE31D;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x7C)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E31D: ORAA $7D,X
void block_e31d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE31F;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x7D)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E31F: ORAA $7E,X
void block_e31f(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE321;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x7E)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E321: ORAA $7F,X
void block_e321(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE323;
  s.a = static_cast<uint8_t>(s.a | core.read8(static_cast<uint16_t>(s.x + 0x7F)));
  s.cc = and8_nzv(s.cc, s.a);
}

// E323: BEQ E32A
void block_e323(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE32A : 0xE325;
}

// E325: DEC $00DB
void block_e325(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE328;
  uint8_t v = core.read8(0x00DB);
  v = static_cast<uint8_t>(v - 1);
  core.write8(0x00DB, v);
  s.cc = dec8_nzv(s.cc, v);
}

// E328: BNE E303
void block_e328(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE32A : 0xE303;
}

// E32C: LDX $00B5
void block_e32c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE32E;
  s.x = core.read16(0x00B5);
  s.cc = nzv16(s.cc, s.x);
}

// E32E: CLRA
void block_e32e(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xE32F;
}

// E32F: CLRB
void block_e32f(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE330;
  s.b = 0x00;
  s.cc = nzv8(s.cc, s.b);
}

// E330: STD $02,X
void block_e330(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE332;
  core.write16(static_cast<uint16_t>(s.x + 0x02), static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
  s.cc = nzv16(s.cc, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
}

// E332: STD $08,X
void block_e332(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE334;
  core.write16(static_cast<uint16_t>(s.x + 0x08), static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
  s.cc = nzv16(s.cc, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
}

// E334: STD $0E,X
void block_e334(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE336;
  core.write16(static_cast<uint16_t>(s.x + 0x0E), static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
  s.cc = nzv16(s.cc, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
}

// E336: STD $14,X
void block_e336(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE338;
  core.write16(static_cast<uint16_t>(s.x + 0x14), static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
  s.cc = nzv16(s.cc, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
}

// E338: STD $1A,X
void block_e338(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE33A;
  core.write16(static_cast<uint16_t>(s.x + 0x1A), static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
  s.cc = nzv16(s.cc, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
}

// E33A: STD $20,X
void block_e33a(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE33C;
  core.write16(static_cast<uint16_t>(s.x + 0x20), static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
  s.cc = nzv16(s.cc, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
}

// E33C: STD $26,X
void block_e33c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE33E;
  core.write16(static_cast<uint16_t>(s.x + 0x26), static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
  s.cc = nzv16(s.cc, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
}

// E33E: STD $2C,X
void block_e33e(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE340;
  core.write16(static_cast<uint16_t>(s.x + 0x2C), static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
  s.cc = nzv16(s.cc, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
}

// E340: STD $32,X
void block_e340(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE342;
  core.write16(static_cast<uint16_t>(s.x + 0x32), static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
  s.cc = nzv16(s.cc, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
}

// E342: STD $38,X
void block_e342(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE344;
  core.write16(static_cast<uint16_t>(s.x + 0x38), static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
  s.cc = nzv16(s.cc, static_cast<uint16_t>((static_cast<uint16_t>(s.a) << 8) | s.b));
}

// E344: LDD #$00FC
void block_e344(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE347;
  s.a = 0x00;
  s.b = 0xFC;
  s.cc = nzv16(s.cc, 0x00FC);
}

// E347: LDX $00B1
void block_e347(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE349;
  s.x = core.read16(0x00B1);
  s.cc = nzv16(s.cc, s.x);
}

// E349: JMP EC84
void block_e349(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xEC84;
}

// E4F5: RTS
void block_e4f5(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// E4FA: LDX $0096
void block_e4fa(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE4FC;
  s.x = core.read16(0x0096);
  s.cc = nzv16(s.cc, s.x);
}

// E4FC: BRA E508
void block_e4fc(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xE508;
}

// E508: TAB
void block_e508(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE509;
  s.b = s.a;
  s.cc = nzv8(s.cc, s.b);
}

// E509: LDAA $20,X
void block_e509(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE50B;
  s.a = core.read8(static_cast<uint16_t>(s.x + 0x20));
  s.cc = nzv8(s.cc, s.a);
}

// E50B: STAB $20,X
void block_e50b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE50D;
  core.write8(static_cast<uint16_t>(s.x + 0x20), s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E50D: CMPA $0091
void block_e50d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE50F;
  const uint8_t a = s.a;
  const uint8_t b = core.read8(0x0091);
  const uint8_t r = static_cast<uint8_t>(a - b);
  s.cc = sub8_nzvc(s.cc, a, b, r);
}

// E50F: BEQ E4F5
void block_e50f(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE4F5 : 0xE511;
}

// E511: INX
void block_e511(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE512;
  s.x = static_cast<uint16_t>(s.x + 1);
  if (s.x == 0)
    s.cc = static_cast<uint8_t>(s.cc | CC_Z);
  else
    s.cc = static_cast<uint8_t>(s.cc & ~CC_Z);
}

// E512: CPX $0092
void block_e512(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE514;
  const uint16_t a = s.x;
  const uint16_t b = core.read16(0x0092);
  const uint16_t r = static_cast<uint16_t>(a - b);
  s.cc = sub16_nzvc(s.cc, a, b, r);
}

// E514: BCS E508
void block_e514(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE508 : 0xE516;
}

// E3C4: STAB $008D
void block_e3c4(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE3C6;
  core.write8(0x008D, s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E3C6: LDAB #$FF
void block_e3c6(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE3C8;
  s.b = 0xFF;
  s.cc = nzv8(s.cc, s.b);
}

// E3C8: STAB $60,X
void block_e3c8(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE3CA;
  core.write8(static_cast<uint16_t>(s.x + 0x60), s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E3CA: LDX $008C
void block_e3ca(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE3CC;
  s.x = core.read16(0x008C);
  s.cc = nzv16(s.cc, s.x);
}

// E3CC: CPX $008E
void block_e3cc(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE3CE;
  const uint16_t a = s.x;
  const uint16_t b = core.read16(0x008E);
  const uint16_t r = static_cast<uint16_t>(a - b);
  s.cc = sub16_nzvc(s.cc, a, b, r);
}

// E3CE: BCC E3E7
void block_e3ce(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool c = (s.cc & CC_C) != 0;
  s.pc = c ? 0xE3D0 : 0xE3E7;
}

// E3D0: LDAA $81,X
void block_e3d0(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE3D2;
  s.a = core.read8(static_cast<uint16_t>(s.x + 0x81));
  s.cc = nzv8(s.cc, s.a);
}

// E3D2: STAA $80,X
void block_e3d2(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE3D4;
  core.write8(static_cast<uint16_t>(s.x + 0x80), s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E3D4: BMI E3EE
void block_e3d4(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool n = (s.cc & CC_N) != 0;
  s.pc = n ? 0xE3EE : 0xE3D6;
}

// E3D6: LDAA $89,X
void block_e3d6(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE3D8;
  s.a = core.read8(static_cast<uint16_t>(s.x + 0x89));
  s.cc = nzv8(s.cc, s.a);
}

// E3D8: STAA $88,X
void block_e3d8(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE3DA;
  core.write8(static_cast<uint16_t>(s.x + 0x88), s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E3DA: LDAB $85,X
void block_e3da(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE3DC;
  s.b = core.read8(static_cast<uint16_t>(s.x + 0x85));
  s.cc = nzv8(s.cc, s.b);
}

// E3DC: STAB $84,X
void block_e3dc(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE3DE;
  core.write8(static_cast<uint16_t>(s.x + 0x84), s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E3DE: LDAA #$00
void block_e3de(Rd200RomBLiftedCore &core)
{
  block_e049(core);
  core.state().pc = 0xE3E0;
}

// E3E0: XGDX
void block_e3e0(Rd200RomBLiftedCore &core)
{
  block_e03f(core);
  core.state().pc = 0xE3E1;
}

// E3E1: DEC $60,X
void block_e3e1(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE3E3;
  const uint16_t a = static_cast<uint16_t>(s.x + 0x60);
  uint8_t v = core.read8(a);
  v = static_cast<uint8_t>(v - 1);
  core.write8(a, v);
  s.cc = dec8_nzv(s.cc, v);
}

// E3E3: XGDX
void block_e3e3(Rd200RomBLiftedCore &core)
{
  block_e03f(core);
  core.state().pc = 0xE3E4;
}

// E3E4: INX
void block_e3e4(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE3E5;
  s.x = static_cast<uint16_t>(s.x + 1);
  if (s.x == 0)
    s.cc = static_cast<uint8_t>(s.cc | CC_Z);
  else
    s.cc = static_cast<uint8_t>(s.cc & ~CC_Z);
}

// E3E5: BRA E3CC
void block_e3e5(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xE3CC;
}

// E3E7: LDD #$FFFF
void block_e3e7(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE3EA;
  s.a = 0xFF;
  s.b = 0xFF;
  s.cc = nzv16(s.cc, 0xFFFF);
}

// E3EA: STAA $80,X
void block_e3ea(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE3EC;
  core.write8(static_cast<uint16_t>(s.x + 0x80), s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E3EC: STAB $84,X
void block_e3ec(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE3EE;
  core.write8(static_cast<uint16_t>(s.x + 0x84), s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E3EE: JSR E52A
void block_e3ee(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE3F1);
  s.pc = 0xE52A;
}

// E3F1: RTS
void block_e3f1(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// E502: LDX $009A
void block_e502(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE504;
  s.x = core.read16(0x009A);
  s.cc = nzv16(s.cc, s.x);
}

// E504: BRA E508
void block_e504(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xE508;
}

// E556: LDAA $00E1
void block_e556(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE558;
  s.a = core.read8(0x00E1);
  s.cc = nzv8(s.cc, s.a);
}

// E558: STAA $009F
void block_e558(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE55A;
  core.write8(0x009F, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E55A: LDX $009E
void block_e55a(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE55C;
  s.x = core.read16(0x009E);
  s.cc = nzv16(s.cc, s.x);
}

// E55C: LDAA $ED,X
void block_e55c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE55E;
  s.a = core.read8(static_cast<uint16_t>(s.x + 0xED));
  s.cc = nzv8(s.cc, s.a);
}

// E55E: BPL E59C
void block_e55e(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool n = (s.cc & CC_N) != 0;
  s.pc = n ? 0xE560 : 0xE59C;
}

// E560: ANDA #$7F
void block_e560(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE562;
  s.a = static_cast<uint8_t>(s.a & 0x7F);
  s.cc = and8_nzv(s.cc, s.a);
}

// E562: AIM #$40,$ED,X
void block_e562(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE565;
  const uint16_t a = static_cast<uint16_t>(s.x + 0xED);
  const uint8_t r = static_cast<uint8_t>(core.read8(a) & 0x40);
  core.write8(a, r);
  s.cc = and8_nzv(s.cc, r);
}

// E565: BITA #$20
void block_e565(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE567;
  const uint8_t r = static_cast<uint8_t>(s.a & 0x20);
  s.cc = and8_nzv(s.cc, r);
}

// E567: BEQ E59C
void block_e567(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE59C : 0xE569;
}

// E569: ANDA #$0F
void block_e569(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE56B;
  s.a = static_cast<uint8_t>(s.a & 0x0F);
  s.cc = and8_nzv(s.cc, s.a);
}

// E56B: STAA $0091
void block_e56b(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE56D;
  core.write8(0x0091, s.a);
  s.cc = nzv8(s.cc, s.a);
}

// E56D: LDX $0090
void block_e56d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE56F;
  s.x = core.read16(0x0090);
  s.cc = nzv16(s.cc, s.x);
}

// E56F: LDAB $50,X
void block_e56f(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE571;
  s.b = core.read8(static_cast<uint16_t>(s.x + 0x50));
  s.cc = nzv8(s.cc, s.b);
}

// E571: ANDB #$7F
void block_e571(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE573;
  s.b = static_cast<uint8_t>(s.b & 0x7F);
  s.cc = and8_nzv(s.cc, s.b);
}

// E573: STAB $50,X
void block_e573(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE575;
  core.write8(static_cast<uint16_t>(s.x + 0x50), s.b);
  s.cc = nzv8(s.cc, s.b);
}

// E575: BITB #$60
void block_e575(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  s.pc = 0xE577;
  const uint8_t r = static_cast<uint8_t>(s.b & 0x60);
  s.cc = and8_nzv(s.cc, r);
}

// E577: BEQ E583
void block_e577(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE583 : 0xE579;
}

// E579: TST $60,X
void block_e579(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE57B;
  const uint8_t v = core.read8(static_cast<uint16_t>(s.x + 0x60));
  s.cc &= static_cast<uint8_t>(~(CC_N | CC_Z | CC_V | CC_C));
  if (v & 0x80)
    s.cc |= CC_N;
  if (v == 0)
    s.cc |= CC_Z;
}

// E57B: BPL E59C
void block_e57b(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool n = (s.cc & CC_N) != 0;
  s.pc = n ? 0xE57D : 0xE59C;
}

// E57D: JSR E4FE
void block_e57d(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE580);
  s.pc = 0xE4FE;
}

// E580: BSR E535
void block_e580(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE582);
  s.pc = 0xE535;
}

// E582: RTS
void block_e582(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

// E583: LDAB $60,X
void block_e583(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE585;
  s.b = core.read8(static_cast<uint16_t>(s.x + 0x60));
  s.cc = nzv8(s.cc, s.b);
}

// E585: BMI E58C
void block_e585(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool n = (s.cc & CC_N) != 0;
  s.pc = n ? 0xE58C : 0xE587;
}

// E587: JSR E3C4
void block_e587(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE58A);
  s.pc = 0xE3C4;
}

// E58A: LDAA $0091
void block_e58a(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE58C;
  s.a = core.read8(0x0091);
  s.cc = nzv8(s.cc, s.a);
}

// E58C: JSR E502
void block_e58c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE58F);
  s.pc = 0xE502;
}

// E58F: BSR E540
void block_e58f(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE591);
  s.pc = 0xE540;
}

// E591: BSR E535
void block_e591(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  core.push16(0xE593);
  s.pc = 0xE535;
}

// E593: LDX $0090
void block_e593(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE595;
  s.x = core.read16(0x0090);
  s.cc = nzv16(s.cc, s.x);
}

// E595: TST $70,X
void block_e595(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = 0xE597;
  const uint8_t v = core.read8(static_cast<uint16_t>(s.x + 0x70));
  s.cc &= static_cast<uint8_t>(~(CC_N | CC_Z | CC_V | CC_C));
  if (v & 0x80)
    s.cc |= CC_N;
  if (v == 0)
    s.cc |= CC_Z;
}

// E597: BEQ E59C
void block_e597(Rd200RomBLiftedCore &core)
{
  (void)core;
  auto &s = core.state();
  const bool z = (s.cc & CC_Z) != 0;
  s.pc = z ? 0xE59C : 0xE599;
}

// E599: JMP EBBF
void block_e599(Rd200RomBLiftedCore &core)
{
  (void)core;
  core.state().pc = 0xEBBF;
}

// E59C: RTS
void block_e59c(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  s.pc = core.pop16();
}

bool exec_dynamic_e79b_ec83(Rd200RomBLiftedCore &core)
{
  auto &s = core.state();
  u16 pc = s.pc;
  const u8 op = core.read8(pc++);

  const auto fetch8 = [&](void) -> u8 {
    const u8 v = core.read8(pc);
    pc = static_cast<u16>(pc + 1);
    return v;
  };
  const auto fetch16 = [&](void) -> u16 {
    const u16 hi = fetch8();
    const u16 lo = fetch8();
    return static_cast<u16>((hi << 8) | lo);
  };
  const auto rel8_target = [&](u8 off) -> u16 {
    const s8 d = static_cast<s8>(off);
    return static_cast<u16>(pc + d);
  };
  const auto dir_addr = [&](void) -> u16 { return static_cast<u16>(fetch8()); };
  const auto idx_addr = [&](void) -> u16 { return static_cast<u16>(s.x + fetch8()); };

  switch (op)
  {
  case 0x08: // INX
    s.x = static_cast<u16>(s.x + 1);
    s.cc = (s.x == 0) ? static_cast<u8>(s.cc | CC_Z) : static_cast<u8>(s.cc & ~CC_Z);
    s.pc = pc;
    return true;
  case 0x0E: // CLI
    s.cc = static_cast<u8>(s.cc & ~0x10);
    s.pc = pc;
    return true;
  case 0x0F: // SEI
    s.cc = static_cast<u8>(s.cc | 0x10);
    s.pc = pc;
    return true;
  case 0x17: // TBA
    s.a = s.b;
    s.cc = nzv8(s.cc, s.a);
    s.pc = pc;
    return true;
  case 0x16: // TAB
    s.b = s.a;
    s.cc = nzv8(s.cc, s.b);
    s.pc = pc;
    return true;
  case 0x18: // XGDX
  {
    const u16 d = static_cast<u16>((static_cast<u16>(s.a) << 8) | s.b);
    const u16 x = s.x;
    s.x = d;
    s.a = static_cast<u8>((x >> 8) & 0xff);
    s.b = static_cast<u8>(x & 0xff);
    s.pc = pc;
    return true;
  }
  case 0x20: // BRA
    s.pc = rel8_target(fetch8());
    return true;
  case 0x24: // BCC
  {
    const u16 tgt = rel8_target(fetch8());
    const bool c = (s.cc & CC_C) != 0;
    s.pc = c ? pc : tgt;
    return true;
  }
  case 0x22: // BHI
  {
    const u16 tgt = rel8_target(fetch8());
    const bool c = (s.cc & CC_C) != 0;
    const bool z = (s.cc & CC_Z) != 0;
    s.pc = (!c && !z) ? tgt : pc;
    return true;
  }
  case 0x23: // BLS
  {
    const u16 tgt = rel8_target(fetch8());
    const bool c = (s.cc & CC_C) != 0;
    const bool z = (s.cc & CC_Z) != 0;
    s.pc = (c || z) ? tgt : pc;
    return true;
  }
  case 0x25: // BCS
  {
    const u16 tgt = rel8_target(fetch8());
    const bool c = (s.cc & CC_C) != 0;
    s.pc = c ? tgt : pc;
    return true;
  }
  case 0x26: // BNE
  {
    const u16 tgt = rel8_target(fetch8());
    const bool z = (s.cc & CC_Z) != 0;
    s.pc = z ? pc : tgt;
    return true;
  }
  case 0x27: // BEQ
  {
    const u16 tgt = rel8_target(fetch8());
    const bool z = (s.cc & CC_Z) != 0;
    s.pc = z ? tgt : pc;
    return true;
  }
  case 0x2A: // BPL
  {
    const u16 tgt = rel8_target(fetch8());
    const bool n = (s.cc & CC_N) != 0;
    s.pc = n ? pc : tgt;
    return true;
  }
  case 0x2B: // BMI
  {
    const u16 tgt = rel8_target(fetch8());
    const bool n = (s.cc & CC_N) != 0;
    s.pc = n ? tgt : pc;
    return true;
  }
  case 0x30: // TSX
    s.x = static_cast<u16>(s.s + 1);
    s.pc = pc;
    return true;
  case 0x35: // TXS
    s.s = static_cast<u16>(s.x - 1);
    s.pc = pc;
    return true;
  case 0x33: // PULB
    s.b = core.pop8();
    s.pc = pc;
    return true;
  case 0x37: // PSHB
    core.push8(s.b);
    s.pc = pc;
    return true;
  case 0x38: // PULX
    s.x = core.pop16();
    s.pc = pc;
    return true;
  case 0x3C: // PSHX
    core.push16(s.x);
    s.pc = pc;
    return true;
  case 0x39: // RTS
    s.pc = core.pop16();
    return true;
  case 0x3A: // ABX
    s.x = static_cast<u16>(s.x + s.b);
    s.pc = pc;
    return true;
  case 0x3D: // MUL
  {
    const u16 r = static_cast<u16>(static_cast<u16>(s.a) * static_cast<u16>(s.b));
    s.a = static_cast<u8>((r >> 8) & 0xff);
    s.b = static_cast<u8>(r & 0xff);
    s.cc = static_cast<u8>(s.cc & ~CC_C);
    if (r & 0x0080)
      s.cc |= CC_C;
    s.pc = pc;
    return true;
  }
  case 0x43: // COMA
    s.a = static_cast<u8>(~s.a);
    s.cc = nzv8(s.cc, s.a);
    s.cc = static_cast<u8>(s.cc | CC_C);
    s.pc = pc;
    return true;
  case 0x49: // ROLA
  {
    const u8 in = s.a;
    const u8 c = (s.cc & CC_C) ? 1 : 0;
    const u8 out = static_cast<u8>((in << 1) | c);
    s.a = out;
    s.cc &= static_cast<u8>(~(CC_N | CC_Z | CC_V | CC_C));
    if (out & 0x80)
      s.cc |= CC_N;
    if (out == 0)
      s.cc |= CC_Z;
    if (in & 0x80)
      s.cc |= CC_C;
    if (((s.cc & CC_N) != 0) != ((s.cc & CC_C) != 0))
      s.cc |= CC_V;
    s.pc = pc;
    return true;
  }
  case 0x4F: // CLRA
    s.a = 0;
    s.cc = static_cast<u8>((s.cc & 0xf0) | CC_Z);
    s.pc = pc;
    return true;
  case 0x54: // LSRB
  {
    const u8 in = s.b;
    const u8 out = static_cast<u8>(in >> 1);
    s.b = out;
    s.cc = lsr8_nzvc(s.cc, in, out);
    s.pc = pc;
    return true;
  }
  case 0x58: // ASLB
  {
    const u8 in = s.b;
    const u8 out = static_cast<u8>(in << 1);
    s.b = out;
    s.cc &= static_cast<u8>(~(CC_N | CC_Z | CC_V | CC_C));
    if (out & 0x80)
      s.cc |= CC_N;
    if (out == 0)
      s.cc |= CC_Z;
    if (in & 0x80)
      s.cc |= CC_C;
    if (((s.cc & CC_N) != 0) != ((s.cc & CC_C) != 0))
      s.cc |= CC_V;
    s.pc = pc;
    return true;
  }
  case 0x5C: // INCB
    s.b = static_cast<u8>(s.b + 1);
    s.cc = inc8_nzv(s.cc, s.b);
    s.pc = pc;
    return true;
  case 0x5F: // CLRB
    s.b = 0;
    s.cc = static_cast<u8>((s.cc & 0xf0) | CC_Z);
    s.pc = pc;
    return true;
  case 0x04: // LSRD
  {
    const u16 in = static_cast<u16>((static_cast<u16>(s.a) << 8) | s.b);
    const u16 out = static_cast<u16>(in >> 1);
    s.a = static_cast<u8>((out >> 8) & 0xff);
    s.b = static_cast<u8>(out & 0xff);
    s.cc &= static_cast<u8>(~(CC_N | CC_Z | CC_V | CC_C));
    if (in & 0x0001)
      s.cc |= CC_C;
    if (out == 0)
      s.cc |= CC_Z;
    if ((s.cc & CC_C) != 0)
      s.cc |= CC_V;
    s.pc = pc;
    return true;
  }
  case 0x05: // ASLD
  {
    const u16 in = static_cast<u16>((static_cast<u16>(s.a) << 8) | s.b);
    const u16 out = static_cast<u16>(in << 1);
    s.a = static_cast<u8>((out >> 8) & 0xff);
    s.b = static_cast<u8>(out & 0xff);
    s.cc = asld16_nzvc(s.cc, in, out);
    s.pc = pc;
    return true;
  }
  case 0x62: // OIM indexed
  {
    const u8 imm = fetch8();
    const u8 off = fetch8();
    const u16 a = static_cast<u16>(s.x + off);
    const u8 r = static_cast<u8>(core.read8(a) | imm);
    core.write8(a, r);
    s.cc = and8_nzv(s.cc, r);
    s.pc = pc;
    return true;
  }
  case 0x6D: // TST indexed
  {
    const u8 v = core.read8(idx_addr());
    s.cc &= static_cast<u8>(~(CC_N | CC_Z | CC_V | CC_C));
    if (v & 0x80)
      s.cc |= CC_N;
    if (v == 0)
      s.cc |= CC_Z;
    s.pc = pc;
    return true;
  }
  case 0x71: // AIM direct
  {
    const u8 imm = fetch8();
    const u16 a = dir_addr();
    const u8 r = static_cast<u8>(core.read8(a) & imm);
    core.write8(a, r);
    s.cc = and8_nzv(s.cc, r);
    s.pc = pc;
    return true;
  }
  case 0x72: // OIM direct
  {
    const u8 imm = fetch8();
    const u16 a = dir_addr();
    const u8 r = static_cast<u8>(core.read8(a) | imm);
    core.write8(a, r);
    s.cc = and8_nzv(s.cc, r);
    s.pc = pc;
    return true;
  }
  case 0x7A: // DEC extended
  {
    const u16 a = fetch16();
    u8 v = core.read8(a);
    v = static_cast<u8>(v - 1);
    core.write8(a, v);
    s.cc = dec8_nzv(s.cc, v);
    s.pc = pc;
    return true;
  }
  case 0x80: // SUBA #imm
  {
    const u8 a = s.a;
    const u8 b = fetch8();
    const u8 r = static_cast<u8>(a - b);
    s.a = r;
    s.cc = sub8_nzvc(s.cc, a, b, r);
    s.pc = pc;
    return true;
  }
  case 0x84: // ANDA #imm
    s.a = static_cast<u8>(s.a & fetch8());
    s.cc = and8_nzv(s.cc, s.a);
    s.pc = pc;
    return true;
  case 0x85: // BITA #imm
  {
    const u8 r = static_cast<u8>(s.a & fetch8());
    s.cc = and8_nzv(s.cc, r);
    s.pc = pc;
    return true;
  }
  case 0x86: // LDAA #imm
    s.a = fetch8();
    s.cc = nzv8(s.cc, s.a);
    s.pc = pc;
    return true;
  case 0x8B: // ADDA #imm
  {
    const u8 a = s.a;
    const u8 b = fetch8();
    const u8 r = static_cast<u8>(a + b);
    s.a = r;
    s.cc = add8_hnzvc(s.cc, a, b, r);
    s.pc = pc;
    return true;
  }
  case 0x8D: // BSR
  {
    const u16 ret = static_cast<u16>(pc + 1);
    const u16 tgt = rel8_target(fetch8());
    core.push16(ret);
    s.pc = tgt;
    return true;
  }
  case 0x8E: // LDS #imm16
    s.s = fetch16();
    s.cc = nzv16(s.cc, s.s);
    s.pc = pc;
    return true;
  case 0x91: // CMPA direct
  {
    const u8 a = s.a;
    const u8 b = core.read8(dir_addr());
    const u8 r = static_cast<u8>(a - b);
    s.cc = sub8_nzvc(s.cc, a, b, r);
    s.pc = pc;
    return true;
  }
  case 0x94: // ANDA dir
    s.a = static_cast<u8>(s.a & core.read8(dir_addr()));
    s.cc = and8_nzv(s.cc, s.a);
    s.pc = pc;
    return true;
  case 0x96: // LDAA dir
    s.a = core.read8(dir_addr());
    s.cc = nzv8(s.cc, s.a);
    s.pc = pc;
    return true;
  case 0x97: // STAA dir
    core.write8(dir_addr(), s.a);
    s.cc = nzv8(s.cc, s.a);
    s.pc = pc;
    return true;
  case 0x9C: // CPX direct
  {
    const u16 a = s.x;
    const u16 b = core.read16(dir_addr());
    const u16 r = static_cast<u16>(a - b);
    s.cc = sub16_nzvc(s.cc, a, b, r);
    s.pc = pc;
    return true;
  }
  case 0x9E: // LDS dir
    s.s = core.read16(dir_addr());
    s.cc = nzv16(s.cc, s.s);
    s.pc = pc;
    return true;
  case 0x9B: // ADDA dir
  {
    const u8 a = s.a;
    const u8 b = core.read8(dir_addr());
    const u8 r = static_cast<u8>(a + b);
    s.a = r;
    s.cc = add8_hnzvc(s.cc, a, b, r);
    s.pc = pc;
    return true;
  }
  case 0x9F: // STS dir
    core.write16(dir_addr(), s.s);
    s.cc = nzv16(s.cc, s.s);
    s.pc = pc;
    return true;
  case 0xA6: // LDAA idx
    s.a = core.read8(idx_addr());
    s.cc = nzv8(s.cc, s.a);
    s.pc = pc;
    return true;
  case 0xA1: // CMPA idx
  {
    const u8 a = s.a;
    const u8 b = core.read8(idx_addr());
    const u8 r = static_cast<u8>(a - b);
    s.cc = sub8_nzvc(s.cc, a, b, r);
    s.pc = pc;
    return true;
  }
  case 0xA7: // STAA idx
    core.write8(idx_addr(), s.a);
    s.cc = nzv8(s.cc, s.a);
    s.pc = pc;
    return true;
  case 0xBD: // JSR ext
  {
    const u16 tgt = fetch16();
    core.push16(pc);
    s.pc = tgt;
    return true;
  }
  case 0xC3: // ADDD #imm16
  {
    const u16 a = static_cast<u16>((static_cast<u16>(s.a) << 8) | s.b);
    const u16 b = fetch16();
    const u16 r = static_cast<u16>(a + b);
    s.a = static_cast<u8>((r >> 8) & 0xff);
    s.b = static_cast<u8>(r & 0xff);
    s.cc = add16_nzvc(s.cc, a, b, r);
    s.pc = pc;
    return true;
  }
  case 0xC6: // LDAB #imm
    s.b = fetch8();
    s.cc = nzv8(s.cc, s.b);
    s.pc = pc;
    return true;
  case 0xCC: // LDD #imm16
  {
    const u16 d = fetch16();
    s.a = static_cast<u8>((d >> 8) & 0xff);
    s.b = static_cast<u8>(d & 0xff);
    s.cc = nzv16(s.cc, d);
    s.pc = pc;
    return true;
  }
  case 0xC4: // ANDB #imm
    s.b = static_cast<u8>(s.b & fetch8());
    s.cc = and8_nzv(s.cc, s.b);
    s.pc = pc;
    return true;
  case 0xC0: // SUBB #imm
  {
    const u8 a = s.b;
    const u8 b = fetch8();
    const u8 r = static_cast<u8>(a - b);
    s.b = r;
    s.cc = sub8_nzvc(s.cc, a, b, r);
    s.pc = pc;
    return true;
  }
  case 0xC1: // CMPB #imm
  {
    const u8 a = s.b;
    const u8 b = fetch8();
    const u8 r = static_cast<u8>(a - b);
    s.cc = sub8_nzvc(s.cc, a, b, r);
    s.pc = pc;
    return true;
  }
  case 0xC5: // BITB #imm
  {
    const u8 r = static_cast<u8>(s.b & fetch8());
    s.cc = and8_nzv(s.cc, r);
    s.pc = pc;
    return true;
  }
  case 0xCA: // ORAB #imm
    s.b = static_cast<u8>(s.b | fetch8());
    s.cc = and8_nzv(s.cc, s.b);
    s.pc = pc;
    return true;
  case 0xCB: // ADDB #imm
  {
    const u8 a = s.b;
    const u8 b = fetch8();
    const u8 r = static_cast<u8>(a + b);
    s.b = r;
    s.cc = add8_hnzvc(s.cc, a, b, r);
    s.pc = pc;
    return true;
  }
  case 0xCE: // LDX #imm16
    s.x = fetch16();
    s.cc = nzv16(s.cc, s.x);
    s.pc = pc;
    return true;
  case 0xD3: // ADDD dir
  {
    const u16 a = static_cast<u16>((static_cast<u16>(s.a) << 8) | s.b);
    const u16 b = core.read16(dir_addr());
    const u16 r = static_cast<u16>(a + b);
    s.a = static_cast<u8>((r >> 8) & 0xff);
    s.b = static_cast<u8>(r & 0xff);
    s.cc = add16_nzvc(s.cc, a, b, r);
    s.pc = pc;
    return true;
  }
  case 0xD1: // CMPB dir
  {
    const u8 a = s.b;
    const u8 b = core.read8(dir_addr());
    const u8 r = static_cast<u8>(a - b);
    s.cc = sub8_nzvc(s.cc, a, b, r);
    s.pc = pc;
    return true;
  }
  case 0xD6: // LDAB dir
    s.b = core.read8(dir_addr());
    s.cc = nzv8(s.cc, s.b);
    s.pc = pc;
    return true;
  case 0xD7: // STAB dir
    core.write8(dir_addr(), s.b);
    s.cc = nzv8(s.cc, s.b);
    s.pc = pc;
    return true;
  case 0xDB: // ADDB dir
  {
    const u8 a = s.b;
    const u8 b = core.read8(dir_addr());
    const u8 r = static_cast<u8>(a + b);
    s.b = r;
    s.cc = add8_hnzvc(s.cc, a, b, r);
    s.pc = pc;
    return true;
  }
  case 0xDD: // STD dir
  {
    const u16 d = static_cast<u16>((static_cast<u16>(s.a) << 8) | s.b);
    core.write16(dir_addr(), d);
    s.cc = nzv16(s.cc, d);
    s.pc = pc;
    return true;
  }
  case 0xDE: // LDX dir
    s.x = core.read16(dir_addr());
    s.cc = nzv16(s.cc, s.x);
    s.pc = pc;
    return true;
  case 0xDC: // LDD dir
  {
    const u16 d = core.read16(dir_addr());
    s.a = static_cast<u8>((d >> 8) & 0xff);
    s.b = static_cast<u8>(d & 0xff);
    s.cc = nzv16(s.cc, d);
    s.pc = pc;
    return true;
  }
  case 0xDF: // STX dir
    core.write16(dir_addr(), s.x);
    s.cc = nzv16(s.cc, s.x);
    s.pc = pc;
    return true;
  case 0xE6: // LDAB idx
    s.b = core.read8(idx_addr());
    s.cc = nzv8(s.cc, s.b);
    s.pc = pc;
    return true;
  case 0xE7: // STAB idx
    core.write8(idx_addr(), s.b);
    s.cc = nzv8(s.cc, s.b);
    s.pc = pc;
    return true;
  case 0xEB: // ADDB idx
  {
    const u8 a = s.b;
    const u8 b = core.read8(idx_addr());
    const u8 r = static_cast<u8>(a + b);
    s.b = r;
    s.cc = add8_hnzvc(s.cc, a, b, r);
    s.pc = pc;
    return true;
  }
  case 0xEC: // LDD idx
  {
    const u16 d = core.read16(idx_addr());
    s.a = static_cast<u8>((d >> 8) & 0xff);
    s.b = static_cast<u8>(d & 0xff);
    s.cc = nzv16(s.cc, d);
    s.pc = pc;
    return true;
  }
  case 0xED: // STD idx
  {
    const u16 d = static_cast<u16>((static_cast<u16>(s.a) << 8) | s.b);
    core.write16(idx_addr(), d);
    s.cc = nzv16(s.cc, d);
    s.pc = pc;
    return true;
  }
  case 0xEE: // LDX idx
    s.x = core.read16(idx_addr());
    s.cc = nzv16(s.cc, s.x);
    s.pc = pc;
    return true;
  default:
    return false;
  }
}

void block_dynamic_e79b_ec83(Rd200RomBLiftedCore &core)
{
  if (!exec_dynamic_e79b_ec83(core))
    core.halt();
}

} // namespace

void rd200_rom_b_register_blocks(Rd200RomBLiftedCore &core)
{
  core.register_block(0xE000, &block_e000);
  core.register_block(0xE003, &block_e003);
  core.register_block(0xE006, &block_e006);
  core.register_block(0xE008, &block_e008);
  core.register_block(0xE009, &block_e009);
  core.register_block(0xE00C, &block_e00c);
  core.register_block(0xE00E, &block_e00e);
  core.register_block(0xE02E, &block_e02e);
  core.register_block(0xE030, &block_e030);
  core.register_block(0xE033, &block_e033);
  core.register_block(0xE036, &block_e036);
  core.register_block(0xE038, &block_e038);
  core.register_block(0xE03B, &block_e03b);
  core.register_block(0xE03D, &block_e03d);
  core.register_block(0xE03F, &block_e03f);
  core.register_block(0xE040, &block_e040);
  core.register_block(0xE043, &block_e043);
  core.register_block(0xE044, &block_e044);
  core.register_block(0xE047, &block_e047);
  core.register_block(0xE22C, &block_e22c);
  core.register_block(0xE22E, &block_e22e);
  core.register_block(0xE22F, &block_e22f);
  core.register_block(0xE232, &block_e232);
  core.register_block(0xE27D, &block_e27d);
  core.register_block(0xE27F, &block_e27f);
  core.register_block(0xE281, &block_e281);
  core.register_block(0xE28A, &block_e28a);
  core.register_block(0xE28C, &block_e28c);
  core.register_block(0xE28D, &block_e28d);
  core.register_block(0xE28F, &block_e28f);
  core.register_block(0xE291, &block_e291);
  core.register_block(0xE293, &block_e293);
  core.register_block(0xE295, &block_e295);
  core.register_block(0xE296, &block_e296);
  core.register_block(0xE298, &block_e298);
  core.register_block(0xE29A, &block_e29a);
  core.register_block(0xE29D, &block_e29d);
  core.register_block(0xE29F, &block_e29f);
  core.register_block(0xE2A1, &block_e2a1);
  core.register_block(0xE2A2, &block_e2a2);
  core.register_block(0xE2A5, &block_e2a5);
  core.register_block(0xE2A7, &block_e2a7);
  core.register_block(0xE2A9, &block_e2a9);
  core.register_block(0xE2AB, &block_e2ab);
  core.register_block(0xE2AD, &block_e2ad);
  core.register_block(0xE2AF, &block_e2af);
  core.register_block(0xE2B1, &block_e2b1);
  core.register_block(0xE2B3, &block_e2b3);
  core.register_block(0xE2B5, &block_e2b5);
  core.register_block(0xE2B7, &block_e2b7);
  core.register_block(0xE2B9, &block_e2b9);
  core.register_block(0xE2BB, &block_e2bb);
  core.register_block(0xE2BD, &block_e2bd);
  core.register_block(0xE2BF, &block_e2bf);
  core.register_block(0xE2C1, &block_e2c1);
  core.register_block(0xE2C3, &block_e2c3);
  core.register_block(0xE2C5, &block_e2c5);
  core.register_block(0xE2C7, &block_e2c7);
  core.register_block(0xE2C9, &block_e2c9);
  core.register_block(0xE32A, &block_e32a);
  core.register_block(0xE32B, &block_e32b);
  core.register_block(0xE243, &block_e243);
  core.register_block(0xE245, &block_e245);
  core.register_block(0xE247, &block_e247);
  core.register_block(0xE249, &block_e249);
  core.register_block(0xE24B, &block_e24b);
  core.register_block(0xE24D, &block_e24d);
  core.register_block(0xE24E, &block_e24e);
  core.register_block(0xE24F, &block_e24f);
  core.register_block(0xE251, &block_e251);
  core.register_block(0xE253, &block_e253);
  core.register_block(0xE097, &block_e097);
  core.register_block(0xE09A, &block_e09a);
  core.register_block(0xE09D, &block_e09d);
  core.register_block(0xE09F, &block_e09f);
  core.register_block(0xE0A0, &block_e0a0);
  core.register_block(0xE0A1, &block_e0a1);
  core.register_block(0xE0A2, &block_e0a2);
  core.register_block(0xE0A5, &block_e0a5);
  core.register_block(0xE0A7, &block_e0a7);
  core.register_block(0xE0AB, &block_e0ab);
  core.register_block(0xE0AE, &block_e0ae);
  core.register_block(0xE07B, &block_e07b);
  core.register_block(0xE07E, &block_e07e);
  core.register_block(0xE080, &block_e080);
  core.register_block(0xE082, &block_e082);
  core.register_block(0xE084, &block_e084);
  core.register_block(0xE086, &block_e086);
  core.register_block(0xE088, &block_e088);
  core.register_block(0xE08B, &block_e08b);
  core.register_block(0xE08D, &block_e08d);
  core.register_block(0xE08E, &block_e08e);
  core.register_block(0xE091, &block_e091);
  core.register_block(0xE092, &block_e092);
  core.register_block(0xE095, &block_e095);
  core.register_block(0xE0A8, &block_e0a8);
  core.register_block(0xE0A9, &block_e0a9);
  core.register_block(0xE0AF, &block_e0af);
  core.register_block(0xE0B1, &block_e0b1);
  core.register_block(0xE0B2, &block_e0b2);
  core.register_block(0xE0B5, &block_e0b5);
  core.register_block(0xE0B6, &block_e0b6);
  core.register_block(0xE0B9, &block_e0b9);
  core.register_block(0xE0BB, &block_e0bb);
  core.register_block(0xE0BC, &block_e0bc);
  core.register_block(0xE0BE, &block_e0be);
  core.register_block(0xE0BF, &block_e0bf);
  core.register_block(0xE0C1, &block_e0c1);
  core.register_block(0xE049, &block_e049);
  core.register_block(0xE04A, &block_e04a);
  core.register_block(0xE04C, &block_e04c);
  core.register_block(0xE04D, &block_e04d);
  core.register_block(0xE050, &block_e050);
  core.register_block(0xE053, &block_e053);
  core.register_block(0xE055, &block_e055);
  core.register_block(0xE057, &block_e057);
  core.register_block(0xE05A, &block_e05a);
  core.register_block(0xE05C, &block_e05c);
  core.register_block(0xE05E, &block_e05e);
  core.register_block(0xE060, &block_e060);
  core.register_block(0xE062, &block_e062);
  core.register_block(0xE064, &block_e064);
  core.register_block(0xE066, &block_e066);
  core.register_block(0xE068, &block_e068);
  core.register_block(0xE069, &block_e069);
  core.register_block(0xE06B, &block_e06b);
  core.register_block(0xE06C, &block_e06c);
  core.register_block(0xE06E, &block_e06e);
  core.register_block(0xE071, &block_e071);
  core.register_block(0xE073, &block_e073);
  core.register_block(0xE076, &block_e076);
  core.register_block(0xE078, &block_e078);
  core.register_block(0xE121, &block_e121);
  core.register_block(0xE122, &block_e122);
  core.register_block(0xE124, &block_e124);
  core.register_block(0xE127, &block_e127);
  core.register_block(0xE129, &block_e129);
  core.register_block(0xE12B, &block_e12b);
  core.register_block(0xE12E, &block_e12e);
  core.register_block(0xE130, &block_e130);
  core.register_block(0xE132, &block_e132);
  core.register_block(0xE134, &block_e134);
  core.register_block(0xE136, &block_e136);
  core.register_block(0xE138, &block_e138);
  core.register_block(0xE139, &block_e139);
  core.register_block(0xE13A, &block_e13a);
  core.register_block(0xE13B, &block_e13b);
  core.register_block(0xE13E, &block_e13e);
  core.register_block(0xE13F, &block_e13f);
  core.register_block(0xE141, &block_e141);
  core.register_block(0xE143, &block_e143);
  core.register_block(0xE145, &block_e145);
  core.register_block(0xE147, &block_e147);
  core.register_block(0xE149, &block_e149);
  core.register_block(0xE14B, &block_e14b);
  core.register_block(0xE14D, &block_e14d);
  core.register_block(0xE14F, &block_e14f);
  core.register_block(0xE151, &block_e151);
  core.register_block(0xE153, &block_e153);
  core.register_block(0xE156, &block_e156);
  core.register_block(0xE157, &block_e157);
  core.register_block(0xE15A, &block_e15a);
  core.register_block(0xE15C, &block_e15c);
  core.register_block(0xE15E, &block_e15e);
  core.register_block(0xE161, &block_e161);
  core.register_block(0xE164, &block_e164);
  core.register_block(0xE166, &block_e166);
  core.register_block(0xE168, &block_e168);
  core.register_block(0xE16B, &block_e16b);
  core.register_block(0xE16D, &block_e16d);
  core.register_block(0xE51B, &block_e51b);
  core.register_block(0xE51D, &block_e51d);
  core.register_block(0xE51F, &block_e51f);
  core.register_block(0xE520, &block_e520);
  core.register_block(0xE522, &block_e522);
  core.register_block(0xE524, &block_e524);
  core.register_block(0xE527, &block_e527);
  core.register_block(0xE529, &block_e529);
  core.register_block(0xE52A, &block_e52a);
  core.register_block(0xE52C, &block_e52c);
  core.register_block(0xE52D, &block_e52d);
  core.register_block(0xE52F, &block_e52f);
  core.register_block(0xE531, &block_e531);
  core.register_block(0xE532, &block_e532);
  core.register_block(0xE534, &block_e534);
  core.register_block(0xE535, &block_e535);
  core.register_block(0xE537, &block_e537);
  core.register_block(0xE538, &block_e538);
  core.register_block(0xE53A, &block_e53a);
  core.register_block(0xE53C, &block_e53c);
  core.register_block(0xE53D, &block_e53d);
  core.register_block(0xE53F, &block_e53f);
  core.register_block(0xE540, &block_e540);
  core.register_block(0xE542, &block_e542);
  core.register_block(0xE543, &block_e543);
  core.register_block(0xE545, &block_e545);
  core.register_block(0xE547, &block_e547);
  core.register_block(0xE548, &block_e548);
  core.register_block(0xE54A, &block_e54a);
  core.register_block(0xE54B, &block_e54b);
  core.register_block(0xE54D, &block_e54d);
  core.register_block(0xE54E, &block_e54e);
  core.register_block(0xE550, &block_e550);
  core.register_block(0xE552, &block_e552);
  core.register_block(0xE553, &block_e553);
  core.register_block(0xE555, &block_e555);
  core.register_block(0xE59D, &block_e59d);
  core.register_block(0xE59F, &block_e59f);
  core.register_block(0xE5A1, &block_e5a1);
  core.register_block(0xE5A2, &block_e5a2);
  core.register_block(0xE5A4, &block_e5a4);
  core.register_block(0xE5A6, &block_e5a6);
  core.register_block(0xE5A8, &block_e5a8);
  core.register_block(0xE5AA, &block_e5aa);
  core.register_block(0xE5AC, &block_e5ac);
  core.register_block(0xE5AE, &block_e5ae);
  core.register_block(0xE5B0, &block_e5b0);
  core.register_block(0xE5B2, &block_e5b2);
  core.register_block(0xE5B4, &block_e5b4);
  core.register_block(0xE5B5, &block_e5b5);
  core.register_block(0xE5B6, &block_e5b6);
  core.register_block(0xE5B8, &block_e5b8);
  core.register_block(0xE5BA, &block_e5ba);
  core.register_block(0xE5BC, &block_e5bc);
  core.register_block(0xE5BE, &block_e5be);
  core.register_block(0xE5C0, &block_e5c0);
  core.register_block(0xE5C2, &block_e5c2);
  core.register_block(0xE5C3, &block_e5c3);
  core.register_block(0xE5C5, &block_e5c5);
  core.register_block(0xE5C7, &block_e5c7);
  core.register_block(0xE5C9, &block_e5c9);
  core.register_block(0xE5CC, &block_e5cc);
  core.register_block(0xE5CE, &block_e5ce);
  core.register_block(0xE5D0, &block_e5d0);
  core.register_block(0xE5D2, &block_e5d2);
  core.register_block(0xE5D4, &block_e5d4);
  core.register_block(0xE5D6, &block_e5d6);
  core.register_block(0xE5D8, &block_e5d8);
  core.register_block(0xE5DA, &block_e5da);
  core.register_block(0xE5DD, &block_e5dd);
  core.register_block(0xE5DF, &block_e5df);
  core.register_block(0xE5E1, &block_e5e1);
  core.register_block(0xE5E3, &block_e5e3);
  core.register_block(0xE5E5, &block_e5e5);
  core.register_block(0xE5E7, &block_e5e7);
  core.register_block(0xE5E9, &block_e5e9);
  core.register_block(0xE5EB, &block_e5eb);
  core.register_block(0xE5ED, &block_e5ed);
  core.register_block(0xE5EE, &block_e5ee);
  core.register_block(0xE5F3, &block_e5f3);
  core.register_block(0xE5F4, &block_e5f4);
  core.register_block(0xE5F7, &block_e5f7);
  core.register_block(0xE5FA, &block_e5fa);
  core.register_block(0xE5FD, &block_e5fd);
  core.register_block(0xE5FF, &block_e5ff);
  core.register_block(0xE601, &block_e601);
  core.register_block(0xE603, &block_e603);
  core.register_block(0xE605, &block_e605);
  core.register_block(0xE607, &block_e607);
  core.register_block(0xE609, &block_e609);
  core.register_block(0xE60B, &block_e60b);
  core.register_block(0xE60D, &block_e60d);
  core.register_block(0xE60F, &block_e60f);
  core.register_block(0xE611, &block_e611);
  core.register_block(0xE613, &block_e613);
  core.register_block(0xE615, &block_e615);
  core.register_block(0xE617, &block_e617);
  core.register_block(0xE619, &block_e619);
  core.register_block(0xE61B, &block_e61b);
  core.register_block(0xE61D, &block_e61d);
  core.register_block(0xE61F, &block_e61f);
  core.register_block(0xE621, &block_e621);
  core.register_block(0xE624, &block_e624);
  core.register_block(0xE625, &block_e625);
  core.register_block(0xE626, &block_e626);
  core.register_block(0xE656, &block_e656);
  core.register_block(0xE658, &block_e658);
  core.register_block(0xE65A, &block_e65a);
  core.register_block(0xE65D, &block_e65d);
  core.register_block(0xE65F, &block_e65f);
  core.register_block(0xE661, &block_e661);
  core.register_block(0xE663, &block_e663);
  core.register_block(0xE664, &block_e664);
  core.register_block(0xE666, &block_e666);
  core.register_block(0xE668, &block_e668);
  core.register_block(0xE669, &block_e669);
  core.register_block(0xE66C, &block_e66c);
  core.register_block(0xE66F, &block_e66f);
  core.register_block(0xE670, &block_e670);
  core.register_block(0xE672, &block_e672);
  core.register_block(0xE674, &block_e674);
  core.register_block(0xE676, &block_e676);
  core.register_block(0xE678, &block_e678);
  core.register_block(0xE67A, &block_e67a);
  core.register_block(0xE67C, &block_e67c);
  core.register_block(0xE67E, &block_e67e);
  core.register_block(0xE67F, &block_e67f);
  core.register_block(0xE681, &block_e681);
  core.register_block(0xE682, &block_e682);
  core.register_block(0xE684, &block_e684);
  core.register_block(0xE686, &block_e686);
  core.register_block(0xE688, &block_e688);
  core.register_block(0xE68A, &block_e68a);
  core.register_block(0xE68C, &block_e68c);
  core.register_block(0xE68E, &block_e68e);
  core.register_block(0xE68F, &block_e68f);
  core.register_block(0xE691, &block_e691);
  core.register_block(0xE693, &block_e693);
  core.register_block(0xE695, &block_e695);
  core.register_block(0xE697, &block_e697);
  core.register_block(0xE699, &block_e699);
  core.register_block(0xE69B, &block_e69b);
  core.register_block(0xE69E, &block_e69e);
  core.register_block(0xE6A0, &block_e6a0);
  core.register_block(0xE6A3, &block_e6a3);
  core.register_block(0xE6A6, &block_e6a6);
  core.register_block(0xE6A9, &block_e6a9);
  core.register_block(0xE6AA, &block_e6aa);
  core.register_block(0xE6AC, &block_e6ac);
  core.register_block(0xE6AE, &block_e6ae);
  core.register_block(0xE6B0, &block_e6b0);
  core.register_block(0xE6B2, &block_e6b2);
  core.register_block(0xE6B3, &block_e6b3);
  core.register_block(0xE6B5, &block_e6b5);
  core.register_block(0xE6B7, &block_e6b7);
  core.register_block(0xE6B9, &block_e6b9);
  core.register_block(0xE6BB, &block_e6bb);
  core.register_block(0xE6BD, &block_e6bd);
  core.register_block(0xE6BF, &block_e6bf);
  core.register_block(0xE6C1, &block_e6c1);
  core.register_block(0xE6C3, &block_e6c3);
  core.register_block(0xE6C4, &block_e6c4);
  core.register_block(0xE6C6, &block_e6c6);
  core.register_block(0xE6C7, &block_e6c7);
  core.register_block(0xE6C9, &block_e6c9);
  core.register_block(0xE6CB, &block_e6cb);
  core.register_block(0xE6CD, &block_e6cd);
  core.register_block(0xE6CF, &block_e6cf);
  core.register_block(0xE19B, &block_e19b);
  core.register_block(0xE19C, &block_e19c);
  core.register_block(0xE19E, &block_e19e);
  core.register_block(0xE1A0, &block_e1a0);
  core.register_block(0xE1A3, &block_e1a3);
  core.register_block(0xE1A5, &block_e1a5);
  core.register_block(0xE1A7, &block_e1a7);
  core.register_block(0xE1A9, &block_e1a9);
  core.register_block(0xE1AA, &block_e1aa);
  core.register_block(0xE1AD, &block_e1ad);
  core.register_block(0xE1B0, &block_e1b0);
  core.register_block(0xE1B1, &block_e1b1);
  core.register_block(0xE1B2, &block_e1b2);
  core.register_block(0xE1B3, &block_e1b3);
  core.register_block(0xE1B5, &block_e1b5);
  core.register_block(0xE1B7, &block_e1b7);
  core.register_block(0xE1BA, &block_e1ba);
  core.register_block(0xE1BB, &block_e1bb);
  core.register_block(0xE1BD, &block_e1bd);
  core.register_block(0xE1C0, &block_e1c0);
  core.register_block(0xE1C2, &block_e1c2);
  core.register_block(0xE1C5, &block_e1c5);
  core.register_block(0xE1C7, &block_e1c7);
  core.register_block(0xE1C9, &block_e1c9);
  core.register_block(0xE1CB, &block_e1cb);
  core.register_block(0xE1CD, &block_e1cd);
  core.register_block(0xE1CF, &block_e1cf);
  core.register_block(0xE1D1, &block_e1d1);
  core.register_block(0xE1D3, &block_e1d3);
  core.register_block(0xE1E1, &block_e1e1);
  core.register_block(0xE1E4, &block_e1e4);
  core.register_block(0xE1E7, &block_e1e7);
  core.register_block(0xE1E9, &block_e1e9);
  core.register_block(0xE1EB, &block_e1eb);
  core.register_block(0xE1ED, &block_e1ed);
  core.register_block(0xE1EF, &block_e1ef);
  core.register_block(0xE1F2, &block_e1f2);
  core.register_block(0xE1F4, &block_e1f4);
  core.register_block(0xE1F5, &block_e1f5);
  core.register_block(0xE1F6, &block_e1f6);
  core.register_block(0xE1F7, &block_e1f7);
  core.register_block(0xE1F9, &block_e1f9);
  core.register_block(0xE1FB, &block_e1fb);
  core.register_block(0xE1FD, &block_e1fd);
  core.register_block(0xE200, &block_e200);
  core.register_block(0xE204, &block_e204);
  core.register_block(0xE206, &block_e206);
  core.register_block(0xE208, &block_e208);
  core.register_block(0xE209, &block_e209);
  core.register_block(0xE20B, &block_e20b);
  core.register_block(0xE20D, &block_e20d);
  core.register_block(0xE20F, &block_e20f);
  core.register_block(0xE211, &block_e211);
  core.register_block(0xE213, &block_e213);
  core.register_block(0xE216, &block_e216);
  core.register_block(0xE218, &block_e218);
  core.register_block(0xE21A, &block_e21a);
  core.register_block(0xE21C, &block_e21c);
  core.register_block(0xE21E, &block_e21e);
  core.register_block(0xE220, &block_e220);
  core.register_block(0xE222, &block_e222);
  core.register_block(0xE224, &block_e224);
  core.register_block(0xE226, &block_e226);
  core.register_block(0xE228, &block_e228);
  core.register_block(0xE229, &block_e229);
  core.register_block(0xE234, &block_e234);
  core.register_block(0xE236, &block_e236);
  core.register_block(0xE238, &block_e238);
  core.register_block(0xE23A, &block_e23a);
  core.register_block(0xE23C, &block_e23c);
  core.register_block(0xE23E, &block_e23e);
  core.register_block(0xE23F, &block_e23f);
  core.register_block(0xE241, &block_e241);
  core.register_block(0xE26C, &block_e26c);
  core.register_block(0xE26E, &block_e26e);
  core.register_block(0xE270, &block_e270);
  core.register_block(0xE271, &block_e271);
  core.register_block(0xE273, &block_e273);
  core.register_block(0xE276, &block_e276);
  core.register_block(0xE278, &block_e278);
  core.register_block(0xE27B, &block_e27b);
  core.register_block(0xEB05, &block_eb05);
  core.register_block(0xEB07, &block_eb07);
  core.register_block(0xEB09, &block_eb09);
  core.register_block(0xEB0B, &block_eb0b);
  core.register_block(0xEB0D, &block_eb0d);
  core.register_block(0xEB0F, &block_eb0f);
  core.register_block(0xEB11, &block_eb11);
  core.register_block(0xEB12, &block_eb12);
  core.register_block(0xEB14, &block_eb14);
  core.register_block(0xEB16, &block_eb16);
  core.register_block(0xEB18, &block_eb18);
  core.register_block(0xEB1A, &block_eb1a);
  core.register_block(0xEB1C, &block_eb1c);
  core.register_block(0xEB1D, &block_eb1d);
  core.register_block(0xEB1F, &block_eb1f);
  core.register_block(0xEB20, &block_eb20);
  core.register_block(0xEB22, &block_eb22);
  core.register_block(0xEB24, &block_eb24);
  core.register_block(0xEB25, &block_eb25);
  core.register_block(0xEB27, &block_eb27);
  core.register_block(0xEB28, &block_eb28);
  core.register_block(0xEB2A, &block_eb2a);
  core.register_block(0xEB2C, &block_eb2c);
  core.register_block(0xEB2E, &block_eb2e);
  core.register_block(0xEB2F, &block_eb2f);
  core.register_block(0xEB31, &block_eb31);
  core.register_block(0xEB32, &block_eb32);
  core.register_block(0xEB34, &block_eb34);
  core.register_block(0xEB36, &block_eb36);
  core.register_block(0xEB37, &block_eb37);
  core.register_block(0xEB39, &block_eb39);
  core.register_block(0xEB3A, &block_eb3a);
  core.register_block(0xEB3B, &block_eb3b);
  core.register_block(0xEB3D, &block_eb3d);
  core.register_block(0xEB3E, &block_eb3e);
  core.register_block(0xED00, &block_ed00);
  core.register_block(0xED02, &block_ed02);
  core.register_block(0xED03, &block_ed03);
  core.register_block(0xED04, &block_ed04);
  core.register_block(0xED05, &block_ed05);
  core.register_block(0xED06, &block_ed06);
  core.register_block(0xED07, &block_ed07);
  core.register_block(0xED09, &block_ed09);
  core.register_block(0xED0A, &block_ed0a);
  core.register_block(0xED0D, &block_ed0d);
  core.register_block(0xED0F, &block_ed0f);
  core.register_block(0xED10, &block_ed10);
  core.register_block(0xED12, &block_ed12);
  core.register_block(0xED13, &block_ed13);
  core.register_block(0xED16, &block_ed16);
  core.register_block(0xED17, &block_ed17);
  core.register_block(0xED19, &block_ed19);
  core.register_block(0xED1A, &block_ed1a);
  core.register_block(0xED1B, &block_ed1b);
  core.register_block(0xED1E, &block_ed1e);
  core.register_block(0xED20, &block_ed20);
  core.register_block(0xED22, &block_ed22);
  core.register_block(0xED24, &block_ed24);
  core.register_block(0xED25, &block_ed25);
  core.register_block(0xED27, &block_ed27);
  core.register_block(0xED29, &block_ed29);
  core.register_block(0xED2A, &block_ed2a);
  core.register_block(0xED2C, &block_ed2c);
  core.register_block(0xED2D, &block_ed2d);
  core.register_block(0xED30, &block_ed30);
  core.register_block(0xED31, &block_ed31);
  core.register_block(0xED33, &block_ed33);
  core.register_block(0xED35, &block_ed35);
  core.register_block(0xED37, &block_ed37);
  core.register_block(0xED39, &block_ed39);
  core.register_block(0xED3B, &block_ed3b);
  core.register_block(0xED3D, &block_ed3d);
  core.register_block(0xED3F, &block_ed3f);
  core.register_block(0xED40, &block_ed40);
  core.register_block(0xED41, &block_ed41);
  core.register_block(0xED42, &block_ed42);
  core.register_block(0xED43, &block_ed43);
  core.register_block(0xED46, &block_ed46);
  core.register_block(0xED47, &block_ed47);
  core.register_block(0xED49, &block_ed49);
  core.register_block(0xED4A, &block_ed4a);
  core.register_block(0xED4C, &block_ed4c);
  core.register_block(0xED4E, &block_ed4e);
  core.register_block(0xED4F, &block_ed4f);
  core.register_block(0xED52, &block_ed52);
  core.register_block(0xED54, &block_ed54);
  core.register_block(0xED56, &block_ed56);
  core.register_block(0xED57, &block_ed57);
  core.register_block(0xED59, &block_ed59);
  core.register_block(0xED5B, &block_ed5b);
  core.register_block(0xED5C, &block_ed5c);
  core.register_block(0xED5D, &block_ed5d);
  core.register_block(0xED5E, &block_ed5e);
  core.register_block(0xED5F, &block_ed5f);
  core.register_block(0xED61, &block_ed61);
  core.register_block(0xED63, &block_ed63);
  core.register_block(0xED65, &block_ed65);
  core.register_block(0xED67, &block_ed67);
  core.register_block(0xED68, &block_ed68);
  core.register_block(0xED6A, &block_ed6a);
  core.register_block(0xED6B, &block_ed6b);
  core.register_block(0xED6D, &block_ed6d);
  core.register_block(0xED6F, &block_ed6f);
  core.register_block(0xED70, &block_ed70);
  core.register_block(0xED72, &block_ed72);
  core.register_block(0xED73, &block_ed73);
  core.register_block(0xED75, &block_ed75);
  core.register_block(0xED77, &block_ed77);
  core.register_block(0xED79, &block_ed79);
  core.register_block(0xED7A, &block_ed7a);
  core.register_block(0xED7C, &block_ed7c);
  core.register_block(0xED7D, &block_ed7d);
  core.register_block(0xED7F, &block_ed7f);
  core.register_block(0xED81, &block_ed81);
  core.register_block(0xED82, &block_ed82);
  core.register_block(0xED84, &block_ed84);
  core.register_block(0xED85, &block_ed85);
  core.register_block(0xED87, &block_ed87);
  core.register_block(0xED89, &block_ed89);
  core.register_block(0xED8A, &block_ed8a);
  core.register_block(0xED8C, &block_ed8c);
  core.register_block(0xED8D, &block_ed8d);
  core.register_block(0xED8F, &block_ed8f);
  core.register_block(0xED90, &block_ed90);
  core.register_block(0xED92, &block_ed92);
  core.register_block(0xED93, &block_ed93);
  core.register_block(0xED95, &block_ed95);
  core.register_block(0xED96, &block_ed96);
  core.register_block(0xED98, &block_ed98);
  core.register_block(0xED9A, &block_ed9a);
  core.register_block(0xE2CB, &block_e2cb);
  core.register_block(0xE2CE, &block_e2ce);
  core.register_block(0xE2D0, &block_e2d0);
  core.register_block(0xE2D1, &block_e2d1);
  core.register_block(0xE2D2, &block_e2d2);
  core.register_block(0xE2D4, &block_e2d4);
  core.register_block(0xE2D7, &block_e2d7);
  core.register_block(0xE2D9, &block_e2d9);
  core.register_block(0xE2DB, &block_e2db);
  core.register_block(0xE2DD, &block_e2dd);
  core.register_block(0xE2DF, &block_e2df);
  core.register_block(0xE2E1, &block_e2e1);
  core.register_block(0xE2E3, &block_e2e3);
  core.register_block(0xE2E6, &block_e2e6);
  core.register_block(0xE2E8, &block_e2e8);
  core.register_block(0xE2EB, &block_e2eb);
  core.register_block(0xE2ED, &block_e2ed);
  core.register_block(0xE2EE, &block_e2ee);
  core.register_block(0xE2F0, &block_e2f0);
  core.register_block(0xE2F2, &block_e2f2);
  core.register_block(0xE2F4, &block_e2f4);
  core.register_block(0xE2F6, &block_e2f6);
  core.register_block(0xE2F7, &block_e2f7);
  core.register_block(0xE2F9, &block_e2f9);
  core.register_block(0xE2FB, &block_e2fb);
  core.register_block(0xE2FC, &block_e2fc);
  core.register_block(0xE2FF, &block_e2ff);
  core.register_block(0xE301, &block_e301);
  core.register_block(0xE303, &block_e303);
  core.register_block(0xE305, &block_e305);
  core.register_block(0xE307, &block_e307);
  core.register_block(0xE309, &block_e309);
  core.register_block(0xE30B, &block_e30b);
  core.register_block(0xE30D, &block_e30d);
  core.register_block(0xE30F, &block_e30f);
  core.register_block(0xE311, &block_e311);
  core.register_block(0xE313, &block_e313);
  core.register_block(0xE315, &block_e315);
  core.register_block(0xE317, &block_e317);
  core.register_block(0xE319, &block_e319);
  core.register_block(0xE31B, &block_e31b);
  core.register_block(0xE31D, &block_e31d);
  core.register_block(0xE31F, &block_e31f);
  core.register_block(0xE321, &block_e321);
  core.register_block(0xE323, &block_e323);
  core.register_block(0xE325, &block_e325);
  core.register_block(0xE328, &block_e328);
  core.register_block(0xE32C, &block_e32c);
  core.register_block(0xE32E, &block_e32e);
  core.register_block(0xE32F, &block_e32f);
  core.register_block(0xE330, &block_e330);
  core.register_block(0xE332, &block_e332);
  core.register_block(0xE334, &block_e334);
  core.register_block(0xE336, &block_e336);
  core.register_block(0xE338, &block_e338);
  core.register_block(0xE33A, &block_e33a);
  core.register_block(0xE33C, &block_e33c);
  core.register_block(0xE33E, &block_e33e);
  core.register_block(0xE340, &block_e340);
  core.register_block(0xE342, &block_e342);
  core.register_block(0xE344, &block_e344);
  core.register_block(0xE347, &block_e347);
  core.register_block(0xE349, &block_e349);
  core.register_block(0xE4F5, &block_e4f5);
  core.register_block(0xE508, &block_e508);
  core.register_block(0xE509, &block_e509);
  core.register_block(0xE50B, &block_e50b);
  core.register_block(0xE50D, &block_e50d);
  core.register_block(0xE50F, &block_e50f);
  core.register_block(0xE511, &block_e511);
  core.register_block(0xE512, &block_e512);
  core.register_block(0xE514, &block_e514);
  core.register_block(0xE3C4, &block_e3c4);
  core.register_block(0xE3C6, &block_e3c6);
  core.register_block(0xE3C8, &block_e3c8);
  core.register_block(0xE3CA, &block_e3ca);
  core.register_block(0xE3CC, &block_e3cc);
  core.register_block(0xE3CE, &block_e3ce);
  core.register_block(0xE3D0, &block_e3d0);
  core.register_block(0xE3D2, &block_e3d2);
  core.register_block(0xE3D4, &block_e3d4);
  core.register_block(0xE3D6, &block_e3d6);
  core.register_block(0xE3D8, &block_e3d8);
  core.register_block(0xE3DA, &block_e3da);
  core.register_block(0xE3DC, &block_e3dc);
  core.register_block(0xE3DE, &block_e3de);
  core.register_block(0xE3E0, &block_e3e0);
  core.register_block(0xE3E1, &block_e3e1);
  core.register_block(0xE3E3, &block_e3e3);
  core.register_block(0xE3E4, &block_e3e4);
  core.register_block(0xE3E5, &block_e3e5);
  core.register_block(0xE3E7, &block_e3e7);
  core.register_block(0xE3EA, &block_e3ea);
  core.register_block(0xE3EC, &block_e3ec);
  core.register_block(0xE3EE, &block_e3ee);
  core.register_block(0xE3F1, &block_e3f1);
  core.register_block(0xE4FA, &block_e4fa);
  core.register_block(0xE4FC, &block_e4fc);
  core.register_block(0xE502, &block_e502);
  core.register_block(0xE504, &block_e504);
  core.register_block(0xE556, &block_e556);
  core.register_block(0xE558, &block_e558);
  core.register_block(0xE55A, &block_e55a);
  core.register_block(0xE55C, &block_e55c);
  core.register_block(0xE55E, &block_e55e);
  core.register_block(0xE560, &block_e560);
  core.register_block(0xE562, &block_e562);
  core.register_block(0xE565, &block_e565);
  core.register_block(0xE567, &block_e567);
  core.register_block(0xE569, &block_e569);
  core.register_block(0xE56B, &block_e56b);
  core.register_block(0xE56D, &block_e56d);
  core.register_block(0xE56F, &block_e56f);
  core.register_block(0xE571, &block_e571);
  core.register_block(0xE573, &block_e573);
  core.register_block(0xE575, &block_e575);
  core.register_block(0xE577, &block_e577);
  core.register_block(0xE579, &block_e579);
  core.register_block(0xE57B, &block_e57b);
  core.register_block(0xE57D, &block_e57d);
  core.register_block(0xE580, &block_e580);
  core.register_block(0xE582, &block_e582);
  core.register_block(0xE583, &block_e583);
  core.register_block(0xE585, &block_e585);
  core.register_block(0xE587, &block_e587);
  core.register_block(0xE58A, &block_e58a);
  core.register_block(0xE58C, &block_e58c);
  core.register_block(0xE58F, &block_e58f);
  core.register_block(0xE591, &block_e591);
  core.register_block(0xE593, &block_e593);
  core.register_block(0xE595, &block_e595);
  core.register_block(0xE597, &block_e597);
  core.register_block(0xE599, &block_e599);
  core.register_block(0xE59C, &block_e59c);

  // Temporary dynamic lift for remaining unlifted rd200_rom_b PCs.
  // It covers E000..EDFF addresses not yet statically lifted while we progressively
  // replace it with static per-block lifts.
  for (u16 pc = 0xE000; pc <= 0xEDFF; ++pc)
  {
    if (!core.has_block(pc))
      core.register_block(pc, &block_dynamic_e79b_ec83);
  }
}
