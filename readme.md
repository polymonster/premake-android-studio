# premake-android-studio 
[![Build Status](https://github.com/polymonster/premake-android-studio/workflows/ci/badge.svg)](https://github.com/polymonster/premake-android-studio/actions)

If you are using premake as your build configuration system for Visual Studio, XCode or GNU Make and wanted to easily integrate Android into your development work flow, this module will abstract the convoluted world of gradle, sdk and ndk.

To find out how to use premake modules you can check the reference [here](https://github.com/premake/premake-core/wiki/Using-Modules), You can find the premake-core repository [here](https://github.com/premake/premake-core) and the latest premake executables [here](https://premake.github.io/download.html). 

In addition to generating Android Studio friendly build.gradle files you can also build from the command line using gradle build.

*****

## Usage
```bash
premake5 android-studio
```

*****

## Android specific premake extensions
```lua
androidabis { "armeabi", "armeabi-v7a", "arm64-v8a", "x86", "x86_64" }

-- sdk / gradle version
gradleversion "com.android.tools.build:gradle:3.1.4"
androidsdkversion "28"
androidminsdkversion "25"
androidndkversion "26.2.11394342"
androidndkpath "file_path_to_ndk_directory_is_optional"
androidappid "com.company.application"

-- extra build settings to apply to each config (config scope)
androidbuildsettings
{
    "firebaseCrashlytics { nativeSymbolUploadEnabled true }"
}

-- plugins to apply (project scope)
androidplugins
{
    "com.google.gms.google-services"
}

-- gradle properties (workspace scope)
gradleproperties
{
    "org.gradle.jvmargs=-Xmx4608m",
    "org.gradle.parallel=true"
}

-- gradle wrapper (workspace scope)
-- generates the file build/android/gradle/wrapper/gradle-wrapper.properties
gradlewrapper 
{
    "distributionUrl=https://services.gradle.org/distributions/gradle-7.1-bin.zip"
}

-- repositories (workspace scope)
--
-- if left empty then default google() and jcenter() repositories will be supplied
-- otherwise, only the repository entries listed will be supplied
androidrepositories
{
    "jcenter()",
    "maven { url 'http://maven.gameanalytics.com/release' }"
}

-- asset packs (workspace scope)
assetpacks
{
    ["asset_pack_name"] = "install-time" -- supported values are "fast-follow", "on-demand", "install-time"
    ["another_pack_name"] = "on-demand"
}

-- files, dependencies, directories (project scope)
--
-- starting an entry with 'implementation' keyword will result in the entry string being copied over raw
-- if 'implementation' is not specified at the start then it will be implicitly added as well as the quotes
-- the raw string method can be used to add more complex dependencies, e.g. fileTree(), files(), etc. 
androiddependencies
{
    "implementation platform('com.google.firebase:firebase-bom:29.0.0')",
    "com.android.support:appcompat-v7:+",
    "com.android.support:support-v4:25.0.0",
    "com.android.support:design:25.0.0"
}

-- files, dependencies, diretories (workspace scope)
androiddependenciesworkspace
{
    "com.google.gms:google-services:4.3.10"
}

-- cross project dependencies 
androidprojectdependencies 
{ 
    "SubModuleA", 
    "SubModuleB" 
}

-- asset pack dependencies (project scope)
assetpackdependencies
{
    "asset_pack_name",
    "another_pack_name"
}

archivedirs
{
    "path/to/jar/",
    "path/to/aar/"
}

assetdirs
{
    "path/to/assets" -- these will go into android asset manager and inside .pkg
}

-- signing
androidkeystorefile "keystore.jks"
androidstorepassword "K3yStorePa55w0rd"
androidkeyalias "Product Key"
androidkeypassword "Pr0ductK3yPa$$word"

-- version info
androidversioncode "1"
androidversionname "1.0"

-- Relative path to export the APK
apkoutputpath "./../../../../../builds"

-- Relative path to export the AAR
aaroutputpath "./../../../../libs"

-- run configuration module name
-- the name of the module that will be run when running/debugging in Android Studio
-- should be provided along with "runconfigoptions" to ensure run configuration targets correct module
runconfigmodule "module"

-- run configuration options
-- key value pairs for the run configuration options, will be written to xml in <build>/.idea/runConfigurations
-- { 'DEPLOY_APK_FROM_BUNDLE, 'true' } when using "assetpacks" ensures app is launched in the correct asset bundle mode
runconfigoptions 
{
    { 'DEPLOY', 'true' },
    { 'DEPLOY_APK_FROM_BUNDLE', 'true' },
    { 'DEPLOY_AS_INSTANT', 'false' }
}

-- Custom CMake arguments injection
androidcmake
{
    '# setup: treat warnings as errors',
    'set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")'
}

-- Android automation test instrumentation runner support 
androidtestrunner "androidx.test.runner.AndroidJUnitRunner"

```

*****

## Custom build commands

premake [custom build commands](https://premake.github.io/docs/Custom-Build-Commands/) are partially supported through the gradle [exec](https://docs.gradle.org/current/dsl/org.gradle.api.tasks.Exec.html) task. Currently you can only apply `prebuildcommand` and `postbuildcommands`. Gradle exec is a bit strange so you need to separate all arguments by commas and wrap them in quotes. 

Here is a small example using `cp` to copy a file using a string with double quotes `"` and wrapping the args in single quotes `'` with args separated by commas `,`. You can supply multiple post build commands which will be executed in order.

```lua
postbuildcommands {
    "'cp', 'a.txt', 'b.txt'",
    "'echo', 'hello world!'"
}
```

## Android specific premake considerations

You can use CMake variables injected specifically for android from within the premake script to make life easier to handle multiple abis and so forth.

```lua
libdirs
{
    "path/to/libs/${ANDROID_ABI}/"
}
```

Find a full list of CMake Android variables [here](https://gist.github.com/nddrylliog/4774829)

To link and .aar (Android Archive) or .jar (Java Archive) simply add them to links along with their extension:

```lua
links
{
    "android_archive.aar",
    "java_archive.jar"
}
```

To add a directory to search for .aar or .jar files add these to archivedirs:

```lua
archivedirs
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

Resource files such as images and layouts must all be included from a sub directory named "res":

```lua
files
{
    "src/res/**.*"
}
```

AndroidManifest.xml is required for all projects, if one does not exist a simple stub will be auto generated, if an AndroidManifest.xml is specified inside premake files then this one will be used instead:

```lua
files
{
    "src/manifest/AndroidManifest.xml"
}
```

Google-services.json is required for Google Firebase features, if google-services.json is specified inside premake files, then this one will be COPIED into the root of a project so the google services plugin can preprocess it:

```lua
files
{
    "src/google-services.json"
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

## Automation support 
Android's UIAutomation2 framework requires the project to setup the `testInstrumentationRunner` and to add the required dependencies.
The module will automatically inject the `androidTest.java.srcDirs` to discover your tests.

This is an example of how to enable UIAutomation support for your project (addapt to your needs):

```lua
androidtestrunner "androidx.test.runner.AndroidJUnitRunner"

 androiddependencies 
{
    "junit:junit:4.12",
    "androidx.test:runner:1.4.0",
    "androidx.test:rules:1.4.0",
    "androidx.test.uiautomator:uiautomator:2.2.0",
}
```

## Asset Packs
If you want to use asset packs to publish to google play store and avoid the 150mb limit, you can simply use the 'assetpacks' key-value list to register asset packs. This will create a folder and the required metadata. Asset packs must be declared at workspace scope and included in a project via the `assetpackdependencies` string list at project scope. The asset pack directory will be created inside the top level gradle directory (workspace.location) from there it is up to you to copy your assets into the correct subdirectory
`asset_pack_directory/src/main/assets`

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

C/C++
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

An example program is included for testing and reference purposes, it features a main activity, a java entry point and a jni call to native c++ code.

The premake5 executable provided in this repository is for linux, if you want to build for another platform change this exectuable.

To run the example:
```bash
cd example
../premake5 android-studio
```

Open the folder example/build with Android Studio then sync gradle, build and run. Android Studio will manage any gradle, sdk or ndk dependencies for you. 

Output from run should contain:
```bash
D/Hello world!: I'm Java
I/CPP: oh hai!, I'm c++
```

You can alternatively build from the commandline with the following, provided you have installed the Android sdk, ndk and gradle:
```bash
cd example/build
gradle build
```

To run the example on Linux or Windows add your premake5 executable to this directory and follow the above steps.



