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
  mcu = new Mcu((const uint8_t *)BinaryData::RD200_IC5_bin,
                (const uint8_t *)BinaryData::RD200_IC6_bin,
                (const uint8_t *)BinaryData::RD200_IC7_bin,
                (const uint8_t *)BinaryData::RD200_B_bin,
                (const uint8_t *)BinaryData::RD200_IC18_bin);

  // MCU handshake
  mcu->commands_queue.push(0x30);
  for (size_t cycle = 0; cycle < 100; cycle++) {
    mcu->generate_next_sample();
  }
  sourceSampleRate = sampleRates[0];

  // DAW parameters
  addParameter(volume =
                   new juce::AudioParameterFloat("volume", // parameterID
                                                 "Volume", // parameter name
                                                 0.0f,     // minimum value
                                                 1.0f,     // maximum value
                                                 1.0));    // default value
  addParameter(chorusEnabled = new juce::AudioParameterBool(
                   "chorusEnabled",  // parameterID
                   "Chorus Enabled", // parameter name
                   true));           // default value
  addParameter(chorusRate =
                   new juce::AudioParameterInt("chorusRate",  // parameterID
                                               "Chorus Rate", // parameter name
                                               0,             // minimum value
                                               14,            // maximum value
                                               1));           // default value
  addParameter(chorusDepth =
                   new juce::AudioParameterInt("chorusDepth",  // parameterID
                                               "Chorus Depth", // parameter name
                                               0,              // minimum value
                                               14,             // maximum value
                                               3));            // default value
  addParameter(tremoloEnabled = new juce::AudioParameterBool(
                   "tremoloEnabled",  // parameterID
                   "Tremolo Enabled", // parameter name
                   false));           // default value
  addParameter(tremoloRate =
                   new juce::AudioParameterInt("tremoloRate",  // parameterID
                                               "Tremolo Rate", // parameter name
                                               0,              // minimum value
                                               14,             // maximum value
                                               6));            // default value
  addParameter(tremoloDepth = new juce::AudioParameterInt(
                   "tremoloDepth",  // parameterID
                   "Tremolo Depth", // parameter name
                   0,               // minimum value
                   14,              // maximum value
                   6));             // default value

  volume->addListener(this);
  chorusEnabled->addListener(this);
  chorusRate->addListener(this);
  chorusDepth->addListener(this);
  tremoloEnabled->addListener(this);
  tremoloRate->addListener(this);
  tremoloDepth->addListener(this);
}

RdPiano_juceAudioProcessor::~RdPiano_juceAudioProcessor() {
  // memset(mcu, 0, sizeof(Mcu));
  delete mcu;
  mcu = 0;
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
  if (index / 8 != currentPatch / 8) {
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

  currentPatch = index;
  mcu->commands_queue.push(0x30 | (currentPatch & 0xF));
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
  mcu->commands_queue.push(0x30 | (currentPatch & 0xF));

  mcuLock.exit();

  sendChangeMessage();
}

//==============================================================================
void RdPiano_juceAudioProcessor::prepareToPlay(double sampleRate,
                                               int samplesPerBlock) {
  juce::dsp::ProcessSpec spec;
  spec.maximumBlockSize = samplesPerBlock;
  spec.sampleRate = sampleRate;
  spec.numChannels = 1;

  delayL = juce::dsp::DelayLine<float,
                                juce::dsp::DelayLineInterpolationTypes::Linear>{
      samplesPerBlock * 8};
  delayR = juce::dsp::DelayLine<float,
                                juce::dsp::DelayLineInterpolationTypes::Linear>{
      samplesPerBlock * 8};
  delayL.prepare(spec);
  delayR.prepare(spec);
  delayL.reset();
  delayR.reset();

  double ratio = sampleRate / 32000;
  dry_sample_buffer_size = ceil(samplesPerBlock * ratio);
  dry_sample_buffer = new float[dry_sample_buffer_size];
  dry_resampled_sample_buffer = new float[samplesPerBlock];
}

void RdPiano_juceAudioProcessor::releaseResources() {
  if (dry_sample_buffer) {
    delete[] dry_sample_buffer;
    dry_sample_buffer = 0;
  }
  if (dry_resampled_sample_buffer) {
    delete[] dry_resampled_sample_buffer;
    dry_resampled_sample_buffer = 0;
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
      renderBufferFrames > dry_sample_buffer_size) {
    printf("Too many samples to render\n");
    fflush(stdout);
    return;
  }

  for (size_t i = 0; i < dry_sample_buffer_size; i++) {
    dry_sample_buffer[i] = 0;
  }

  std::vector<int> processedEvents;

  bool mode32khz = sourceSampleRate == 32000;

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

    int16_t sample = mcu->generate_next_sample(mode32khz);
    dry_sample_buffer[i] = sample / 65536.0f * *volume;
  }
  mcuLock.exit();

  double ratio = destSampleRate / sourceSampleRate;
  if (savedDestSampleRate != destSampleRate ||
      savedSourceSampleRate != sourceSampleRate) {
    savedDestSampleRate = destSampleRate;
    savedSourceSampleRate = sourceSampleRate;
    if (resample)
      resample_close(resample);
    resample = resample_open(1, ratio, ratio);
  }

  int inUsed = 0;
  int out = 0;
  out = resample_process(resample, ratio, dry_sample_buffer, renderBufferFrames,
                         false, &inUsed, dry_resampled_sample_buffer,
                         buffer.getNumSamples());
  samplesError += currentError;
  if (inUsed == 0) {
    samplesError = 0;
    printf("click: %d\n", out);
  }

  for (size_t i = 0; i < buffer.getNumSamples(); i++) {
    delayL.pushSample(0, dry_resampled_sample_buffer[i]);
    delayR.pushSample(0, dry_resampled_sample_buffer[i]);
  }

  float *channelDataL = buffer.getWritePointer(0);
  float *channelDataR = buffer.getWritePointer(1);

  // chorus
  for (int i = 0; i < buffer.getNumSamples(); i++) {
    float amplitude = *chorusDepth / 14.0f * 512.0f;
    // float amplitude = chorusRateToDepthChange[*chorusRate] / 20.0;

    float speed = 1000.0f / chorusRateToMsPeriod[*chorusRate];

    chorusPhase = (chorusPhase + 1) & 0xffffffff;
    float lfoDelay =
        fabs(fmod((chorusPhase * speed) / destSampleRate, 1) - 0.5f) * 2.0f *
        amplitude;

    delayL.setDelay(lfoDelay);
    delayR.setDelay(amplitude - lfoDelay);

    float drySample = dry_resampled_sample_buffer[i];
    float lSample = delayL.popSample(0);
    float rSample = delayR.popSample(0);

    if (*chorusEnabled) {
      channelDataL[i] = 0.6 * drySample + 0.4 * (lSample - rSample);
      channelDataR[i] = 0.6 * drySample + 0.4 * (rSample - lSample);
    } else {
      channelDataL[i] = drySample;
      channelDataR[i] = drySample;
    }

    if (*tremoloEnabled) {
      float tremoloL = (0.5f + 0.5f * sin(*tremoloRate * 3.14159265359 *
                                          chorusPhase / destSampleRate));
      float tremoloR =
          (0.5f + 0.5f * sin(3.1415926535 + *tremoloRate * 3.14159265359 *
                                                chorusPhase / destSampleRate));
      float depth = *tremoloDepth / 14.0f;
      channelDataL[i] *= (1.0f - depth) + (tremoloL * depth);
      channelDataR[i] *= (1.0f - depth) + (tremoloR * depth);
    }
  }

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

  setMasterTune(masterTune);

  mcuLock.enter();
  mcu->loadSounds(
      currentPatch / 8 == 0 ? (const uint8_t *)BinaryData::RD200_IC5_bin
                             : (const uint8_t *)BinaryData::MK80_IC5_bin,
      currentPatch / 8 == 0 ? (const uint8_t *)BinaryData::RD200_IC6_bin
                             : (const uint8_t *)BinaryData::MK80_IC6_bin,
      currentPatch / 8 == 0 ? (const uint8_t *)BinaryData::RD200_IC7_bin
                             : (const uint8_t *)BinaryData::MK80_IC7_bin,
      currentPatch / 8 == 0 ? (const uint8_t *)BinaryData::RD200_IC18_bin
                             : (const uint8_t *)BinaryData::MK80_IC18_bin);

  mcu->commands_queue.push(0x30 | (currentPatch & 0xF));
  mcuLock.exit();

  sourceSampleRate = sampleRates[currentPatch];
}

//==============================================================================
// This creates new instances of the plugin..
juce::AudioProcessor *JUCE_CALLTYPE createPluginFilter() {
  return new RdPiano_juceAudioProcessor();
}
