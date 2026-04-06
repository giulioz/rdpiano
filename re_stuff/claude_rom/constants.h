/*
 * constants.h - Shared constants for the RD200 sound engine
 */

#pragma once

static constexpr int NUM_VOICES = 128;
static constexpr int PARTS_PER_VOICE = 10;
static constexpr int PARTS_PER_VOICE_MEM = 16;   // sound chip memory slots per voice
static constexpr int NUM_PROGRAMS = 8;
static constexpr int NUM_ENV_SCALE_TABLES = 16;
static constexpr int NUM_ENV_SCALE_ENTRIES = 64;
