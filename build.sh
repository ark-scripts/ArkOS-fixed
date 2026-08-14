#!/bin/bash
# Builds ArkOS.iso from this project.
# Must be run as root on a real (or VM) Debian/Ubuntu machine with
# live-build installed and internet access to the Ubuntu archives.
set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "Please run this with sudo: sudo ./build.sh"
  exit 1
fi

if ! command -v lb >/dev/null 2>&1; then
  echo "Installing live-build..."
  apt-get update
  apt-get install -y live-build
fi

echo "Cleaning any previous build..."
lb clean --purge || true

echo "Configuring..."
lb config

echo "Building ArkOS.iso (this downloads ~1-2GB and can take 20-60+ minutes)..."
lb build

if [ -f live-image-amd64.hybrid.iso ]; then
  mv live-image-amd64.hybrid.iso ArkOS.iso
  echo ""
  echo "Done! ArkOS.iso is ready in this folder."
  echo "Boot it in VirtualBox/VMware/QEMU as you would any Linux ISO."
else
  echo "Build finished but the .iso wasn't found under the expected name."
  echo "Check the ls output below for the actual file live-build produced:"
  ls -la *.iso 2>/dev/null || true
fi
