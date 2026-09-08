# RecapMod

A Kobo plugin that adds a "Recap" tab to the table of contents for bookmarking functionality.

## Features

- Adds a new "Recap" tab to your Kobo's main menu
- Allows bookmarking of text content
- Persists bookmarks to file storage
- Uses the NickelHook framework for seamless integration

## Installation

1. Build the package using `make koboroot`
2. Transfer the generated `KoboRoot.tgz` to your Kobo device
3. Install via the Kobo's plugin manager or manually copy to `/mnt/onboard/.kobo/plugins/`

## Building

To build this plugin, you need to use the NickelTC Docker environment for proper cross-compilation:

```bash
# Build using Docker (recommended)
make koboroot

# Or manually with Docker
docker run --rm \
  -v $(pwd):/workspace \
  -w /workspace \
  ghcr.io/pgaskin/nickeltc:1.0 \
  make clean && make koboroot
```

## Requirements

- Kobo device running firmware compatible with NickelHook
- Docker installed for building (optional but recommended)

## License

MIT
