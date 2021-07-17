require "android_studio"

workspace "android_studio_example"
	configurations { "Debug", "Release" }
	gradleversion "com.android.tools.build:gradle:4.0.1"
	location ("build")

project "android_studio_example"
	kind "ConsoleApp"
	language "C++"
	targetdir "bin/%{cfg.buildcfg}"

    	androidsdkversion "26"
    	androidminsdkversion "21"

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

	configuration "Debug"
		defines { "DEBUG" }
		symbols "On"

	configuration "Release"
		defines { "NDEBUG" }
		optimize "On"
