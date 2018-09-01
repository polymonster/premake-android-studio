# premake-android-studio

If you are using premake as your build system for Visual Studio, XCode or GNU Make and wanted to easily integrate Android into your development work flow, this module will abstract the confusing world of gradle, ndk, jni and Android Studio.

*****

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

*****

Android specific premake considerations:

To link and .aar (Android Archive) or .jar (Java Archive) simply add them to links along with their extension:

```bash
links
{
  "android_archive.aar",
  "java_archive.jar"
}
```

When adding .java files for the android project please note that only directories can be added and not single files, so the simplest way to avoid this is to put all java files inside their own directory:

```bash
files
{
  "src/java/**.java"
}
```

Resource files such as images and layouts must all be included from a sub directory named res:

```bash
files
{
  "src/res/**.*"
}
```

AndroidManifest.xml is required for all projects, if one does not exist a simple stub will be auto generated, if an AndroidManifest.xml is specicied inside premake files then this one will be used instead:

```bash
files
{
  "src/manifest/AndroidManifest.xml"
}
```

The module will dected files types based on extensions and add them into the appropriate categories:

```bash
Native (.c, .h, .cpp, .hpp)
Java (.java)
Resource (.xml, .png)
Manifest (AndoridManifest.xml)

Native files are added to cmake lists.
Java, Resource and Manifest files are added to the gradle project.
```

*****

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

You can find the latest premake executables [here](https://premake.github.io/download.html)



