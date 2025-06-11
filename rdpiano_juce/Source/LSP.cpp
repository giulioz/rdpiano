/*
  ==============================================================================

    LSP.cpp
    Created: 11 Jun 2025 3:43:55am
    Author:  Giulio Zausa

  ==============================================================================
*/

#include "LSP.h"

RamOperationStage2::RamOperationStage2(int32_t *eram,
                                       std::queue<int32_t> *eramReadFifo)
    : eram(eram), eramReadFifo(eramReadFifo) {}

void RamOperationStage2::start(bool isWrite, uint16_t addr, uint8_t stage) {
  this->isWrite = isWrite;
  this->addr = addr;
  this->active = true;
  this->stage = stage;
}

void RamOperationStage2::tick(int32_t eramWriteLatch) {
  writeData = eramWriteLatch;

  if (active) {
    if (stage == 11 && isWrite) {
      active = false;
      eram[addr] = writeData >> 4;
    }

    if (stage == 11 && !isWrite) {
      active = false;
      eramReadFifo->push(eram[addr] << 4);
    }

    stage += 1;
  }
}

void RamOperationStage1::startTransaction(uint8_t command, uint16_t baseAddr,
                                          int32_t offsetAddr) {
  if (active) {
    printf("stage 1 already active: %02x\n", command);
  }
  if (command == 0x05) {
    printf("invalid command %02x\n", command);
  }

  bool shouldUseOffset = (command & 0x06) == 0x04;
  addr = baseAddr + (shouldUseOffset ? (offsetAddr >> 10) : 0);
  stage = 0;
  isWrite = (command & 0x06) == 0x06;
  active = true;
  startCommand = command;
}

bool RamOperationStage1::sendCommand(RamOperationStage2 &ramStage2,
                                     uint8_t command, uint16_t baseAddr,
                                     int32_t offsetAddr) {
  if (active) {
    stage += 1;
    uint16_t incr = command << ((stage - 1) * 3);
    if (startCommand == 0x04) {
      incr = 0x00;
      if (command == 0x02 && stage == 1) {
        incr = 0x01;
      } else if (command != 0x00 && stage != 6) {
        printf("ERAM invalid command: %02x\n", command);
      }
    }

    if (stage < 6) {
      addr = addr + incr;
    } else {
      if ((command & 1 && stage == 6)) {
        addr = addr + incr;
      }

      // pass to next stage
      ramStage2.start(isWrite, addr, stage);
      active = false;

      if (command > 0x1) {
        startTransaction(command, baseAddr, offsetAddr);
      }

      return true;
    }
  } else {
    if (command == 0x00) {
      // nop
    } else if (command > 0x01) {
      startTransaction(command, baseAddr, offsetAddr);
    } else {
      printf("ERAM invalid stage: %02x\n", command);
    }
  }

  return false;
}

static constexpr int pipelineWriteDelay = 3;

LspState::LspState() : ramStage2{RamOperationStage2(eram, &eramReadFifo)} {}

void LspState::runProgram() {
  int total = 0;
  for (pc = 0x80; pc < 0x200 && total < 384; pc++, total++) {
    if (pc >= (0x80 + 384 / 2))
      audioIn = audioInL;
    else
      audioIn = audioInR;

    uint32_t instr = iram[pc];
    accA.fwdPipeline();
    accB.fwdPipeline();
    step(instr);
    accA.storePipeline();
    accB.storePipeline();

    if (pc >= (0x80 + 384 / 2))
      audioOutL = audioOut;
    else
      audioOutR = audioOut;
  }

  bufferPos = (bufferPos - 1) & 0x7f;
  eramPos -= 1;

  if (eramReadFifo.size() > 0) {
    printf("ERAM read FIFO overflow: %zu\n", eramReadFifo.size());
  }
}

void LspState::step(uint32_t instr) {
  uint8_t ii = (instr >> 16) & 0xff;
  uint8_t rr = (instr >> 8) & 0xff;
  int8_t cc = (int8_t)(instr & 0xff);

  uint8_t opcode = ii & 0xe0;
  uint8_t extRamCtrl = ii & 0x7;

  if (opcode == 0x00 || opcode == 0x20 || opcode == 0x40 || opcode == 0x60 ||
      opcode == 0xa0) {
    doInstrMac(ii, rr, cc);
  } else if (opcode == 0x80) {
    doInstrMul(ii, rr, cc);
  } else if (opcode == 0xc0 || opcode == 0xe0) {
    doInstrSpecialReg(ii, rr, cc);
  }

  commonDoEram(extRamCtrl);

  prevRR = rr;
}

void LspState::commonDoEram(uint8_t command) {
  ramStage1.sendCommand(ramStage2, command, eramPos, eramSecondTapOffs);
  ramStage2.tick(eramWriteLatch);
}

void LspState::commonDoStore(uint8_t ii, uint8_t rr) {
  uint8_t memOffs = rr & 0x7f;
  uint8_t writeCtrl = ii & 0x18;
  if (writeCtrl == 0x00) {
    // nop
  } else if (writeCtrl == 0x08) {
    writeMemOffs(memOffs, accA.historySat24(pipelineWriteDelay));
  } else if (writeCtrl == 0x10) {
    writeMemOffs(memOffs, accB.historySat24(pipelineWriteDelay));
  } else if (writeCtrl == 0x18) {
    writeMemOffs(memOffs, accA.historyRaw24(pipelineWriteDelay));
  }
}

int32_t LspState::commonGetMemOrImmediate(uint8_t rr, int8_t cc) {
  uint8_t mulScaler = (rr & 0x80) != 0 ? 5 : 7;
  uint8_t memOffs = rr & 0x7f;
  int64_t incr = readMemOffs(memOffs) * cc;
  if (memOffs == 1)
    incr = cc << 7;
  if (memOffs == 2)
    incr = cc << 12;
  if (memOffs == 3)
    incr = cc << 17;
  if (memOffs == 4)
    incr = cc << 22;
  incr >>= mulScaler;
  return incr;
}

void LspState::doInstrMac(uint8_t ii, uint8_t rr, int8_t cc) {
  bool absValue = (ii & 0xe0) == 0xa0;
  bool replaceAcc = ((ii & 0x20) != 0) || absValue;
  DspAccumulator &acc = (ii & 0x40) != 0 ? accB : accA;

  commonDoStore(ii, rr);

  int32_t incr = commonGetMemOrImmediate(rr, cc);
  if (replaceAcc) {
    acc.set(incr);
  } else {
    acc.add(incr);
  }

  if (absValue) {
    acc.abs();
  }
}

void LspState::doInstrMul(uint8_t ii, uint8_t rr, int8_t cc) {
  uint8_t memOffs = rr & 0x7f;
  uint8_t mulScaler = (rr & 0x80) != 0 ? 5 : 7;
  bool lower = (cc & 0x40) != 0;
  DspAccumulator &acc = (cc & 0x10) != 0 ? accB : accA;
  bool negate = (cc & 0x4) != 0;
  bool replaceAcc = (cc & 0x8) != 0;
  int32_t opB = (cc & 0x2) != 0 ? multiplCoef2 : multiplCoef1;

  commonDoStore(ii, memOffs);

  if (lower) {
    opB &= 0xffff;
    opB >>= 9;
  } else {
    opB >>= 16;
  }

  int64_t opA = readMemOffs(memOffs);
  if (memOffs == 1)
    opA = cc << 7;
  if (memOffs == 2)
    opA = cc << 12;
  if (memOffs == 3)
    opA = cc << 17;
  if (memOffs == 4)
    opA = cc << 22;

  int64_t result = 0;
  if (cc == 0x00) {
    result = 0;
  } else if (cc == 0x04 || cc == 0x08 || cc == 0xc) {
    printf("UNIMPLEMENTED %02x %02x %02x\n", ii, rr, cc);
  } else {
    result = opA * opB;
  }

  result >>= mulScaler;
  if (lower) {
    result >>= 7;
  }

  if (negate) {
    result = -result;
  }
  if (!replaceAcc || lower) {
    result += acc.sat24();
  }
  acc.set(result);
}

void LspState::doInstrSpecialReg(uint8_t ii, uint8_t rr, int8_t cc) {
  DspAccumulator &accDest = (ii & 0x20) != 0 ? accB : accA;
  uint8_t writeCtrl = ii & 0x18;
  uint8_t mulScaler = (rr & 0x80) != 0 ? 5 : 7;
  bool useSpecial = (rr & 0x40) != 0;
  bool replaceAcc = (rr & 0x20) != 0;
  uint8_t specialSlot = rr & 0x1f;

  if (!useSpecial) {
    printf("UNIMPLEMENTED %02x %02x %02x\n", ii, rr, cc);
    return;
  }

  // special case 50/d0
  if (writeCtrl == 0x00) {
    if (specialSlot == 0x10) {
      uint8_t prevMem = prevRR & 0x7f;

      int64_t incr = readMemOffs(prevMem) * (uint8_t)cc;
      incr >>= 7;

      if (prevMem == 1 || prevMem == 2 || prevMem == 3 || prevMem == 4) {
        int prevShift = 0;
        if (prevMem == 2)
          prevShift = 5;
        else if (prevMem == 3)
          prevShift = 10;
        else if (prevMem == 4)
          prevShift = 15;
        incr = ((uint8_t)cc) << prevShift;
      }

      incr >>= 1;
      incr >>= mulScaler;

      if (replaceAcc) {
        accDest.set(incr);
      } else {
        accDest.add(incr);
      }
    } else {
      printf("UNIMPLEMENTED %02x %02x %02x\n", ii, rr, cc);
    }
    return;
  }

  int64_t src = 0;
  if (writeCtrl == 0x08) {
    src = accA.historySat24(pipelineWriteDelay);
  } else if (writeCtrl == 0x10) {
    src = accB.historySat24(pipelineWriteDelay);
  } else if (writeCtrl == 0x18) {
    src = accA.historyRaw24(pipelineWriteDelay);
  }

  bool updatesAcc = false;

  if (specialSlot == 0x0d) { // jmp if <0
    // TODO: probably wrong
    if (src < 0) {
      pc = (((uint8_t)cc) << 1) - 1;
    }
    updatesAcc = true; // TODO: check
  }

  else if (specialSlot == 0x0e) { // jmp if >=0
    if (src >= 0) {
      pc = (((uint8_t)cc) << 1) - 1;
    }
    updatesAcc = true; // TODO: check
  }

  else if (specialSlot == 0x0f) { // jmp
    pc = (((uint8_t)cc) << 1) - 1;
    updatesAcc = true; // TODO: check
  }

  else if (specialSlot == 0x10) { // eram write latch
    eramWriteLatch = src;
  }

  else if (specialSlot == 0x13) { // eram second tap offset
    eramSecondTapOffs = src;
  }

  else if (specialSlot == 0x14) { // multiplCoef1
    multiplCoef1 = src;
  }

  else if (specialSlot == 0x15) { // multiplCoef2
    multiplCoef2 = src;
  }

  else if (specialSlot == 0x18) { // audio out
    audioOut = src;
    writeMemOffs(0x78, src);
    updatesAcc = true;
  }

  else if (specialSlot == 0x1a) { // eram read 1
    if (!eramReadFifo.empty()) {
      src = eramReadFifo.front();
      eramReadFifo.pop();
    } else {
      printf("%04x: eram read 1 empty\n", pc);
    }
    writeMemOffs(0x7a, src);
    updatesAcc = true;
  }

  else if (specialSlot == 0x1b) { // eram read 2
    if (!eramReadFifo.empty()) {
      src = eramReadFifo.front();
      eramReadFifo.pop();
    } else {
      printf("%04x: eram read 2 empty\n", pc);
    }
    writeMemOffs(0x7b, src);
    updatesAcc = true;
  }

  else if (specialSlot == 0x1c) { // eram read 3
    if (!eramReadFifo.empty()) {
      src = eramReadFifo.front();
      eramReadFifo.pop();
    } else {
      printf("%04x: eram read 3 empty\n", pc);
    }
    writeMemOffs(0x7c, src);
    updatesAcc = true;
  }

  else if (specialSlot == 0x1d) { // eram read 4
    if (!eramReadFifo.empty()) {
      src = eramReadFifo.front();
      eramReadFifo.pop();
    } else {
      printf("%04x: eram read 4 empty\n", pc);
    }
    writeMemOffs(0x7d, src);
    updatesAcc = true;
  }

  else if (specialSlot == 0x1e) { // audio in
    src = audioIn;
    writeMemOffs(0x7e, src);
    updatesAcc = true;
  }

  else {
    printf("%04x: unknown special write %02x=%06x\n", pc, specialSlot,
           (int32_t)src);
    return;
  }

  if (updatesAcc) {
    src *= cc;
    src >>= mulScaler;
    if (replaceAcc) {
      accDest.set(src);
    } else {
      accDest.add(src);
    }
  }
}

void LspState::writeMemOffs(uint8_t memOffs, int32_t value) {
  uint32_t ramPos = ((uint32_t)memOffs + bufferPos) & 0x7f;
  iram[ramPos] = value;
}

int64_t LspState::readMemOffs(uint8_t memOffs) {
  uint32_t ramPos = ((uint32_t)memOffs + bufferPos) & 0x7f;
  return iram[ramPos];
}
