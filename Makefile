CXX := arm-linux-gnueabihf-g++
PKG_CONFIG := arm-linux-gnueabihf-pkg-config

# Retrieve Qt5 include directories via pkg-config
QT_CFLAGS := $(shell $(PKG_CONFIG) --cflags Qt5Widgets 2>/dev/null || \
    echo "-I/usr/include/arm-linux-gnueabihf/qt5 -I/usr/include/arm-linux-gnueabihf/qt5/QtWidgets")

CXXFLAGS := -I. -INickelHook $(QT_CFLAGS) -fPIC -Wall -Wextra -std=c++11

librecapmod.so: src/recapmod.cc
	$(CXX) $(CXXFLAGS) -shared -o $@ $<

build: librecapmod.so

clean:
	rm -rf KoboRoot* librecapmod.so

koboroot: build
	rm -rf KoboRoot
	mkdir -p KoboRoot/usr/lib
	cp librecapmod.so KoboRoot/usr/lib/
	tar -czf KoboRoot.tgz KoboRoot
