#!/usr/bin/env bash

# Don't allow users to run this script as root
if ((EUID == 0)); then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

# Install packages for Nvidia hardware acceleration
echo "Installing Nvidia VA-API driver"
sudo pacman -Syu --needed libva-nvidia-driver

# Sets environment variables for Nvidia hardware acceleration for VA-API, VDPAU, and CUDA
# Essentially improves video playback and hardware acceleration for Nvidia GPUs
if grep -q "Nvidia hardware acceleration environment variables" /etc/environment 2> /dev/null; then
    echo "Nvidia hardware acceleration environment variables are already set, skipping."
else
    echo "Setting environment variables for Nvidia hardware acceleration"
    cat << 'EOF' | sudo tee -a /etc/environment > /dev/null

# Nvidia hardware acceleration environment variables
MOZ_DISABLE_RDD_SANDBOX=1
LIBVA_DRIVER_NAME=nvidia
VDPAU_DRIVER=nvidia
NVD_BACKEND=direct
CUDA_DISABLE_PERF_BOOST=1
EOF
fi
