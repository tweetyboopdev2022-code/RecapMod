#include <stdio.h>

// Simple plugin that just logs when loaded
extern "C" void nh_init() {
    printf("RecapMod plugin initialized successfully\n");
}

extern "C" void nh_fini() {
    printf("RecapMod plugin cleaned up\n");
}
