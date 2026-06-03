# Docker Ubuntu 24.04 ARM64 Environment

This directory contains Docker configuration and scripts for running an Ubuntu 24.04 ARM64 environment on x86 host systems using QEMU emulation.

## Overview

This setup provides a complete ARM64 Ubuntu 24.04 development environment that can run on x86/x64 host machines. It's useful for:
- Cross-platform development and testing
- Building ARM64 binaries on x86 systems
- Testing applications in ARM64 architecture
- Development with GUI support through X11 forwarding

## Prerequisites

- Docker installed on your system
- `qemu-user-static` package for ARM64 emulation on x86 hosts:
  ```bash
  sudo apt install -y qemu-user-static
  ```
- A `~/dev_arm` directory on your host (or modify the mount path in the run scripts)

## Files Description

### Dockerfile

Defines the Ubuntu 24.04 ARM64 container with:
- **Base Image**: Ubuntu 24.04
- **Development Tools**: nano, git, gcc, g++, cmake, make
- **Utilities**: htop, net-tools, iputils-ping, dialog
- **GUI Support**: cmake-qt-gui, zenity
- **Libraries**: zlib1g-dev, libjpeg-dev, libpng-dev
- **User Setup**: Creates `ubuntu` user with matching UID/GID to host (default password: ubuntu)

### Scripts

#### `image_build.sh`
Builds the ARM64 Docker image with platform-specific settings.

**Features**:
- Checks for `qemu-user-static` installation
- Passes host UID/GID to match file permissions
- Skips rebuild if image already exists
- Uses platform flag `--platform linux/arm64`

**Usage**:
```bash
./image_build.sh
```

#### `run.sh`
Launches the container as the `ubuntu` user (non-root).

**Features**:
- Interactive terminal with bash login shell
- Port forwarding: 8080:8080
- X11 forwarding for GUI applications
- Volume mount: `~/dev_arm` → `/home/ubuntu/dev/`
- tmpfs mount at `/tmp`
- Auto-removes existing container with same name
- Container removed on exit (--rm flag)

**Usage**:
```bash
./run.sh
```

#### `run_as_root.sh`
Launches the container as root user.

**Features**:
- Same as `run.sh` but runs as root
- Useful for system administration tasks
- Full privileges inside the container

**Usage**:
```bash
./run_as_root.sh
```

#### `image_save_to_file.sh`
Exports the Docker image to a compressed tar.gz file.

**Features**:
- Saves image as `image_linux_arm64.tar.gz`
- Compressed format for easier distribution
- Useful for transferring to other systems

**Usage**:
```bash
./image_save_to_file.sh
```

#### `image_load_from_file.sh`
Imports the Docker image from a compressed tar.gz file.

**Features**:
- Loads from `image_linux_arm64.tar.gz`
- Useful for restoring or deploying on other systems

**Usage**:
```bash
./image_load_from_file.sh
```

## Quick Start

1. **Install prerequisites**:
   ```bash
   sudo apt install -y qemu-user-static docker.io
   ```

2. **Create development directory**:
   ```bash
   mkdir -p ~/dev_arm
   ```

3. **Build the image**:
   ```bash
   ./image_build.sh
   ```

4. **Run the container**:
   ```bash
   ./run.sh
   ```

## Container Details

- **Image Name**: `image_linux_arm64`
- **Container Name**: `linux_arm64`
- **Platform**: linux/arm64
- **Default User**: ubuntu (password: ubuntu)
- **Exposed Port**: 8080
- **Shared Directory**: `~/dev_arm` (host) → `/home/ubuntu/dev/` (container)

## X11 GUI Support

The container is configured with X11 forwarding, allowing you to run GUI applications. The following environment variables and mounts are configured:
- `DISPLAY` environment variable passed from host
- `/tmp/.X11-unix` mounted from host

To run GUI applications (e.g., `zenity`, `cmake-qt-gui`), simply execute them from within the container.

## File Permissions

The Docker image is built with build arguments to match your host user's UID and GID, ensuring that files created in the mounted volume have the correct ownership on the host system.

## Network Configuration

- The container can access the host via `host.docker.internal`
- Port 8080 is forwarded from container to host
- Standard Docker networking is available

## Troubleshooting

### QEMU not found error
If you get an error about ARM64 platform support:
```bash
sudo apt install -y qemu-user-static
```

### X11 connection issues
If GUI applications fail to connect to display:
```bash
xhost +local:docker
```

### Permission denied on mounted volume
Ensure the `~/dev_arm` directory exists and is accessible:
```bash
mkdir -p ~/dev_arm
chmod 755 ~/dev_arm
```

## Notes

- The container is removed automatically when you exit (--rm flag)
- Any existing container named `linux_arm64` is removed before creating a new one
- Files in `/tmp` are stored in memory (tmpfs) for better performance
- The working directory inside the container is `/home/ubuntu`
