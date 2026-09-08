# Simple Makefile for NickelHook integration

NAME ?= recapmod
LIBRARY ?= lib$(NAME).so
SOURCES ?= src/$(NAME).cc
INCLUDES ?= -I. -I./NickelHook

CFLAGS += $(INCLUDES) -fPIC -Wall -Wextra
CXXFLAGS += $(CFLAGS) -std=c++11

# Build targets
$(LIBRARY): $(SOURCES)
	$(CXX) $(CXXFLAGS) -shared -o $@ $^

clean:
	rm -f $(LIBRARY)

.PHONY: clean
