# RecapMod Makefile
NAME := recapmod
LIBRARY := librecapmod.so
SOURCES := src/recapmod.cc
INCLUDES := -I. -INickelHook

# Use Docker for cross-compilation with NickelTC
DOCKER_IMAGE := ghcr.io/pgaskin/nickeltc:1.0

# Default target
all: koboroot

# Build using the NickelTC Docker environment (proper approach)
build-in-docker:
	docker run --rm \
		-v $(PWD):/workspace \
		-w /workspace \
		$(DOCKER_IMAGE) \
		bash -c "make clean && make build"

# Build the plugin library
build:
	c++ -I. -INickelHook -fPIC -Wall -Wextra -std=c++11 -shared -o $(LIBRARY) $(SOURCES)

# Create KoboRoot.tgz package
koboroot: build
	@echo "Creating KoboRoot.tgz..."
	@mkdir -p KoboRoot/usr/lib
	@cp $(LIBRARY) KoboRoot/usr/lib/
	@tar -czf KoboRoot.tgz KoboRoot
	@echo "KoboRoot.tgz created successfully!"

# Clean build artifacts
clean:
	rm -rf KoboRoot* $(LIBRARY)

.PHONY: all build build-in-docker koboroot clean