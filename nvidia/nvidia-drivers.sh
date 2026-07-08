#!/usr/bin/env bash

echo "Please make sure to enable the multilib repo in your pacman.conf before running this script."
echo "If it's not enabled, please close the script and do that before running this script again."
read -n 1 -s -r -p "Press any key to continue..."

# Installs Nvidia, Vulkan, and OpenCL packages
linux_kernel=$(uname -r)
case "$linux_kernel" in
    *-arch*)
        echo "Installing Nvidia drivers for Arch Linux kernel"
        sudo pacman -Syu --needed nvidia-open nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader opencl-nvidia lib32-opencl-nvidia
        ;;
    *-lts*)
        echo "Installing Nvidia drivers for Linux LTS kernel"
        sudo pacman -Syu --needed nvidia-open-lts nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader opencl-nvidia lib32-opencl-nvidia
        ;;
    |*-hardened*|*-zen*|*-cachyos*)
        echo "Installing Nvidia drivers for Other Linux kernel: $linux_kernel"
        sudo pacman -Syu --needed nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader opencl-nvidia lib32-opencl-nvidia
        ;;
    *)
        echo "Installing Nvidia drivers for unknown kernel: $linux_kernel"
        sudo pacman -Syu --needed nvidia-open-dkms nvidia-utils lib32-nvidia-utils nvidia-settings vulkan-icd-loader lib32-vulkan-icd-loader opencl-nvidia lib32-opencl-nvidia
        ;;
esac

# Creates a conf file to enable suspend and resizable bar, and also disables Nvidia link.
echo "Creating Nvidia modprobe file"
echo 'options nvidia NVreg_PreserveVideoMemoryAllocations=1 NVreg_EnableResizableBar=1 NVreg_NvLinkDisable=1 NVreg_UseKernelSuspendNotifiers=1' | sudo tee /etc/modprobe.d/nvidia-kernel-parameters.conf

# Increases maximum shader cache size to reduce stutters
mkdir -p ~/.config/environment.d
cat << 'EOF' > ~/.config/environment.d/nvidia-shader-cache.conf
# Increase Nvidia's shader cache size to 12GB
__GL_SHADER_DISK_CACHE_SIZE=12000000000
EOF
