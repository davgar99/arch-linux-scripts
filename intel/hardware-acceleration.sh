#!/usr/bin/env bash

# Don't allow users to run this script as root
if ((EUID == 0)); then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

# Installs a VDPAU-to-VA-API bridge, since Intel GPUs don't ship a native VDPAU driver
echo "Installing VDPAU bridge for Intel graphics"
sudo pacman -Syu --needed libvdpau-va-gl

# Sets environment variables to explicitly select the iHD driver for VA-API and the VA-API bridge for VDPAU
if grep -q "Intel hardware acceleration environment variables" /etc/environment 2> /dev/null; then
    echo "Intel hardware acceleration environment variables are already set, skipping."
else
    echo "Setting environment variables for Intel hardware acceleration"
    cat << 'EOF' | sudo tee -a /etc/environment > /dev/null

# Intel hardware acceleration environment variables
LIBVA_DRIVER_NAME=iHD
VDPAU_DRIVER=va_gl
EOF
fi

echo "Note: LIBVA_DRIVER_NAME=iHD is for intel-media-driver (Broadwell/2014 and newer). If you're using the older libva-intel-driver instead, set it to i965."
