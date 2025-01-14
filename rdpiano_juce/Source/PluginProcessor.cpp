/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin processor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"

const char *rd200PatchNames[] = {"MKS-20: Piano 1",   "MKS-20: Piano 2",
                                 "MKS-20: Piano 3",   "MKS-20: Harpsichord",
                                 "MKS-20: Clavi",     "MKS-20: Vibraphone",
                                 "MKS-20: E-Piano 1", "MKS-20: E-Piano 2"};

const char *mk80PatchNames[] = {"MK-80: Classic",    "MK-80: Special",
                                "MK-80: Blend",      "MK-80: Contemporary",
                                "MK-80: A. Piano 1", "MK-80: A. Piano 2",
                                "MK-80: Clavi",      "MK-80: Vibraphone"};

const int sampleRates[] = {
    // RD200
    20000, 20000, 20000, 32000, 32000, 20000, 20000, 32000,
    // MK80
    20000, 20000, 20000, 32000, 20000, 20000, 32000, 20000};

//==============================================================================
RdPiano_juceAudioProcessor::RdPiano_juceAudioProcessor()
    : AudioProcessor(
          BusesProperties()
              .withInput("Input", juce::AudioChannelSet::stereo(), true)
              .withOutput("Output", juce::AudioChannelSet::stereo(), true)) {
  mcu = new Mcu((const uint8_t *)BinaryData::RD200_IC5_bin,
                (const uint8_t *)BinaryData::RD200_IC6_bin,
                (const uint8_t *)BinaryData::RD200_IC7_bin,
                (const uint8_t *)BinaryData::RD200_B_bin,
                (const uint8_t *)BinaryData::RD200_IC18_bin);
  mcu->commands_queue.push(0x30);
  for (size_t cycle = 0; cycle < 100; cycle++) {
    mcu->generate_next_sample();
  }
}

RdPiano_juceAudioProcessor::~RdPiano_juceAudioProcessor() {
  memset(mcu, 0, sizeof(Mcu));
  delete mcu;
}

//==============================================================================
const juce::String RdPiano_juceAudioProcessor::getName() const {
  return JucePlugin_Name;
}

bool RdPiano_juceAudioProcessor::acceptsMidi() const { return true; }

bool RdPiano_juceAudioProcessor::producesMidi() const { return false; }

bool RdPiano_juceAudioProcessor::isMidiEffect() const { return false; }

double RdPiano_juceAudioProcessor::getTailLengthSeconds() const { return 0.0; }

int RdPiano_juceAudioProcessor::getNumPrograms() { return 8 + 8; }

int RdPiano_juceAudioProcessor::getCurrentProgram() {
  return status.currentPatch;
}

void RdPiano_juceAudioProcessor::setCurrentProgram(int index) {
  if (index < 0 || index >= getNumPrograms())
    return;

  mcuLock.enter();
  if (index / 8 != status.currentPatch / 8) {
    mcu->loadSounds(index / 8 == 0 ? (const uint8_t *)BinaryData::RD200_IC5_bin
                                   : (const uint8_t *)BinaryData::MK80_IC5_bin,
                    index / 8 == 0 ? (const uint8_t *)BinaryData::RD200_IC6_bin
                                   : (const uint8_t *)BinaryData::MK80_IC6_bin,
                    index / 8 == 0 ? (const uint8_t *)BinaryData::RD200_IC7_bin
                                   : (const uint8_t *)BinaryData::MK80_IC7_bin,
                    index / 8 == 0
                        ? (const uint8_t *)BinaryData::RD200_IC18_bin
                        : (const uint8_t *)BinaryData::MK80_IC18_bin);
  }

  status.currentPatch = index;
  mcu->commands_queue.push(0x30 | (status.currentPatch & 0xF));
  mcuLock.exit();
  sourceSampleRate = sampleRates[status.currentPatch];

  sendChangeMessage();
}

const juce::String RdPiano_juceAudioProcessor::getProgramName(int index) {
  return juce::String(index >= 8 ? mk80PatchNames[index - 8]
                                 : rd200PatchNames[index]);
}

void RdPiano_juceAudioProcessor::changeProgramName(
    int index, const juce::String &newName) {}

void RdPiano_juceAudioProcessor::setMasterTune(int16_t tune) {
  status.masterTune = tune;

  mcuLock.enter();

  u8 tuneMsb = status.masterTune < 0 ? 0x7f : 0x00;
  u8 tuneLsb =
      (int8_t)(floor(abs(status.masterTune) / 32767.0 * 16.0) * 4) & 0xff;
  if (tuneLsb > 0x3c)
    tuneLsb = 0x3c;
  if (status.masterTune < 0)
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
  mcu->commands_queue.push(0x30 | (status.currentPatch & 0xF));

  mcuLock.exit();

  sendChangeMessage();
}

//==============================================================================
void RdPiano_juceAudioProcessor::prepareToPlay(double sampleRate,
                                               int samplesPerBlock) {
  // Use this method as the place to do any pre-playback
  // initialisation that you need..
}

void RdPiano_juceAudioProcessor::releaseResources() {
  // When playback stops, you can use this as an opportunity to free up any
  // spare memory, etc.
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
  float *channelDataL = buffer.getWritePointer(0);
  float *channelDataR = buffer.getWritePointer(1);

  double renderBufferFramesFloat =
      (double)buffer.getNumSamples() / destSampleRate * sourceSampleRate;
  unsigned int renderBufferFrames = ceil(renderBufferFramesFloat);
  double currentError = renderBufferFrames - renderBufferFramesFloat;

  int limit = buffer.getNumSamples() / 4;
  if (samplesError > limit && renderBufferFrames > limit) {
    // printf("compensating neg %d\n", limit);
    renderBufferFrames -= limit;
    currentError -= limit;
  } else if (-samplesError > limit) {
    // printf("compensating pos %d\n", limit);
    renderBufferFrames += limit;
    currentError += limit;
  }

  if (audio_buffer_size < renderBufferFrames) {
    printf("Audio buffer size is too small. (%d requested)\n",
           renderBufferFrames);
    fflush(stdout);
    return;
  }

  for (size_t i = 0; i < audio_buffer_size; i++) {
    sample_buffer_l[i] = 0;
    sample_buffer_r[i] = 0;
  }

  std::vector<int> processedEvents;

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

    int16_t sample = mcu->generate_next_sample();
    sample_buffer_l[i] = sample / 65536.0f * status.volume;
    sample_buffer_r[i] = sample / 65536.0f * status.volume;
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

  int inUsedL = 0;
  int inUsedR = 0;
  int outL = 0;
  int outR = 0;

  outL =
      resample_process(resampleL, ratio, sample_buffer_l, renderBufferFrames,
                       false, &inUsedL, channelDataL, buffer.getNumSamples());
  outR =
      resample_process(resampleR, ratio, sample_buffer_r, renderBufferFrames,
                       false, &inUsedR, channelDataR, buffer.getNumSamples());

  samplesError += currentError;
  // printf("error: %f total: %f\n", currentError, samplesError);

  if (inUsedL == 0 || inUsedR == 0) {
    samplesError = 0;
    printf("click: %d %d\n", outL, outR);
  }

  if (hasMidi) {
    midiMessageCount++;
    sendChangeMessage();
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
  destData.ensureSize(sizeof(DataToSave));
  destData.replaceAll(&status, sizeof(DataToSave));
}

void RdPiano_juceAudioProcessor::setStateInformation(const void *data,
                                                     int sizeInBytes) {
  memcpy(&status, data, sizeof(DataToSave));

  setMasterTune(status.masterTune);

  mcuLock.enter();
  mcu->loadSounds(
      status.currentPatch / 8 == 0 ? (const uint8_t *)BinaryData::RD200_IC5_bin
                                   : (const uint8_t *)BinaryData::MK80_IC5_bin,
      status.currentPatch / 8 == 0 ? (const uint8_t *)BinaryData::RD200_IC6_bin
                                   : (const uint8_t *)BinaryData::MK80_IC6_bin,
      status.currentPatch / 8 == 0 ? (const uint8_t *)BinaryData::RD200_IC7_bin
                                   : (const uint8_t *)BinaryData::MK80_IC7_bin,
      status.currentPatch / 8 == 0
          ? (const uint8_t *)BinaryData::RD200_IC18_bin
          : (const uint8_t *)BinaryData::MK80_IC18_bin);

  mcu->commands_queue.push(0x30 | (status.currentPatch & 0xF));
  mcuLock.exit();
  
  sourceSampleRate = sampleRates[status.currentPatch];
}

//==============================================================================
// This creates new instances of the plugin..
juce::AudioProcessor *JUCE_CALLTYPE createPluginFilter() {
  return new RdPiano_juceAudioProcessor();
}
