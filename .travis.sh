#!/usr/bin/env bash
echo $ANDROID_HOME
cd $ANDROID_HOME
yes | sudo sdkmanager "ndk-bundle"

