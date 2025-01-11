/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>
#include "PluginProcessor.h"

//==============================================================================
/**
*/
class RdPiano_juceAudioProcessorEditor  : public juce::AudioProcessorEditor
{
public:
    RdPiano_juceAudioProcessorEditor (RdPiano_juceAudioProcessor&);
    ~RdPiano_juceAudioProcessorEditor() override;

    //==============================================================================
    void resized() override;

private:
    RdPiano_juceAudioProcessor& audioProcessor;

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR (RdPiano_juceAudioProcessorEditor)
};
