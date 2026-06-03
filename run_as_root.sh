#!/bin/bash

# Check if container already exists and remove it
if docker ps -a | grep -q linux_arm64; then
    echo "Removing existing container..."
    docker rm -f linux_arm64
fi

#if directory not exists, create it
if [ ! -d ~/dev_arm ]; then
    echo "Creating directory ~/dev_arm..."
    mkdir -p ~/dev_arm
fi

# Create and run the container with X11 support
echo "Creating container with X11 support..."
cd "$(dirname "$0")"
docker run \
    --platform linux/arm64 \
    --add-host=host.docker.internal:host-gateway \
    -it \
    -p 8080:8080 \
    --name linux_arm64 \
    --mount type=tmpfs,destination=/tmp \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $(realpath ~/dev_arm):/home/ubuntu/dev/ \
    -u root \
    image_linux_arm64

# Ask user if they want to commit the container changes
read -p "Do you want to commit the container changes to the image? (y/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Committing container changes to image..."
    docker commit linux_arm64 image_linux_arm64
else
    echo "Skipping commit."
fi

docker rm linux_arm64
