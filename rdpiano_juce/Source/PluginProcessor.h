/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin processor.

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>
#include "mcu.h"
#include "resample/libresample.h"

//==============================================================================
/**
*/
class RdPiano_juceAudioProcessor  : public juce::AudioProcessor
{
public:
    //==============================================================================
    RdPiano_juceAudioProcessor();
    ~RdPiano_juceAudioProcessor() override;

    //==============================================================================
    void prepareToPlay (double sampleRate, int samplesPerBlock) override;
    void releaseResources() override;

    bool isBusesLayoutSupported (const BusesLayout& layouts) const override;

    void processBlock (juce::AudioBuffer<float>&, juce::MidiBuffer&) override;

    //==============================================================================
    juce::AudioProcessorEditor* createEditor() override;
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
    void setCurrentProgram (int index) override;
    const juce::String getProgramName (int index) override;
    void changeProgramName (int index, const juce::String& newName) override;

    //==============================================================================
    void getStateInformation (juce::MemoryBlock& destData) override;
    void setStateInformation (const void* data, int sizeInBytes) override;

    //==============================================================================

    struct DataToSave
    {
        int8_t masterTune = 0;
        uint8_t currentPatch = 0;
    };

    DataToSave status;
    Mcu *mcu;

    void* resampleL = 0;
    void* resampleR = 0;
    int savedDestSampleRate = 0;
    int sourceSampleRate = 0;
    int savedSourceSampleRate = 0;
    double samplesError = 0;

    static const int audio_buffer_size = 4096 * 8;
    float sample_buffer_l[audio_buffer_size] = {0};
    float sample_buffer_r[audio_buffer_size] = {0};

private:
    //==============================================================================
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (RdPiano_juceAudioProcessor)
};
