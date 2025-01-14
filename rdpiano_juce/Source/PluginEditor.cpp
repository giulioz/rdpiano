/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#include "PluginEditor.h"
#include "PluginProcessor.h"

static int bgWidth = 6140;
static int bgHeight = 1503;
static float scaleFactor = 5;
static int uiWidth = bgWidth / scaleFactor;
static int uiHeight = bgHeight / scaleFactor;

//==============================================================================
RdPiano_juceAudioProcessorEditor::RdPiano_juceAudioProcessorEditor(
    RdPiano_juceAudioProcessor &p)
    : AudioProcessorEditor(&p), audioProcessor(p), midiMessageTimer(*this) {
  addAndMakeVisible(lcd);

  addAndMakeVisible(buttonMks20);
  addAndMakeVisible(buttonMk80);
  addAndMakeVisible(button1);
  addAndMakeVisible(button2);
  addAndMakeVisible(button3);
  addAndMakeVisible(button4);
  addAndMakeVisible(button5);
  addAndMakeVisible(button6);
  addAndMakeVisible(button7);
  addAndMakeVisible(button8);
  addAndMakeVisible(buttonTune);
  buttonMks20.addListener(this);
  buttonMk80.addListener(this);
  button1.addListener(this);
  button2.addListener(this);
  button3.addListener(this);
  button4.addListener(this);
  button5.addListener(this);
  button6.addListener(this);
  button7.addListener(this);
  button8.addListener(this);
  buttonTune.addListener(this);

  addAndMakeVisible(alphaDial);
  alphaDial.setLookAndFeel(&knobLF);
  alphaDial.setSliderStyle(juce::Slider::Rotary);
  alphaDial.setTextBoxStyle(juce::Slider::NoTextBox, true, 0, 0);
  alphaDial.setRange(-1, 1);
  // alphaDial.setRotaryParameters(juce::MathConstants<float>::pi * 1.3f,
  //                               juce::MathConstants<float>::pi * 2.7f, true);
  alphaDial.addListener(this);

  setResizeLimits(uiWidth, uiHeight, uiWidth, uiHeight);
  setSize(uiWidth, uiHeight);

  updateValues();
  p.addChangeListener(this);
}

RdPiano_juceAudioProcessorEditor::~RdPiano_juceAudioProcessorEditor() {
  alphaDial.setLookAndFeel(nullptr);
}

void RdPiano_juceAudioProcessorEditor::resized() {
  float sfC = (float)bgWidth / getBounds().getWidth();

  lcd.setBounds((1984 + 60) / sfC, (272 + 50) / sfC, (1394 - 60 * 2) / sfC,
                (309 - 40 * 2) / sfC);

  buttonMks20.setBounds(2602 / sfC, 806 / sfC, 248 / sfC, 248 / sfC);
  buttonMk80.setBounds(2602 / sfC, 1068 / sfC, 248 / sfC, 248 / sfC);
  button1.setBounds(1504 / sfC, 806 / sfC, 250 / sfC, 248 / sfC);
  button2.setBounds(1764 / sfC, 806 / sfC, 248 / sfC, 248 / sfC);
  button3.setBounds(2024 / sfC, 806 / sfC, 248 / sfC, 248 / sfC);
  button4.setBounds(2284 / sfC, 806 / sfC, 248 / sfC, 248 / sfC);
  button5.setBounds(1504 / sfC, 1068 / sfC, 250 / sfC, 248 / sfC);
  button6.setBounds(1764 / sfC, 1068 / sfC, 248 / sfC, 248 / sfC);
  button7.setBounds(2024 / sfC, 1068 / sfC, 248 / sfC, 248 / sfC);
  button8.setBounds(2284 / sfC, 1068 / sfC, 248 / sfC, 248 / sfC);
  buttonTune.setBounds(669 / sfC, 295 / sfC, 273 / sfC, 273 / sfC);

  buttonMks20.position(2598, 800, 257, 258, sfC);
  buttonMk80.position(2598, 1058, 257, 260, sfC);
  button1.position(1478, 800, 290, 260, sfC);
  button2.position(1759, 800, 262, 260, sfC);
  button3.position(2018, 800, 262, 260, sfC);
  button4.position(2279, 800, 262, 260, sfC);
  button5.position(1478, 1058, 290, 260, sfC);
  button6.position(1759, 1058, 262, 260, sfC);
  button7.position(2018, 1058, 262, 260, sfC);
  button8.position(2279, 1058, 262, 260, sfC);
  buttonTune.position(669, 295, 273, 273, sfC);

  alphaDial.setBounds(
      (204.564) * (6140 / 311.92) / sfC, (24.061) * (6140 / 311.92) / sfC,
      (39.145) * (6140 / 311.92) / sfC, (39.145) * (6140 / 311.92) / sfC);
}

void RdPiano_juceAudioProcessorEditor::paint(juce::Graphics &g) {
  float sfC = (float)bgWidth / getBounds().getWidth();

  g.drawImage(juce::ImageCache::getFromMemory(BinaryData::background_png,
                                              BinaryData::background_pngSize),
              getLocalBounds().toFloat());

  // Alpha Dial
  // g.drawImage(juce::ImageCache::getFromMemory(BinaryData::interactable_png,
  //                                             BinaryData::interactable_pngSize),
  //             4000 / sfC, 455 / sfC, 824 / sfC, 807 / sfC, 4000, 455, 824,
  //             807);

  // Volume
  g.drawImage(juce::ImageCache::getFromMemory(BinaryData::interactable_png,
                                              BinaryData::interactable_pngSize),
              1185 / sfC, 1175 / sfC, 107 / sfC, 142 / sfC, 1185, 1175, 107,
              142);

  if (audioProcessor.midiMessageCount != lastMidiMessageCount) {
    g.setColour(juce::Colours::greenyellow);
    g.fillRect(5197 / sfC, 517 / sfC, 85 / sfC, 38 / sfC);
    lastMidiMessageCount = audioProcessor.midiMessageCount;
    midiMessageTimer.restart();
  }
}

void RdPiano_juceAudioProcessorEditor::buttonClicked(juce::Button *button) {
  bool prevTuneMode = tuneMode;
  tuneMode = false;
  if (button == &buttonMks20) {
    audioProcessor.setCurrentProgram(0);
  } else if (button == &buttonMk80) {
    audioProcessor.setCurrentProgram(8);
  } else if (button == &button1) {
    audioProcessor.setCurrentProgram(
        0 + (audioProcessor.status.currentPatch >= 8 ? 8 : 0));
  } else if (button == &button2) {
    audioProcessor.setCurrentProgram(
        1 + (audioProcessor.status.currentPatch >= 8 ? 8 : 0));
  } else if (button == &button3) {
    audioProcessor.setCurrentProgram(
        2 + (audioProcessor.status.currentPatch >= 8 ? 8 : 0));
  } else if (button == &button4) {
    audioProcessor.setCurrentProgram(
        3 + (audioProcessor.status.currentPatch >= 8 ? 8 : 0));
  } else if (button == &button5) {
    audioProcessor.setCurrentProgram(
        4 + (audioProcessor.status.currentPatch >= 8 ? 8 : 0));
  } else if (button == &button6) {
    audioProcessor.setCurrentProgram(
        5 + (audioProcessor.status.currentPatch >= 8 ? 8 : 0));
  } else if (button == &button7) {
    audioProcessor.setCurrentProgram(
        6 + (audioProcessor.status.currentPatch >= 8 ? 8 : 0));
  } else if (button == &button8) {
    audioProcessor.setCurrentProgram(
        7 + (audioProcessor.status.currentPatch >= 8 ? 8 : 0));
  } else if (button == &buttonTune) {
    tuneMode = !prevTuneMode;
    updateValues();
  }
}

void RdPiano_juceAudioProcessorEditor::sliderValueChanged(
    juce::Slider *slider) {
  if (slider == &alphaDial) {
    if (tuneMode) {
      audioProcessor.setMasterTune(alphaDial.getValue() * 32767.0);
    } else {
      audioProcessor.setCurrentProgram((alphaDial.getValue() + 1) * 8);
    }
  }
}

void RdPiano_juceAudioProcessorEditor::visibilityChanged() { updateValues(); }

void RdPiano_juceAudioProcessorEditor::changeListenerCallback(
    juce::ChangeBroadcaster *) {
  updateValues();
}

const char *displayPatchNames[] = {
    "MKS-20           Piano 1          ", "MKS-20           Piano 2          ",
    "MKS-20           Piano 3          ", "MKS-20           Harpsichord      ",
    "MKS-20           Clavi            ", "MKS-20           Vibraphone       ",
    "MKS-20           E-Piano 1        ", "MKS-20           E-Piano 2        ",
    "MK-80            Classic          ", "MK-80            Special          ",
    "MK-80            Blend            ", "MK-80            Contemporary     ",
    "MK-80            A. Piano 1       ", "MK-80            A. Piano 2       ",
    "MK-80            Clavi            ", "MK-80            Vibraphone       "};

void RdPiano_juceAudioProcessorEditor::updateValues() {
  buttonMks20.enabled = !tuneMode && audioProcessor.status.currentPatch < 8;
  buttonMk80.enabled = !tuneMode && audioProcessor.status.currentPatch >= 8;
  buttonMks20.enabled = !tuneMode && audioProcessor.status.currentPatch < 8;
  buttonMk80.enabled = !tuneMode && audioProcessor.status.currentPatch >= 8;

  button1.enabled = !tuneMode && audioProcessor.status.currentPatch % 8 == 0;
  button2.enabled = !tuneMode && audioProcessor.status.currentPatch % 8 == 1;
  button3.enabled = !tuneMode && audioProcessor.status.currentPatch % 8 == 2;
  button4.enabled = !tuneMode && audioProcessor.status.currentPatch % 8 == 3;
  button5.enabled = !tuneMode && audioProcessor.status.currentPatch % 8 == 4;
  button6.enabled = !tuneMode && audioProcessor.status.currentPatch % 8 == 5;
  button7.enabled = !tuneMode && audioProcessor.status.currentPatch % 8 == 6;
  button8.enabled = !tuneMode && audioProcessor.status.currentPatch % 8 == 7;

  buttonTune.enabled = tuneMode;

  if (tuneMode) {
    juce::String tuningString =
        "TUNING           " +
        juce::String(440.0 + audioProcessor.status.masterTune / 32767.0 * 12.0,
                     1) +
        "Hz          ";
    lcd.setText(tuningString);
    alphaDial.setValue(audioProcessor.status.masterTune / 32767.0,
                       juce::dontSendNotification);
  } else {
    lcd.setText(displayPatchNames[audioProcessor.status.currentPatch]);
    alphaDial.setValue(audioProcessor.status.currentPatch / 16.0 * 2.0 - 1,
                       juce::dontSendNotification);
  }

  this->repaint();
}
