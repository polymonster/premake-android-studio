#!/usr/bin/env bash
cd example
../premake5 android-studio
cd build
gradle build