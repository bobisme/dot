#!/bin/bash
# Test install script using podman (simple one-liner approach)

set -e

echo "Testing in a fresh Arch container..."
podman run --rm -it -v ./install.sh:/install.sh:ro archlinux:latest bash -c "
  echo '=== Installing dependencies ==='
  pacman -Sy --noconfirm curl sudo
  echo '=== Creating test user ==='
  useradd -m testuser
  echo 'testuser ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
  echo '=== Running install script as testuser ==='
  su - testuser -c 'sh /install.sh'
"

