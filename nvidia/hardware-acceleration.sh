#!/usr/bin/env bash

if ((EUID == 0)); then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

sudo pacman -S --needed libva-nvidia-driver

echo "Setting environment variables for Nvidia hardware acceleration"
cat << 'EOF' | sudo tee -a /etc/environment > /dev/null

# Nvidia hardware acceleration environment variables
MOZ_DISABLE_RDD_SANDBOX=1
LIBVA_DRIVER_NAME=nvidia
VDPAU_DRIVER=nvidia
NVD_BACKEND=direct
CUDA_DISABLE_PERF_BOOST=1
EOF