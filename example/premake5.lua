require "android_studio"

workspace "android_studio_example"
	configurations { "Debug", "Release" }
	gradleversion "com.android.tools.build:gradle:8.0.2"
	location ("build")
	
	assetpacks
	{
		["pack"] = "install-time",
	}

	androidnamespace "premake.andoid.studio"

	gradlewrapper {
		"distributionUrl=https://services.gradle.org/distributions/gradle-8.0.2-bin.zip"
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
		
		-- "manifest/**.*"
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
		"com.android.support:support-v4:27.1.0",
	}
	
	assetpackdependencies
	{
		"pack"
	}

	configuration "Debug"
		defines { "DEBUG" }
		symbols "On"

	configuration "Release"
		defines { "NDEBUG" }
		optimize "On"
