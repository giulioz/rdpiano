#include "Vcpub_ics.h"
#include "verilated.h"
#include <queue>
#include <stdio.h>

VerilatedContext *contextp;
Vcpub_ics *cpub;

void loadRom(const char *path, unsigned char *dest, int length) {
  FILE *f = fopen(path, "rb");
  if (!f) {
    printf("Failed to open file %s\n", path);
  }
  fread(dest, 1, length, f);
  fclose(f);
}

struct WriteRequest {
  unsigned long address;
  unsigned long data;
};
std::queue<WriteRequest> writeRequests;

unsigned char testData[] = {
    0x6C, 0x01, 0x10, 0x00, 0xDF, 0x7F, 0x00, 0x00, 0x7C, 0x02, 0x10, 0x00,
    0xE2, 0x5F, 0x00, 0x00, 0x85, 0x62, 0x10, 0x00, 0xBD, 0x7F, 0x00, 0x00,
    0x71, 0x39, 0x14, 0x04, 0xB3, 0x7F, 0x00, 0x00, 0x72, 0x63, 0x15, 0x06,
    0xB5, 0x7F, 0x00, 0x00, 0x72, 0x77, 0x15, 0x08, 0xB2, 0x7F, 0x00, 0x00,
    0x2E, 0x9E, 0x10, 0x17, 0xBC, 0x7F, 0x00, 0x00, 0x3C, 0xA0, 0x10, 0x14,
    0xB1, 0x7D, 0x00, 0x00, 0x00, 0x5B, 0xFF, 0x19, 0xDE, 0x78, 0x00, 0x00,
    0x20, 0x00, 0xFF, 0x27, 0xE7, 0xFF, 0xFF, 0x00,
};

int main() {
  contextp = new VerilatedContext;
  cpub = new Vcpub_ics{contextp};

  loadRom("../roms/RD200_C_desc.bin", cpub->ic11_memory, 8192);
  loadRom("../roms/RD200_IC10_desc.bin", cpub->ic10_memory, 2048);
  loadRom("../roms/RD200_IC5_desc.bin", cpub->ic5_memory, 131072);
  loadRom("../roms/RD200_IC6_desc.bin", cpub->ic6_memory, 131072);
  loadRom("../roms/RD200_IC7_desc.bin", cpub->ic7_memory, 131072);

  FILE *audioFile = fopen("test.bin", "wb");

  cpub->RESET_IN = 0;
  cpub->shouldWrite = 0;
  cpub->writeAddress = 0;
  cpub->writeData = 0;

  int prevWriteDone = 0;
  int prevMpx = 1;

  for (size_t voice = 0; voice < 16; voice++) {
    for (size_t part = 0; part < 16; part++) {
      writeRequests.emplace(WriteRequest{0x1000 + voice * 256 + part * 16,
                                         ((voice | 0x10) << 8) | (part << 4)});
      writeRequests.emplace(
          WriteRequest{0x1002 + voice * 256 + part * 16, 0x0000});
      writeRequests.emplace(
          WriteRequest{0x1004 + voice * 256 + part * 16, 0x0000});
      writeRequests.emplace(WriteRequest{0x1006 + voice * 256 + part * 16,
                                         (part == 0) ? 0xFF01 : 0x0001});
    }
  }
  // for (size_t i = 0; i < 80; i += 2) {
  //   int part = i / 8;
  //   int pos = i % 8;
  //   writeRequests.emplace(WriteRequest{0x1000 + part * 16 + pos,
  //                                      testData[i + 1] | (testData[i] <<
  //                                      8)});
  // }

  writeRequests.emplace(WriteRequest{0x1000 + 4, 0x1030});

  unsigned long nsCpu = 0; // 8 Mhz, 125 ns
  unsigned long nsIC = 0;  // 12.8 Mhz, 78.125 ns
  unsigned long cycles = 0;
  unsigned long waveCycles = 0;
  unsigned long lastCycleWrite = 0;
  unsigned long lastPrintCycles = 0;
  while (!contextp->gotFinish()) {
    // Clock generation
    nsIC++;
    if (nsIC == 78) {
      cpub->XTAL_IN_12 = ~cpub->XTAL_IN_12;
      nsIC = 0;

      waveCycles++;
      if (waveCycles > 10000) {
        waveCycles = 0;
        cpub->WR_A_OUT += 1;
      }
    }
    nsCpu++;
    if (nsCpu == 125) {
      cpub->XTAL_IN_8 = ~cpub->XTAL_IN_8;
      nsCpu = 0;
    }
    cycles++;

    if (cycles == 200) {
      cpub->RESET_IN = 1;
    } else if (cycles == 400) {
      cpub->RESET_IN = 0;
    }

    if (!prevWriteDone && cpub->writeDone) {
      // printf("writeDone %d\n", cycles);
      cpub->shouldWrite = 0;
      cpub->writeAddress = 0;
      cpub->writeData = 0;
    }
    prevWriteDone = cpub->writeDone;

    if (cycles >= 8000 && (cycles - lastCycleWrite) > 20000) {
      lastCycleWrite = cycles;
      if (!writeRequests.empty()) {
        WriteRequest wr = writeRequests.front();
        writeRequests.pop();
        cpub->shouldWrite = 1;
        cpub->writeAddress = wr.address;
        // cpub->writeData = wr.data;
        cpub->writeData = ((wr.data >> 8) | (wr.data << 8)) & 0xffff;
        // printf("writing %04x = %04x\n", wr.address, wr.data);
      }

      // for (size_t i = 0; i < 2048; i++) {
      //   printf("%02x ", cpub->mem_ic13[i]);
      // }
      // printf("\n");
    }

    if (cycles >= 8000 && (cycles - lastPrintCycles) > 200) {
      printf("%08x\n", cpub->mem_ic13[4] | (cpub->mem_ic13[5] << 8) |
                           (cpub->mem_ic13[6] << 16) |
                           (cpub->mem_ic13[7] << 24));
                           lastPrintCycles = cycles;
    }

    cpub->eval();

    // if (cpub->MPX1_OUT != prevMpx) {
    //   if (cpub->MPX1_OUT) {
    //     long long sample = cpub->DAC_OUT - 32768;
    //     fwrite(&sample, 2, 1, audioFile);
    //     fflush(audioFile);
    //   }
    //   prevMpx = cpub->MPX1_OUT;
    // }
  }

  fclose(audioFile);

  delete cpub;
  delete contextp;
  return 0;
}
