/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin processor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"
#include <cmath>

const char *rd200PatchNames[] = {"MKS-20: Piano 1",   "MKS-20: Piano 2",
                                 "MKS-20: Piano 3",   "MKS-20: Harpsichord",
                                 "MKS-20: Clavi",     "MKS-20: Vibraphone",
                                 "MKS-20: E-Piano 1", "MKS-20: E-Piano 2"};

const char *mk80PatchNames[] = {"MK-80: Classic",    "MK-80: Special",
                                "MK-80: Blend",      "MK-80: Contemporary",
                                "MK-80: A. Piano 1", "MK-80: A. Piano 2",
                                "MK-80: Clavi",      "MK-80: Vibraphone"};

struct RomSet {
  const uint8_t *ic5;
  const uint8_t *ic6;
  const uint8_t *ic7;
  const uint8_t *ic18;
};

const RomSet mks20ARomSet = {(const uint8_t *)BinaryData::mks20_15179738_BIN,
                             (const uint8_t *)BinaryData::mks20_15179737_BIN,
                             (const uint8_t *)BinaryData::mks20_15179736_BIN,
                             (const uint8_t *)BinaryData::mks20_15179757_BIN};
const RomSet mks20BRomSet = {(const uint8_t *)BinaryData::mks20_15179741_BIN,
                             (const uint8_t *)BinaryData::mks20_15179740_BIN,
                             (const uint8_t *)BinaryData::mks20_15179739_BIN,
                             (const uint8_t *)BinaryData::mks20_15179757_BIN};
const RomSet mk80RomSet = {(const uint8_t *)BinaryData::MK80_IC5_bin,
                           (const uint8_t *)BinaryData::MK80_IC6_bin,
                           (const uint8_t *)BinaryData::MK80_IC7_bin,
                           (const uint8_t *)BinaryData::MK80_IC18_bin};

const RomSet *patchToRomSet[] = {
    &mks20ARomSet, &mks20ARomSet, &mks20ARomSet, &mks20BRomSet,
    &mks20BRomSet, &mks20BRomSet, &mks20BRomSet, &mks20BRomSet,
    &mk80RomSet,   &mk80RomSet,   &mk80RomSet,   &mk80RomSet,
    &mk80RomSet,   &mk80RomSet,   &mk80RomSet,   &mk80RomSet};

const size_t patchToOffset[] = {
    // MKS-20
    0x000000, // Piano 1
    0x008000, // Piano 2
    0x010000, // Piano 3
    0x018000, // Harpsichord
    0x003c20, // Clavi
    0x00ab50, // Vibraphone
    0x014260, // E-Piano 1
    0x01bef0, // E-Piano 2

    // MK80
    0x000020, // Classic
    0x008000, // Special
    0x010000, // Blend
    0x018000, // Contemporary
    0x002c00, // A. Piano 1
    0x00b1f0, // A. Piano 2
    0x012910, // Clavi
    0x0199f0, // Vibraphone
};

const int sampleRates[] = {
    // MKS-20
    20000, 20000, 20000, 32000, 32000, 20000, 20000, 32000,
    // MK80
    20000, 20000, 20000, 32000, 20000, 20000, 32000, 20000};

const int chorusRateToMsPeriod[] = {
    2700, // 1
    1380, // 2
    910,  // 3
    680,  // 4
    540,  // 5
    450,  // 6
    385,  // 7
    335,  // 8
    300,  // 9
    265,  // 10
    245,  // 11
    220,  // 12
    205,  // 13
    190,  // 14
    175,  // 15
};

const int chorusRateToDepthChange[] = {
    11200, // 1
    5600,  // 2
    3700,  // 3
    2700,  // 4
    2200,  // 5
    1800,  // 6
    1520,  // 7
    1360,  // 8
    1200,  // 9
    1040,  // 10
    960,   // 11
    880,   // 12
    800,   // 13
    720,   // 14
    680,   // 15
};

//==============================================================================
RdPiano_juceAudioProcessor::RdPiano_juceAudioProcessor()
    : AudioProcessor(
          BusesProperties()
              .withInput("Input", juce::AudioChannelSet::stereo(), true)
              .withOutput("Output", juce::AudioChannelSet::stereo(), true)) {
  mcu = new Mcu(
      patchToRomSet[0]->ic5, patchToRomSet[0]->ic6, patchToRomSet[0]->ic7,
      // (const uint8_t *)BinaryData::mks20_cpub_1_0_bin,
      (const uint8_t *)BinaryData::RD200_B_bin, patchToRomSet[0]->ic18);

  spaceD = new SpaceD();
  phaser = new Phaser();

  mcuReset();
  spaceD->reset();
  phaser->reset();

  sourceSampleRate = sampleRates[0];

  // DAW parameters
  addParameter(volume = new juce::AudioParameterFloat(
                   juce::ParameterID{"volume", 1}, // parameterID
                   "Volume",                       // parameter name
                   0.0f,                           // minimum value
                   1.0f,                           // maximum value
                   1.0));                          // default value
  addParameter(chorusEnabled = new juce::AudioParameterBool(
                   juce::ParameterID{"chorusEnabled", 1}, // parameterID
                   "Chorus Enabled",                      // parameter name
                   true));                                // default value
  addParameter(chorusRate = new juce::AudioParameterInt(
                   juce::ParameterID{"chorusRate", 1}, // parameterID
                   "Chorus Rate",                      // parameter name
                   0,                                  // minimum value
                   14,                                 // maximum value
                   5));                                // default value
  addParameter(chorusDepth = new juce::AudioParameterInt(
                   juce::ParameterID{"chorusDepth", 1}, // parameterID
                   "Chorus Depth",                      // parameter name
                   0,                                   // minimum value
                   14,                                  // maximum value
                   14));                                // default value
  addParameter(tremoloEnabled = new juce::AudioParameterBool(
                   juce::ParameterID{"tremoloEnabled", 1}, // parameterID
                   "Tremolo Enabled",                      // parameter name
                   false));                                // default value
  addParameter(tremoloRate = new juce::AudioParameterInt(
                   juce::ParameterID{"tremoloRate", 1}, // parameterID
                   "Tremolo Rate",                      // parameter name
                   0,                                   // minimum value
                   14,                                  // maximum value
                   6));                                 // default value
  addParameter(tremoloDepth = new juce::AudioParameterInt(
                   juce::ParameterID{"tremoloDepth", 1}, // parameterID
                   "Tremolo Depth",                      // parameter name
                   0,                                    // minimum value
                   14,                                   // maximum value
                   6));                                  // default value
  addParameter(efxEnabled = new juce::AudioParameterBool(
                   juce::ParameterID{"efxEnabled", 1}, "EFX Enabled", false));
  // addParameter(
  //     efxPhaserOnOff = new juce::AudioParameterBool(
  //         juce::ParameterID{"efxPhaserOnOff", 1}, "Phaser Enabled", false));
  addParameter(
      efxPhaserRate = new juce::AudioParameterFloat(
          juce::ParameterID{"efxPhaserRate", 1}, "Phaser Rate", 0, 1, 0.4));
  addParameter(
      efxPhaserDepth = new juce::AudioParameterFloat(
          juce::ParameterID{"efxPhaserDepth", 1}, "Phaser Depth", 0, 1, 0.8));
  // addParameter(
  //     efxReverbOnOff = new juce::AudioParameterBool(
  //         juce::ParameterID{"efxReverbOnOff", 1}, "Reverb Enabled", true));
  // addParameter(
  //     efxReverbType = new juce::AudioParameterInt(
  //         juce::ParameterID{"efxReverbType", 1}, "Reverb Type", 0, 1, 0));
  // addParameter(
  //     efxReverbBalance = new juce::AudioParameterFloat(
  //         juce::ParameterID{"efxReverbBalance", 1}, "Reverb Balance", 0, 1,
  //         0));

  volume->addListener(this);
  chorusEnabled->addListener(this);
  chorusRate->addListener(this);
  chorusDepth->addListener(this);
  tremoloEnabled->addListener(this);
  tremoloRate->addListener(this);
  tremoloDepth->addListener(this);
  efxEnabled->addListener(this);
  // efxPhaserOnOff->addListener(this);
  efxPhaserRate->addListener(this);
  efxPhaserDepth->addListener(this);
  // efxReverbOnOff->addListener(this);
  // efxReverbType->addListener(this);
  // efxReverbBalance->addListener(this);
}

RdPiano_juceAudioProcessor::~RdPiano_juceAudioProcessor() {
  // memset(mcu, 0, sizeof(Mcu));
  delete mcu;
  mcu = 0;
  delete spaceD;
  spaceD = 0;
  delete phaser;
  phaser = 0;
}

//==============================================================================
void RdPiano_juceAudioProcessor::parameterValueChanged(int parameterIndex,
                                                       float newValue) {
  sendChangeMessage();
}

void RdPiano_juceAudioProcessor::parameterGestureChanged(
    int parameterIndex, bool gestureIsStarting) {}

//==============================================================================
const juce::String RdPiano_juceAudioProcessor::getName() const {
  return JucePlugin_Name;
}

bool RdPiano_juceAudioProcessor::acceptsMidi() const { return true; }

bool RdPiano_juceAudioProcessor::producesMidi() const { return false; }

bool RdPiano_juceAudioProcessor::isMidiEffect() const { return false; }

double RdPiano_juceAudioProcessor::getTailLengthSeconds() const { return 0.0; }

int RdPiano_juceAudioProcessor::getNumPrograms() { return 8 + 8; }

int RdPiano_juceAudioProcessor::getCurrentProgram() { return currentPatch; }

void RdPiano_juceAudioProcessor::setCurrentProgram(int index) {
  if (index < 0 || index >= getNumPrograms())
    return;

  mcuLock.enter();
  // if (patchToRomSet[index] != patchToRomSet[currentPatch]) {
  mcu->loadSounds(patchToRomSet[index]->ic5, patchToRomSet[index]->ic6,
                  patchToRomSet[index]->ic7, patchToRomSet[index]->ic18,
                  patchToOffset[index]);
  // }

  currentPatch = index;
  mcu->commands_queue.push(0x31);
  mcu->commands_queue.push(0x30);
  mcuLock.exit();
  sourceSampleRate = sampleRates[currentPatch];

  sendChangeMessage();
}

const juce::String RdPiano_juceAudioProcessor::getProgramName(int index) {
  if (index >= getNumPrograms())
    return juce::String();

  return juce::String(index >= 8 ? mk80PatchNames[index - 8]
                                 : rd200PatchNames[index]);
}

void RdPiano_juceAudioProcessor::changeProgramName(
    int index, const juce::String &newName) {}

void RdPiano_juceAudioProcessor::setMasterTune(int16_t tune) {
  masterTune = tune;

  mcuLock.enter();

  u8 tuneMsb = masterTune < 0 ? 0x7f : 0x00;
  u8 tuneLsb = (int8_t)(floor(abs(masterTune) / 32767.0 * 16.0) * 4) & 0xff;
  if (tuneLsb > 0x3c)
    tuneLsb = 0x3c;
  if (masterTune < 0)
    tuneLsb = 0x48 + tuneLsb;

  // TODO: we need to do this horrible switcharoo since changing
  // the tuning on patches different than 0 doesn't work...
  mcu->commands_queue.push(0x30);
  for (size_t cycle = 0; cycle < 100; cycle++) {
    mcu->generate_next_sample();
  }
  mcu->commands_queue.push(0xE0);
  mcu->commands_queue.push(tuneMsb);
  mcu->commands_queue.push(tuneLsb);
  for (size_t cycle = 0; cycle < 100; cycle++) {
    mcu->generate_next_sample();
  }
  mcu->commands_queue.push(0x30);

  mcuLock.exit();

  sendChangeMessage();
}

void RdPiano_juceAudioProcessor::mcuReset() {
  mcuLock.enter();

  mcu->reset();

  u8 tuneMsb = masterTune < 0 ? 0x7f : 0x00;
  u8 tuneLsb = (int8_t)(floor(abs(masterTune) / 32767.0 * 16.0) * 4) & 0xff;
  if (tuneLsb > 0x3c)
    tuneLsb = 0x3c;
  if (masterTune < 0)
    tuneLsb = 0x48 + tuneLsb;

  // MCU handshake
  mcu->commands_queue.push(0x30);
  mcu->commands_queue.push(0xE0);
  mcu->commands_queue.push(tuneMsb);
  mcu->commands_queue.push(tuneLsb);
  for (size_t cycle = 0; cycle < 1024; cycle++) {
    mcu->generate_next_sample();
  }
  mcu->commands_queue.push(0x31);
  mcu->commands_queue.push(0x30);

  mcuLock.exit();
}

//==============================================================================
void RdPiano_juceAudioProcessor::prepareToPlay(double sampleRate,
                                               int samplesPerBlock) {
  double ratio = sampleRate / 32000;
  emu_sample_buffer_size = ceil(samplesPerBlock * ratio);
  emu_sample_bufferL = new float[emu_sample_buffer_size];
  emu_sample_bufferR = new float[emu_sample_buffer_size];
  emu_resampled_sample_bufferL = new float[samplesPerBlock];
  emu_resampled_sample_bufferR = new float[samplesPerBlock];

  mcuReset();

  spaceD->reset();
  phaser->reset();

  juce::dsp::ProcessSpec spec;
  spec.sampleRate = sampleRate;
  spec.maximumBlockSize = samplesPerBlock;
  spec.numChannels = getTotalNumOutputChannels();

  midEQ.prepare(spec);
}

void RdPiano_juceAudioProcessor::releaseResources() {
  if (emu_sample_bufferL) {
    delete[] emu_sample_bufferL;
    emu_sample_bufferL = 0;
  }
  if (emu_sample_bufferR) {
    delete[] emu_sample_bufferR;
    emu_sample_bufferR = 0;
  }
  if (emu_resampled_sample_bufferL) {
    delete[] emu_resampled_sample_bufferL;
    emu_resampled_sample_bufferL = 0;
  }
  if (emu_resampled_sample_bufferR) {
    delete[] emu_resampled_sample_bufferR;
    emu_resampled_sample_bufferR = 0;
  }
}

bool RdPiano_juceAudioProcessor::isBusesLayoutSupported(
    const BusesLayout &layouts) const {
  if (layouts.getMainOutputChannelSet() != juce::AudioChannelSet::stereo())
    return false;

  return true;
}

void RdPiano_juceAudioProcessor::processBlock(juce::AudioBuffer<float> &buffer,
                                              juce::MidiBuffer &midiMessages) {
  juce::ScopedNoDenormals noDenormals;
  auto totalNumInputChannels = getTotalNumInputChannels();
  auto totalNumOutputChannels = getTotalNumOutputChannels();

  bool hasMidi = false;

  for (auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
    buffer.clear(i, 0, buffer.getNumSamples());

  // int sourceSampleRate = mcu->current_sample_rate ? 32000 : 20000;
  double destSampleRate = getSampleRate();

  double renderBufferFramesFloat =
      (double)buffer.getNumSamples() / destSampleRate * sourceSampleRate;
  unsigned int renderBufferFrames = ceil(renderBufferFramesFloat);
  double currentError = renderBufferFrames - renderBufferFramesFloat;

  int limit = buffer.getNumSamples() / 4;
  if (samplesError > limit && renderBufferFrames > limit) {
    renderBufferFrames -= limit;
    currentError -= limit;
  } else if (-samplesError > limit) {
    renderBufferFrames += limit;
    currentError += limit;
  }

  if (renderBufferFrames < 2) {
    printf("Not enough samples to render\n");
    fflush(stdout);
    return;
  }
  if (renderBufferFrames > 20000 ||
      renderBufferFrames > emu_sample_buffer_size) {
    printf("Too many samples to render\n");
    fflush(stdout);
    return;
  }

  for (size_t i = 0; i < emu_sample_buffer_size; i++) {
    emu_sample_bufferL[i] = 0;
    emu_sample_bufferR[i] = 0;
  }
  for (size_t i = 0; i < buffer.getNumSamples(); i++) {
    emu_resampled_sample_bufferL[i] = 0;
    emu_resampled_sample_bufferR[i] = 0;
  }

  std::vector<int> processedEvents;

  bool mode32khz = sourceSampleRate == 32000;

  spaceD->rate =
      spaceDRateFromMs(1000.0f / chorusRateToMsPeriod[*chorusRate] / 4.0f);
  spaceD->depth = spaceDDepth(*chorusDepth / 15.0f);

  phaser->rate = phaserRateTable[(int)floor(*efxPhaserRate * 0x7f)];
  phaser->depth = phaserDepthTable[(int)floor(*efxPhaserDepth * 0x7f)];

  mcuLock.enter();
  for (int i = 0; i < renderBufferFrames; i++) {
    int evI = 0;
    for (const auto metadata : midiMessages) {
      auto message = metadata.getMessage();
      if (metadata.samplePosition >= i &&
          std::find(processedEvents.begin(), processedEvents.end(), evI) ==
              processedEvents.end()) {
        mcu->sendMidiCmd(message.getRawData()[0], message.getRawData()[1],
                         message.getRawData()[2]);
        processedEvents.push_back(evI);

        hasMidi = true;
      }
      evI++;
    }

    int32_t sample = mcu->generate_next_sample(mode32khz);

    spaceD->audioInL = sample << 5;
    spaceD->audioInR = sample << 5;
    if (*chorusEnabled) {
      spaceD->process();
    } else {
      spaceD->audioOutL = spaceD->audioInL;
      spaceD->audioOutR = spaceD->audioInR;
    }
    spaceD->audioOutL >>= 6;
    spaceD->audioOutR >>= 6;

    // if (*efxPhaserOnOff && *efxEnabled) {
    if (*efxEnabled) {
      phaser->audioInL = spaceD->audioOutL << 5;
      phaser->audioInR = spaceD->audioOutR << 5;
      phaser->process();
      spaceD->audioOutL = phaser->audioOutL >> 6;
      spaceD->audioOutR = phaser->audioOutR >> 6;
    }

    emu_sample_bufferL[i] = spaceD->audioOutL / 65536.0f * *volume;
    emu_sample_bufferR[i] = spaceD->audioOutR / 65536.0f * *volume;
  }
  mcuLock.exit();

  double ratio = destSampleRate / sourceSampleRate;
  if (savedDestSampleRate != destSampleRate ||
      savedSourceSampleRate != sourceSampleRate) {
    savedDestSampleRate = destSampleRate;
    savedSourceSampleRate = sourceSampleRate;
    if (resampleL)
      resample_close(resampleL);
    if (resampleR)
      resample_close(resampleR);
    resampleL = resample_open(1, ratio, ratio);
    resampleR = resample_open(1, ratio, ratio);
  }

  int inUsed = 0;
  int out = 0;
  out = resample_process(resampleL, ratio, emu_sample_bufferL,
                         renderBufferFrames, false, &inUsed,
                         emu_resampled_sample_bufferL, buffer.getNumSamples());
  resample_process(resampleR, ratio, emu_sample_bufferR, renderBufferFrames,
                   false, &inUsed, emu_resampled_sample_bufferR,
                   buffer.getNumSamples());
  samplesError += currentError;
  if (inUsed == 0) {
    samplesError = 0;
    printf("click: %d\n", out);
  }

  float *channelDataL = buffer.getWritePointer(0);
  float *channelDataR = buffer.getWritePointer(1);

  const float scaling = 0.5f;
  for (int i = 0; i < buffer.getNumSamples(); i++) {
    channelDataL[i] = emu_resampled_sample_bufferL[i] * scaling;
    channelDataR[i] = emu_resampled_sample_bufferR[i] * scaling;

    tremoloPhase = (tremoloPhase + 1) & 0xffffffff;
    if (*tremoloEnabled) {
      float tremoloL = (0.5f + 0.5f * sin(*tremoloRate * 3.14159265359 *
                                          tremoloPhase / destSampleRate));
      float tremoloR =
          (0.5f + 0.5f * sin(3.1415926535 + *tremoloRate * 3.14159265359 *
                                                tremoloPhase / destSampleRate));
      float depth = *tremoloDepth / 14.0f;
      channelDataL[i] *= (1.0f - depth) + (tremoloL * depth);
      channelDataR[i] *= (1.0f - depth) + (tremoloR * depth);
    }
  }

  // mid EQ (tuned by ear listening to the MKS-20)
  const float midFreq = 350.0f; // Hz
  const float q = 0.2f;
  const float gainDB = 8;
  const float gainLinear = juce::Decibels::decibelsToGain(gainDB);
  *midEQ.state = *juce::dsp::IIR::Coefficients<float>::makePeakFilter(
      getSampleRate(), midFreq, q, gainLinear);
  juce::dsp::AudioBlock<float> block(buffer);
  juce::dsp::ProcessContextReplacing<float> context(block);
  midEQ.process(context);

  // flush midi
  mcuLock.enter();
  int evI = 0;
  for (const auto metadata : midiMessages) {
    auto message = metadata.getMessage();
    if (std::find(processedEvents.begin(), processedEvents.end(), evI) ==
        processedEvents.end()) {
      mcu->sendMidiCmd(message.getRawData()[0], message.getRawData()[1],
                       message.getRawData()[2]);
      processedEvents.push_back(evI);

      printf("leftover midi\n");

      hasMidi = true;
    }
    evI++;
  }
  mcuLock.exit();

  if (hasMidi) {
    midiMessageCount++;
    // sendChangeMessage();
  }
}

//==============================================================================
bool RdPiano_juceAudioProcessor::hasEditor() const { return true; }

juce::AudioProcessorEditor *RdPiano_juceAudioProcessor::createEditor() {
  return new RdPiano_juceAudioProcessorEditor(*this);
}

//==============================================================================
void RdPiano_juceAudioProcessor::getStateInformation(
    juce::MemoryBlock &destData) {
  std::unique_ptr<juce::XmlElement> xml(new juce::XmlElement("RdPiano"));
  xml->setAttribute("masterTune", masterTune);
  xml->setAttribute("currentPatch", currentPatch);
  xml->setAttribute("volume", (double)*volume);
  xml->setAttribute("chorusEnabled", (bool)*chorusEnabled);
  xml->setAttribute("chorusRate", (int)*chorusRate);
  xml->setAttribute("chorusDepth", (int)*chorusDepth);
  xml->setAttribute("tremoloEnabled", (bool)*tremoloEnabled);
  xml->setAttribute("tremoloRate", (int)*tremoloRate);
  xml->setAttribute("tremoloDepth", (int)*tremoloDepth);
  xml->setAttribute("efxEnabled", (bool)*efxEnabled);
  xml->setAttribute("efxPhaserRate", (float)*efxPhaserRate);
  xml->setAttribute("efxPhaserDepth", (float)*efxPhaserDepth);
  copyXmlToBinary(*xml, destData);
}

void RdPiano_juceAudioProcessor::setStateInformation(const void *data,
                                                     int sizeInBytes) {
  std::unique_ptr<juce::XmlElement> xmlState(
      getXmlFromBinary(data, sizeInBytes));

  if (xmlState.get() != nullptr) {
    if (xmlState->hasTagName("RdPiano")) {
      masterTune = xmlState->getIntAttribute("masterTune", 0);
      currentPatch = xmlState->getIntAttribute("currentPatch", 0);
      *volume = (float)xmlState->getDoubleAttribute("volume", 1.0);
      *chorusEnabled = (bool)xmlState->getBoolAttribute("chorusEnabled", true);
      *chorusRate = (int)xmlState->getIntAttribute("chorusRate", 1);
      *chorusDepth = (int)xmlState->getIntAttribute("chorusDepth", 3);
      *tremoloEnabled =
          (bool)xmlState->getBoolAttribute("tremoloEnabled", false);
      *tremoloRate = (int)xmlState->getIntAttribute("tremoloRate", 6);
      *tremoloDepth = (int)xmlState->getIntAttribute("tremoloDepth", 6);
      *efxEnabled = (bool)xmlState->getBoolAttribute("efxEnabled", false);
      *efxPhaserRate =
          (float)xmlState->getDoubleAttribute("efxPhaserRate", 0.4);
      *efxPhaserDepth =
          (float)xmlState->getDoubleAttribute("efxPhaserDepth", 0.8);
    }
  }

  if (currentPatch < 0 || currentPatch >= getNumPrograms())
    currentPatch = 0;
  if (*volume < 0 || *volume > 1)
    *volume = 1;
  if (*chorusRate > 14)
    *chorusRate = 1;
  if (*chorusDepth > 14)
    *chorusDepth = 3;
  if (*tremoloRate > 14)
    *tremoloRate = 6;
  if (*tremoloDepth > 14)
    *tremoloDepth = 6;
  if (*efxPhaserRate > 1)
    *efxPhaserRate = 0.4;
  if (*efxPhaserDepth > 1)
    *efxPhaserDepth = 0.8;

  setMasterTune(masterTune);

  mcuLock.enter();
  mcu->loadSounds(
      patchToRomSet[currentPatch]->ic5, patchToRomSet[currentPatch]->ic6,
      patchToRomSet[currentPatch]->ic7, patchToRomSet[currentPatch]->ic18,
      patchToOffset[currentPatch]);

  mcu->commands_queue.push(0x31);
  mcu->commands_queue.push(0x30);
  mcuLock.exit();

  sourceSampleRate = sampleRates[currentPatch];
}

//==============================================================================
// This creates new instances of the plugin..
juce::AudioProcessor *JUCE_CALLTYPE createPluginFilter() {
  return new RdPiano_juceAudioProcessor();
}
