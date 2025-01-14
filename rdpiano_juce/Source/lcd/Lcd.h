/*
  ==============================================================================

    Lcd.h
    Created: 14 Jan 2025 2:26:42am
    Author:  Giulio Zausa

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>

//==============================================================================
/*
 */
class Lcd : public juce::Component {
public:
  Lcd();
  ~Lcd() override;

  void paint(juce::Graphics &) override;

  void setText(const juce::String &text);

  void setScale(float scale);

private:
  JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(Lcd)

  void LCD_FontRenderStandard(int32_t x, int32_t y, uint8_t ch,
                              juce::Graphics &g);

  uint8_t LCD_Data[80];
  float scale = 1;
};
