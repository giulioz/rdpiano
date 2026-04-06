// license:BSD-3-Clause
// copyright-holders:Nicola Salmoria, Aaron Giles

#ifndef MAME_UTILS_H
#define MAME_UTILS_H

#include <type_traits>
#include <cstdint>

#define LSB_FIRST

template <typename T, typename U> constexpr T make_bitmask(U n)
{
	return T((n < (8 * sizeof(T)) ? (std::make_unsigned_t<T>(1) << n) : std::make_unsigned_t<T>(0)) - 1);
}
template <typename T, typename U> constexpr T BIT(T x, U n) noexcept { return (x >> n) & T(1); }
template <typename T, typename U, typename V> constexpr T BIT(T x, U n, V w)
{
	return (x >> n) & make_bitmask<T>(w);
}
template <typename T, typename U, typename... V> constexpr T bitswap(T val, U b, V... c) noexcept
{
	if constexpr (sizeof...(c) > 0U)
		return (BIT(val, b) << sizeof...(c)) | bitswap(val, c...);
	else
		return BIT(val, b);
}
template <unsigned B, typename T, typename... U> constexpr T bitswap(T val, U... b) noexcept
{
	static_assert(sizeof...(b) == B, "wrong number of bits");
	static_assert((sizeof(std::remove_reference_t<T>) * 8) >= B, "return type too small for result");
	return bitswap(val, b...);
}

using s8 = std::int8_t;
using u8 = std::uint8_t;
using s16 = std::int16_t;
using u16 = std::uint16_t;
using s32 = std::int32_t;
using u32 = std::uint32_t;
using s64 = std::int64_t;
using u64 = std::uint64_t;

// PAIR is an endian-safe union useful for representing 32-bit CPU registers
union PAIR
{
#ifdef LSB_FIRST
	struct { u8 l,h,h2,h3; } b;
	struct { u16 l,h; } w;
	struct { s8 l,h,h2,h3; } sb;
	struct { s16 l,h; } sw;
#else
	struct { u8 h3,h2,h,l; } b;
	struct { s8 h3,h2,h,l; } sb;
	struct { u16 h,l; } w;
	struct { s16 h,l; } sw;
#endif
	u32 d;
	s32 sd;
};

enum line_state
{
	CLEAR_LINE = 0,             // clear (a fired or held) line
	ASSERT_LINE,                // assert an interrupt immediately
	HOLD_LINE                   // hold interrupt line until acknowledged
};

// I/O line definitions
enum
{
	// input lines
	MAX_INPUT_LINES = 64+3,
	INPUT_LINE_IRQ0 = 0,
	INPUT_LINE_IRQ1 = 1,
	INPUT_LINE_IRQ2 = 2,
	INPUT_LINE_IRQ3 = 3,
	INPUT_LINE_IRQ4 = 4,
	INPUT_LINE_IRQ5 = 5,
	INPUT_LINE_IRQ6 = 6,
	INPUT_LINE_IRQ7 = 7,
	INPUT_LINE_IRQ8 = 8,
	INPUT_LINE_IRQ9 = 9,
	INPUT_LINE_NMI = MAX_INPUT_LINES - 3,

	// special input lines that are implemented in the core
	INPUT_LINE_RESET = MAX_INPUT_LINES - 2,
	INPUT_LINE_HALT = MAX_INPUT_LINES - 1
};

#endif
