#!/bin/bash

git clone -b 8.0.1 --depth 1 https://github.com/juce-framework/JUCE JUCE
bash -ex ./build/download-projucer.sh
