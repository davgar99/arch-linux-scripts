#!/usr/bin/env bash

# Don't allow users to run this script as root
if ((EUID == 0)); then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

# Sets environment variables to explicitly select the radeonsi driver for VA-API and VDPAU
# This is already the default on most systems, but setting it explicitly avoids ambiguity on hybrid/multi-GPU systems
if grep -q "AMD hardware acceleration environment variables" /etc/environment 2> /dev/null; then
    echo "AMD hardware acceleration environment variables are already set, skipping."
else
    echo "Setting environment variables for AMD hardware acceleration"
    cat << 'EOF' | sudo tee -a /etc/environment > /dev/null

# AMD hardware acceleration environment variables
LIBVA_DRIVER_NAME=radeonsi
VDPAU_DRIVER=radeonsi
EOF
fi
