#!/usr/bin/env bash

# this script no longer works on ci because android sdk manager crashes with java9+ and java8 can no longer be installed via home brew.
# to succesfully install android sdk and ndk get android studio and it will install them for you, you can then use the commandline.

cd example
../premake5 android-studio
cd build
gradle build --stacktrace

