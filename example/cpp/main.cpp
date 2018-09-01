#include "main.h" // main.h includes jni and log to test cmake include dirs

extern "C"
JNIEXPORT void JNICALL Java_com_as_example_main_1activity_hello_1cpp(void* args)
{
    __android_log_write(ANDROID_LOG_INFO, "CPP", "oh hai!, I'm c++");
}
