#!/usr/bin/env bash
cd example
../premake5 android-studio
cd example/build
gradle build