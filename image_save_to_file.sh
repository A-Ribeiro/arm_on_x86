#!/bin/bash

# Exit immediately if any command fails
set -e
# Exit if undefined variables are used
set -u
# Catch errors in pipes
set -o pipefail

# Save the image as a tar.gz file
echo "Saving image to image_linux_arm64.tar.gz..."
cd "$(dirname "$0")"
docker save image_linux_arm64 | gzip > image_linux_arm64.tar.gz
echo "Image saved successfully!"
