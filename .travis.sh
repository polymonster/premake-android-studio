#!/usr/bin/env bash
brew cask install android-sdk
yes | sudo sdkmanager --add-modules java.xml.bind --licenses

