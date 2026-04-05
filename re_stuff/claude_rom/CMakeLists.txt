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
