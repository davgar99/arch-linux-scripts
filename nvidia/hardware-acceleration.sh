#!/usr/bin/env bash
set -euo pipefail

# Don't allow users to run this script as root
if ((EUID == 0)); then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

# Install packages for NVIDIA hardware acceleration
echo "Installing NVIDIA VA-API driver"
sudo pacman -Syu --needed libva-nvidia-driver

# Sets environment variables for NVIDIA hardware acceleration for VA-API, VDPAU, and CUDA
# Essentially improves video playback and hardware acceleration for NVIDIA GPUs
if grep -q "NVIDIA hardware acceleration environment variables" /etc/environment 2> /dev/null; then
    echo "NVIDIA hardware acceleration environment variables are already set, skipping."
else
    echo "Setting environment variables for NVIDIA hardware acceleration"
    cat << 'EOF' | sudo tee -a /etc/environment > /dev/null

# NVIDIA hardware acceleration environment variables
MOZ_DISABLE_RDD_SANDBOX=1
LIBVA_DRIVER_NAME=nvidia
VDPAU_DRIVER=nvidia
NVD_BACKEND=direct
CUDA_DISABLE_PERF_BOOST=1
EOF
fi
