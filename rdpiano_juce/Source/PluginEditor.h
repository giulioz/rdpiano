/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#pragma once

#include "PluginProcessor.h"
#include "lcd/Lcd.h"
#include <JuceHeader.h>

//==============================================================================
/**
 */
class RdPiano_juceAudioProcessorEditor : public juce::AudioProcessorEditor,
                                         public juce::Button::Listener,
                                         public juce::Slider::Listener,
                                         public juce::ChangeListener {
public:
  RdPiano_juceAudioProcessorEditor(RdPiano_juceAudioProcessor &);
  ~RdPiano_juceAudioProcessorEditor() override;

  //==============================================================================
  void resized() override;
  void paint(juce::Graphics &g) override;
  void visibilityChanged() override;

  void buttonClicked(juce::Button *) override;
  void sliderValueChanged(juce::Slider *) override;
  void changeListenerCallback(juce::ChangeBroadcaster *) override;

  void updateValues();

private:
  RdPiano_juceAudioProcessor &audioProcessor;

  class MksButton : public juce::Button {
  public:
    int x, y, w, h;
    float scaleFactor;
    bool enabled = false;
    MksButton() : juce::Button("") {}
    void position(int x, int y, int w, int h, float scaleFactor) {
      this->x = x;
      this->y = y;
      this->w = w;
      this->h = h;
      this->scaleFactor = scaleFactor;
    }
    void paintButton(juce::Graphics &g, bool isMouseOverButton,
                     bool isButtonDown) override {
      auto topLeft = getBoundsInParent().getTopLeft();
      float downShift = isButtonDown ? 8 / scaleFactor : 0;
      g.drawImage(
          juce::ImageCache::getFromMemory(BinaryData::interactable_png,
                                          BinaryData::interactable_pngSize),
          x / scaleFactor - topLeft.x + downShift,
          y / scaleFactor - topLeft.y - downShift, w / scaleFactor,
          h / scaleFactor, x, y, w, h);

      if (enabled) {
        g.setColour(juce::Colours::red);
        g.fillRect(49 / scaleFactor + downShift, 36 / scaleFactor - downShift,
                   79 / scaleFactor, 28 / scaleFactor);
      }
    }
  };

  Lcd lcd;
  MksButton buttonMks20;
  MksButton buttonMk80;
  MksButton button1;
  MksButton button2;
  MksButton button3;
  MksButton button4;
  MksButton button5;
  MksButton button6;
  MksButton button7;
  MksButton button8;
  MksButton buttonTune;

  bool tuneMode = false;

  unsigned long lastMidiMessageCount = 0;

  class MidiMessageTimer : public juce::Timer {
  public:
    RdPiano_juceAudioProcessorEditor &parent;
    MidiMessageTimer(RdPiano_juceAudioProcessorEditor &parent)
        : parent(parent){};

    void timerCallback() override { parent.repaint(); };
    void restart() { startTimer(100); }
  };
  MidiMessageTimer midiMessageTimer;

  juce::Slider alphaDial;

  class KnobLF : public juce::LookAndFeel_V3 {
  public:
    KnobLF() {}
    ~KnobLF() {}

    void drawRotarySlider(juce::Graphics &g, int x, int y, int width,
                          int height, float sliderPos,
                          const float rotaryStartAngle,
                          const float rotaryEndAngle, juce::Slider &slider) {
      auto scale = (770.55 / width);
      auto centerX = x + width * 0.5f;
      auto centerY = y + height * 0.5f;
      auto radius = juce::jmin(width * 0.5f, height * 0.5f) -
                    (244.0f / scale) / 2 - 30.0f / scale;
      auto angle = rotaryStartAngle +
                   sliderPos * (rotaryEndAngle - rotaryStartAngle) + 3.14 / 2 + 3.14;
      auto px = centerX + cos(angle) * radius;
      auto py = centerY + sin(angle) * radius;

      g.drawImage(juce::ImageCache::getFromMemory(
                      BinaryData::alphadial_png, BinaryData::alphadial_pngSize),
                  px - 244 / scale / 2, py - 244 / scale / 2, 244 / scale,
                  244 / scale, 0, 0, 244, 244);
    }

  private:
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(KnobLF)
  };
  KnobLF knobLF;

  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(RdPiano_juceAudioProcessorEditor)
};
