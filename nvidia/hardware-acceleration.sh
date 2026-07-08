#!/usr/bin/env bash

# Don't allow users to run this script as root
if ((EUID == 0)); then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

# Install packages for Nvidia hardware acceleration
sudo pacman -S --needed libva-nvidia-driver

# Sets environment variables for Nvidia hardware acceleration for VA-API, VDPAU, and CUDA
# Essentially improves video playback and hardware acceleration for Nvidia GPUs
echo "Setting environment variables for Nvidia hardware acceleration"
cat << 'EOF' | sudo tee -a /etc/environment > /dev/null

# Nvidia hardware acceleration environment variables
MOZ_DISABLE_RDD_SANDBOX=1
LIBVA_DRIVER_NAME=nvidia
VDPAU_DRIVER=nvidia
NVD_BACKEND=direct
CUDA_DISABLE_PERF_BOOST=1
EOF
