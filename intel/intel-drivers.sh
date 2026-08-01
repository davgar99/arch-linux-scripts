#!/usr/bin/env bash

# Don't allow users to run this script as root
if ((EUID == 0)); then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

echo "Please make sure to enable the multilib repo in your pacman.conf before running this script."
echo "If it's not enabled, please close the script and do that before running this script again."
read -n 1 -s -r -p "Press any key to continue..."
printf "\n"

# Installs Mesa, Vulkan, and VA-API packages for Intel GPUs
# This also covers Intel integrated graphics, since they use the same i915/Iris/Mesa driver stack as Intel's discrete Arc cards
echo "Installing Intel graphics drivers"
sudo pacman -Syu --needed mesa lib32-mesa vulkan-intel lib32-vulkan-intel vulkan-icd-loader lib32-vulkan-icd-loader intel-media-driver

echo "Note: intel-media-driver covers Broadwell (2014) and newer. If your Intel GPU is older than that, install libva-intel-driver instead."
