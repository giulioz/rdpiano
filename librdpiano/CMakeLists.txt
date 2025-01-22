cmake_minimum_required(VERSION 3.10)

# project name and version
project(RdPiano VERSION 1.0)

# set c++ standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED True)

add_compile_options(-fsanitize=address)
add_link_options(-fsanitize=address)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-constant-logical-operand")

# find SDL2
find_package(SDL2 REQUIRED)

# find portmidi
find_path(PORTMIDI_INCLUDE_DIR portmidi.h)
find_library(PORTMIDI_LIBRARY portmidi)

if (NOT PORTMIDI_INCLUDE_DIR OR NOT PORTMIDI_LIBRARY)
    message(FATAL_ERROR "portmidi library not found")
endif()

# include directories for all targets
include_directories(${SDL2_INCLUDE_DIRS} ${PORTMIDI_INCLUDE_DIR} "include")

# library target
add_library(librdpiano src/mcu.cpp src/sound_chip.cpp)

# test application target
add_executable(rdpiano_standalone test/standalone.cpp)

# link libraries for test app
target_link_libraries(rdpiano_standalone ${SDL2_LIBRARIES} ${PORTMIDI_LIBRARY} librdpiano)

# include directories for specific targets
target_include_directories(librdpiano PRIVATE src)
target_include_directories(rdpiano_standalone PRIVATE test)
