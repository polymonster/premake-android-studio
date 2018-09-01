# premake-android-studio [![Build Status](https://travis-ci.org/polymonster/premake-android-studio.svg?branch=master)](https://travis-ci.org/polymonster/premake-android-studio)

If you are using premake as your build configuration system for Visual Studio, XCode or GNU Make and wanted to easily integrate Android into your development work flow, this module will abstract the confusing world of gradle, ndk, jni and Android Studio.

To find out how to use premake modules you can check the reference [here](https://github.com/premake/premake-core/wiki/Using-Modules), You can find the premake-core repository [here](https://github.com/premake/premake-core) and the latest premake executables [here](https://premake.github.io/download.html). 

*This is still work in progress so may not contain all features of premake implemented in gradle or cmake.*

*****

## Usage
```bash
premake5 android-studio
```

*****

## Android specific premake extensions
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

## Android specific premake considerations

To link and .aar (Android Archive) or .jar (Java Archive) simply add them to links along with their extension:

```lua
links
{
  "android_archive.aar",
  "java_archive.jar"
}
```

The same goes for library search paths for .aar or .jar files, simply add them to premake libdirs:

```lua
libdirs
{
  "path/to/aar_libs"
}
```

When adding .java files for the android project please note that only directories and not single files can be added to the project, by adding a directory it's entire subtree is also added (ie. "dir/\*\*.\*), this means if a directory contains non java files they will still be added to the java source set. The simplest way to avoid adding files to the wrong category is to put all java files inside their own directory:

```lua
files
{
  "src/java/**.java"
}
```

Resource files such as images and layouts must all be included from a sub directory named res:

```lua
files
{
  "src/res/**.*"
}
```

AndroidManifest.xml is required for all projects, if one does not exist a simple stub will be auto generated, if an AndroidManifest.xml is specicied inside premake files then this one will be used instead:

```lua
files
{
  "src/manifest/AndroidManifest.xml"
}
```

The module will dected files types based on extensions and add them into the appropriate categories:

```txt
Native (.c, .h, .cpp, .hpp)
Java (.java)
Resource (.xml, .png)
Manifest (AndoridManifest.xml)

Native files are added to cmake lists.
Java, Resource and Manifest files are added to the gradle project.
```

*****

## JNI

To call c++ from a Java file you must use jni (java native interface). This process requires importing a c or c++ lib from java, defining a function call and implementing the c or c++ function with the correct function name for java to find the exported function.

Java:
```java
package com.as.example;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

public class main_activity extends Activity
{
	public static native int hello_cpp(); // declare c or c++ function (synonymous with c's extern)

	static 
	{
		System.loadLibrary("android_studio_example"); // load c or c++ lib
	}

	@Override
	protected void onCreate(Bundle arg0) 
	{
		Log.d("Hello world!", "I'm Java");

		hello_cpp(); // call c or c++ function 

		super.onCreate(arg0);
	}
}
```

c/c++
```c
extern "C"
JNIEXPORT void JNICALL Java_com_as_example_main_1activity_hello_1cpp(void* args)
{
    __android_log_write(ANDROID_LOG_INFO, "CPP", "oh hai!, I'm c++");
}
```

Naming convention for exported functions available to java is as follows:  

Java_ <package_name_separated_by_underscores> function_name

If an underscore is used in the function name this is replaced with "_1"

so for package com.as.example function hello_cpp becomes Java_com_as_example_main_1activity_hello_1cpp

*****

## Example

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



