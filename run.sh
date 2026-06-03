#!/bin/bash

# Check if container already exists and remove it
if docker ps -a | grep -q linux_arm64; then
    echo "Removing existing container..."
    docker rm -f linux_arm64
fi

# Create and run the container with X11 support
echo "Creating container with X11 support..."
cd "$(dirname "$0")"
docker run \
    --platform linux/arm64 \
    --add-host=host.docker.internal:host-gateway \
    -it \
    --rm \
    -p 8080:8080 \
    --name linux_arm64 \
    --mount type=tmpfs,destination=/tmp \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v $(realpath ~/dev_arm):/home/ubuntu/dev/ \
    --entrypoint "" \
    -u ubuntu \
    image_linux_arm64 /bin/bash -l
