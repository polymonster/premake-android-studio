# premake-android-studio

If you are using premake as your build system for Windows, macOS, iOS and Linux and wanted to easily integrate Android into your development work flow, this module will abstract the confusing world of gradle, Android Studio and ndk.

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
