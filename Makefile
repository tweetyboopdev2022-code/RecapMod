# RecapMod Makefile
# Uses NickelHook framework for Kobo mod development

include ./NickelHook/NickelHook.mk

# Mod configuration
override NAME           := RecapMod
override LIBRARY        := librecapmod.so
override SOURCES        += src/recapmod.cc
override CFLAGS         += -Wall -Wextra -Werror
override PKGCONF        += Qt5Widgets
override MOCS           += src/recapmod.h
override CXXFLAGS       += -Wall -Wextra -Werror -Wno-missing-field-initializers

# Include NickelHook.mk again to complete the build configuration
include ./NickelHook/NickelHook.mk

# Additional build targets
.PHONY: clean distclean

distclean: clean
	rm -f KoboRoot.tgz
