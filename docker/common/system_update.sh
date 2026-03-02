#!/usr/bin/env bash
set -euo pipefail

# Update system and install build/runtime dependencies for native builds and GUI libs.
# Retry on transient mirror/network errors.
update_ok=0
for attempt in 1 2 3 4 5; do
  if dnf -y update; then
    update_ok=1
    break
  fi
  echo "dnf update failed (attempt ${attempt}/5). Retrying in 10s..."
  sleep 10
done
if [ "${update_ok}" -ne 1 ]; then
  echo "dnf update failed after 5 attempts."
  exit 1
fi

group_ok=0
for attempt in 1 2 3 4 5; do
  if dnf -y groupinstall "Development Tools"; then
    group_ok=1
    break
  fi
  echo "dnf groupinstall failed (attempt ${attempt}/5). Retrying in 10s..."
  sleep 10
done
if [ "${group_ok}" -ne 1 ]; then
  echo "dnf groupinstall failed after 5 attempts."
  exit 1
fi

install_ok=0
for attempt in 1 2 3 4 5; do
  # Install build/runtime dependencies for native builds and GUI libs.
  if dnf -y --allowerasing install \
    cmake \
    make \
    gcc \
    gcc-c++ \
    pkgconfig \
    git \
    wget \
    curl \
    dnf-plugins-core \
    sudo \
    openssh-server \
    iproute \
    procps-ng \
    psmisc \
    python3 \
    python3-devel \
    python3-pip \
    openssl-devel \
    bzip2-devel \
    libffi-devel \
    zlib-devel \
    xz-devel \
    sqlite-devel \
    readline-devel \
    tk-devel \
    qt5-qtbase-devel \
    qt5-qtdeclarative-devel \
    qt5-qtsvg-devel \
    mesa-libGL-devel \
    mesa-libGLU-devel \
    libX11-devel \
    libXext-devel \
    libXrender-devel \
    libXi-devel \
    libXfixes-devel \
    libXcursor-devel \
    libXrandr-devel
  then
    install_ok=1
    break
  fi
  echo "dnf install failed (attempt ${attempt}/5). Retrying in 10s..."
  sleep 10
done
if [ "${install_ok}" -ne 1 ]; then
  echo "dnf install failed after 5 attempts."
  exit 1
fi

dnf clean all
rm -rf /var/cache/dnf
