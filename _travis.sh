#!/usr/bin/env bash
export ANDROID_HOME="/usr/local/share/android-sdk"
export ANDROID_NDK_HOME="/usr/local/share/android-ndk"
yes | sudo sdkmanager --licenses
yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-25"
yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;27.0.3"
cd example
../premake5 android-studio
cd build
yes | gradle build