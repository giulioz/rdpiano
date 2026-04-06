/*
 * bitswap.h - Bit manipulation utilities (from MAME, BSD-3-Clause)
 */

#pragma once

#include <cstdint>
#include <type_traits>

template <typename T, typename U> constexpr T make_bitmask(U n)
{
    return T((n < (8 * sizeof(T)) ? (std::make_unsigned_t<T>(1) << n) : std::make_unsigned_t<T>(0)) - 1);
}

template <typename T, typename U> constexpr T BIT(T x, U n) noexcept
{
    return (x >> n) & T(1);
}

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
