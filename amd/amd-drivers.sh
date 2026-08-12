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

# Installs Mesa, Vulkan, and VA-API packages for AMD GPUs
# This also covers AMD integrated/APU graphics, since they use the same amdgpu/Mesa driver stack as discrete Radeon cards
echo "Installing AMD graphics drivers"
sudo pacman -Syu --needed mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-icd-loader lib32-vulkan-icd-loader libva-mesa-driver lib32-libva-mesa-driver

# CachyOS recommends increasing AMD's shader cache size to 12GB for gaming.
echo "Configuring AMD shader cache"
mkdir -p "$HOME/.config/environment.d"
gaming_config="$HOME/.config/environment.d/gaming.conf"
touch "$gaming_config"

if grep -q '^MESA_SHADER_CACHE_MAX_SIZE=' "$gaming_config"; then
    sed -i 's/^MESA_SHADER_CACHE_MAX_SIZE=.*/MESA_SHADER_CACHE_MAX_SIZE=12G/' "$gaming_config"
else
    cat << 'EOF' >> "$gaming_config"

# Increase AMD's shader cache size to 12GB
MESA_SHADER_CACHE_MAX_SIZE=12G
EOF
fi
