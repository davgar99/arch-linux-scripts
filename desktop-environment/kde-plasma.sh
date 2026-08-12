#!/usr/bin/env bash
set -euo pipefail

# Don't allow users to run this script as root
if ((EUID == 0)); then
    echo "This script should not be run as root. Please run it as a regular user."
    exit 1
fi

# Installs the KDE Plasma desktop environment along with some essential applications
echo "Installing KDE Plasma and essential applications"
sudo pacman -Syu --needed plasma-meta sddm dolphin konsole kate ark

# Warns if a different display manager is already enabled before SDDM takes over
if [[ -e /etc/systemd/system/display-manager.service ]]; then
    current_dm=$(basename "$(readlink -f /etc/systemd/system/display-manager.service)")
    if [[ "$current_dm" != "sddm.service" ]]; then
        echo "Note: $current_dm is currently enabled as the display manager, it will be replaced with SDDM."
    fi
fi

# Enables the SDDM display manager so KDE Plasma starts automatically on boot
echo "Enabling SDDM display manager"
sudo systemctl enable sddm.service

# Enables NetworkManager so networking works out of the box in Plasma
echo "Enabling NetworkManager"
sudo systemctl enable NetworkManager.service
