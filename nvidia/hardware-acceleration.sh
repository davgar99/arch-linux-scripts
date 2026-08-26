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

# Older versions of this script set Firefox's RDD sandbox override globally.
# Remove only the exact legacy line managed by this script so the sandbox is
# not disabled for every Firefox launch on the system.
if grep -qx 'MOZ_DISABLE_RDD_SANDBOX=1' /etc/environment 2> /dev/null; then
    echo "Removing legacy global Firefox RDD sandbox override"
    sudo sed -i '/^MOZ_DISABLE_RDD_SANDBOX=1$/d' /etc/environment
fi

# Sets environment variables for NVIDIA hardware acceleration for VA-API, VDPAU, and CUDA
# Essentially improves video playback and hardware acceleration for NVIDIA GPUs
if grep -Eqi "# (Nvidia|NVIDIA) hardware acceleration environment variables" /etc/environment 2> /dev/null; then
    echo "NVIDIA hardware acceleration environment variables are already set, skipping."
else
    echo "Setting environment variables for NVIDIA hardware acceleration"
    cat << 'EOF' | sudo tee -a /etc/environment > /dev/null

# NVIDIA hardware acceleration environment variables
LIBVA_DRIVER_NAME=nvidia
VDPAU_DRIVER=nvidia
NVD_BACKEND=direct
CUDA_DISABLE_PERF_BOOST=1
EOF
fi

cat << 'EOF'
Firefox note: some NVIDIA VA-API configurations may still require the upstream
RDD sandbox workaround. If hardware video decoding does not work, test Firefox
for a single launch with:

    MOZ_DISABLE_RDD_SANDBOX=1 firefox

That variable disables Firefox's RDD decoder sandbox for that launch, so it is
not enabled system-wide by this script.
EOF
