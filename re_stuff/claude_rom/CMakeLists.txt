cmake_minimum_required(VERSION 3.14)
project(rd200_synth_compare CXX)

set(CMAKE_CXX_STANDARD 17)

# Paths
set(LIBRDPIANO_DIR ${CMAKE_CURRENT_SOURCE_DIR}/../../librdpiano)

# Sound chip library (shared between both implementations)
add_library(sound_chip STATIC
    ${LIBRDPIANO_DIR}/src/sound_chip.cpp
)
target_include_directories(sound_chip PUBLIC ${LIBRDPIANO_DIR}/include)

# Native firmware library
add_library(synth_firmware STATIC
    synth_firmware.cpp
)
target_include_directories(synth_firmware PUBLIC
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${LIBRDPIANO_DIR}/include
)
target_link_libraries(synth_firmware PUBLIC sound_chip)

# MCU emulator library (existing implementation)
add_library(mcu_emu STATIC
    ${LIBRDPIANO_DIR}/src/mcu.cpp
)
target_include_directories(mcu_emu PUBLIC ${LIBRDPIANO_DIR}/include)
target_link_libraries(mcu_emu PUBLIC sound_chip)

# Comparison harness
add_executable(compare_harness compare_harness.cpp)
target_link_libraries(compare_harness PRIVATE synth_firmware mcu_emu sound_chip)
target_include_directories(compare_harness PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${LIBRDPIANO_DIR}/include
)

# WAV export
add_executable(export_wav export_wav.cpp)
target_link_libraries(export_wav PRIVATE synth_firmware mcu_emu sound_chip)
target_include_directories(export_wav PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${LIBRDPIANO_DIR}/include
)

# Standalone native player
find_package(SDL2 QUIET)
if(NOT SDL2_FOUND)
    # Try homebrew path
    find_library(SDL2_LIB SDL2 PATHS /opt/homebrew/lib)
    find_path(SDL2_INCLUDE SDL.h PATHS /opt/homebrew/include/SDL2)
    if(SDL2_LIB AND SDL2_INCLUDE)
        set(SDL2_FOUND TRUE)
    endif()
endif()

find_library(PORTMIDI_LIB portmidi PATHS /opt/homebrew/lib /usr/local/lib)
find_path(PORTMIDI_INCLUDE portmidi.h PATHS /opt/homebrew/include /usr/local/include)

if(SDL2_FOUND)
    add_executable(standalone_native standalone_native.cpp)
    target_link_libraries(standalone_native PRIVATE synth_firmware sound_chip)
    target_include_directories(standalone_native PRIVATE
        ${CMAKE_CURRENT_SOURCE_DIR}
        ${LIBRDPIANO_DIR}/include
    )

    if(TARGET SDL2::SDL2)
        target_link_libraries(standalone_native PRIVATE SDL2::SDL2)
    else()
        target_link_libraries(standalone_native PRIVATE ${SDL2_LIB})
        target_include_directories(standalone_native PRIVATE ${SDL2_INCLUDE})
    endif()

    if(PORTMIDI_LIB)
        target_link_libraries(standalone_native PRIVATE ${PORTMIDI_LIB})
        target_include_directories(standalone_native PRIVATE ${PORTMIDI_INCLUDE})
        message(STATUS "Building standalone_native (SDL2 + PortMidi)")
    else()
        target_compile_definitions(standalone_native PRIVATE NO_PORTMIDI=1)
        message(STATUS "Building standalone_native (SDL2 only, no MIDI input)")
    endif()
else()
    message(STATUS "Skipping standalone_native (SDL2 not found)")
endif()
