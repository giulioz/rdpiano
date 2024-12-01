#include "Vcpub_ics.h"
#include "verilated.h"
#include <stdio.h>

VerilatedContext *contextp;
Vcpub_ics *cpub;

unsigned short cpuAddress = 0x00;
unsigned char cpuData = 0x00;
bool cpuShouldWrite = false;
bool cpuWriteDone = true;

// unsigned char testData[] = {
//     0x6C, 0x01, 0x10, 0x00, 0xDF, 0x7F, 0x00, 0x00, 0x7C, 0x02, 0x10, 0x00,
//     0xCF, 0x7F, 0x00, 0x00, 0x85, 0x62, 0x10, 0x00, 0xBD, 0x7F, 0x00, 0x00,
//     0x71, 0x39, 0x14, 0x04, 0xB3, 0x7F, 0x00, 0x00, 0x72, 0x63, 0x15, 0x06,
//     0xB5, 0x7F, 0x00, 0x00, 0x72, 0x77, 0x15, 0x08, 0xB2, 0x7F, 0x00, 0x00,
//     0x2E, 0x9E, 0x10, 0x17, 0xBC, 0x7F, 0x00, 0x00, 0x3C, 0xA0, 0x10, 0x14,
//     0xB1, 0x7D, 0x00, 0x00, 0x00, 0x5B, 0xFF, 0x19, 0xDE, 0x78, 0x00, 0x00,
//     0x20, 0x00, 0xFF, 0x27, 0xE7, 0xFF, 0xFF, 0x00,
// };
unsigned char testData[] = {
  0x41, 0x25, 0x14, 0x02, 0xEA, 0x7E, 0x00, 0x00,
  0x46, 0x7B, 0x19, 0x04, 0xFA, 0x76, 0x00, 0x00,
  0x4E, 0x6C, 0x1D, 0x06, 0xF0, 0x76, 0x00, 0x00,
  0x51, 0x43, 0x26, 0x07, 0xF0, 0x76, 0x00, 0x00,
  0x4F, 0xE2, 0x23, 0x09, 0xE9, 0x75, 0x00, 0x00,
  0x56, 0x21, 0x2D, 0x09, 0xE4, 0x75, 0x00, 0x00,
  0x14, 0x3A, 0x10, 0x0F, 0xE9, 0x75, 0x00, 0x00,
  0x24, 0x3A, 0x10, 0x10, 0xDC, 0x74, 0x00, 0x00,
  0x29, 0x8F, 0x10, 0x0E, 0xD5, 0x75, 0x00, 0x00,
  0x35, 0x82, 0x10, 0x0E, 0xD0, 0x73, 0xFF, 0x00,
};

int cpuStage = 0;
void evalCpu() {
  if (!cpuWriteDone)
    return;

  // Initial reset
  if (cpuStage < 8 * 16 * 16) {
    int sub = cpuStage % 8;
    int part = cpuStage / 8;
    int voice = cpuStage / 256;
    cpuAddress = 0x1000 + sub + part * 16 + voice * 256;
    cpuData = 0x00;
    if (sub == 0)
      cpuData = voice + 0x10;
    if (sub == 1)
      cpuData = part << 4;
    if (sub == 6 && part == 0)
      cpuData = 0xFF;
    if (sub == 7)
      cpuData = 0x01;
    cpuShouldWrite = true;
  }

  // if (cpuStage >= 8 * 16 * 16 && cpuStage < 8 * 16 * 16 + 8 * 10) {
  //   int sub = cpuStage % 8;
  //   int part = cpuStage / 8;
  //   int voice = cpuStage / 256;
  //   cpuAddress = 0x1000 + sub + part * 16 + voice * 256;
  //   cpuData = testData[(cpuStage - 8 * 16 * 16) + sub + part * 8];
  //   cpuShouldWrite = true;
  // }

  cpuStage++;
}

int main() {
  contextp = new VerilatedContext;
  cpub = new Vcpub_ics{contextp};

  FILE *f = fopen("test.bin", "wb");

  int prevMpx = 0;
  unsigned long nsCpu = 0; // 2 Mhz, 500 ns
  unsigned long nsIC = 0;  // 12.8 Mhz, 78.125 ns
  unsigned long cyclesCpu = 0;
  while (!contextp->gotFinish()) {
    // Clock generation
    nsIC++;
    if (nsIC == 78) {
      cpub->XTAL_IN = ~cpub->XTAL_IN;
      nsIC = 0;
    }

    nsCpu++;
    if (cpub->E_IN && nsCpu == 10) {
      cpub->AS_IN = 1;
      cpub->RW_IN = !cpuShouldWrite;
      cpub->CPU_P3_IN = cpuAddress & 0xFF;
      cpub->CPU_P4_IN = (cpuAddress >> 8) & 0xFF;
    }
    if (cpub->E_IN && nsCpu == (500 - 10)) {
      cpub->AS_IN = 0;
    }
    if (!cpub->E_IN) {
      cpub->CPU_P3_IN = cpuData;
    }
    if (nsCpu == 500) {
      if (!cpub->E_IN) {
        cpuAddress = 0x00;
        cpuWriteDone = true;
        if (cyclesCpu % 4 == 0) {
          evalCpu();

          for (size_t i = 0; i < 2048; i++) {
            // printf("%02x ", cpub->mem_ic12[i]);
          }
          // printf("\n");
        }
        cyclesCpu++;
      }
      cpub->E_IN = ~cpub->E_IN;
      nsCpu = 0;
    }

    cpub->eval();

    if (cpub->MPX1_OUT != prevMpx) {
      // printf("%d\n", cpub->DAC_OUT);
      fwrite(&cpub->DAC_OUT, 2, 1, f);
      fflush(f);
      prevMpx = cpub->MPX1_OUT;
    }
  }

  fclose(f);

  delete cpub;
  delete contextp;
  return 0;
}
