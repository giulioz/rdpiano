#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef uint8_t u8;
typedef uint16_t u16;
typedef uint32_t u32;

#define BIT(x, n) (((x) >> (n)) & 1)

#define BITSWAP8(val, B7, B6, B5, B4, B3, B2, B1, B0)                \
  ((BIT(val, B7) << 7) | (BIT(val, B6) << 6) | (BIT(val, B5) << 5) | \
   (BIT(val, B4) << 4) | (BIT(val, B3) << 3) | (BIT(val, B2) << 2) | \
   (BIT(val, B1) << 1) | (BIT(val, B0) << 0))

#define BITSWAP16(val, B16, B15, B14, B13, B12, B11, B10, B9, B8, B7, B6, B5, \
                  B4, B3, B2, B1, B0)                                         \
  ((BIT(val, B16) << 16) | (BIT(val, B15) << 15) | (BIT(val, B14) << 14) |    \
   (BIT(val, B13) << 13) | (BIT(val, B12) << 12) | (BIT(val, B11) << 11) |    \
   (BIT(val, B10) << 10) | (BIT(val, B9) << 9) | (BIT(val, B8) << 8) |        \
   (BIT(val, B7) << 7) | (BIT(val, B6) << 6) | (BIT(val, B5) << 5) |          \
   (BIT(val, B4) << 4) | (BIT(val, B3) << 3) | (BIT(val, B2) << 2) |          \
   (BIT(val, B1) << 1) | (BIT(val, B0) << 0))

int main(int argc, char** argv) {
  if (argc != 3) {
    printf("Usage: %s scrambled.bin descrambled.bin", *argv);
    return 1;
  }

  const char* filename_in = argv[1];
  const char* filename_out = argv[2];

  FILE* f = fopen(filename_in, "rb");
  if (!f) {
    printf("Error: cannot open %s: %s\n", filename_in, strerror(errno));
    return 1;
  }

  fseek(f, 0, SEEK_END);
  size_t fsize = ftell(f);
  fseek(f, 0, SEEK_SET);

  u8* buf = (u8*)malloc(fsize);
  u8* outbuf = (u8*)malloc(fsize);
  for (size_t i = 0; i < fsize; i++) {
    outbuf[i] = 0x00;
  }

  fread(buf, fsize, 1, f);
  fclose(f);

  int width;
  const char* type;

  // printf("ROM size: %lu [%d bit data]\n", fsize, width);
  // printf("ROM type: %s\n", type);

  //////////////////////////////////////////////
  // descramble the whole ROM
  for (size_t i = 0; i < fsize; i++) {
    // // IC10
    // u32 addr = ((BIT(i, 1) << 10) | (BIT(i, 0) << 9) | (BIT(i, 8) << 8) |
    //             (BIT(i, 10) << 7) | (BIT(i, 5) << 6) | (BIT(i, 4) << 5) |
    //             (BIT(i, 7) << 4) | (BIT(i, 3) << 3) | (BIT(i, 2) << 2) |
    //             (BIT(i, 6) << 1) | (BIT(i, 9) << 0));
    // u16 tmp = BITSWAP8(buf[addr], 2, 4, 5, 0, 3, 1, 7, 6);
    // outbuf[i] = tmp;

    // // ROM C
    // u32 addr = ((BIT(i, 2) << 12) | (BIT(i, 7) << 11) | (BIT(i, 3) << 10) |
    //             (BIT(i, 12) << 9) | (BIT(i, 0) << 8)  | (BIT(i, 10) << 7) |
    //             (BIT(i, 6) << 6)  | (BIT(i, 1) << 5)  | (BIT(i, 8) << 4) |
    //             (BIT(i, 11) << 3) | (BIT(i, 9) << 2)  | (BIT(i, 4) << 1) |
    //             (BIT(i, 5) << 0));
    // u16 tmp = BITSWAP8(buf[addr], 5, 1, 0, 4, 3, 6, 7, 2);
    // outbuf[i] = tmp;

    // // IC 5,6,7
    // u32 addr = ((BIT(i, 16) << 16) | (BIT(i, 15) << 15) | (BIT(i, 14) << 14) |
    //             (BIT(i, 1) << 13) | (BIT(i, 4) << 12) | (BIT(i, 9) << 11) |
    //             (BIT(i, 5) << 10) | (BIT(i, 10) << 9) | (BIT(i, 3) << 8) |
    //             (BIT(i, 0) << 7) | (BIT(i, 6) << 6) | (BIT(i, 11) << 5) |
    //             (BIT(i, 7) << 4) | (BIT(i, 2) << 3) | (BIT(i, 12) << 2) |
    //             (BIT(i, 8) << 1) | (BIT(i, 13) << 0));
    // u16 tmp = buf[addr];
    // outbuf[i] = tmp;

    // ROM B
    // u32 addr = ((BIT(i, 13) << 13)| (BIT(i, 12) << 12) | (BIT(i, 11) << 11) | (BIT(i, 8) << 10) |
    //             (BIT(i, 9) << 9) | (BIT(i, 10) << 8) | (BIT(i, 7) << 7) |
    //             (BIT(i, 6) << 6) | (BIT(i, 5) << 5) | (BIT(i, 4) << 4) |
    //             (BIT(i, 3) << 3) | (BIT(i, 2) << 2) | (BIT(i, 1) << 1) |
    //             (BIT(i, 0) << 0));
    // u16 tmp = BITSWAP8(buf[addr], 7, 0, 6, 1, 5, 2, 4, 3);
    // outbuf[i] = tmp;

    // // ROM B RESCRAMBLE
    // u32 addr = ((BIT(i, 13) << 13)| (BIT(i, 12) << 12) | (BIT(i, 11) << 11) | (BIT(i, 8) << 10) |
    //             (BIT(i, 9) << 9) | (BIT(i, 10) << 8) | (BIT(i, 7) << 7) |
    //             (BIT(i, 6) << 6) | (BIT(i, 5) << 5) | (BIT(i, 4) << 4) |
    //             (BIT(i, 3) << 3) | (BIT(i, 2) << 2) | (BIT(i, 1) << 1) |
    //             (BIT(i, 0) << 0));
    // u16 tmp = BITSWAP8(buf[addr], 7, 5, 3, 1, 0, 2, 4, 6);
    // outbuf[i] = tmp;

    // // IC18
    u32 addr = ((BIT(i, 16) << 16) | (BIT(i, 15) << 15) | (BIT(i, 13) << 14) |
                (BIT(i, 12) << 13) | (BIT(i, 14) << 12) |
                // split here
                (BIT(i, 11) << 11) | (BIT(i, 8) << 10) | (BIT(i, 9) << 9) |
                (BIT(i, 10) << 8) | (BIT(i, 7) << 7) | (BIT(i, 6) << 6) |
                (BIT(i, 5) << 5) | (BIT(i, 4) << 4) | (BIT(i, 3) << 3) |
                (BIT(i, 2) << 2) | (BIT(i, 1) << 1) | (BIT(i, 0) << 0));
    u16 tmp = BITSWAP8(buf[addr], 7, 0, 6, 1, 5, 2, 4, 3);
    outbuf[i] = tmp;
  }
  //////////////////////////////////////////////

  FILE* out = fopen(filename_out, "wb");
  if (!out) {
    printf("Error: cannot open %s: %s\n", filename_out, strerror(errno));
    return 1;
  }

  fwrite(outbuf, fsize, 1, out);
  fclose(out);

  return 0;
}