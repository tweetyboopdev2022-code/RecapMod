# Simple build system for Kobo plugin
CXX := arm-linux-gnueabihf-g++
CXXFLAGS := -I. -fPIC -Wall -Wextra -std=c++11

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
