#!/usr/bin/env bash
# The harness runs on this Mac; Docker, NickelTC and the cross toolchain live on
# Nobara. This pushes the sources there, builds in the container, and pulls the
# artifacts back. Edit files locally as normal — just build with this.
#
# Usage: ./build.sh            build librecapmod.so
#        ./build.sh koboroot   build and package KoboRoot.tgz
#        ./build.sh clean
set -euo pipefail
cd "$(dirname "$0")"
REMOTE="${RECAP_BUILD_HOST:-tweety@100.84.179.90}"
RPATH="recapmod_build"

rsync -az ./src ./Makefile ./NickelHook "$REMOTE:$RPATH/"
ssh "$REMOTE" "cd $RPATH && ./build.sh $*"
for a in librecapmod.so KoboRoot.tgz; do
  rsync -az "$REMOTE:$RPATH/$a" ./ 2>/dev/null || true
done
echo "--- local artifacts:"
ls -la librecapmod.so KoboRoot.tgz 2>/dev/null || echo "(none)"
