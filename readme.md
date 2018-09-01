# premake-android-studio

If you are using premake as your build system for Visual Studio, XCode or GNU Make and wanted to easily integrate Android into your development work flow, this module will abstract the confusing world of gradle, ndk, jni and Android Studio.

Usage:
```bash
premake5 android-studio
```

Android specific premake extensions:
```bash
gradleversion "com.android.tools.build:gradle:3.1.4"

androidsdkversion "28"

androidminsdkversion "25"

androiddependencies
{
  "com.android.support:appcompat-v7:+", 
  "com.android.support:support-v4:25.0.0",
  "com.android.support:design:25.0.0"
}
```

An example program is included for testing and reference purposes, it features a main activity, java function call and a jni call to native c++ code.

To run the example (osx only):
```bash
cd example
../premake5 android-studio
```

Open the folder example/build with Android Studio then sync gradle, build and run from android studio. Output from run should contain:
```bash
D/Hello world!: I'm Java
I/CPP: oh hai!, I'm c++
```

To run the example on Linux or Windows add your premake5 executable to this directory and follow the above steps.



