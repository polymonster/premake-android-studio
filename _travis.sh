#!/usr/bin/env bash
# java9 causes an exception with android sdk manager
brew cask uninstall java
brew tap caskroom/versions
brew cask install java8
touch ~/.android/repositories.cfg
brew cask install android-sdk
brew cask install https://raw.githubusercontent.com/commitay/homebrew-cask/03c79bb9b18850c1d042434f07c6095e9612d368/Casks/android-ndk.rb

export ANDROID_HOME="/usr/local/share/android-sdk"
export ANDROID_NDK_HOME="/usr/local/share/android-ndk"
yes | sudo sdkmanager --licenses
yes | $ANDROID_HOME/tools/bin/sdkmanager "platforms;android-25"
yes | $ANDROID_HOME/tools/bin/sdkmanager "build-tools;27.0.3"

cd example
../premake5 android-studio
cd build
yes | gradle build
