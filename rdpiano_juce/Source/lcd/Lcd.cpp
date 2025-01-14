/*
  ==============================================================================

    Lcd.cpp
    Created: 14 Jan 2025 2:26:42am
    Author:  Giulio Zausa

  ==============================================================================
*/

#include "Lcd.h"
#include "lcd_font.h"
#include <JuceHeader.h>

//==============================================================================
Lcd::Lcd() {
  memcpy(LCD_Data, "                                  ", 17 * 2);
}

Lcd::~Lcd() {}

void Lcd::setText(const juce::String &text) {
  memcpy(LCD_Data, text.begin(), 17 * 2);
  // repaint();
}

const float size = 0.445;

void Lcd::paint(juce::Graphics &g) {
  g.setColour(juce::Colours::transparentWhite);
  g.fillAll();

  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 17; j++) {
      uint8_t ch = LCD_Data[i * 17 + j];
      LCD_FontRenderStandard(i * (50 * size), j * (34 * size), ch, g);
    }
  }
}

void Lcd::resized() {}

uint32_t lcd_col1 = 0xFF233336;
uint32_t lcd_col2 = 0xFF73A5A9;

void Lcd::LCD_FontRenderStandard(int32_t x, int32_t y, uint8_t ch,
                                 juce::Graphics &g) {
  if (ch < 16)
    return;

  uint8_t *f = &lcd_font[ch - 16][0];
  for (int i = 0; i < 7; i++) {
    for (int j = 0; j < 5; j++) {
      if (f[i] & (1 << (4 - j))) {
        g.setColour(juce::Colour(lcd_col1));
      } else {
        g.setColour(juce::Colour(lcd_col2));
      }
      float xx = x + i * (6 * size);
      float yy = y + j * (6 * size);
      g.fillRect(yy, xx, (5 * size), (5 * size));
    }
  }
}
