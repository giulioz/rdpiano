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
Lcd::Lcd() { memcpy(LCD_Data, "                                  ", 17 * 2); }

Lcd::~Lcd() {}

void Lcd::setText(const juce::String &text) {
  memcpy(LCD_Data, text.begin(), 17 * 2);
  // repaint();
}

void Lcd::setScale(float scale) { this->scale = scale; }

void Lcd::paint(juce::Graphics &g) {
  g.setColour(juce::Colours::transparentWhite);
  g.fillAll();

  float sfC = 0.445 / (scale / 5);

  for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 17; j++) {
      uint8_t ch = LCD_Data[i * 17 + j];
      LCD_FontRenderStandard(i * (50 * sfC), j * (34 * sfC), ch, g);
    }
  }
}

uint32_t lcd_col1 = 0xFF233336;
uint32_t lcd_col2 = 0xFF73A5A9;

void Lcd::LCD_FontRenderStandard(int32_t x, int32_t y, uint8_t ch,
                                 juce::Graphics &g) {
  if (ch < 16)
    return;

  float sfC = 0.445 / (scale / 5);

  uint8_t *f = &lcd_font[ch - 16][0];
  for (int i = 0; i < 7; i++) {
    for (int j = 0; j < 5; j++) {
      if (f[i] & (1 << (4 - j))) {
        g.setColour(juce::Colour(lcd_col1));
      } else {
        g.setColour(juce::Colour(lcd_col2));
      }
      float xx = x + i * (6 * sfC);
      float yy = y + j * (6 * sfC);
      g.fillRect(yy, xx, (5 * sfC), (5 * sfC));
    }
  }
}
