# Use latest Ubuntu image
FROM ubuntu:latest

# Set environment variables for non-interactive installs
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    git \
    build-essential \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-dev \
    websockify \
    xvfb \
    x11-xserver-utils \
    xterm \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Hashcat
RUN git clone https://github.com/hashcat/hashcat.git /opt/hashcat && \
    cd /opt/hashcat && \
    git submodule update --init && \
    make && \
    make install

# Install noVNC and Websockify
RUN git clone https://github.com/novnc/noVNC.git /opt/noVNC && \
    git clone https://github.com/novnc/websockify.git /opt/websockify

# Set up the working directory
WORKDIR /opt/hashcat

# Expose the port for noVNC (default 6080)
EXPOSE 6080

# Command to start Xvfb and run Hashcat GUI with noVNC
CMD ["sh", "-c", "Xvfb :1 -screen 0 1024x768x16 & DISPLAY=:1 hashcat -g"]
