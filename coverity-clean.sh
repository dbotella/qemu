#!/bin/bash
set -e

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

MAKE="${MAKE:-make}"

# Clean build directory if it exists
if [ -d build ]; then
  $MAKE -C build clean || true
fi

