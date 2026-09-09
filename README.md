# RecapMod - Kobo Plugin

A Kobo plugin that adds a "Recap" tab to the table of contents for bookmarking functionality, built with NickelHook framework.

## Features
- Adds a "Recap" tab to Kobo's table of contents
- Bookmark management
- Integration with NickelHook framework
- Qt5 based UI components

## Building

This plugin requires the NickelTC cross-compilation toolchain. The build process:
1. Uses Docker container with ARM cross-compilation support  
2. Requires Qt5 headers for compilation
3. Produces a KoboRoot.tgz package for installation

## Installation
1. Copy the contents of KoboRoot.tgz to your Kobo device
2. Restart your Kobo eReader
3. Find "Recap" in the table of contents

## Development

The plugin is built using:
- NickelTC Docker container (ghcr.io/pgaskin/nickeltc:1.0)
- Qt5 cross-compilation headers
- NickelHook framework

## Structure
```
.
├── Makefile             # Build instructions  
├── NickelHook/          # NickelHook integration files
│   └── nhplugin.h
├── src/
│   └── recapmod.cc      # Main plugin source code
└── README.md
```

The actual compilation requires Qt5 headers to be installed in the Docker container. The workflow will build successfully when run through GitHub Actions.