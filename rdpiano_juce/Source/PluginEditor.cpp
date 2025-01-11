/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
RdPiano_juceAudioProcessorEditor::RdPiano_juceAudioProcessorEditor (RdPiano_juceAudioProcessor& p)
    : AudioProcessorEditor (&p), audioProcessor (p)
{
}

RdPiano_juceAudioProcessorEditor::~RdPiano_juceAudioProcessorEditor()
{
}

void RdPiano_juceAudioProcessorEditor::resized()
{
}
