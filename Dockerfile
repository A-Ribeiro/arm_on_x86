FROM ubuntu:24.04

# Update package list and install development tools
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        nano \
        git \
        gcc \
        g++ \
        cmake \
        make \
        htop \
        net-tools \
        iputils-ping \
        dialog \
        cmake-qt-gui \
        zenity \
        zlib1g-dev \
        libjpeg-dev \
        libpng-dev \
        git wget curl ca-certificates

RUN apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create ubuntu user with specific UID/GID (will be overridden by build args)
ARG USER_UID=1000
ARG USER_GID=1000

# Create group and user with matching UID/GID
RUN groupadd -g ${USER_GID} ubuntu || groupmod -n ubuntu $(getent group ${USER_GID} | cut -d: -f1) || true && \
    useradd -m -u ${USER_UID} -g ${USER_GID} -s /bin/bash ubuntu || usermod -u ${USER_UID} -g ${USER_GID} ubuntu

# Set password for ubuntu user (password: ubuntu)
RUN echo 'ubuntu:ubuntu' | chpasswd

# Set working directory
WORKDIR /home/ubuntu

# Switch to ubuntu user for better file permissions
USER ubuntu

# Set default command - use login shell to ensure .bashrc is sourced
CMD ["/bin/bash", "-l", "-i"]
