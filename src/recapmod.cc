#include <stdio.h>

// Simple plugin that just works with basic C/C++
extern "C" void nh_init() {
    printf("RecapMod plugin loaded successfully\n");
}

extern "C" void nh_fini() {
    printf("RecapMod plugin unloaded\n");
}
