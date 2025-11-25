#!/bin/bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Set number of jobs
JOBS=$(expr $(nproc) + 1)
MAKE="${MAKE:-make}"

# Ensure build directory exists
mkdir -p build

# Configure if not already configured
if [ ! -f build/Makefile ]; then
  cd build
  ../configure --enable-werror --disable-docs --enable-fdt=system \
      --disable-debug-info \
      || { cat config.log meson-logs/meson-log.txt && exit 1; }
  if [ -n "$LD_JOBS" ]; then
    pyvenv/bin/meson configure . -Dbackend_max_links="$LD_JOBS" || exit 1
  fi
  cd ..
fi

# Build with distcheck
$MAKE -C build distcheck -j"$JOBS" 

