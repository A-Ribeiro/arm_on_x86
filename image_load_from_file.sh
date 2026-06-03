#!/bin/bash

# Exit immediately if any command fails
set -e
# Exit if undefined variables are used
set -u
# Catch errors in pipes
set -o pipefail

# Load the image from a tar.gz file
echo "Loading image from image_linux_arm64.tar.gz..."
cd "$(dirname "$0")"
gunzip -c image_linux_arm64.tar.gz | docker load
echo "Image loaded successfully!"
