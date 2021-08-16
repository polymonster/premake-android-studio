require "android_studio"

workspace "android_studio_example"
	configurations { "Debug", "Release" }
	gradleversion "com.android.tools.build:gradle:4.0.1"
	location ("build")
	
	gradleproperties {
		"org.gradle.jvmargs=-Xmx4608m"
	} 

project "android_studio_example"
	kind "ConsoleApp"
	language "C++"
	targetdir "bin/%{cfg.buildcfg}"

    	androidsdkversion "29"
    	androidminsdkversion "29"

	files 
	{ 
		"cpp/**.*", 
		"java/**.*",
		"manifest/**.*"
	}
	
	links
	{
		"log" -- required for c++ logging	
	}
	
	buildoptions
	{
		"-std=c++11" -- flag mainly here to test cmake compile options
	}
	
	linkoptions
	{
		"--no-undefined" -- this flag is used just to cmake link libraries
	}
	
	includedirs
	{
		"h"
	}
	
	androidabis
	{
		"arm64-v8a"
	}

	androiddependencies
	{
		"com.android.support:appcompat-v7:26.0.2",
		"com.android.support:support-v4:26.0.2",
		"com.android.support:design:26.0.2"
	}

	configuration "Debug"
		defines { "DEBUG" }
		symbols "On"

	configuration "Release"
		defines { "NDEBUG" }
		optimize "On"
