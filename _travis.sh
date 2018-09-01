#!/usr/bin/env bash
export ANDROID_HOME="/usr/local/share/android-sdk"
export ANDROID_NDK_HOME="/usr/local/share/android-ndk"
cd example
../premake5 android-studio
cd build
gradle build