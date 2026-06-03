#!/bin/bash

# Exit immediately if any command fails
set -e
# Exit if undefined variables are used
set -u
# Catch errors in pipes
set -o pipefail

# Check if qemu-user-static is installed
if ! dpkg -s qemu-user-static &> /dev/null; then
    echo "ERROR: qemu-user-static is not installed"
    echo "Please install it with the following command:"
    echo "  sudo apt install -y qemu-user-static"
    exit 1
fi

# Build the ARM64 image only if it doesn't exist
if docker image inspect image_linux_arm64 &> /dev/null; then
    echo "Image image_linux_arm64 already exists, skipping build..."
    exit 0
fi

cd "$(dirname "$0")"

# Pass host user UID/GID to match permissions
docker build \
    --platform linux/arm64 \
    --build-arg USER_UID=$(id -u) \
    --build-arg USER_GID=$(id -g) \
    -t image_linux_arm64 .
