/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin processor.

  ==============================================================================
*/

#pragma once

#include "../../librdpiano/include/mcu.h"
#include "resample/libresample.h"
#include <JuceHeader.h>

//==============================================================================
/**
 */
class RdPiano_juceAudioProcessor : public juce::AudioProcessor,
                                   public juce::ChangeBroadcaster {
public:
  //==============================================================================
  RdPiano_juceAudioProcessor();
  ~RdPiano_juceAudioProcessor() override;

  //==============================================================================
  void prepareToPlay(double sampleRate, int samplesPerBlock) override;
  void releaseResources() override;

  bool isBusesLayoutSupported(const BusesLayout &layouts) const override;

  void processBlock(juce::AudioBuffer<float> &, juce::MidiBuffer &) override;

  //==============================================================================
  juce::AudioProcessorEditor *createEditor() override;
  bool hasEditor() const override;

  //==============================================================================
  const juce::String getName() const override;

  bool acceptsMidi() const override;
  bool producesMidi() const override;
  bool isMidiEffect() const override;
  double getTailLengthSeconds() const override;

  //==============================================================================
  int getNumPrograms() override;
  int getCurrentProgram() override;
  void setCurrentProgram(int index) override;
  const juce::String getProgramName(int index) override;
  void changeProgramName(int index, const juce::String &newName) override;

  //==============================================================================
  void getStateInformation(juce::MemoryBlock &destData) override;
  void setStateInformation(const void *data, int sizeInBytes) override;

  //==============================================================================

  struct DataToSave {
    int16_t masterTune = 0;
    uint8_t currentPatch = 0;
    float volume = 1.0;
    bool chorusEnabled = true;
    uint8_t chorusRate = 1;
    uint8_t chorusDepth = 3;
    bool tremoloEnabled = false;
    uint8_t tremoloRate = 6;
    uint8_t tremoloDepth = 6;
  };

  DataToSave status;
  Mcu *mcu;

  void *resample = 0;
  int savedDestSampleRate = 0;
  int sourceSampleRate = 0;
  int savedSourceSampleRate = 0;
  double samplesError = 0;

  float *dry_sample_buffer;
  float *dry_resampled_sample_buffer;
  size_t dry_sample_buffer_size = 0;

  unsigned long chorusPhase = 0;
  juce::dsp::DelayLine<float, juce::dsp::DelayLineInterpolationTypes::Linear>
      delayL;
  juce::dsp::DelayLine<float, juce::dsp::DelayLineInterpolationTypes::Linear>
      delayR;

  unsigned long midiMessageCount = 0;

  void setMasterTune(int16_t tune);

  juce::SpinLock mcuLock;

private:
  //==============================================================================
  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(RdPiano_juceAudioProcessor)
};
