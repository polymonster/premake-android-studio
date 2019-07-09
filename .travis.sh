#!/usr/bin/env bash
brew cask install android-sdk
export JAVA_OPTS='-XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee'
yes | sudo sdkmanager --licenses

